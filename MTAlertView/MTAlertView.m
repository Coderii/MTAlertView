//
//  MTAlertView.m
//  MTAlertView
//
//  Created by Cheng on 16/7/14.
//  Copyright © 2016年 meitu. All rights reserved.
//

#import "MTAlertView.h"

#pragma mark - MTAlertAction

/**
 *   MTAlertAction集合中按钮的样式
 */
typedef NS_ENUM(NSUInteger, MTAlertActionType) {
    MTAlertActionTypeDefalut = 0,    /**< 系统默认 **/
    MTAlertActionTypeCustomeView,  /** 为自定义的View **/
} NS_AVAILABLE_IPHONE(7.0);

@interface MTAlertAction()

@property (nonatomic, strong) UIView *actionView;  /** Action集合中的自定义View **/
@property (nonatomic, strong) UIButton *defaultButton;   /**< action默认为按钮 **/
@property (nonatomic, copy) void(^buttonClick)();   /**< 按钮点击block回调 **/
@property (nonatomic, copy) void(^actionCustomeViewFinishedLoad)(); /** 当前action内的view加载完毕 **/
@property (nonatomic, assign) MTAlertActionType actionType; /**< action的形式 **/
@end

static CGFloat const kMT_DeaultActionButtonH = 44.0f;
static CGFloat const kMT_Zero = 0.0f;

@implementation MTAlertAction

#pragma mark - Life Cycle
#pragma mark Defaule

+ (instancetype)actionWithDefaultTypeWithTitle:(NSString *)title style:(MTAlertActionStyle)style handler:(void (^)(MTAlertAction *))handler {
    return [[self alloc] initActionWithDefaultTypeWithTitle:title style:style handler:handler];
}

- (instancetype)initActionWithDefaultTypeWithTitle:(NSString *)title style:(MTAlertActionStyle)style handler:(void (^)(MTAlertAction *))handler {
    if (self = [super init]) {
        _title = title;
        _actionType = MTAlertActionTypeDefalut;
        
        //button init
        _defaultButton = [[UIButton alloc] initWithFrame:CGRectMake(kMT_Zero, kMT_Zero, kMT_Zero, kMT_DeaultActionButtonH)];
        [_defaultButton setAdjustsImageWhenHighlighted:YES];
        [_defaultButton setTitle:_title forState:UIControlStateNormal];
        [_defaultButton addTarget:self action:@selector(actionButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        //设置style
        switch (style) {
            case MTAlertActionStyleDefault:
                [_defaultButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                _defaultButton.titleLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
                break;
            case MTAlertActionStyleCancel:
                [_defaultButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                _defaultButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:[UIFont systemFontSize]];   //字体加粗
                break;
            case MTAlertActionStyleDestructive:
                [_defaultButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                _defaultButton.titleLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
            default:
                break;
        }
        
        //block回调
        __weak typeof(self) _weakSelf = self;
        [self setButtonClick:^{
            if (handler) {
                handler(_weakSelf);
            }
        }];
    }
    return self;
}

#pragma mark Custome View

+ (instancetype)actionWithCustomeViewTypeWithViewSize:(CGSize)size handleCustomeView:(void (^)(UIView *))handleCustomeView {
    return [[self alloc] initActionWithCustomeViewTypeWithViewSize:size handleCustomeView:handleCustomeView];
}

- (instancetype)initActionWithCustomeViewTypeWithViewSize:(CGSize)size handleCustomeView:(void (^)(UIView *))handleCustomeView {
    if (self = [super init]) {
        _actionType = MTAlertActionTypeCustomeView;
        _actionView = [[UIView alloc] initWithFrame:CGRectMake(kMT_Zero, kMT_Zero, size.width, size.height)];
        
        __weak typeof(_actionView) _weakView = _actionView;
        [self setActionCustomeViewFinishedLoad:^{
            if (handleCustomeView) {
                handleCustomeView(_weakView);
            }
        }];
    }
    return self;
}

#pragma mark - Class Methods

- (void)actionButtonClick {
    //Block
    if (_buttonClick) {
        _buttonClick();
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [_defaultButton setTitle:_title forState:UIControlStateNormal];
}
@end

#pragma mark MTAlertView

#define MT_IPHONE6P_W 414
#define MT_IPHONE6P_H 736
#define MT_SUBTITLE_FONT [UIFont systemFontOfSize:13.0]
#define MT_MESSAGE_FONT [UIFont systemFontOfSize:12.0]
#define MT_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define MT_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define MT_ALERTVIEW_CORLOR [UIColor colorWithRed:247.0 / 255.0 green:247.0 / 255.0 blue:247.0 / 255.0 alpha:1.0]
#define MT_PADDING_CORLOR [UIColor colorWithRed:210.0 / 255.0 green:210.0 / 255.0 blue:216.0 / 255.0 alpha:1.0]

@interface MTAlertView() {
    UIView *_containerView;  /** 容器 **/
    
    CGFloat _alertW;
    CGFloat _alertH;
    
    CGFloat _actionBeginY;  /**< action集合中控件的起始坐标 **/
    
    NSMutableArray<UIView *> *_horizontalViewArray; /** 水平 **/
    NSMutableArray<UIView *> *_verticalViewArray;   /** 垂直 **/
    
    NSMutableArray<MTAlertAction *> *_actions;   /**< 保存MTAlerction **/
    
    UIButton *_closeButton; /**< 关闭按钮 **/
}

@property (nonatomic, strong) UIView *myCustomeView; /**< 自定义部分view **/
@property (nonatomic, assign, getter = isVisible) BOOL visible;
@property (nonatomic, copy) void(^showIsFinished)();    /**< 是否已经show **/
@property (nonatomic, copy) void(^customeFrameIsSetting)();
@end

@implementation MTAlertView

#pragma mark - LifeCycle

- (void)dealloc {
    NSLog(@"self dealloc"); 
    _titleLabel = nil;
    _subTitleLabel = nil;
    _messageLabel = nil;
    _actions = nil;
    _containerView = nil;
    _horizontalViewArray = nil;
    _verticalViewArray = nil;
    _closeButton = nil;
    _myCustomeView = nil;
    
    [self removeObserver];
}

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle message:(NSString *)message delegate:(id)delegate actionShowStyle:(MTAlertActionShowStyle)style {
    if (self = [super init]) {
        
        [self subViewsInitialize];
        [self parameterInitialize];
        [self observersInitialize];
        
        _titleLabel.text = title;
        _subTitleLabel.text = subTitle;
        _messageLabel.text = message;
        _actionShowStyle = style;
    }
    return self;
}

#pragma mark - Override superclass Show/Hide Methods

- (void)showInParentView:(UIView *)parentView animation:(MTAnimationStyle)style completion:(void (^)())completion {
    [super showInParentView:parentView animation:style completion:completion];
    
    [self calculateLayout];
    [self addAlertViewSubviews];
    
    _visible = YES;
    
    if (_showIsFinished) {
        _showIsFinished();
    }
}

- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation {
    NSLog(@"mtalertView");
    
    [self calculateLayout];
    [self calculateCloseButtonLayout];
}

#pragma mark - Initialize

- (void)parameterInitialize {
    _leftOrRightMargin = 44.0;
    _labelMargin = 20.0;
    _contentTopMargin = 20.0;
    _titleLabeltTopMargin = 0.0;
    _subLabelTopMargin = 5.0;
    _messageTopMargin = 10.0;
    _actionBeginY = 0.0;
    
    //array
    _actions = [NSMutableArray array];
    _horizontalViewArray = [NSMutableArray array];
    _verticalViewArray = [NSMutableArray array];
}

- (void)subViewsInitialize {
    //label
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    //subLabel
    _subTitleLabel = [[UILabel alloc] init];
    _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    if (_titleLabel.text || _messageLabel.text) {
        _subTitleLabel.font = MT_SUBTITLE_FONT;
    }
    _subTitleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;

    //messageLabel
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.font = MT_MESSAGE_FONT;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    //container
    _containerView = [[UIView alloc] init];
    _containerView.backgroundColor = MT_ALERTVIEW_CORLOR;
    _containerView.layer.cornerRadius = 10.0f;
    _containerView.layer.masksToBounds = YES;

    _myCustomeView = [UIView new];
    _closeButton = [UIButton new];
}

#pragma mark Observer

- (void)observersInitialize {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //屏幕检测通知
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleDeviceOrientationDidChange:)
                                                     name:UIDeviceOrientationDidChangeNotification                                       object:nil
         ];
    }
}

- (void)removeObserver {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIDeviceOrientationDidChangeNotification
                                                      object:nil
         ];
        [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
    }
}

#pragma mark - Class Methods

- (void)calculateLayout {
    //super
    [super calculateLayout];
    
    //alertW
    [self calculateAlertW];
    
    //label layout
    [self calculateLabelsLayout];
    
    //actions subview layout
    [self calculateActionsLayout];

    //self layout
    [self calculateContainerLayout];
}

#pragma mark - alertW

- (void)calculateAlertW {
    CGFloat parentViewW = self.parentView.bounds.size.width;
    CGFloat parentViewH = self.parentView.bounds.size.height;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if ((parentViewW != MT_SCREEN_WIDTH) || (parentViewH != MT_SCREEN_HEIGHT)) {    /**< 非全屏幕 **/
            _alertW = parentViewW - 2 * _leftOrRightMargin;
        }
        else {
            _alertW = MT_IPHONE6P_W - 2 * _leftOrRightMargin;
        }
    }
    else {
        _alertW = parentViewW - 2 * _leftOrRightMargin;
    }
}

#pragma mark - Label

- (void)calculateLabelsLayout {
    [self calculateTitleLabelLayout];
    [self calculateSubTitleLabelLayout];
    [self calculatemessageLabelLayout];
    
    if ([_titleLabel.text length] == 0
        && [_subTitleLabel.text length] == 0
        && [_messageLabel.text length] == 0) {
        _alertH = 0.0;
    }
    
    _actionBeginY = _alertH;
}

- (void)calculateTitleLabelLayout {
    if ([_titleLabel.text length] > 0) {
        CGSize labelSize = [self sizeWithTitle:_titleLabel.text font:_titleLabel.font];
        CGFloat labelX = 0.0f;
        
        if (_labelAlignment == MTAlertViewTitleLabelAlignmentCenter) {   //居中
            labelX = (_alertW - labelSize.width) * 0.5;
        }
        else if (_labelAlignment == MTAlertViewTitleLabelAlignmentLeft) {    //靠左
            labelX = _labelMargin;
        }
        else if (_labelAlignment == MTAlertViewTitleLabelAlignmentRight) {  //靠右
            labelX = _alertW - labelSize.width - _labelMargin;
        }
        _titleLabel.frame = CGRectMake(labelX,
                                       _contentTopMargin + _titleLabeltTopMargin,
                                       labelSize.width,
                                       labelSize.height);
        
        _alertH = _titleLabel.frame.origin.y + labelSize.height + _contentTopMargin;
    }
}

- (void)calculateSubTitleLabelLayout {
    if ([_subTitleLabel.text length] > 0) {
        //标题当y坐标
        CGFloat labelY = _titleLabel.frame.origin.y;
        
        CGSize subTitleSize = [self sizeWithTitle:_subTitleLabel.text font:_subTitleLabel.font];
        CGFloat labelH = _titleLabel.frame.size.height;
        
        CGFloat labelX = 0.0f;
        if (_subLabelAlignment == MTAlertViewSubTitleLabelAlignmentCenter) {   //居中
            labelX = (_alertW - subTitleSize.width) * 0.5;
        }
        else if (_subLabelAlignment == MTAlertViewSubTitleLabelAlignmentLeft) {    //靠左
            labelX = _labelMargin;
        }
        else if (_subLabelAlignment == MTAlertViewSubTitleLabelAlignmentRight) {  //靠右
            labelX = _alertW - subTitleSize.width - _labelMargin;
        }
        if (_titleLabel.text) { //有标题
            _subTitleLabel.frame = CGRectMake(labelX,
                                              labelY + labelH + _subLabelTopMargin,
                                              subTitleSize.width,
                                              subTitleSize.height);
        }
        else {
            _subTitleLabel.frame = CGRectMake(labelX,
                                              _contentTopMargin + _subLabelTopMargin,
                                              subTitleSize.width,
                                              subTitleSize.height);
            
        }
        
        _alertH = _subTitleLabel.frame.origin.y + subTitleSize.height + _contentTopMargin;
    }
}

- (void)calculatemessageLabelLayout {
    if ([_messageLabel.text length] > 0) {
        CGFloat labeY = _titleLabel.frame.origin.y;
        CGFloat lablH = _titleLabel.frame.size.height;
        CGFloat subTitleLabelY = _subTitleLabel.frame.origin.y;
        CGFloat subTitleLabelH = _subTitleLabel.frame.size.height;
        
        CGSize messageLabelSize = [self sizeWithTitle:_messageLabel.text font:_messageLabel.font];
        
        CGFloat labelX = 0.0f;
        if (_messageLabelAlignment == MTAlertViewMessageLabelAlignmentCenter) {   //居中
            labelX = (_alertW - messageLabelSize.width) * 0.5;
        }
        else if (_messageLabelAlignment == MTAlertViewMessageLabelAlignmentLeft) {    //靠左
            labelX = _labelMargin;
        }
        else if (_messageLabelAlignment == MTAlertViewMessageLabelAlignmentRight) {  //靠右
            labelX = _alertW - messageLabelSize.width - _labelMargin; 
        }
        if (_subTitleLabel.text) {    //存在副标题
            _messageLabel.frame = CGRectMake(labelX,
                                             subTitleLabelY + subTitleLabelH + _messageTopMargin,
                                             messageLabelSize.width,
                                             messageLabelSize.height);
        }
        else {  //不存在副标题
            if (_titleLabel.text) {   //存在标题
                _messageLabel.frame = CGRectMake(labelX,
                                                 labeY + lablH + _messageTopMargin,
                                                 messageLabelSize.width,
                                                 messageLabelSize.height);
            }
            else {
                _messageLabel.frame = CGRectMake(labelX,
                                                 labeY + lablH + _contentTopMargin + _messageTopMargin,
                                                 messageLabelSize.width,
                                                 messageLabelSize.height);
            }
        }
        _alertH = _messageLabel.frame.origin.y + messageLabelSize.height + _contentTopMargin;
    }
}

#pragma mark - Actions

- (void)addAction:(MTAlertAction *)action {
    [_actions addObject:action];
    
    //按钮相应的分割线
    [_horizontalViewArray addObject:[UIView new]];
    [_verticalViewArray addObject:[UIView new]];
    
    //点击按钮隐藏
    __weak typeof(self) _weakSelf = self;
    [action setButtonClick:^{
        [_weakSelf dissmissAnimation:_weakSelf.defaultHideAnimationStyle completion:nil];
    }];
}

- (void)addActions:(NSArray *)actions {
    for (MTAlertAction *action in actions) {
        [self addAction:action];
    }
}

- (void)calculateActionsLayout {
    switch (_actionShowStyle) { //布局样式
        case MTAlertActionShowStyleNone: {  //控件默认的排序方式(两个列排，三个行排)
            [self calculateActionShowStyleNoneLayout];
            break;
        }
        case MTAlertActionShowStyleList: {  //全部列排
            [self calculateActionShowStyleListLayoutWithActionsCount:_actions.count];
            break;
        }
        case MTAlertActionShowStyleRow: {  //全部行排
            [self calculateActionShowStyleRowsLayout];
            break;
        }
    }
}

- (void)calculateActionShowStyleNoneLayout {    //系统默认样式
    if (_actions.count == 0) return;
    if (_actions.count == 2) {
        [self calculateActionShowStyleListLayoutWithActionsCount:2];
    }
    else {
        [self calculateActionShowStyleRowsLayout];
    }
}

#pragma mark Actions List

- (void)calculateActionShowStyleListLayoutWithActionsCount:(NSInteger)count {    //列排
    CGFloat eachW = _alertW / count;
    CGFloat actionH = 44.0f;
    
    for (NSUInteger index = 0; index < count; index++) {
        MTAlertAction *action = [_actions objectAtIndex:index];
        
        //竖直分割线
        [_verticalViewArray objectAtIndex:index].frame = CGRectMake(eachW * (index + 1) , _actionBeginY, 1, actionH);
        [_verticalViewArray objectAtIndex:index].backgroundColor = MT_PADDING_CORLOR;
        
        //水平
        [_horizontalViewArray firstObject].frame = CGRectMake(0, _actionBeginY, _alertW, 1);
        [_horizontalViewArray firstObject].backgroundColor = MT_PADDING_CORLOR;
        
        if (action.actionType == MTAlertActionTypeCustomeView) {
            action.actionView.frame = CGRectMake(index * eachW, _alertH, eachW, actionH);
            [_containerView addSubview:action.actionView];
        }
        else {
            action.defaultButton.frame = CGRectMake(index * eachW, _alertH, eachW, actionH);
            [_containerView addSubview:action.defaultButton];
            [_containerView addSubview:[_verticalViewArray objectAtIndex:index]];
            [_containerView addSubview:[_horizontalViewArray objectAtIndex:index]];
        }
        
        //block回调
        if (action.actionCustomeViewFinishedLoad) {
            action.actionCustomeViewFinishedLoad();
        }
    }
    [[_verticalViewArray lastObject] removeFromSuperview];
    _alertH = _alertH + actionH;
}

#pragma mark Actions Rows

- (void)calculateActionShowStyleRowsLayout {    //行排
    for (NSUInteger index = 0; index < _actions.count; index++) {
        if ([_actions objectAtIndex:index].actionType == MTAlertActionTypeDefalut) { //默认的按钮
            [self calculateActionShowStyleRowsLayoutForDefaultWithIndex:index];
        }
        else if ([_actions objectAtIndex:index].actionType == MTAlertActionTypeCustomeView) {    //添加自定义的按钮
            [self calculateActionShowStyleRowsLayoutForCustomeViewWithIndex:index];
        }
    }
}

/** custome的row排列，一行只有一个action内容 **/
- (void)calculateActionShowStyleRowsLayoutForCustomeViewWithIndex:(NSInteger)index {
    MTAlertAction *action = [_actions objectAtIndex:index];
    CGFloat actionW = action.actionView.frame.size.width < _alertW ? action.actionView.frame.size.width : _alertW;
    CGFloat actionH = action.actionView.frame.size.height;
    
    action.actionView.frame = CGRectMake((_alertW - actionW) * 0.5, _actionBeginY, actionW, actionH);
    _actionBeginY = _actionBeginY + actionH;
    _alertH = _alertH + actionH;
    [_containerView addSubview:action.actionView];
    
    //block回调
    if (action.actionCustomeViewFinishedLoad) {
        action.actionCustomeViewFinishedLoad();
    }
}

/** 默认action里为按钮的集合，按钮row排列方式 **/
- (void)calculateActionShowStyleRowsLayoutForDefaultWithIndex:(NSInteger)index {
    MTAlertAction *action = [_actions objectAtIndex:index];
    CGFloat actionButtonH = action.defaultButton.frame.size.height;
    
    [_horizontalViewArray objectAtIndex:index].frame = CGRectMake(0, _actionBeginY, _alertW, 1);
    [_horizontalViewArray objectAtIndex:index].backgroundColor = MT_PADDING_CORLOR;
    
    action.defaultButton.frame = CGRectMake(0,  _actionBeginY, _alertW, actionButtonH);
    _actionBeginY = _actionBeginY + actionButtonH;
    _alertH = _alertH + actionButtonH;
    
    [_containerView addSubview:[_horizontalViewArray objectAtIndex:index]];
    [_containerView addSubview:action.defaultButton];
}
 
#pragma mark - Container

- (void)calculateContainerLayout {
    //添加label等控件的contaenerView的尺寸
    CGFloat parentViewW = self.parentView.bounds.size.width;
    CGFloat parentViewH = self.parentView.bounds.size.height;
    
    CGRect selfFrame = self.frame;
    selfFrame.size = CGSizeMake(_alertW, _alertH);
    selfFrame.origin = CGPointMake((parentViewW - _alertW) * 0.5, (parentViewH - _alertH) * 0.5);
    self.frame = selfFrame;
    
    CGFloat selfX = self.bounds.origin.x;
    CGFloat selfY = self.bounds.origin.y;
    CGFloat selfW = self.bounds.size.width;
    CGFloat selfH = self.bounds.size.height;
    
    _containerView.frame = CGRectMake(selfX, selfY, selfW, selfH);
}

#pragma mark - Add SubViews

- (void)addAlertViewSubviews {
    [_containerView addSubview:_titleLabel];
    [_containerView addSubview:_subTitleLabel];
    [_containerView addSubview:_messageLabel];
    [_containerView addSubview:_myCustomeView];
    
    [self addSubview:_closeButton];
    [self addSubview:_containerView];
} 

#pragma mark - Add Closebutton

- (void)calculateCloseButtonLayout {
    CGRect containerFrame = _containerView.frame;
    containerFrame.origin.x = _containerView.frame.origin.x + _closeButton.frame.size.width / 2;
    containerFrame.origin.y = _containerView.frame.origin.y + _closeButton.frame.size.height / 2;
    _containerView.frame = containerFrame;
    
    CGRect selfFrame = self.frame;
    selfFrame.origin.x = self.frame.origin.x - _closeButton.frame.size.width / 2;
    selfFrame.origin.y = self.frame.origin.y - _closeButton.frame.size.height / 2;
    selfFrame.size.width = self.frame.size.width + _closeButton.frame.size.width;
    selfFrame.size.height = self.frame.size.height + _closeButton.frame.size.height / 2;
    self.frame = selfFrame; 
    
    _closeButton.frame = CGRectMake(self.bounds.size.width - _closeButton.frame.size.width,
                                    self.bounds.origin.y,
                                    _closeButton.frame.size.width,
                                    _closeButton.frame.size.height);
    
    _closeButton.layer.cornerRadius = _closeButton.frame.size.width / 2;
    _closeButton.layer.masksToBounds = YES;
    [self bringSubviewToFront:_closeButton];
}

- (void)addCloseButtonSize:(CGSize)size handleCloseButton:(void (^)(UIButton *))handleCloseButton {
    _closeButton.frame = CGRectMake(0, 0, size.width, size.height);
    
    if (_visible) {
        [self calculateCloseButtonLayout];
        if (handleCloseButton) {
            handleCloseButton(_closeButton);
        }
    }
    else { 
        __weak typeof(self) _weakSelf = self;
        __weak typeof(_closeButton) _weakButton = _closeButton;
        [self setShowIsFinished:^{
            [_weakSelf calculateCloseButtonLayout];
            if (handleCloseButton) {
                handleCloseButton(_weakButton);
            }
        }];
    }
}

#pragma mark - Label Size

- (CGSize)sizeWithTitle:(NSString *)title font:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [title boundingRectWithSize:CGSizeMake(_alertW - 2 * _labelMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

#pragma mark Setter

- (void)setLeftOrRightMargin:(CGFloat)leftOrRightMargin {
    _leftOrRightMargin = leftOrRightMargin;
    [self calculateLayout];
}

- (void)setLabelMargin:(CGFloat)labelMargin {
    _labelMargin = labelMargin;
    [self calculateLayout];
}

- (void)setContentTopMargin:(CGFloat)contentTopMargin {
    _contentTopMargin = contentTopMargin;
    [self calculateLayout];
}

- (void)setTitleLabeltTopMargin:(CGFloat)titleLabeltTopMargin {
    _titleLabeltTopMargin = titleLabeltTopMargin;
    [self calculateLayout];
}

- (void)setSubLabelTopMargin:(CGFloat)subLabelTopMargin {
    _subLabelTopMargin = subLabelTopMargin;
    [self calculateLayout];
}

- (void)setMessageTopMargin:(CGFloat)messageTopMargin {
    _messageTopMargin = messageTopMargin;
    [self calculateLayout];
}

- (void)setLabelAlignment:(MTAlertViewTitleLabelAlignment)labelAlignment {
    _labelAlignment = labelAlignment;
    [self calculateLayout];
}

- (void)setSubLabelAlignment:(MTAlertViewSubTitleLabelAlignment)subLabelAlignment {
    _subLabelAlignment = subLabelAlignment;
    [self calculateLayout];
}

- (void)setMessageLabelAlignment:(MTAlertViewMessageLabelAlignment)messageLabelAlignment {
    _messageLabelAlignment = messageLabelAlignment;
    [self calculateLayout];
}
@end
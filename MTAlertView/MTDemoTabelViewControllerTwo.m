//
//  MTDemoTabelViewControllerTwo.m
//  MTAlertView
//
//  Created by Cheng on 16/7/12.
//  Copyright © 2016年 meitu. All rights reserved.
//

#import "MTDemoTabelViewControllerTwo.h"
#import "MTAlertView.h"
#import "UIButton+MTButtonCreate.h"

@interface MTAlertViewExample : NSObject

@property (nonatomic, copy) NSString *exampName;
@property (nonatomic, copy) NSString *selectorName;

@end

@implementation MTAlertViewExample

- (instancetype)initAlertViewExampleWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _exampName = dict[@"exampName"];
        _selectorName = dict[@"selectorName"];
    }
    return self;
}

@end

@interface MTDemoTabelViewControllerTwo() {
    NSArray<NSArray *> *_dataArray;
}
@property (nonatomic, weak) MTAlertView *alert;
@property (nonatomic, weak) MTPopView *ViewPop;

@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation MTDemoTabelViewControllerTwo

- (void)dealloc {
    NSLog(@"MTDemoTabelViewControllerTwoDealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *defaultArray = @[@{@"exampName": @"Default_OntButton",
                                @"selectorName": NSStringFromSelector(@selector(default_OneButton))},
                              @{@"exampName": @"Default_TwoButtons",
                                @"selectorName": NSStringFromSelector(@selector(default_TwoButtons))},
                              @{@"exampName": @"Default_ThreeButtons",
                                @"selectorName": NSStringFromSelector(@selector(default_ThreeButtons))},
                              @{@"exampName": @"Default_CloseButton",
                                @"selectorName": NSStringFromSelector(@selector(default_CloseButton))},
                              @{@"exampName": @"",
                                @"selectorName": NSStringFromSelector(@selector(noneAction))},
                              @{@"exampName": @"Default_LongLabelTitleLines0",
                                @"selectorName": NSStringFromSelector(@selector(default_LongLabelTitleLines0))},
                              @{@"exampName": @"Default_LongLabelTitleLines1",
                                @"selectorName": NSStringFromSelector(@selector(default_LongLabelTitleLines1))},
                              @{@"exampName": @"Default_LabelTypeAlter",
                                @"selectorName": NSStringFromSelector(@selector(default_LabelTypeAlter))},
                              @{@"exampName": @"",
                                @"selectorName": NSStringFromSelector(@selector(noneAction))},
                              @{@"exampName": @"Default_ButtonListShow",
                                @"selectorName": NSStringFromSelector(@selector(default_ButtonListShow))},
                              @{@"exampName": @"Default_ButtonRowsShow",
                                @"selectorName": NSStringFromSelector(@selector(default_ButtonRowsShow))},
                              ];
    
    NSArray *customeArray = @[@{@"exampName": @"CustomeView_Button",
                                @"selectorName": NSStringFromSelector(@selector(customeView_Button))},
                              @{@"exampName": @"CustomeView_View",
                                @"selectorName": NSStringFromSelector(@selector(customeView_View))},
                              @{@"exampName": @"CustomeView_ViewAndButton",
                                @"selectorName": NSStringFromSelector(@selector(customeView_ViewAndButton))},
                              @{@"exampName": @"",
                                @"selectorName": NSStringFromSelector(@selector(noneAction))},
                              @{@"exampName": @"CustomeView_ViewAndButtonCloseButton",
                                @"selectorName": NSStringFromSelector(@selector(customeView_ViewAndButtonCloseButton))},
                              ];
    
    NSArray *popArray = @[@{@"exampName": @"PopView",
                            @"selectorName": NSStringFromSelector(@selector(popView))},
                          ];
    _dataArray = @[
                   defaultArray,
                   customeArray,
                   popArray,
                   ];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell2"];
    self.navigationItem.titleView = self.titleLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = self.title;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray[self.item].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    
    NSArray *infoArray = _dataArray[_item];
    MTAlertViewExample *example = [[MTAlertViewExample alloc] initAlertViewExampleWithDict:infoArray[indexPath.row]];
    
    if ([example.exampName isEqualToString:@""]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
    cell.textLabel.text = example.exampName;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *infoArray = _dataArray[_item];
    MTAlertViewExample *example = [[MTAlertViewExample alloc] initAlertViewExampleWithDict:infoArray[indexPath.row]];
    
    if (example.selectorName) {
        SEL actionSelector = NSSelectorFromString(example.selectorName);
        if ([self respondsToSelector:actionSelector]) {
            [self performSelector:actionSelector withObject:nil afterDelay:0.0];
        }
    }
}

- (void)buttonClickClose {
    if (self.alert) {
        [self.alert dissmissAnimation:MTAnimationStyleBounce completion:nil];
    }
    
    if (self.ViewPop) {
        [self.ViewPop dissmissAnimation:MTAnimationStyleBounce completion:nil];
    }
}

- (void)buttonClick {
    NSLog(@"其他");
    if (self.alert) {
        [self.alert dissmissAnimation:MTAnimationStyleBounce completion:nil];
    }
}

- (void)button1Click {
    NSLog(@"关于");
    if (self.alert) {
        [self.alert dissmissAnimation:MTAnimationStyleBounce completion:nil];
    }
}
#pragma mark delegate

- (void)alertViewLoginStyleClickedUsernameField:(UITextField *)usernameField passwordField:(UITextField *)passwordField alertView:(MTAlertView *)alertView {
    NSLog(@"username = %@=passwd = %@", usernameField.text, passwordField.text);
    [alertView dissmissAnimation:MTAnimationStyleBounce completion:nil]; 
}
 
#pragma mark - Default
- (void)default_OneButton {
    MTAlertView *alertView = [[MTAlertView alloc] initWithTitle:@"标题" subTitle:@"副标题" message:@"详细信息" delegate:self actionShowStyle:MTAlertActionShowStyleNone];
    self.alert = alertView;
    
    MTAlertAction *action = [MTAlertAction actionWithDefaultTypeWithTitle:@"1" style:MTAlertActionStyleDefault handler:^(MTAlertAction *action) {
        NSLog(@"default_OneButton");
    }];
    [alertView addAction:action];
    
    alertView.titleLabel.font = [UIFont systemFontOfSize:30.0];
    alertView.subTitleLabel.backgroundColor = [UIColor redColor];
    
    
    [alertView showInParentView:[UIApplication sharedApplication].keyWindow animation:MTAnimationStyleSlideFromTop completion:nil];
}

- (void)default_TwoButtons {
    MTAlertView *alertView = [[MTAlertView alloc] initWithTitle:@"标题" subTitle:@"副标题" message:@"详细信息" delegate:self actionShowStyle:MTAlertActionShowStyleNone];
    self.alert = alertView;
    
    MTAlertAction *action = [MTAlertAction actionWithDefaultTypeWithTitle:@"1" style:MTAlertActionStyleDefault handler:^(MTAlertAction *action) {
        NSLog(@"default_TwoButtons");
    }];
    
    MTAlertAction *action1 = [MTAlertAction actionWithDefaultTypeWithTitle:@"2" style:MTAlertActionStyleDefault handler:^(MTAlertAction *action) {
        NSLog(@"default_TwoButtons1");
    }];
    
    [alertView addAction:action];
    [alertView addAction:action1];
    
    [alertView showInParentView:[UIApplication sharedApplication].keyWindow animation:MTAnimationStyleStyleDropDown completion:nil];
}

- (void)default_ThreeButtons {
    MTAlertView *alertView = [[MTAlertView alloc] initWithTitle:@"标题" subTitle:@"副标题" message:@"详细信息" delegate:self actionShowStyle:MTAlertActionShowStyleNone];
    self.alert = alertView;
    
    MTAlertAction *action = [MTAlertAction actionWithDefaultTypeWithTitle:@"1" style:MTAlertActionStyleDefault handler:^(MTAlertAction *action) {
        NSLog(@"default_TwoButtons");
    }];
    
    MTAlertAction *action1 = [MTAlertAction actionWithDefaultTypeWithTitle:@"2" style:MTAlertActionStyleCancel handler:^(MTAlertAction *action) {
        NSLog(@"default_TwoButtons1");
    }];
    
    MTAlertAction *action2 = [MTAlertAction actionWithDefaultTypeWithTitle:@"3" style:MTAlertActionStyleDestructive handler:^(MTAlertAction *action) {
        NSLog(@"default_TwoButtons2");
    }];
    
    [alertView addAction:action];
    [alertView addAction:action1];
    [alertView addAction:action2];
    
    [alertView showInParentView:[UIApplication sharedApplication].keyWindow animation:MTAnimationStyleStyleDropDown completion:nil];
}

- (void)default_CloseButton {
    MTAlertView *alertView = [[MTAlertView alloc] initWithTitle:@"标题" subTitle:@"副标题" message:@"详细信息" delegate:self actionShowStyle:MTAlertActionShowStyleNone];
    self.alert = alertView;
    
    MTAlertAction *action = [MTAlertAction actionWithDefaultTypeWithTitle:@"1" style:MTAlertActionStyleDefault handler:^(MTAlertAction *action) {
        NSLog(@"default_TwoButtons");
    }];
    
    MTAlertAction *action1 = [MTAlertAction actionWithDefaultTypeWithTitle:@"2" style:MTAlertActionStyleCancel handler:^(MTAlertAction *action) {
        NSLog(@"default_TwoButtons1");
    }];
    
    MTAlertAction *action2 = [MTAlertAction actionWithDefaultTypeWithTitle:@"3" style:MTAlertActionStyleDestructive handler:^(MTAlertAction *action) {
        NSLog(@"default_TwoButtons2");
    }];
    
    [alertView addAction:action];
    [alertView addAction:action1];
    [alertView addAction:action2];
    
    [alertView showInParentView:[UIApplication sharedApplication].keyWindow animation:MTAnimationStyleStyleDropDown completion:nil];
    
    [alertView addCloseButtonSize:CGSizeMake(30, 30) handleCloseButton:^(UIButton *closeButton) {
        [closeButton addTarget:self action:@selector(buttonClickClose) forControlEvents:UIControlEventTouchUpInside];
        closeButton.backgroundColor = [UIColor redColor];
    }];
}

- (void)default_LongLabelTitleLines0 {
    MTAlertView *alertView = [[MTAlertView alloc] initWithTitle:@"标题标题标题标题标题" subTitle:@"副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题" message:@"详细信息详细信息详细信息详细信息详细信息详细信息详细信息" delegate:self actionShowStyle:MTAlertActionShowStyleNone];
    self.alert = alertView;
    
    MTAlertAction *action = [MTAlertAction actionWithDefaultTypeWithTitle:@"1" style:MTAlertActionStyleDefault handler:^(MTAlertAction *action) {
        NSLog(@"default_TwoButtons");
    }];
    
    MTAlertAction *action1 = [MTAlertAction actionWithDefaultTypeWithTitle:@"2" style:MTAlertActionStyleCancel handler:^(MTAlertAction *action) {
        NSLog(@"default_TwoButtons1");
    }];
    
    MTAlertAction *action2 = [MTAlertAction actionWithDefaultTypeWithTitle:@"3" style:MTAlertActionStyleDestructive handler:^(MTAlertAction *action) {
        NSLog(@"default_TwoButtons2");
    }];
    
    
    [alertView addAction:action];
    [alertView addAction:action1];
    [alertView addAction:action2];
    
    [alertView showInParentView:[UIApplication sharedApplication].keyWindow animation:MTAnimationStyleStyleDropDown completion:nil];
}

- (void)default_LongLabelTitleLines1 {
    MTAlertView *alertView = [[MTAlertView alloc] initWithTitle:@"标题标题标题标题标题" subTitle:@"副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题" message:@"详细信息详细信息详细信息详细信息详细信息详细信息详细信息" delegate:self actionShowStyle:MTAlertActionShowStyleNone];
    self.alert = alertView;
    
    MTAlertAction *action = [MTAlertAction actionWithDefaultTypeWithTitle:@"1" style:MTAlertActionStyleDefault handler:^(MTAlertAction *action) {
        NSLog(@"default_TwoButtons");
    }];
    
    MTAlertAction *action1 = [MTAlertAction actionWithDefaultTypeWithTitle:@"2" style:MTAlertActionStyleCancel handler:^(MTAlertAction *action) {
        NSLog(@"default_TwoButtons1");
    }];
    
    MTAlertAction *action2 = [MTAlertAction actionWithDefaultTypeWithTitle:@"3" style:MTAlertActionStyleDestructive handler:^(MTAlertAction *action) {
        NSLog(@"default_TwoButtons2");
    }];
    
    alertView.subTitleLabel.numberOfLines = 0;
    
    [alertView addAction:action];
    [alertView addAction:action1];
    [alertView addAction:action2];
    
    [alertView showInParentView:[UIApplication sharedApplication].keyWindow animation:MTAnimationStyleStyleDropDown completion:nil];
    
    alertView.messageLabel.numberOfLines = 0;
}

- (void)default_LabelTypeAlter {
    MTAlertView *alertView = [[MTAlertView alloc] initWithTitle:@"标题" subTitle:@"副标题" message:@"详细信息" delegate:self actionShowStyle:MTAlertActionShowStyleNone];
    self.alert = alertView;
    
    
    alertView.titleLabel.font = [UIFont systemFontOfSize:20.0];
    alertView.titleLabel.textColor = [UIColor redColor];
    
    alertView.subTitleLabel.font = [UIFont systemFontOfSize:15.0];
    alertView.subTitleLabel.textColor = [UIColor blueColor];
    
    alertView.messageLabel.font = [UIFont systemFontOfSize:13.0];
    alertView.messageLabel.textColor = [UIColor purpleColor];
    
//    alertView.labelAlignment = MTAlertViewTitleLabelAlignmentLeft;  //修改label的位置
    alertView.subLabelAlignment = MTAlertViewSubTitleLabelAlignmentRight;
    alertView.messageLabelAlignment = MTAlertViewMessageLabelAlignmentLeft;
    alertView.labelMargin = 0;
    MTAlertAction *action = [MTAlertAction actionWithDefaultTypeWithTitle:@"1" style:MTAlertActionStyleDefault handler:^(MTAlertAction *action) {
        NSLog(@"default_TwoButtons");
    }];
    
    MTAlertAction *action1 = [MTAlertAction actionWithDefaultTypeWithTitle:@"2" style:MTAlertActionStyleDefault handler:^(MTAlertAction *action) {
        NSLog(@"default_TwoButtons1");
    }];
    
    MTAlertAction *action2 = [MTAlertAction actionWithDefaultTypeWithTitle:@"3" style:MTAlertActionStyleDefault handler:^(MTAlertAction *action) {
        NSLog(@"default_TwoButtons2");
    }];
    
    [alertView addAction:action];
    [alertView addAction:action1];
    [alertView addAction:action2];
    [alertView showInParentView:[UIApplication sharedApplication].keyWindow animation:MTAnimationStyleStyleDropDown completion:nil];
}

- (void)default_ButtonListShow {
    MTAlertView *alertView = [[MTAlertView alloc] initWithTitle:@"标题标题标题标题标题" subTitle:@"副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题" message:@"详细信息详细信息详细信息详细信息详细信息详细信息详细信息" delegate:self actionShowStyle:MTAlertActionShowStyleList];
    self.alert = alertView;
    
    alertView.titleLabel.font = [UIFont systemFontOfSize:30.0];
    alertView.titleLabel.textColor = [UIColor redColor];
    
    alertView.subTitleLabel.font = [UIFont systemFontOfSize:15.0];
    alertView.subTitleLabel.textColor = [UIColor blueColor];
    
    alertView.messageLabel.font = [UIFont systemFontOfSize:13.0];
    alertView.messageLabel.textColor = [UIColor purpleColor];
    
    MTAlertAction *action = [MTAlertAction actionWithDefaultTypeWithTitle:@"1" style:MTAlertActionStyleDefault handler:^(MTAlertAction *action) {
        NSLog(@"default_TwoButtons");
    }];
    
    MTAlertAction *action1 = [MTAlertAction actionWithDefaultTypeWithTitle:@"2" style:MTAlertActionStyleDefault handler:^(MTAlertAction *action) {
        NSLog(@"default_TwoButtons1");
    }];
    
    MTAlertAction *action2 = [MTAlertAction actionWithDefaultTypeWithTitle:@"3" style:MTAlertActionStyleDefault handler:^(MTAlertAction *action) {
        NSLog(@"default_TwoButtons2");
    }];
    
    [alertView addAction:action];
    [alertView addAction:action1];
    [alertView addAction:action2];
    
    [alertView showInParentView:[UIApplication sharedApplication].keyWindow animation:MTAnimationStyleStyleDropDown completion:nil];
}

- (void)default_ButtonRowsShow {
    MTAlertView *alertView = [[MTAlertView alloc] initWithTitle:@"标题" subTitle:@"副标题" message:@"详细信息" delegate:self actionShowStyle:MTAlertActionShowStyleRow];
    self.alert = alertView;
    
    MTAlertAction *action = [MTAlertAction actionWithDefaultTypeWithTitle:@"1" style:MTAlertActionStyleDefault handler:^(MTAlertAction *action) {
        NSLog(@"default_TwoButtons");
    }];
    
    MTAlertAction *action1 = [MTAlertAction actionWithDefaultTypeWithTitle:@"2" style:MTAlertActionStyleDefault handler:^(MTAlertAction *action) {
        NSLog(@"default_TwoButtons1");
    }];
    
    [alertView addAction:action];
    [alertView addAction:action1];
    
    [alertView showInParentView:[UIApplication sharedApplication].keyWindow animation:MTAnimationStyleStyleDropDown completion:nil];
}

- (void)customeView_Button {
    MTAlertView *alertView = [[MTAlertView alloc] initWithTitle:@"标题" subTitle:@"副标题" message:@"详细信息" delegate:self actionShowStyle:MTAlertActionShowStyleRow];
    self.alert = alertView;
    
    MTAlertAction *action = [MTAlertAction actionWithCustomeViewTypeWithViewSize:CGSizeMake(200, 30) handleCustomeView:^(UIView *customeView) {
        UIButton *button = [UIButton mt_createButtonWithTitle:@"确认" target:self selector:@selector(buttonClickClose) backGroundColor:[UIColor redColor]];
        button.frame = CGRectMake(0, 0, 200, 30);
        [customeView addSubview:button];
    }];
    
    MTAlertAction *action1 = [MTAlertAction actionWithCustomeViewTypeWithViewSize:CGSizeMake(200, 44) handleCustomeView:^(UIView *customeView) {
        UIButton *button = [UIButton mt_createButtonWithTitle:@"取消" target:self selector:@selector(buttonClickClose) backGroundColor:[UIColor blueColor]];
        button.frame = CGRectMake(0, 0, 200, 44);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [customeView addSubview:button];
    }];
    
    MTAlertAction *action2 = [MTAlertAction actionWithCustomeViewTypeWithViewSize:CGSizeMake(300, 30) handleCustomeView:^(UIView *customeView) {
        UIButton *button = [UIButton mt_createButtonWithTitle:@"其他" target:self selector:@selector(buttonClickClose) backGroundColor:[UIColor purpleColor]];
        button.frame = CGRectMake(0, 0, 300, 30);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [customeView addSubview:button];
    }];
    
    [alertView addActions:@[action,
                           action1,
                           action2,
                            ]];
    
    [alertView showInParentView:[UIApplication sharedApplication].keyWindow animation:MTAnimationStyleStyleDropDown completion:nil];
}

- (void)customeView_View {
    MTAlertView *alertView = [[MTAlertView alloc] initWithTitle:@"标题" subTitle:@"副标题" message:@"详细信息" delegate:self actionShowStyle:MTAlertActionShowStyleRow];
    self.alert = alertView;
    
    MTAlertAction *action = [MTAlertAction actionWithCustomeViewTypeWithViewSize:CGSizeMake(MAXFLOAT, 200) handleCustomeView:^(UIView *customeView) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, customeView.frame.size.width, 200)];
        imageview.image = [UIImage imageNamed:@"test.png"];
        [customeView addSubview:imageview];
    }];
    
    [alertView addAction:action];
    
    
    [alertView addCloseButtonSize:CGSizeMake(30, 30) handleCloseButton:^(UIButton *closeButton) {
        [closeButton addTarget:self action:@selector(buttonClickClose) forControlEvents:UIControlEventTouchUpInside];
        closeButton.backgroundColor = [UIColor redColor];
    }];
    
    [alertView showInParentView:[UIApplication sharedApplication].keyWindow animation:MTAnimationStyleStyleDropDown completion:nil];
}

- (void)customeView_ViewAndButton {
    MTAlertView *alertView = [[MTAlertView alloc] initWithTitle:@"标题" subTitle:@"副标题" message:@"详细信息" delegate:self actionShowStyle:MTAlertActionShowStyleRow];
    self.alert = alertView;
    
    MTAlertAction *action = [MTAlertAction actionWithCustomeViewTypeWithViewSize:CGSizeMake(MAXFLOAT, 200) handleCustomeView:^(UIView *customeView) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, customeView.frame.size.width, 200)];
        imageview.image = [UIImage imageNamed:@"test.png"];
        [customeView addSubview:imageview];
    }];
    
    MTAlertAction *action2 = [MTAlertAction actionWithCustomeViewTypeWithViewSize:CGSizeMake(MAXFLOAT, 44) handleCustomeView:^(UIView *customeView) {
        UIButton *button = [UIButton mt_createButtonWithTitle:@"其他" target:self selector:@selector(buttonClick) backGroundColor:[UIColor purpleColor]];
        button.frame = CGRectMake(0, 0, customeView.frame.size.width * 0.5, 44);
        
        UIButton *button1 = [UIButton mt_createButtonWithTitle:@"关于" target:self selector:@selector(button1Click) backGroundColor:[UIColor redColor]];
        button1.frame = CGRectMake(customeView.frame.size.width * 0.5, 0, customeView.frame.size.width * 0.5, 44);
        
        [customeView addSubview:button];
        [customeView addSubview:button1];
    }];
    
    [alertView addAction:action]; 
    [alertView addAction:action2];
    
    [alertView showInParentView:[UIApplication sharedApplication].keyWindow animation:MTAnimationStyleStyleDropDown completion:nil];
}

- (void)customeView_ViewAndButtonCloseButton {
    MTAlertView *alertView = [[MTAlertView alloc] initWithTitle:@"标题" subTitle:@"副标题" message:@"详细信息" delegate:self actionShowStyle:MTAlertActionShowStyleRow];
    self.alert = alertView;
    
    MTAlertAction *action = [MTAlertAction actionWithCustomeViewTypeWithViewSize:CGSizeMake(MAXFLOAT, 200) handleCustomeView:^(UIView *customeView) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, customeView.frame.size.width, 200)];
        imageview.image = [UIImage imageNamed:@"test.png"];
        [customeView addSubview:imageview];
    }];
    
    MTAlertAction *action2 = [MTAlertAction actionWithCustomeViewTypeWithViewSize:CGSizeMake(MAXFLOAT, 44) handleCustomeView:^(UIView *customeView) {
        UIButton *button = [UIButton mt_createButtonWithTitle:@"其他" target:self selector:@selector(buttonClickClose) backGroundColor:[UIColor purpleColor]];
        button.frame = CGRectMake(0, 0, customeView.frame.size.width, 44);
        [customeView addSubview:button];
    }];
    
    [alertView addAction:action];
    [alertView addAction:action2];
    
    [alertView showInParentView:[UIApplication sharedApplication].keyWindow animation:MTAnimationStyleStyleDropDown completion:nil];
    
    [alertView addCloseButtonSize:CGSizeMake(30, 30) handleCloseButton:^(UIButton *closeButton) {
        [closeButton addTarget:self action:@selector(buttonClickClose) forControlEvents:UIControlEventTouchUpInside];
        closeButton.backgroundColor = [UIColor redColor];
    }];
}

- (void)popView {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    button.backgroundColor = [UIColor purpleColor];
    [button addTarget:self action:@selector(buttonClickClose) forControlEvents:UIControlEventTouchUpInside];

    MTPopView *pop = [[MTPopView alloc] initPopViewWith:button];
    _ViewPop = pop;
    [pop showInParentView:[UIApplication sharedApplication].keyWindow animation:MTAnimationStyleStyleDropDown completion:nil];
}

- (void)noneAction {
}
@end

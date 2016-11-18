//
//  MTAlertView.h
//  MTAlertView
//
//  Created by Cheng on 16/7/14.
//  Copyright © 2016年 meitu. All rights reserved.
//

#import "MTPopView.h"

#pragma mark - MTAlertAction

/**
 *   MTAlertAction集合中按钮样式
 */
typedef NS_ENUM(NSUInteger, MTAlertActionStyle) {
    MTAlertActionStyleDefault = 0,  /**< 蓝色 **/
    MTAlertActionStyleCancel,   /**< 蓝色加粗 **/
    MTAlertActionStyleDestructive,  /**< 红色 **/
} NS_AVAILABLE_IOS(7.0);

/**
 *   MTAlertAction集合中控件的排序方式
 */
typedef NS_ENUM(NSUInteger, MTAlertActionShowStyle) {
    MTAlertActionShowStyleNone = 0, /**< 没有，及系统默认 **/
    MTAlertActionShowStyleList, /**< 一行多列 **/
    MTAlertActionShowStyleRow, /**< 只有一列，多行 **/
} NS_AVAILABLE_IPHONE(7.0);

/**
 *   MTAlertAction用于添加按钮的类
 */
@interface MTAlertAction : NSObject

/**
 *  添加一个Action为一个默认的UIButton
 *
 *  @param title   标题
 *  @param style   集合中按钮的
 *  @param handler 按钮的点击事件
 *
 *  @return MTAlertAction
 */
+ (instancetype)actionWithDefaultTypeWithTitle:(NSString *)title style:(MTAlertActionStyle)style handler:(void (^)(MTAlertAction *action))handler;
@property (nonatomic, copy) NSString *title;    /** action的文本内容 **/

/**
 *  添加一个Action为一个可以自定义视图内容的CustomeView
 *
 *  @param size              添加的action中CustomeView的尺寸，当宽度大于AlertView的宽度，默认为AlertView的宽度
 *  @param handleCustomeView 在CustomeView上进行其他操作的Block函数
 *
 *  @return MTAlertAction
 */
+ (instancetype)actionWithCustomeViewTypeWithViewSize:(CGSize)size handleCustomeView:(void(^)(UIView *customeView))handleCustomeView;

@end

#pragma mark MTAlertView

/**
 *   标题的在AlertView所在位置
 */
typedef NS_ENUM(NSUInteger, MTAlertViewTitleLabelAlignment) {
    MTAlertViewTitleLabelAlignmentCenter = 0,  /**< 居中 **/
    MTAlertViewTitleLabelAlignmentLeft,   /**< 靠左 **/
    MTAlertViewTitleLabelAlignmentRight,  /**< 靠右 **/
} NS_AVAILABLE_IOS(7.0);

/**
 *   副标题在AlertView所在位置
 */
typedef NS_ENUM(NSUInteger, MTAlertViewSubTitleLabelAlignment) {
    MTAlertViewSubTitleLabelAlignmentCenter = 0,  /**< 居中 **/
    MTAlertViewSubTitleLabelAlignmentLeft,   /**< 靠左 **/
    MTAlertViewSubTitleLabelAlignmentRight,  /**< 靠右 **/
} NS_AVAILABLE_IOS(7.0);

/**
 *   详细信息在AlertView所在位置
 */
typedef NS_ENUM(NSUInteger, MTAlertViewMessageLabelAlignment) {
    MTAlertViewMessageLabelAlignmentCenter = 0,  /**< 居中 **/
    MTAlertViewMessageLabelAlignmentLeft,   /**< 靠左 **/
    MTAlertViewMessageLabelAlignmentRight,  /**< 靠右 **/
} NS_AVAILABLE_IOS(7.0);

/**
 *   继承MTPopView封装的一个类似于系统UIAlertView的类
 */
@interface MTAlertView : MTPopView

/**
 *  初始化一个MTAlertView
 *
 *  @param title    标题
 *  @param subTitle 副标题
 *  @param message  详细信息
 *  @param delegate 代理
 *  @param style    MTAlertView样式
 *
 *  @return MTAlertView 
 */
- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle message:(NSString *)message delegate:(id)delegate actionShowStyle:(MTAlertActionShowStyle)style;

/**
 *  添加MTAlertAction
 *
 *  @param action MTAlertAction实例
 */
- (void)addAction:(MTAlertAction *)action;

/**
 *  批量添加MTAlertAction
 *
 *  @param actions action的数组
 */
- (void)addActions:(NSArray *)actions;

@property (nonatomic, strong) UILabel *titleLabel;  /** 标题 **/
@property (nonatomic, strong) UILabel *subTitleLabel;   /** 副标题 **/
@property (nonatomic, strong) UILabel *messageLabel;    /** 详细信息 **/

@property (nonatomic, assign) MTAlertActionShowStyle actionShowStyle;   /**< 添加的action集合中按钮的排序方式 **/

@property (nonatomic, assign) MTAlertViewTitleLabelAlignment labelAlignment; /** alertView内Label的显示位置 **/
@property (nonatomic, assign) MTAlertViewSubTitleLabelAlignment subLabelAlignment; /** alertView内subLabel的显示位置 **/
@property (nonatomic, assign) MTAlertViewMessageLabelAlignment messageLabelAlignment; /** alertView内messageLabel的显示位置 **/

/**
 *  提供Size添加关闭按钮
 *
 *  @param size              按钮的尺寸
 *  @param handleCloseButton 按钮的处理事件BLock回调
 */
- (void)addCloseButtonSize:(CGSize)size handleCloseButton:(void(^)(UIButton *closeButton))handleCloseButton;

@property (nonatomic, assign) CGFloat leftOrRightMargin;   /**< alertView的在父视图中的左右间距 **/
@property (nonatomic, assign) CGFloat labelMargin;  /**< label的距离alertView内的边距 **/
@property (nonatomic, assign) CGFloat contentTopMargin;   /**< alertView内部的控件上边距 **/
@property (nonatomic, assign) CGFloat titleLabeltTopMargin; /** 标题上方间距 **/
@property (nonatomic, assign) CGFloat subLabelTopMargin;  /**< 副标题上方的间距 **/
@property (nonatomic, assign) CGFloat messageTopMargin; /**< messageLabel上方的间距 **/
@end

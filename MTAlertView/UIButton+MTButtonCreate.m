//
//  UIButton+MTButtonCreate.m
//  MTAlertView
//
//  Created by Cheng on 16/7/18.
//  Copyright © 2016年 meitu. All rights reserved.
//

#import "UIButton+MTButtonCreate.h"

@implementation UIButton (MTButtonCreate)

+ (UIButton *)mt_createButtonWithTitle:(NSString *)title target:(id)target selector:(SEL)selector backGroundColor:(UIColor *)color {
    UIButton *button = [UIButton new];
    button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = color;
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return button;
}
@end

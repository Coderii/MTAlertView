//
//  UIButton+MTButtonCreate.h
//  MTAlertView
//
//  Created by Cheng on 16/7/18.
//  Copyright © 2016年 meitu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (MTButtonCreate)

+ (UIButton *)mt_createButtonWithTitle:(NSString *)title target:(id)target selector:(SEL)selector backGroundColor:(UIColor *)color;
@end

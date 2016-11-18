//
//  MTDemoNavigationController.m
//  MTAlertView
//
//  Created by Cheng on 16/7/12.
//  Copyright © 2016年 meitu. All rights reserved.
//

#import "MTDemoNavigationController.h"

@implementation MTDemoNavigationController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UINavigationBar *naviBar = [UINavigationBar appearance];
    naviBar.barTintColor = [UIColor purpleColor];
    naviBar.tintColor = [UIColor whiteColor];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
@end

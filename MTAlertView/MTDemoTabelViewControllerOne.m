//
//  MTDemoTabelViewControllerOne.m
//  MTAlertView
//
//  Created by Cheng on 16/7/12.
//  Copyright © 2016年 meitu. All rights reserved.
//

#import "MTDemoTabelViewControllerOne.h"
#import "MTDemoTabelViewControllerTwo.h"

@interface MTDemoTabelViewControllerOne() {
    NSArray *_oneArray;
}

@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation MTDemoTabelViewControllerOne
 
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _oneArray = @[
                  @"Defalut",
                  @"CustomeView",
                  @"PopView"
                  ];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    self.navigationItem.titleView = self.titleLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"MTAlertView";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _oneArray.count;
} 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = _oneArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MTDemoTabelViewControllerTwo *twoVC = [[MTDemoTabelViewControllerTwo alloc] initWithNibName:nil bundle:nil];
    twoVC.item = indexPath.row;
    twoVC.title = [_oneArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:twoVC animated:YES];
}

@end

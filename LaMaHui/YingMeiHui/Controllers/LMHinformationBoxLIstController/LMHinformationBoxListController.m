//
//  LMHinformationBoxListController.m
//  YingMeiHui
//
//  Created by Zhumingming on 15-3-26.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "LMHinformationBoxListController.h"
#import "InformationBoxListCell.h"

@interface LMHinformationBoxListController ()
{
    UIBarButtonItem * _returnItem;
}
@end

@implementation LMHinformationBoxListController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"消息盒子";
    
    if (!_returnItem) {
        //返回首页按钮
        UIButton *returnHomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [returnHomeButton setImage:[UIImage imageNamed:@"whiteReturn"] forState:UIControlStateNormal];
        returnHomeButton.frame = CGRectMake(0, 0, 30, 30);
        [returnHomeButton addTarget:self action:@selector(returnHomeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        _returnItem = [[UIBarButtonItem alloc] initWithCustomView:returnHomeButton];
        [self.navigationController addRightBarButtonItem:_returnItem animation:YES];
    }
}
- (void)returnHomeBtnClick
{
    NSArray *viewControllers =[[[self.tabBarController childViewControllers] objectAtIndex:0] childViewControllers];
    for (UIViewController *vc in viewControllers) {
        if ([vc isKindOfClass:[KTChannelViewController class]]) {
            [(KTChannelViewController *)vc selectedTabIndex:0];
        }
    }
    self.tabBarController.selectedIndex=0;
    if (self.tabBarController.selectedIndex == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = GRAY_CELL_COLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark -- tableView 代理

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenW*0.194;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    InformationBoxListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[InformationBoxListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSLog(@"退款");
        self.title = @"退款信息";
    }
    if (indexPath.section == 1) {
        NSLog(@"物流");
        self.title = @"物流信息";
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

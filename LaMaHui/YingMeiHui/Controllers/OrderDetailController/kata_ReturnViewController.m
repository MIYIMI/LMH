//
//  kata_ReturnViewController.m
//  YingMeiHui
//
//  Created by work on 15-2-4.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "kata_ReturnViewController.h"
#import "LMHRefundApplyController.h"

@interface kata_ReturnViewController (){
    OrderGoodsVO *_goodVO;
}

@end

@implementation kata_ReturnViewController

- (id)initWithGoodVO:(OrderGoodsVO *)goodVO{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.ifAddPullToRefreshControl = NO;
        self.ifShowTableSeparator = NO;
        
        _goodVO = goodVO;
        self.title = @"退款选择";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = TABLE_COLOR;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    
    NSString *CELL_IDER = [NSString stringWithFormat:@"CELL_%zi",section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDER];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_IDER];
    }
    if (section == 0) {
        [cell.imageView setImage:[UIImage imageNamed:@"recivegoods"]];
        [cell.textLabel setText:@"已收到货"];
        [cell.detailTextLabel setText:@"已收到货，需要退还已收到的货"];
    }else if (section == 1){
        [cell.imageView setImage:[UIImage imageNamed:@"norecivegoods"]];
        [cell.textLabel setText:@"未收到货"];
        [cell.detailTextLabel setText:@"未收到货，仅需要退还购买的货款"];
    }
    [cell.textLabel setFont:[UIFont systemFontOfSize:16.0]];
    [cell.detailTextLabel setTextColor:DETAIL_COLOR];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12.0]];
    [cell.detailTextLabel setNumberOfLines:0];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LMHRefundApplyController *applyVC = [[LMHRefundApplyController alloc] initWithGoodVO:_goodVO andType:indexPath.section+1];
    applyVC.navigationController = self.navigationController;
    applyVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:applyVC animated:YES];
}

@end

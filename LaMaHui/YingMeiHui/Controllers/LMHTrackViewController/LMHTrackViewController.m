//
//  LMHTrackViewController.m
//  YingMeiHui
//
//  Created by Zhumingming on 14-11-6.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "LMHTrackViewController.h"
#import "TrackInfoCell.h"
#import "TrackInfoModel.h"
#import "LMHTrackInfoRequest.h"

@interface LMHTrackViewController ()
{
    //物流公司   订单ID
    NSString *_companyNameStr;
    NSString *_trackIDStr;
    UIView *headerView;
    UILabel *trackIDLabel;
    UILabel *trackCompanyLabel;
}
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation LMHTrackViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        self.title = @"物流详情";
        self.ifShowTableSeparator = NO;   //cell  无线模式
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    
    [self loadNewer];
    

}
- (void)createUI
{
    if (!headerView) {
        headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 70)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        UIView *headLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 69, ScreenW, 1)];
        headLineView.backgroundColor = GRAY_LINE_COLOR;
        [headerView addSubview:headLineView];
        
        trackCompanyLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, ScreenW - 30, 25)];
        trackCompanyLabel.font = FONT(15);
        trackCompanyLabel.backgroundColor = [UIColor clearColor];
        trackCompanyLabel.textColor = [UIColor blackColor];
        trackCompanyLabel.textAlignment = NSTextAlignmentLeft;
        [headerView addSubview:trackCompanyLabel];
        
        
        trackIDLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 8+30, ScreenW - 30, 25)];
        trackIDLabel.font = FONT(15);
        trackIDLabel.backgroundColor = [UIColor clearColor];
        trackIDLabel.textColor = [UIColor blackColor];
        trackIDLabel.textAlignment = NSTextAlignmentLeft;
        [headerView addSubview:trackIDLabel];
    }
    trackCompanyLabel.text = [NSString stringWithFormat:@"物流公司：%@",_companyNameStr];
    trackIDLabel.text = [NSString stringWithFormat:@"运货单号：%@",_trackIDStr];
    [self.tableView setTableHeaderView:headerView];
    
}
#pragma mark -- 网络请求

- (KTBaseRequest *)request
{
    
//    self.orderIDStr = @"14116597743082";
//    self.productIDStr =@"2150";
    
    KTBaseRequest *req = [[LMHTrackInfoRequest alloc] initWithOrderID:self.orderIDStr andProductID:self.productIDStr];
    
    return req;
}

- (NSArray *)parseResponse:(NSString *)resp
{
    NSArray *objArr = nil;
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if ([respDict objectForKey:@"data"] != nil && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]]) {
                id dataObj = [respDict objectForKey:@"data"];
                
                if ([dataObj isKindOfClass:[NSDictionary class]]) {
                    
                    
                    [self.dataArray removeAllObjects];
                    
                    
                    NSArray *listArr = [dataObj objectForKey:@"express_detail"];

                    if (listArr.count == 0) { //没有物流信息的时候
                     
                        [self performSelectorOnMainThread:@selector(createUI) withObject:nil waitUntilDone:YES];
//                        headerView.hidden = YES;
                        
                        
                        [self performSelectorOnMainThread:@selector(retypeUI) withObject:nil waitUntilDone:YES];
                        
                        
                    }
                    
                    
                    _companyNameStr = [dataObj objectForKey:@"express_name"];
                    _trackIDStr = [dataObj objectForKey:@"express_num"];
                   
                    
                    for (id obj in listArr) {
                        
                        TrackInfoModel *model = [[TrackInfoModel alloc]init];
                        
                        model.contentText = [obj objectForKey:@"context"];
                        model.contentTime = [obj objectForKey:@"time"];
                    
                        
                        [self.dataArray addObject:model];
                    }
                    
                    objArr = self.dataArray;
                    
                    [self performSelectorOnMainThread:@selector(createUI) withObject:nil waitUntilDone:YES];
                    
                } else {
                    self.statefulState = FTStatefulTableViewControllerError;
                }
            } else {
                self.statefulState = FTStatefulTableViewControllerError;
            }
        } else {
            self.statefulState = FTStatefulTableViewControllerError;
        }
    } else {
        self.statefulState = FTStatefulTableViewControllerError;
    }
    
    return objArr;
    
}
- (void)retypeUI
{
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, ScreenW, ScreenH - 80)];
    aView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:aView];
    
    UIImageView *car = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenW - 100)/2, ScreenH/3 - 100, 100, 100)];
    car.image = [UIImage imageNamed:@"truck_noInfomation_1"];
    [aView addSubview:car];
    
    UILabel *noInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(car.frame), ScreenW - 60, 30)];
    noInfoLabel.backgroundColor = [UIColor clearColor];
    noInfoLabel.text = @"很抱歉，您的物流信息由于第三方限制暂无法获取";
    noInfoLabel.textAlignment = 1;
    noInfoLabel.textColor = [UIColor blackColor];
    noInfoLabel.font = FONT(12);
    // 设置Label的字体 HelveticaNeue  Courier
    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:12.0f];
    noInfoLabel.font = fnt;
    CGSize size = [noInfoLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    CGFloat nameW = size.width;
    noInfoLabel.frame = CGRectMake((ScreenW - nameW)/2 + 10, CGRectGetMaxY(car.frame) - 20, nameW, 30);
    [aView addSubview:noInfoLabel];
    
    UIImageView *car_2 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(noInfoLabel.frame)-20, CGRectGetMaxY(car.frame) - 15, 20, 20)];
    car_2.image = [UIImage imageNamed:@"truck_noInfomation_3"];
    [aView addSubview:car_2];
    
    UILabel *noInfoLabel_2 = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(noInfoLabel.frame)-10, ScreenW - 60, 30)];
    noInfoLabel_2.backgroundColor = [UIColor clearColor];
    noInfoLabel_2.text = @"请上物流官网查询";
    noInfoLabel_2.textAlignment = 1;
    noInfoLabel_2.textColor = GRAY_COLOR;
    noInfoLabel_2.font = FONT(12);
    [aView addSubview:noInfoLabel_2];
    
    UIImageView *car_3 = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenW - 110)/2, ScreenH - 224,110, 50)];
    car_3.image = [UIImage imageNamed:@"truck_noInfomation_2"];
    [aView addSubview:car_3];
}

#pragma mark -- tableView 代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //行数
    return self.dataArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //行高
    
    TrackInfoModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    CGSize size=[model.contentText sizeWithFont:LMH_FONT_14 constrainedToSize:CGSizeMake(260, 1000)];
    
    return size.height+40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    
    TrackInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[TrackInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.userInteractionEnabled = NO;
    if(indexPath.row == 0) {
        cell.trackAddressInfoLabel.textColor = LMH_COLOR_SKIN;
    } else {
        cell.trackAddressInfoLabel.textColor = [UIColor blackColor];
    }
    TrackInfoModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell configContent:model andRow:indexPath.row andCount:self.listData.count];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

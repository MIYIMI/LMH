//
//  kata_CouponViewControllerTableViewController.m
//  YingMeiHui
//
//  Created by work on 14-9-22.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_CouponViewController.h"
#import "CouponListVO.h"
#import "kata_UserManager.h"
#import "KTCouponGetRequest.h"

#define TABLEBGCOLOR        [UIColor whiteColor]
#define HEADHEIGHT          60

@interface kata_CouponViewController ()
{
    NSInteger valid_count;
    NSInteger invalid_count;
    NSInteger will_invalid_count;
    UIView *headview;
    UILabel *headLbl;
}

@end

@implementation kata_CouponViewController

-(id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"优惠券";
        valid_count = 0;
        invalid_count = 0;
        will_invalid_count = 0;
        self.ifAddPullToRefreshControl = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    [self loadNewer];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI
{
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1]];
    [self.contentView setBackgroundColor:[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1]];
    [self.tableView setSectionFooterHeight:0];
    [self.tableView setSectionHeaderHeight:0];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView setOpaque:NO];
}

- (UIView *)emptyView
{
    UIView * v = [super emptyView];
    if (v) {
        CGFloat w = self.view.bounds.size.width;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 105)];
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"couponempty"]];
        [image setFrame:CGRectMake((w - CGRectGetWidth(image.frame)) / 2, 0, CGRectGetWidth(image.frame), CGRectGetHeight(image.frame))];
        [view addSubview:image];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, w, 15)];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setTextColor:[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1]];
        [lbl setFont:[UIFont systemFontOfSize:14.0]];
        [lbl setText:@"您暂时没有优惠券"];
        [view addSubview:lbl];
        
        view.center = v.center;
        [v addSubview:view];
    }
    return v;
}

#pragma mark - stateful tableview datasource && stateful tableview delegate
//stateful表格的数据和委托
//////////////////////////////////////////////////////////////////////////////////
- (KTBaseRequest *)request
{
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    NSString *userid = nil;
    NSString *usertoken = nil;
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    if (userid && usertoken) {
        req = [[KTCouponGetRequest alloc] initWithUserID:[userid intValue]
                                            andUserToken:usertoken andOrderID:nil];
    }
    
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
                    CouponListVO *listVO = [CouponListVO CouponListVOWithDictionary:dataObj];
                    
                    if(listVO.invalid){
                        invalid_count = listVO.invalid.intValue;
                    }
                    
                    if (listVO.valid) {
                        valid_count = listVO.valid.intValue;
                    }
                    
                    if (listVO.will_invalid) {
                        will_invalid_count = listVO.will_invalid.intValue;
                    }
                    
                    if ([listVO.Code intValue] == 0) {
                        objArr = listVO.coupon_list;
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
    } else {
        self.statefulState = FTStatefulTableViewControllerError;
    }
    
    return objArr;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.listData.count <= 0) {
        return self.listData.count;
    }
    else if(invalid_count > 0){
        return self.listData.count + 2;
    }else{
        return self.listData.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *COUPON = @"coupon";
    static NSString *BOUNDRARY = @"boundary";
    static NSString *HEADVIEW = @"headview";
    NSInteger row = indexPath.row;
    
    if (row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HEADVIEW];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HEADVIEW];
            headview = [[UIView alloc ] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50)];
            [headview setBackgroundColor:[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1]];
            
            headLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth(self.view.frame), 45)];
            [headLbl setTextColor:[UIColor grayColor]];
            [headLbl setBackgroundColor:[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1]];
            [headLbl setTextAlignment:NSTextAlignmentCenter];
            headLbl.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
            
            [headview addSubview:headLbl];
            [cell addSubview:headview];
        }
        [headLbl setText:[NSString stringWithFormat:@"你有%zi张优惠券即将过期", will_invalid_count]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return  cell;
    }
    if(row == valid_count+1)
    {
        //分界线
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BOUNDRARY];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BOUNDRARY];
            UIImageView *bgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 29.5, CGRectGetWidth(self.view.frame), 0.5)];
            [bgview setImage:[UIImage imageNamed:@"invalid_line.png"]];
            
            UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-150)/2, CGRectGetMaxY(bgview.frame)-10, 150, 20)];
            [lineLabel setText:@"已失效的券"];
            [lineLabel setTextColor:[UIColor grayColor]];
            [lineLabel setTextAlignment:NSTextAlignmentCenter];
            [lineLabel setFont:[UIFont systemFontOfSize:14.0]];
            
            cell.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
            [cell addSubview:bgview];
            [cell addSubview:lineLabel];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    id data;
    if (row > valid_count + 1) {
        //有效券
        data = [self.listData objectAtIndex:row - 2];
    }
    else
    {
        //无效券
        data = [self.listData objectAtIndex:row - 1];
    }
    if (data && [data isKindOfClass:[CouponVO class]]) {
        CouponVO *vo = (CouponVO *)data;
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:COUPON];
        if (cell == nil) {
            cell = [[KTCouponListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:COUPON];
        }
        
        [(KTCouponListTableViewCell*)cell setCouponData:vo];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
        return cell;
    }


    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if (row == 0 || row == valid_count + 1) {
        return 50;
    }

    return 90;
}

@end

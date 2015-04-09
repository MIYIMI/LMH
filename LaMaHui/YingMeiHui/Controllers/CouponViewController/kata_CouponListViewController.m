//
//  kata_CouponListViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-17.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_CouponListViewController.h"
#import "kata_UserManager.h"
#import "KTCouponGetRequest.h"
#import "CouponListVO.h"

#define TABLEBGCOLOR        [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1]

@interface kata_CouponListViewController ()
{
    NSString *_listType;        //AVA、HIS、USE
    BOOL _isCouponErr;
    float _orderPrice;
}

@end

@implementation kata_CouponListViewController

- (id)initWithListType:(NSString *)type
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        _listType = type;
        _isCouponErr = NO;
        _orderPrice = -1;
        self.ifAddPullToRefreshControl = NO;
        self.ifShowTableSeparator = NO;
        
        self.title = @"优惠券";
    }
    return self;
}

- (id)initWithListType:(NSString *)type
         andOrderPrice:(float)price
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        _listType = type;
        _isCouponErr = NO;
        _orderPrice = price;
        self.ifAddPullToRefreshControl = NO;
        self.ifShowTableSeparator = NO;
        
        self.title = @"使用代金券";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self loadNewer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI
{
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:TABLEBGCOLOR];
    [self.contentView setBackgroundColor:TABLEBGCOLOR];
    [self.tableView setSectionFooterHeight:0];
    [self.tableView setSectionHeaderHeight:0];
}

- (void)checkLogin
{
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [self performSelector:@selector(showLoginView) withObject:nil afterDelay:0.1];
    }
}

- (void)showLoginView
{
    [kata_LoginViewController showInViewController:self];
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
        [lbl setText:@"暂无优惠券"];
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
        req = [[KTCouponGetRequest alloc] initWithUserID:[userid integerValue]
                                            andUserToken:usertoken];
    }
    
    return req;
}

- (NSArray *)parseResponse:(NSString *)resp
{
    //NSArray *objArr = nil;
//    if (resp) {
//        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
//        
//        NSString *statusStr = [respDict objectForKey:@"status"];
//        
//        if ([statusStr isEqualToString:@"OK"]) {
//            if ([respDict objectForKey:@"data"] != nil && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]]) {
//                id dataObj = [respDict objectForKey:@"data"];
//                
//                if ([dataObj isKindOfClass:[NSDictionary class]]) {
//                    CouponListVO *listVO = [CouponListVO CouponListVOWithDictionary:dataObj];
//                    
//                    if ([listVO.Code intValue] == 0) {
//                        objArr = listVO.CouponList;
//                    } else {
//                        //listVO.Msg
//                        self.statefulState = FTStatefulTableViewControllerError;
//                        if ([listVO.Code intValue] == -102) {
//                            _isCouponErr = YES;
//                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:listVO.Msg waitUntilDone:YES];
//                            [[kata_UserManager sharedUserManager] logout];
//                            [self performSelectorOnMainThread:@selector(checkLogin) withObject:nil waitUntilDone:YES];
//                        }
//                    }
//                } else {
//                    self.statefulState = FTStatefulTableViewControllerError;
//                }
//            } else {
//                self.statefulState = FTStatefulTableViewControllerError;
//            }
//        } else {
//            self.statefulState = FTStatefulTableViewControllerError;
//        }
//    } else {
//        self.statefulState = FTStatefulTableViewControllerError;
//    }

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    [dict setObject:[NSNumber numberWithInt:3] forKey:@"id"];
    [dict setObject:@"sdsds" forKey:@"title"];
    [dict setObject:@"DSSDSDS" forKey:@"condition"];
    [dict setObject:@"2013.10.10" forKey:@"begin_time"];
    [dict setObject:@"2014.10.10" forKey:@"expire_time"];
    [dict setObject:[NSNumber numberWithFloat:43.5] forKey:@"money"];
    [dict setObject:[NSNumber numberWithFloat:13.5] forKey:@"mini_price"];
    
    NSArray *objArr = [NSArray arrayWithObjects:dict, nil];
    objArr = [CouponVO CouponVOWithArray:objArr];
    
    return objArr;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const COUPON = @"coupon";
    NSInteger row = indexPath.row;
    
    id data = [self.listData objectAtIndex:row];
    //if (data && [data isKindOfClass:[CouponVO class]]) {
        CouponVO *vo = (CouponVO *)data;
        
        KTCouponListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:COUPON];
        if (!cell) {
            cell = [[KTCouponListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:COUPON];
        }
        cell.couponCellDelegate = self;
        [cell setCouponData:vo];
        if ([_listType isEqualToString:@"AVA"]) {
            cell.cellState = KTCouponCellNormal;
        } else if ([_listType isEqualToString:@"USE"]) {
            cell.cellState = KTCouponCellToUser;
        } else if ([_listType isEqualToString:@"HIS"]) {
            cell.cellState = KTCouponCellHistory;
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    //}
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_listType isEqualToString:@"USE"]) {
        NSInteger row = indexPath.row;
        
        if ([self.listData objectAtIndex:row] && [[self.listData objectAtIndex:row] isKindOfClass:[CouponVO class]]) {
            CouponVO *vo = (CouponVO *)[self.listData objectAtIndex:row];
            if ([vo.MiniPrice floatValue] <= _orderPrice) {
                if (self.couponListDelegate && [self.couponListDelegate respondsToSelector:@selector(selectCouponTicket:)]) {
                    [self.couponListDelegate selectCouponTicket:vo];
                }
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self textStateHUD:@"订单金额未达到代金券使用条件"];
            }
        }
    }
}

#pragma mark - Login Delegate
- (void)didLogin
{
    [self loadNewer];
}

- (void)loginCancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - KTCouponListTableViewCell Delegate
- (void)selectCoupon:(CouponVO *)coupon
{
    if (coupon) {
        
    }
}

@end

//
//  KTCoupview.h
//  YingMeiHui
//
//  Created by work on 14-9-23.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@class KTCoupview;
@protocol KTCoupviewDelegate
- (void) selectMethod:(NSString *)coupon_id;
- (void) closeView;
@end

@interface KTCoupview : UIView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
{
    NSMutableArray *btnArray;
    UITextField *couponFied;
    MBProgressHUD *stateHud;
    UIView *bootView;
    UIView *headView;
    UIButton *bootBtn;
}

@property (nonatomic, assign) id <KTCoupviewDelegate> delegate;
@property (nonatomic, retain) NSArray *dataArray;
@property(nonatomic, strong) UITableView *coupon_table;
@property(nonatomic, strong) UIButton *checkBtn;

- (void)textStateHUD:(NSString *)text;

@end

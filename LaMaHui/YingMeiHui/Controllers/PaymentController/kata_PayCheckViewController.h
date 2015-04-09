//
//  kata_PayCheckViewController.h
//  YingMeiHui
//
//  Created by work on 14-10-23.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "FTBaseViewController.h"
#import "KTCoupview.h"
#import "kata_LoginViewController.h"

@class kata_CashFailedViewController;

@protocol kata_PayCheckViewControllerDelegate <NSObject>

- (NSString *)jindouStr;


@end

@interface kata_PayCheckViewController : FTBaseViewController<UITableViewDataSource, UITableViewDelegate,KTCoupviewDelegate,UITextFieldDelegate,LoginDelegate,UIAlertViewDelegate>

-(id)initWithProductData:(NSArray *)productData andMoneyInfo:(NSDictionary *)moneyDict;
@end


//get_credit
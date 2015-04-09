//
//  kata_AddressEditViewController.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-15.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "FTBaseViewController.h"

@class AddressVO;

@protocol kata_AddressEditViewControllerDelegate;

@interface kata_AddressEditViewController : FTBaseViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIActionSheetDelegate>

@property (assign, nonatomic) id<kata_AddressEditViewControllerDelegate> addressEditViewDelegate;
@property(nonatomic,copy) NSString *orderID;// 此orderID 是用于订单中修改地址的。
- (id)initWithAddessInfo:(AddressVO *)addressinfo type:(NSString *)type;

@end

@protocol kata_AddressEditViewControllerDelegate <NSObject>

- (void)addressEdittedSuccessPop:(NSInteger)addressid;

@end

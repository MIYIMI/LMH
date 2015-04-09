//
//  KTOrderSubmitProductTableViewCell.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-12.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTCounterTextField.h"

@protocol KTOrderSubmitProductTableViewCellDelegate;

@interface KTOrderSubmitProductTableViewCell : UITableViewCell <KTCounterTextFieldDelegate>

@property (assign, nonatomic) id<KTOrderSubmitProductTableViewCellDelegate> submitProductCellDelegate;
@property (strong, nonatomic) NSDictionary *orderProductDict;

@end

@protocol KTOrderSubmitProductTableViewCellDelegate <NSObject>

- (void)couponBtnPressed;
- (void)productCountChanged:(NSInteger)count;
- (void)countTFBeginEditting:(UITextField *)tf;

@end

//
//  KTPaymentTableViewCell.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-13.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KTPaymentTableViewCellDelegate;

@class PaymentVO;

typedef enum {
    KTPaymentNormal         =   0,
	KTPaymentSelected       =   1,
} KTPaymentCellState;

@interface KTPaymentTableViewCell : UITableViewCell

@property (assign, nonatomic) id<KTPaymentTableViewCellDelegate> paymentCellDelegate;
@property (strong, nonatomic) PaymentVO *PaymentData;
@property (nonatomic) KTPaymentCellState cellState;

@end

@protocol KTPaymentTableViewCellDelegate <NSObject>

- (void)bindWalletBtnPressed;

@end

//
//  KTOrderSubmitAddressTableViewCell.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-12.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressVO;

typedef enum {
    KTOrderSubmitAddressNormal      =   0,
	KTOrderSubmitAddressDown        =   1,
	KTOrderSubmitAddressUp          =   2,
} KTOrderSubmitAddressState;

@protocol KTOrderSubmitAddressTableViewCellDelegate;

@interface KTOrderSubmitAddressTableViewCell : UITableViewCell

@property (assign, nonatomic) id<KTOrderSubmitAddressTableViewCellDelegate> addressCellDelegate;
@property (strong, nonatomic) AddressVO *AddressData;
@property (nonatomic) KTOrderSubmitAddressState cellState;

@end

@protocol KTOrderSubmitAddressTableViewCellDelegate <NSObject>

- (void)addressEditAddress:(AddressVO *)addressVO;

@end

//
//  KTAddressListTableViewCell.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-11.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressVO;

@protocol KTAddressListTableViewCellDelegate;

@interface KTAddressListTableViewCell : UITableViewCell

@property (assign, nonatomic) id<KTAddressListTableViewCellDelegate> addressCellDelegate;

- (void)setAddressData:(AddressVO *)AddressData andID:(NSInteger)addrID;

@end

@protocol KTAddressListTableViewCellDelegate <NSObject>

- (void)addressEditAddress:(AddressVO *)addressVO;
- (void)addressDeleteAddress:(AddressVO *)addressVO;
- (void)setDefaultAddress:(AddressVO *)addressVO;


@end

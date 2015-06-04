//
//  KTShopCartTableViewCell.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-8-13.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSCheckBoxView.h"
#import "MBProgressHUD.h"

@class CartGoodVO;
@class CartProductVO;

@protocol KTShopCartTableViewCellDelegate;

@interface KTShopCartTableViewCell : UITableViewCell<MBProgressHUDDelegate>
{
    MBProgressHUD *stateHud;
}

@property (assign, nonatomic) id<KTShopCartTableViewCellDelegate> cartCellDelegate;
@property (assign, nonatomic) BOOL selectState;
@property (assign, nonatomic) BOOL editAble;
@property (assign, nonatomic) BOOL outStore;
@property (assign, nonatomic) NSInteger selectNum;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier delegate:(id)delegate;
- (void)setDataVO:(id)goodvo andSection:(NSInteger)section;
@end

@protocol KTShopCartTableViewCellDelegate <NSObject>

- (void)selectCheckBoxAtCell:(id)cell andVO:(id)dataVO andCheck:(NSNumber *)checked andSection:(NSInteger)section;
- (void)pressCountBtnAtCell:(NSNumber *)goodid andCount:(NSNumber *)count;
- (void)pressDeleteAtCell:(CartProductVO *)goodvo;
- (void)clickSizeAndColorBtn:(CartProductVO *)goodvo;

@end

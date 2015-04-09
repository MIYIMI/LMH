//
//  kata_CartManager.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-8-13.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface kata_CartManager : NSObject

+ (kata_CartManager *)sharedCartManager;

- (BOOL)hasCartID;
- (NSString *)cartID;
- (NSNumber *)cartCounter;
- (NSMutableArray *)cartSkuID;
- (BOOL)updateCartID:(NSString *)cartid;
- (BOOL)updateCartCounter:(NSNumber *)cartcounter;
- (BOOL)updateCartSku:(NSMutableArray *)cartArr;
- (BOOL)removeCartID;
- (BOOL)removeCartCounter;
- (BOOL)removeCartSku;
-(void)setGoToHomePage:(BOOL)toHomePage; // 用于在购物车为nill时,用户点击去首页逛逛,写状态跳转.
-(BOOL)isGoToHomePage;
@end

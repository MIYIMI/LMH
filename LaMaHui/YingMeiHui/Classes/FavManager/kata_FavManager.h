//
//  kata_FavManager.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-15.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface kata_FavManager : NSObject

+ (kata_FavManager *)sharedFavManager;

- (NSArray *)favProducts;
- (BOOL)addFavInfo:(NSDictionary *)favData;
- (BOOL)removeFavInfo:(NSDictionary *)favData;
- (BOOL)cleanFav;

- (NSString *)favDate;

@end

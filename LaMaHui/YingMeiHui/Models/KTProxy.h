//
//  KTProxy.h
//  BaoTong
//
//  Created by 林程宇 on 14-3-5.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "KTBaseRequest.h"

typedef void (^RequestCompletedHandleBlock)(NSString * resp, NSStringEncoding encoding);
typedef void (^RequestFailedHandleBlock)(NSError * error);

@interface KTProxy : NSObject

@property (readonly, nonatomic) BOOL loading;
@property (readonly, nonatomic) BOOL loaded;
@property (strong, nonatomic) AFHTTPRequestOperation *oper;

- (void)start;
- (BOOL)isLoading;
- (BOOL)isLoaded;

+ (KTProxy *)loadWithRequest:(KTBaseRequest *)request
                   completed:(RequestCompletedHandleBlock)completeHandleBlock
                      failed:(RequestFailedHandleBlock)failedHandleBlock;

@end

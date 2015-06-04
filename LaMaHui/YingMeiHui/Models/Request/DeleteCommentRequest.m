//
//  DeleteCommentRequest.m
//  YingMeiHui
//
//  Created by Zhumingming on 15-5-29.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "DeleteCommentRequest.h"

@implementation DeleteCommentRequest
- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
      andEvaluate_id:(NSNumber *)evaluate_id
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:3];
        if (userid != -1) {
            [subParams setObject:[NSNumber numberWithLong:userid] forKey:@"user_id"];
        }
        
        if (token) {
            [subParams setObject:token forKey:@"user_token"];
        }
        
        if (evaluate_id) {
            [subParams setObject:evaluate_id forKey:@"id"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"delete_evaluate";
}
@end

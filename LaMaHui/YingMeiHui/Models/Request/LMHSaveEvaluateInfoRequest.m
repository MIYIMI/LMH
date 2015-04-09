//
//  LMHSaveEvaluateInfoRequest.m
//  YingMeiHui
//
//  Created by 王凯 on 15-2-5.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "LMHSaveEvaluateInfoRequest.h"

@implementation LMHSaveEvaluateInfoRequest

- (id)initWithUserID:(NSInteger)userid
        andUserToken:(NSString *)token
    andEvaluationArr:(NSArray *)evaluationarr
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:1];
        
        if (userid >= 0) {
            [subParams setObject:[NSNumber numberWithInteger:userid] forKey:@"user_id"];
        }
        
        if (token) {
            [subParams setObject:token forKey:@"user_token"];
        }
        
        if (evaluationarr) {
            [subParams setObject:evaluationarr forKey:@"evaluationarr"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"user_evaluation_save";
}

@end

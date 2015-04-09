//
//  LMHSaveBabyInforRequest.h
//  YingMeiHui
//
//  Created by Zhumingming on 14-12-1.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "KTBaseRequest.h"

@interface LMHSaveBabyInforRequest : KTBaseRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
        andbaby_name:(NSString *)baby_name
         andbaby_sex:(NSString *)baby_sex
 andbaby_birthday_at:(NSString *)baby_birthday_at
       andmother_birthday_at:(NSString *)mother_birthday_at
          andaddress:(NSString *)address;

@end

//
//  AddressListVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-11.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressVO.h"

@interface AddressListVO : NSObject
{
}

+ (AddressListVO *)AddressListVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (AddressListVO *)AddressListVOWithDictionary:(NSDictionary *)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *Code;
@property(nonatomic, retain) NSString *Msg;
@property(nonatomic, retain) NSArray *AddressList;

@end

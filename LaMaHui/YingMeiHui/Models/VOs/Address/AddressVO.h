//
//  AddressVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-11.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface AddressVO : NSObject
{
}

+ (AddressVO *)AddressVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (AddressVO *)AddressVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)AddressVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

@property(nonatomic, retain) NSNumber *AddressID;
@property(nonatomic, retain) NSString *Name;
@property(nonatomic, retain) NSString *Mobile;
@property(nonatomic, retain) NSString *Detail;
@property(nonatomic, retain) NSString *Province;
@property(nonatomic, retain) NSString *City;
@property(nonatomic, retain) NSString *Region;
@property(nonatomic, retain) NSNumber *IsDefault;
@property(nonatomic, retain) NSNumber *ProvinceCode;
@property(nonatomic, retain) NSNumber *CityCode;
@property(nonatomic, retain) NSNumber *RegionCode;
@property(nonatomic, retain) NSNumber *IsOrderAddress;

@end

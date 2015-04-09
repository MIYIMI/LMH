//
//  AddressVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-11.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "AddressVO.h"

@implementation AddressVO

@synthesize AddressID;
@synthesize Name;
@synthesize Mobile;
@synthesize Detail;
@synthesize Province;
@synthesize City;
@synthesize Region;
@synthesize IsDefault;
@synthesize ProvinceCode;
@synthesize CityCode;
@synthesize RegionCode;
@synthesize IsOrderAddress;

+ (AddressVO *)AddressVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [AddressVO AddressVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (AddressVO *)AddressVOWithDictionary:(NSDictionary *)dictionary
{
    AddressVO *instance = [[AddressVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)AddressVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[AddressVO AddressVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"address_id"] && ![[dictionary objectForKey:@"address_id"] isEqual:[NSNull null]]) {
            self.AddressID = [dictionary objectForKey:@"address_id"];
        }
        
        if (nil != [dictionary objectForKey:@"name"] && ![[dictionary objectForKey:@"name"] isEqual:[NSNull null]]) {
            self.Name = [dictionary objectForKey:@"name"];
        }
        
        if (nil != [dictionary objectForKey:@"mobile"] && ![[dictionary objectForKey:@"mobile"] isEqual:[NSNull null]]) {
            self.Mobile = [dictionary objectForKey:@"mobile"];
        }
        
        if (nil != [dictionary objectForKey:@"detail"] && ![[dictionary objectForKey:@"detail"] isEqual:[NSNull null]]) {
            self.Detail = [dictionary objectForKey:@"detail"];
        }
        
        if (nil != [dictionary objectForKey:@"province"] && ![[dictionary objectForKey:@"province"] isEqual:[NSNull null]]) {
            self.Province = [dictionary objectForKey:@"province"];
        }
        
        if (nil != [dictionary objectForKey:@"city"] && ![[dictionary objectForKey:@"city"] isEqual:[NSNull null]]) {
            self.City = [dictionary objectForKey:@"city"];
        }
        
        if (nil != [dictionary objectForKey:@"region"] && ![[dictionary objectForKey:@"region"] isEqual:[NSNull null]]) {
            self.Region = [dictionary objectForKey:@"region"];
        }
        
        if (nil != [dictionary objectForKey:@"is_default"] && ![[dictionary objectForKey:@"is_default"] isEqual:[NSNull null]]) {
            self.IsDefault = [dictionary objectForKey:@"is_default"];
        }
        
        if (nil != [dictionary objectForKey:@"default"] && ![[dictionary objectForKey:@"default"] isEqual:[NSNull null]]) {
            self.IsDefault = [dictionary objectForKey:@"default"];
        }
        
        if (nil != [dictionary objectForKey:@"province_code"] && ![[dictionary objectForKey:@"province_code"] isEqual:[NSNull null]]) {
            self.ProvinceCode = [dictionary objectForKey:@"province_code"];
        }
        
        if (nil != [dictionary objectForKey:@"city_code"] && ![[dictionary objectForKey:@"city_code"] isEqual:[NSNull null]]) {
            self.CityCode = [dictionary objectForKey:@"city_code"];
        }
        
        if (nil != [dictionary objectForKey:@"region_code"] && ![[dictionary objectForKey:@"region_code"] isEqual:[NSNull null]]) {
            self.RegionCode = [dictionary objectForKey:@"region_code"];
        }
        
        if (nil != [dictionary objectForKey:@"is_order_address"] && ![[dictionary objectForKey:@"is_order_address"] isEqual:[NSNull null]]) {
            self.IsOrderAddress = [dictionary objectForKey:@"is_order_address"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"AddressID = \"%@\"\r\n", AddressID];
    [descriptionOutput appendFormat: @"Name = \"%@\"\r\n", Name];
    [descriptionOutput appendFormat: @"Mobile = \"%@\"\r\n", Mobile];
    [descriptionOutput appendFormat: @"Detail = \"%@\"\r\n", Detail];
    [descriptionOutput appendFormat: @"Province = \"%@\"\r\n", Province];
    [descriptionOutput appendFormat: @"City = \"%@\"\r\n", City];
    [descriptionOutput appendFormat: @"Region = \"%@\"\r\n", Region];
    [descriptionOutput appendFormat: @"IsDefault = \"%@\"\r\n", IsDefault];
    [descriptionOutput appendFormat: @"ProvinceCode = \"%@\"\r\n", ProvinceCode];
    [descriptionOutput appendFormat: @"CityCode = \"%@\"\r\n", CityCode];
    [descriptionOutput appendFormat: @"RegionCode = \"%@\"\r\n", RegionCode];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[AddressID release];
	[Name release];
	[Mobile release];
	[Detail release];
	[Province release];
	[City release];
	[Region release];
	[IsDefault release];
	[ProvinceCode release];
	[CityCode release];
	[RegionCode release];
    
    [super dealloc];
#endif
}

@end

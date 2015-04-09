//
//  OrderDetailVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-18.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "OrderDetailVO.h"

@implementation OrderDetailVO

@synthesize Code;
@synthesize Msg;
@synthesize user_info;
@synthesize order_info;
@synthesize express_info;

+ (OrderDetailVO *)OrderDetailVOWithDictionary:(NSDictionary *)dictionary
{
    OrderDetailVO *instance = [[OrderDetailVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"code"] && ![[dictionary objectForKey:@"code"] isEqual:[NSNull null]]) {
            self.Code = [dictionary objectForKey:@"code"];
        }
        
        if (nil != [dictionary objectForKey:@"msg"] && ![[dictionary objectForKey:@"msg"] isEqual:[NSNull null]]) {
            self.Msg = [dictionary objectForKey:@"msg"];
        }
        
        if (nil != [dictionary objectForKey:@"order_info"] && ![[dictionary objectForKey:@"order_info"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"order_info"] isKindOfClass:[NSDictionary class]]) {
            self.order_info = [OrderInfoVO OrderInfoVOWithDictionary:[dictionary objectForKey:@"order_info"]];
        }
        
        if (nil != [dictionary objectForKey:@"user_info"] && ![[dictionary objectForKey:@"user_info"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"user_info"] isKindOfClass:[NSDictionary class]]) {
            self.user_info = [detailAddressVO detailAddressVOWithDictionary:[dictionary objectForKey:@"user_info"]];
        }
        
        if (nil != [dictionary objectForKey:@"express_info"] && ![[dictionary objectForKey:@"express_info"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"express_info"] isKindOfClass:[NSDictionary class]]) {
            self.express_info = [TranckVO TranckVOWithDictionary:[dictionary objectForKey:@"express_info"]];
        }
    }
    
    return self;
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[Code release];
	[Msg release];
	[user_info release];
	[order_info release];
    [express_info release];
    
    [super dealloc];
#endif
}

@end


@implementation detailAddressVO
@synthesize address;
@synthesize name;
@synthesize mobile;

+ (detailAddressVO *)detailAddressVOWithDictionary:(NSDictionary *)dictionary
{
    detailAddressVO *instance = [[detailAddressVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"address"] && ![[dictionary objectForKey:@"address"] isEqual:[NSNull null]]) {
            self.address = [dictionary objectForKey:@"address"];
        }else if(nil != dictionary[@"return_address"] && ![dictionary[@"return_address"] isEqual:[NSNull null]]){
            self.address = [dictionary objectForKey:@"return_address"];
        }
        
        if (nil != [dictionary objectForKey:@"name"] && ![[dictionary objectForKey:@"name"] isEqual:[NSNull null]]) {
            self.name = [dictionary objectForKey:@"name"];
        }else if(nil != dictionary[@"username"] && ![dictionary[@"username"] isEqual:[NSNull null]]){
            self.name = [dictionary objectForKey:@"username"];
        }
        
        if (nil != [dictionary objectForKey:@"mobile"] && ![[dictionary objectForKey:@"mobile"] isEqual:[NSNull null]]) {
            self.mobile = [dictionary objectForKey:@"mobile"];
        }else if(nil != dictionary[@"phone"] && ![dictionary[@"phone"] isEqual:[NSNull null]]){
            self.mobile = [dictionary objectForKey:@"phone"];
        }
    }
    
    return self;
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
    [address release];
    [name release];
    [mobile release];
    
    [super dealloc];
#endif
}

@end


@implementation TranckVO
@synthesize express_name;
@synthesize express_num;
@synthesize express_detail;
@synthesize context;
@synthesize time;
@synthesize ftime;

+ (NSArray *)TranckVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[TranckVO TranckVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

+ (TranckVO *)TranckVOWithDictionary:(NSDictionary *)dictionary{
    TranckVO *instance = [[TranckVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"express_name"] && ![[dictionary objectForKey:@"express_name"] isEqual:[NSNull null]]) {
            self.express_name = [dictionary objectForKey:@"express_name"];
        }
        
        if (nil != [dictionary objectForKey:@"express_num"] && ![[dictionary objectForKey:@"express_num"] isEqual:[NSNull null]]) {
            self.express_num = [dictionary objectForKey:@"express_num"];
        }
        
        if (nil != [dictionary objectForKey:@"express_detail"] && ![[dictionary objectForKey:@"express_detail"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"express_detail"] isKindOfClass:[NSArray class]]) {
            self.express_detail = [TranckVO TranckVOListWithArray:[dictionary objectForKey:@"express_detail"]];
        }
        
        if (nil != [dictionary objectForKey:@"context"] && ![[dictionary objectForKey:@"context"] isEqual:[NSNull null]]) {
            self.context = [dictionary objectForKey:@"context"];
        }
        
        if (nil != [dictionary objectForKey:@"time"] && ![[dictionary objectForKey:@"time"] isEqual:[NSNull null]]) {
            self.time = [dictionary objectForKey:@"time"];
        }
        
        if (nil != [dictionary objectForKey:@"ftime"] && ![[dictionary objectForKey:@"ftime"] isEqual:[NSNull null]]) {
            self.ftime = [dictionary objectForKey:@"ftime"];
        }
    }
    
    return self;
}

@end


//
//  CategoryDataModel.m
//  YingMeiHui
//
//  Created by KevinKong on 14-9-22.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "CategoryDataModel.h"

@implementation CategoryDataModel
@synthesize cate_id;
@synthesize title;
@synthesize pid;
@synthesize image;
@synthesize cate_son;
@synthesize flag;

+ (CategoryDataModel *)CategoryDataModelWithDictionary:(NSDictionary *)dictionary{
    CategoryDataModel *instance = [[CategoryDataModel alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)CategoryDataModelWithArray:(NSArray *)array{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[CategoryDataModel CategoryDataModelWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"cate_id"] && ![[dictionary objectForKey:@"cate_id"] isEqual:[NSNull null]]) {
            self.cate_id = [dictionary objectForKey:@"cate_id"];
        }
        
        if (nil != [dictionary objectForKey:@"title"] && ![[dictionary objectForKey:@"title"] isEqual:[NSNull null]]) {
            self.title = [dictionary objectForKey:@"title"];
        }
        
        if (nil != [dictionary objectForKey:@"pid"] && ![[dictionary objectForKey:@"pid"] isEqual:[NSNull null]]) {
            self.pid = [dictionary objectForKey:@"pid"];
        }
        
        if (nil != [dictionary objectForKey:@"image"] && ![[dictionary objectForKey:@"image"] isEqual:[NSNull null]]) {
            self.image = [dictionary objectForKey:@"image"];
        }
        
        if (nil != [dictionary objectForKey:@"flag"] && ![[dictionary objectForKey:@"flag"] isEqual:[NSNull null]]) {
            self.flag = [dictionary objectForKey:@"flag"];
        }
        
        if (nil != [dictionary objectForKey:@"cate_son"] && ![[dictionary objectForKey:@"cate_son"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"cate_son"] isKindOfClass:[NSArray class]]) {
            self.cate_son = [dictionary objectForKey:@"cate_son"];
        }
    }
    
    return self;
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
    [cate_id release];
    [title release];
    [pid release];
    [image release];
    [flag release];
    [childDataModels release];
    
    [super dealloc];
#endif
}
@end

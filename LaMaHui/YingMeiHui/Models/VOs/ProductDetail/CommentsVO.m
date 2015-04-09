//
//  CommentsVO.m
//  YingMeiHui
//
//  Created by work on 14-10-15.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "CommentsVO.h"

@implementation CommentsVO

@synthesize comments_sroce;
@synthesize comments_count;
@synthesize comments;
@synthesize user_name;
@synthesize content;
@synthesize create_at;
@synthesize update_at;
@synthesize spec;
@synthesize color;
@synthesize size;

+ (CommentsVO *)CommentsVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [CommentsVO CommentsVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (NSArray *)CommentsVOWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[CommentsVO CommentsVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

+ (CommentsVO *)CommentsVOWithDictionary:(NSDictionary *)dictionary
{
    CommentsVO *instance = [[CommentsVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"comments_sroce"] && ![[dictionary objectForKey:@"comments_sroce"] isEqual:[NSNull null]]) {
            self.comments_sroce = [dictionary objectForKey:@"comments_sroce"];
        }
        
        if (nil != [dictionary objectForKey:@"comments_count"] && ![[dictionary objectForKey:@"comments_count"] isEqual:[NSNull null]]) {
            self.comments_count = [dictionary objectForKey:@"comments_count"];
        }
        
        if (nil != [dictionary objectForKey:@"comments"] && ![[dictionary objectForKey:@"comments"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"comments"] isKindOfClass:[NSArray class]]) {
            self.comments = [CommentsVO CommentsVOWithArray:[dictionary objectForKey:@"comments"]];
        }
        
        if (nil != [dictionary objectForKey:@"user_name"] && ![[dictionary objectForKey:@"user_name"] isEqual:[NSNull null]]) {
            self.user_name = [dictionary objectForKey:@"user_name"];
        }
        
        if (nil != [dictionary objectForKey:@"content"] && ![[dictionary objectForKey:@"content"] isEqual:[NSNull null]]) {
            self.content = [dictionary objectForKey:@"content"];
        }
        
        if (nil != [dictionary objectForKey:@"create_at"] && ![[dictionary objectForKey:@"create_at"] isEqual:[NSNull null]]) {
            self.create_at = [[dictionary objectForKey:@"create_at"] stringValue];
        }
        
        if (nil != [dictionary objectForKey:@"update_at"] && ![[dictionary objectForKey:@"update_at"] isEqual:[NSNull null]]) {
            self.update_at = [dictionary objectForKey:@"update_at"];
        }
        
        if (nil != [dictionary objectForKey:@"guige"] && ![[dictionary objectForKey:@"guige"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"guige"] isKindOfClass:[NSArray class]]) {
            self.spec = [CommentsVO CommentsVOWithArray:[dictionary objectForKey:@"guige"]];
        }
        
        if (nil != [dictionary objectForKey:@"color"] && ![[dictionary objectForKey:@"color"] isEqual:[NSNull null]]) {
            self.color = [dictionary objectForKey:@"color"];
        }
        
        if (nil != [dictionary objectForKey:@"size"] && ![[dictionary objectForKey:@"size"] isEqual:[NSNull null]]) {
            self.size = [dictionary objectForKey:@"size"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"Code = \"%@\"\r\n", comments_sroce];
    [descriptionOutput appendFormat: @"Msg = \"%@\"\r\n", comments_count];
    [descriptionOutput appendFormat: @"BrandTitle = \"%@\"\r\n", comments];
    [descriptionOutput appendFormat: @"Pics = \"%@\"\r\n", user_name];
    [descriptionOutput appendFormat: @"Title = \"%@\"\r\n", content];
    [descriptionOutput appendFormat: @"Title = \"%@\"\r\n", create_at];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
    [comments_sroce release];
    [comments_count release];
    [comments release];
    [user_name release];
    [content release];
    [create_at release];
    [update_at release];
    [spec release];
    [color release];
    [size release];
    
    [super dealloc];
#endif
}

@end

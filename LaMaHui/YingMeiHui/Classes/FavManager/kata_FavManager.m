//
//  kata_FavManager.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-15.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_FavManager.h"

#define GOODS_HISTORY_LIST_SIZE     40

static kata_FavManager *__sharedFavManager;
static NSString *const __kfavProductsInfoFileName   = @"B911B78DSQAD98D7";
static NSString *const __kfavDateFileName           = @"B911B7DEWSDD98D7";

@interface kata_FavManager ()

- (NSString *)favFileFullPath;
- (NSString *)favDateFileFullPath;

@end

@implementation kata_FavManager

+ (kata_FavManager *)sharedFavManager
{
    if (!__sharedFavManager) {
        __sharedFavManager = [[kata_FavManager alloc] init];
    }
    
    [__sharedFavManager setFavDate];
    
    return __sharedFavManager;
}

- (NSArray *)favProducts
{
    NSString *path = [self favFileFullPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:path]) {
        NSArray *info = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if ([info count] > 0) {
            return info;
        }
    }
    return nil;
}

- (NSString *)favDate
{
    NSString *path = [self favDateFileFullPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:path]) {
        NSString *info = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (info) {
            return info;
        }
    }
    return nil;
}

- (BOOL)addFavInfo:(NSDictionary *)favData
{
    NSString *path = [self favFileFullPath];
    
    NSMutableArray *currentFavArrInfo = [[NSMutableArray alloc] initWithArray:[self favProducts]];
    if ([currentFavArrInfo containsObject:favData]) {
        for (NSDictionary *productInfoDict in currentFavArrInfo) {
            if ([favData isEqualToDictionary:productInfoDict]) {
                [currentFavArrInfo removeObject:productInfoDict];
                [currentFavArrInfo insertObject:favData atIndex:0];
                break;
            }
        }
    } else {
        if ([currentFavArrInfo count] < GOODS_HISTORY_LIST_SIZE) {
            [currentFavArrInfo insertObject:favData atIndex:0];
        } else {
            [currentFavArrInfo insertObject:favData atIndex:0];
            [currentFavArrInfo removeLastObject];
        }
    }
    
    return [NSKeyedArchiver archiveRootObject:currentFavArrInfo toFile:path];
}

- (BOOL)removeFavInfo:(NSDictionary *)favData
{
    NSString *path = [self favFileFullPath];
    
    NSMutableArray *currentFavArrInfo = [[NSMutableArray alloc] initWithArray:[self favProducts]];
    if ([currentFavArrInfo containsObject:favData]) {
        [currentFavArrInfo removeObject:favData];
    }
    
    return [NSKeyedArchiver archiveRootObject:currentFavArrInfo toFile:path];
}

- (BOOL)setFavDate
{
    NSString *path = [self favDateFileFullPath];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    if (![self favDate] || ![[self favDate] isEqualToString:dateStr]) {
        [self cleanFav];
    }
    return [NSKeyedArchiver archiveRootObject:dateStr toFile:path];
}

- (BOOL)cleanFav
{
    NSString *path = [self favFileFullPath];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        return [fm removeItemAtPath:path error:nil];
    }
    
    return YES;
}

- (NSString *)favFileFullPath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullPath = [path stringByAppendingPathComponent:__kfavProductsInfoFileName];
    
    return fullPath;
}

- (NSString *)favDateFileFullPath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullPath = [path stringByAppendingPathComponent:__kfavDateFileName];
    
    return fullPath;
}

@end

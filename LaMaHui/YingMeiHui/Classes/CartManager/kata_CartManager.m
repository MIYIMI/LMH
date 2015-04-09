//
//  kata_CartManager.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-8-13.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_CartManager.h"

static kata_CartManager *__sharedCartManager;
static NSString *const __kCartInfoFileName          =   @"B911B8DD1ABEE8D0";
static NSString *const __kCartCounterFileName       =   @"B911B9FD1AD998D2";
static NSString *const __kCartSkuFileName       =   @"B911B9FD1AD998D4";
static NSString *const __KGoToHomeFileName      = @"B911B9FD1AD998D5";
@interface kata_CartManager (/* 私有方法 */)

- (NSString *)cartFileFullPath;
- (NSString *)cartCounterFileFullPath;

@end

@implementation kata_CartManager

+ (kata_CartManager *)sharedCartManager
{
    if (!__sharedCartManager) {
        __sharedCartManager = [[kata_CartManager alloc] init];
    }
    
    return __sharedCartManager;
}

- (BOOL)hasCartID
{
    NSString *info = [self cartID];
    
    if (info) {
        return YES;
    }
    
    return NO;
}

- (NSString *)cartID
{
    NSString *path = [self cartFileFullPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:path]) {
        NSDictionary *info = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if ([info.allKeys count] > 0) {
            if ([info objectForKey:@"cartid"] && [[info objectForKey:@"cartid"] isKindOfClass:[NSString class]]) {
                return [info objectForKey:@"cartid"];
            }
        }
    }
    
    return nil;
}

- (NSMutableArray *)cartSkuID
{
    NSString *path = [self cartSkuFileFullPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:path]) {
        NSMutableArray *info = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        return info;
    }
    
    return nil;
}

- (NSNumber *)cartCounter
{
    NSString *path = [self cartCounterFileFullPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:path]) {
        NSDictionary *info = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if ([info.allKeys count] > 0) {
            if ([info objectForKey:@"cartcounter"] && [[info objectForKey:@"cartcounter"] isKindOfClass:[NSNumber class]]) {
                return [info objectForKey:@"cartcounter"];
            }
        }
    }
    
    return nil;
}

- (BOOL)updateCartID:(NSString *)cartid
{
    NSString *path = [self cartFileFullPath];
    
    NSDictionary *cartDict = nil;
    if (cartid) {
        cartDict = [NSDictionary dictionaryWithObjectsAndKeys:cartid, @"cartid", nil];
    }
    
    return [NSKeyedArchiver archiveRootObject:cartDict toFile:path];
}

- (BOOL)updateCartSku:(NSMutableArray *)cartArr
{
    NSString *path = [self cartSkuFileFullPath];
    return [NSKeyedArchiver archiveRootObject:cartArr toFile:path];
}

- (BOOL)updateCartCounter:(NSNumber *)cartcounter
{
    NSString *path = [self cartCounterFileFullPath];
    
    NSDictionary *cartDict = nil;
    if (cartcounter) {
        NSInteger counter = [cartcounter intValue]<0?0:[cartcounter intValue];
        cartDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:counter], @"cartcounter", nil];
    }
    
    return [NSKeyedArchiver archiveRootObject:cartDict toFile:path];
}

- (NSString *)cartFileFullPath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullPath = [path stringByAppendingPathComponent:__kCartInfoFileName];
    
    return fullPath;
}

- (NSString *)cartSkuFileFullPath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullPath = [path stringByAppendingPathComponent:__kCartSkuFileName];
    
    return fullPath;
}

- (NSString *)cartCounterFileFullPath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullPath = [path stringByAppendingPathComponent:__kCartCounterFileName];
    
    return fullPath;
}

-(NSString *)goToHomeFileFullPath{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullPath = [path stringByAppendingPathComponent:__KGoToHomeFileName];
    
    return fullPath;
    
}

- (BOOL)removeCartID
{
    NSString *path = [self cartFileFullPath];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        return [fm removeItemAtPath:path error:nil];
    }
    
    return YES;
}

- (BOOL)removeCartCounter
{
    NSString *path = [self cartCounterFileFullPath];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        return [fm removeItemAtPath:path error:nil];
    }
    
    return YES;
}

- (BOOL)removeCartSku
{
    NSString *path = [self cartSkuFileFullPath];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        return [fm removeItemAtPath:path error:nil];
    }
    
    return YES;
}

-(void)setGoToHomePage:(BOOL)toHomePage{ // 用于在购物车为nill时,用户点击去首页逛逛,写状态跳转.
    //
    NSString *path = [self goToHomeFileFullPath];
    
    NSDictionary *cartDict = nil;

    cartDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:toHomePage], @"isGoToHomePage", nil];
    
     [NSKeyedArchiver archiveRootObject:cartDict toFile:path];
}

-(BOOL)isGoToHomePage{
    NSString *path = [self goToHomeFileFullPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:path]) {
        NSDictionary *info = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if ([info.allKeys count] > 0) {
            return [[info objectForKey:@"isGoToHomePage"] boolValue];
        }
    }
    
    return NO;
}

@end

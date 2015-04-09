//
//  KTProductListDataGetRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-2.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTProductListDataGetRequest.h"

@implementation KTProductListDataGetRequest

- (id)initWithBrandID:(NSInteger)brandid
       andFilterStock:(NSInteger)stock
            andCateID:(NSInteger)cateid
            andSizeID:(NSInteger)sizeid
         andProductID:(NSInteger)productid
              andSort:(NSInteger)sort
          andPageSize:(NSInteger)pagesize
           andPageNum:(NSInteger)pageno
          andPlatform:(NSString *)platform
            andUserID:(NSInteger)userid
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:5];
        if (brandid != -1) {
            [subParams setObject:[NSNumber numberWithInteger:brandid] forKey:@"brand_id"];
        }
        
        [subParams setObject:[NSNumber numberWithInteger:stock] forKey:@"filter_stock"];
        [subParams setObject:[NSNumber numberWithInteger:sort] forKey:@"sort"];
        
        if (cateid != -1) {
            [subParams setObject:[NSNumber numberWithInteger:cateid] forKey:@"cate_id"];
        }
        
        if (sizeid != -1) {
            [subParams setObject:[NSNumber numberWithInteger:sizeid] forKey:@"size_id"];
        }
        
        if (pagesize != -1) {
            [subParams setObject:[NSNumber numberWithInteger:pagesize] forKey:@"page_size"];
        } else {
            [subParams setObject:[NSNumber numberWithInteger:20] forKey:@"page_size"];
        }
        
        if (pageno != -1) {
            [subParams setObject:[NSNumber numberWithInteger:pageno] forKey:@"page_no"];
        } else {
            [subParams setObject:[NSNumber numberWithInteger:1] forKey:@"page_no"];
        }
        
        if(userid >= 0){
            [subParams setObject:[NSNumber numberWithInteger:userid] forKey:@"user_id"];
        }
        
        if(productid >= 0){
            [subParams setObject:[NSNumber numberWithInteger:productid] forKey:@"product_id"];
        }
        
        if (platform) {
            [subParams setObject:platform forKey:@"source_platform"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"productlist_data_get";
}

@end

//
//  kata_ProductDetailViewController.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-7.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "FTStatefulTableViewController.h"
#import "kata_LoginViewController.h"
#import "EGOImageView.h"
#import "SDWebImagePrefetcher.h"
#import "PopSkuView.h"
#import "AloneProductCellTableViewCell.h"

typedef enum{
    ProductDetailType_noraml,// 正常流程进入的 商品详情.
    ProductDetailType_SeckillActivity
}ProductDetailType;

@interface kata_ProductDetailViewController : FTStatefulTableViewController
<
LoginDelegate,
EGOImageViewDelegate,
UIActionSheetDelegate,
UIScrollViewDelegate,
SDWebImagePrefetcherDelegate,
PopSkuViewDelegate,
UIGestureRecognizerDelegate,
AloneProductCellTableViewCellDelgate
>

- (id)initWithProductID:(NSInteger)productid
               andType:(NSNumber *)productType andSeckillID:(NSInteger)seckillID;
@end

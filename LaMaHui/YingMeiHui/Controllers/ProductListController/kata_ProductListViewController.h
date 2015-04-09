//
//  kata_ProductListViewController.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-2.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "FTStatefulTableViewController.h"
#import "kata_TableListTabBar.h"
#import "KATAFocusViewController.h"
#import "SDWebImagePrefetcher.h"

@interface kata_ProductListViewController : FTStatefulTableViewController <TableListTabBarDelegate,KATAFocusViewControllerDelegate,SDWebImageManagerDelegate>

- (id)initWithBrandID:(NSInteger)brandid
             andTitle:(NSString *)title
         andProductID:(NSInteger)productid
          andPlatform:(NSString *)platform
            isChannel:(BOOL)ischannel;

@end

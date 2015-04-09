//
//  LMHCellView.h
//  Test
//
//  Created by work on 14-8-31.
//  Copyright (c) 2014年 LYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import <UIImageView+AFNetworking.h>
#import "SDWebImageManager.h"

@protocol LMHCellViewDelegate;

@interface LMHCellView : UITableViewCell<SDWebImageManagerDelegate,SDWebImageManagerDelegate>

@property (nonatomic, assign) id<LMHCellViewDelegate> detailDelegate;

-(void)setImageURL:(NSURL *)imageUrl;

@end

@protocol LMHCellViewDelegate <NSObject>
-(void) chaneCellHegith:(NSMutableDictionary *)heightDict;
@end

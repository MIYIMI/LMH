//
//  KTProductMoreInfoTableViewCell.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-24.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KTProductMoreInfoTableViewCellDelegate;

@interface KTProductMoreInfoTableViewCell : UITableViewCell  <UIWebViewDelegate>

@property (strong, nonatomic) NSString *content;
@property (assign, nonatomic) id<KTProductMoreInfoTableViewCellDelegate> infoCellDelegate;

@end

@protocol KTProductMoreInfoTableViewCellDelegate <NSObject>

- (void)heightForCell:(CGFloat)height;

@end

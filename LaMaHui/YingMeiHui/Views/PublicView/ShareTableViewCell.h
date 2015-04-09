//
//  ShareTableViewCell.h
//  YingMeiHui
//
//  Created by work on 14-11-15.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareTableViewCell : UITableViewCell
{
    UIImageView *iconView;
    UILabel *tentLbL;
    UILabel *creditLbl;
    UIButton *rightBtn;
}

-(void)layoutUI:(NSInteger)row;

@end

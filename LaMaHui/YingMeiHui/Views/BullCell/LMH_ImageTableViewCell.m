//
//  LMH_ImageTableViewCell.m
//  YingMeiHui
//
//  Created by work on 15/5/28.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "LMH_ImageTableViewCell.h"

#define SPACE_HEIGHT    10.0f

@interface LMH_ImageTableViewCell()

@end

@implementation LMH_ImageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    
    return self;
}

- (void)layoutUI:(NSArray *)imgArray{
    for (UIView *uview in self.contentView.subviews) {
        if (uview.tag > 1000) {
            [uview removeFromSuperview];
        }
    }
    
    CGFloat offsetX = (ScreenW-20)/27;//7(图像个数)*3(占比)+6(间隔个数)=27(除去两边的空白的份数)
    CGFloat imgX = offsetX*3;
    
    for (int i = 0; i <= (imgArray.count>14?13:imgArray.count); i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i%7*(imgX+offsetX)+SPACE_HEIGHT, i/7*(imgX+offsetX)+SPACE_HEIGHT, imgX, imgX)];
        if (i < (imgArray.count>14?13:imgArray.count)) {
            [imgView sd_setImageWithURL:[NSURL URLWithString:imgArray[i]?imgArray[i]:@""]];
        }
        if (i == (imgArray.count>14?13:imgArray.count)) {
            imgView.image = LOCAL_IMG(@"img_default");
        }
        imgView.tag = 1000+i;
        [self.contentView addSubview:imgView];
    }
}

@end

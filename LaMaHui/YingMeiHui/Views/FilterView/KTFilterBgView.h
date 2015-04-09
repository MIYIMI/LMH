//
//  KTFilterBgView.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-4.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTFilterBgView : UIView

@property (strong, nonatomic) UIActivityIndicatorView * loadingView;

@property (strong, nonatomic) UIView * bgView;

- (id)initWithFrame:(CGRect)frame andXOffset:(CGFloat)pXOffset;

- (void)setOffsetX:(CGFloat)pXoffset;
- (void)setFooterOffsetY:(CGFloat)pYoffset;

@end

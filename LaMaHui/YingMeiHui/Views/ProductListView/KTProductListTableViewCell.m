//
//  KTProductListTableViewCell.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-3.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTProductListTableViewCell.h"
#import "KTProductView.h"
#import <QuartzCore/QuartzCore.h>

#define kProductViewPadding         4.0f
#define kProductViewOringin         8.0f
#define kProductViewWidth           150.0f
#define kProductViewHight           140.0f
#define kImageFrameRatio            1.25f
#define BACKGROUND_COLOR            [UIColor clearColor]

@interface KTProductListTableViewCell ()
{
    UIView *__productsFrameView;
}

@end

@implementation KTProductListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:BACKGROUND_COLOR];
        [[self contentView] setBackgroundColor:BACKGROUND_COLOR];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark init view
////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setProductDataArr:(NSMutableArray *)ProductDataArr
{
    _ProductDataArr = ProductDataArr;
    
    NSInteger productscount = 0;
    
    if (_ProductDataArr) {
        productscount = _ProductDataArr.count;
        
        if (!__productsFrameView) {
            __productsFrameView = [[UIView alloc] initWithFrame:CGRectMake(kProductViewOringin, 0, 320, kProductViewHight * ceil(productscount / 2.0))];
            [__productsFrameView setBackgroundColor:[UIColor clearColor]];
            
            [self.contentView addSubview:__productsFrameView];
        }
        
        for (NSInteger i = 0; i < productscount; i++) {
            NSInteger xcount = i % 2;
            NSInteger ycount = i / 2;
            KTProductView *productView = [[KTProductView alloc] initWithFrame:CGRectMake((kProductViewWidth + kProductViewPadding) * xcount, (kProductViewHight * kImageFrameRatio + kProductViewPadding) * ycount + kProductViewPadding / 2, kProductViewWidth,kProductViewHight)];
            
//            productView.layer.shadowColor = [UIColor grayColor].CGColor;
//            productView.layer.shadowOpacity = 0.4;
//            productView.layer.shadowOffset = CGSizeMake(0, 1);
//            productView.layer.shadowPath = [UIBezierPath bezierPathWithRect:productView.bounds].CGPath;
            
            id vo = [_ProductDataArr objectAtIndex:i];
            if ([vo isKindOfClass:[ProductVO class]]) {
                ProductVO *productVO = (ProductVO *)[_ProductDataArr objectAtIndex:i];
                [productView setProductData:productVO];
            }
            [__productsFrameView addSubview:productView];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(productTaped:)];
            [productView addGestureRecognizer:tapGesture];
        }
    }
}

- (void)productTaped:(id)sender
{
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *tapGR = (UITapGestureRecognizer *)sender;
        if ([tapGR.view isKindOfClass:[KTProductView class]]) {
            KTProductView *view = (KTProductView *)tapGR.view;
            if (self.productCellDelegate && [self.productCellDelegate respondsToSelector:@selector(tapAtProduct:)]) {
                [self.productCellDelegate tapAtProduct:view.ProductData];
            }
        }
    }
}

- (void)prepareForReuse
{
    [__productsFrameView removeFromSuperview];
    __productsFrameView = nil;
}

@end

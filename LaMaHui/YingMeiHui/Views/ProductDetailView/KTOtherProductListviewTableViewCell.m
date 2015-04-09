//
//  KTOtherProductListviewTableViewCell.m
//  YingMeiHui
//
//  Created by work on 14-10-9.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTOtherProductListviewTableViewCell.h"
#import "KTProductView.h"
#import <QuartzCore/QuartzCore.h>

#define kProductViewPadding         5.0f
#define kProductViewOringin         5.0f
#define kProductViewWidth           (ScreenW - 20) / 3
#define kProductViewHight           (ScreenW - 20)/3/100 *170
#define kImageFrameRatio            1.25f
#define BACKGROUND_COLOR            [UIColor clearColor]

@implementation KTOtherProductListviewTableViewCell
{
    UIView *__productsFrameView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:BACKGROUND_COLOR];
        [[self contentView] setBackgroundColor:BACKGROUND_COLOR];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setProductDataArr:(NSMutableArray *)ProductDataArr
{
    _ProductDataArr = ProductDataArr;
    
    NSInteger productscount = 0;
    
    if (_ProductDataArr) {
        productscount = _ProductDataArr.count;
        
        if (!__productsFrameView) {
            __productsFrameView = [[UIView alloc] initWithFrame:CGRectMake(kProductViewOringin, 0, CGRectGetWidth(self.frame), kProductViewHight)];
            [__productsFrameView setBackgroundColor:[UIColor clearColor]];
            
            [self.contentView addSubview:__productsFrameView];
        }
        
        for (NSInteger i = 0; i < productscount; i++) {
            NSInteger xcount = i % 3;
            //NSInteger ycount = i / 3;
            KTProductView *productView = [[KTProductView alloc] initWithFrame:CGRectMake((kProductViewWidth + kProductViewPadding) * xcount, kProductViewOringin, kProductViewWidth,kProductViewHight)];
            
            id vo = [_ProductDataArr objectAtIndex:i];
            if ([vo isKindOfClass:[LikeProductVO class]]) {
                LikeProductVO *productVO = (LikeProductVO *)[_ProductDataArr objectAtIndex:i];
                [productView setLikeData:productVO];
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
                [self.productCellDelegate tapAtProduct:view.LikeData];
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

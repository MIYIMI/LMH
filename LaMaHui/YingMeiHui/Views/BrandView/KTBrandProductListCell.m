//
//  KTBrandProductListCell.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-6-17.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBrandProductListCell.h"
#import "MenuItemVO.h"
#import "KTBrandProductView.h"
#import <QuartzCore/QuartzCore.h>

#define kProductViewPadding         4.0f
#define kProductViewOringin         8.0f
#define kProductViewWidth           150.0f
#define kProductViewHight           250.0f
#define kImageFrameRatio            1.25f
#define BACKGROUND_COLOR            [UIColor clearColor]

@interface KTBrandProductListCell ()
{
    UIView *__productsFrameView;
}

@end

@implementation KTBrandProductListCell

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

- (void)setItemDataArr:(NSMutableArray *)ItemDataArr
{
    _ItemDataArr = ItemDataArr;
    
    NSInteger productscount = 0;
    
    if (_ItemDataArr) {
        productscount = _ItemDataArr.count;
        
        if (!__productsFrameView) {
            __productsFrameView = [[UIView alloc] initWithFrame:CGRectMake(kProductViewOringin, 0, 320 - kProductViewOringin * 2.0, kProductViewWidth*kImageFrameRatio)];
            //[__productsFrameView setBackgroundColor:[UIColor clearColor]];
            
            [self.contentView addSubview:__productsFrameView];
        }
        
        for (NSInteger i = 0; i < productscount; i++) {
            NSInteger xcount = i % 2;
            NSInteger ycount = i / 2;
            KTBrandProductView *productView = [[KTBrandProductView alloc] initWithFrame:CGRectMake((kProductViewWidth + kProductViewPadding) * xcount, (kProductViewWidth * kImageFrameRatio + kProductViewPadding) * ycount + kProductViewPadding / 2, kProductViewWidth, kProductViewWidth*kImageFrameRatio)];
            
//            productView.layer.shadowColor = [UIColor grayColor].CGColor;
//            productView.layer.shadowOpacity = 0.4;
//            productView.layer.shadowOffset = CGSizeMake(0, 1);
//            productView.layer.shadowPath = [UIBezierPath bezierPathWithRect:productView.bounds].CGPath;
            
            id vo = [_ItemDataArr objectAtIndex:i];
            if ([vo isKindOfClass:[MenuItemVO class]]) {
                MenuItemVO *productVO = (MenuItemVO *)[_ItemDataArr objectAtIndex:i];
                [productView setItemData:productVO];
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
        if ([tapGR.view isKindOfClass:[KTBrandProductView class]]) {
            KTBrandProductView *view = (KTBrandProductView *)tapGR.view;
            if (self.braproCellDelegate && [self.braproCellDelegate respondsToSelector:@selector(tapAtItem:)]) {
                [self.braproCellDelegate tapAtItem:view.ItemData];
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

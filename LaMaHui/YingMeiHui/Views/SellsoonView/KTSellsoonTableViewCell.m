//
//  KTSellsoonTableViewCell.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-1.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTSellsoonTableViewCell.h"
#import "SellsoonbrandVO.h"
#import "KTSellsoonBrandView.h"
#import <QuartzCore/QuartzCore.h>

#define kTopicImagePadding          8.0f
#define kBrandViewHeight            160.0f
#define kImageFrameRatio            0.868f
#define BACKGROUND_COLOR            [UIColor clearColor]

@interface KTSellsoonTableViewCell ()
{
    UIView *__brandsFrameView;
}

@end

@implementation KTSellsoonTableViewCell

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

- (void)setSellsoonDataArr:(NSMutableArray *)SellsoonDataArr
{
    _SellsoonDataArr = SellsoonDataArr;
    
    CGFloat originx = 20;
    NSInteger sellsooncount = 0;
    
    if (_SellsoonDataArr) {
        sellsooncount = _SellsoonDataArr.count;
        
        if (!__brandsFrameView) {
            __brandsFrameView = [[UIView alloc] initWithFrame:CGRectMake(originx, 0, 286, 168 * ceil(sellsooncount / 2.0))];
            [__brandsFrameView setBackgroundColor:[UIColor clearColor]];
            
            [self.contentView addSubview:__brandsFrameView];
        }
        
        for (NSInteger i = 0; i < sellsooncount; i++) {
            NSInteger xcount = i % 2;
            NSInteger ycount = i / 2;
            KTSellsoonBrandView *brandView = [[KTSellsoonBrandView alloc] initWithFrame:CGRectMake((kBrandViewHeight * kImageFrameRatio + kTopicImagePadding) * xcount, (kBrandViewHeight + kTopicImagePadding) * ycount + kTopicImagePadding / 2, kBrandViewHeight * kImageFrameRatio, kBrandViewHeight)];
            
//            brandView.layer.shadowColor = [UIColor grayColor].CGColor;
//            brandView.layer.shadowOpacity = 0.2;
//            brandView.layer.shadowOffset = CGSizeMake(0, 0);
//            brandView.layer.shadowPath = [UIBezierPath bezierPathWithRect:brandView.bounds].CGPath;
            
            id vo = [_SellsoonDataArr objectAtIndex:i];
            if ([vo isKindOfClass:[SellsoonbrandVO class]]) {
                SellsoonbrandVO *brandVO = (SellsoonbrandVO *)[_SellsoonDataArr objectAtIndex:i];
                [brandView setSellsoonBrandData:brandVO];
            }
            [__brandsFrameView addSubview:brandView];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(brandTaped:)];
            [brandView addGestureRecognizer:tapGesture];
        }
    }
}

- (void)brandTaped:(id)sender
{
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *tapGR = (UITapGestureRecognizer *)sender;
        if ([tapGR.view isKindOfClass:[KTSellsoonBrandView class]]) {
            KTSellsoonBrandView *view = (KTSellsoonBrandView *)tapGR.view;
            NSInteger brandid = [view.SellsoonBrandData.BrandID intValue];
            BOOL subscribed = [view.SellsoonBrandData.IsSubscribed boolValue];
            if (self.sellsoonCellDelegate && [self.sellsoonCellDelegate respondsToSelector:@selector(tapAtBrand:andIsSubscribed:)]) {
                [self.sellsoonCellDelegate tapAtBrand:brandid andIsSubscribed:subscribed];
            }
        }
    }
}

- (void)prepareForReuse
{
    [__brandsFrameView removeFromSuperview];
    __brandsFrameView = nil;
}

@end

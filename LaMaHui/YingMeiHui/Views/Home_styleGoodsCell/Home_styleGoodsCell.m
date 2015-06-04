//
//  Home_styleGoodsCell.m
//  YingMeiHui
//
//  Created by Zhumingming on 15-1-5.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "Home_styleGoodsCell.h"
#import "HomeVO.h"
#import "AdvVO.h"
#import <UIImageView+WebCache.h>

@implementation Home_styleGoodsCell
{
    UILabel *styleLabel;
    NSMutableArray *actViewArray;
    NSMutableArray *imgViewArray;
    
    HomeBrandVO *_seckillVO;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        actViewArray = [[NSMutableArray alloc] init];
        imgViewArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)layoutUI:(HomeBrandVO*)seckillVO{
    
    //UI部分
    _seckillVO = seckillVO;
    CGFloat th = 30;
    AdvVO *vo1;
    AdvVO *vo2;
    AdvVO *vo3;
    
    for (int i = 0; i<_seckillVO.brandArray.count; i++) {
        
        if (i == 0 ) {
            vo1 = _seckillVO.brandArray[i];
        }
        if (i == 1 ) {
            vo2 = _seckillVO.brandArray[i];
        }
        if (i == 2 ) {
            vo3 = _seckillVO.brandArray[i];
        }
        
    }
    CGFloat leftViewH = 363*ScreenW/640;
    if (!styleLabel) {
        UILabel *grayLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
        grayLbl.backgroundColor = GRAY_CELL_COLOR;
        [self addSubview:grayLbl];
        
        UILabel *styleback = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 30)];
        styleback.backgroundColor = [UIColor whiteColor];
        [self addSubview:styleback];
        
        styleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, ScreenW-5, 30)];
        styleLabel.backgroundColor = [UIColor clearColor];
        styleLabel.font = FONT(14);
        styleLabel.textColor = [UIColor grayColor];
        [self addSubview:styleLabel];
        
        UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, th, ScreenW/2, leftViewH)];
        [imgView1 sd_setImageWithURL:[NSURL URLWithString:vo1.Pic] placeholderImage:nil];
        [self addSubview:imgView1];
        [imgViewArray addObject:imgView1];
        UIView *actView1 = [[UIView alloc] initWithFrame:imgView1.frame];
        [actViewArray addObject:actView1];
        [self addSubview:actView1];
        actView1.tag = 10001;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [actView1 addGestureRecognizer:tap1];

        UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW/2, th+leftViewH/2, ScreenW/2, leftViewH/2-1)];
        [self addSubview:imgView2];
        [imgView2 sd_setImageWithURL:[NSURL URLWithString:vo2.Pic] placeholderImage:nil];
        [imgViewArray addObject:imgView2];
        UIView *actView2 = [[UIView alloc] initWithFrame:imgView2.frame];
        [actViewArray addObject:actView2];
        [self addSubview:actView2];
        actView2.tag = 10002;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [actView2 addGestureRecognizer:tap2];
        
        UIImageView *imgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW/2, th+leftViewH/2, ScreenW/2, leftViewH/2-1)];
        [imgView3 sd_setImageWithURL:[NSURL URLWithString:vo3.Pic] placeholderImage:nil];
        [self addSubview:imgView3];
        [imgViewArray addObject:imgView3];
        UIView *actView3 = [[UIView alloc] initWithFrame:imgView3.frame];
        [actViewArray addObject:actView3];
        [self addSubview:actView3];
        actView3.tag = 10003;
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [actView3 addGestureRecognizer:tap3];
    }
    styleLabel.text = _seckillVO.Title;
    
    if (actViewArray.count > 0) {
        UIView *act1 = actViewArray[0];
        UIImageView *img1 = imgViewArray[0];
        UIView *act2 = actViewArray[1];
        UIImageView *img2 = imgViewArray[1];
        UIView *act3 = actViewArray[2];
        UIImageView *img3 = imgViewArray[2];
        
        //判断 左右
        if ([seckillVO.postion isEqualToString:@"left"]) {
            act1.frame = CGRectMake(0, th, ScreenW/2-1, leftViewH);
            img1.frame = CGRectMake(0, th, ScreenW/2-1, leftViewH);
            
            act2.frame = CGRectMake(ScreenW/2, th, ScreenW/2, leftViewH/2-1);
            img2.frame = CGRectMake(ScreenW/2, th, ScreenW/2, leftViewH/2-1);
            
            act3.frame = CGRectMake(ScreenW/2, th+leftViewH/2, ScreenW/2, leftViewH/2-1);
            img3.frame = CGRectMake(ScreenW/2, th+leftViewH/2, ScreenW/2, leftViewH/2-1);
        }
        if ([seckillVO.postion isEqualToString:@"right"]) {
            act1.frame = CGRectMake(0, th, ScreenW/2-1, leftViewH/2-1);
            img1.frame = CGRectMake(0, th, ScreenW/2-1, leftViewH/2-1);
            
            act2.frame = CGRectMake(0, th+leftViewH/2, ScreenW/2-1, leftViewH/2);
            img2.frame = CGRectMake(0, th+leftViewH/2, ScreenW/2-1, leftViewH/2);
            
            act3.frame = CGRectMake(ScreenW/2, th, ScreenW/2, leftViewH);
            img3.frame = CGRectMake(ScreenW/2, th, ScreenW/2, leftViewH);
        }
        [img1 sd_setImageWithURL:[NSURL URLWithString:vo1.Pic] placeholderImage:nil];
        [img2 sd_setImageWithURL:[NSURL URLWithString:vo2.Pic] placeholderImage:nil];
        [img3 sd_setImageWithURL:[NSURL URLWithString:vo3.Pic] placeholderImage:nil];
    }
}

- (void)tapClick:(UITapGestureRecognizer *)recognize
{
    NSInteger tag = recognize.view.tag - 10001;
    if (self.delegate && [self.delegate respondsToSelector:@selector(ViewTapClick:)] && tag < _seckillVO.brandArray.count) {
        [self.delegate ViewTapClick:_seckillVO.brandArray[tag]];
    }
}

@end

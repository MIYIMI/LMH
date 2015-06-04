//
//  LMHHome_eightCircleCell.m
//  YingMeiHui
//
//  Created by Zhumingming on 15-3-11.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "LMHHome_eightCircleCell.h"
#import <UIButton+WebCache.h>

@interface LMHHome_eightCircleCell(){
    NSMutableArray *btnArray;
}

@end

@implementation LMHHome_eightCircleCell
{
    UIView *cellView;
    
    HomeVO *_eightCircleVO;
    
    NSMutableArray *_mutablePicArray;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        btnArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)layoutUI:(HomeVO *)eightCircleVO
{
    _eightCircleVO = eightCircleVO;
    
    if (!cellView) {
        
        CGFloat cellHeight = 0;
        if (eightCircleVO.category_list.count>0 && eightCircleVO.category_list.count<=4) {
            cellHeight = ScreenW/5*155/180;
        }else{
            cellHeight = ScreenW/5*155/180*2;
        }
        
        cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, cellHeight)];
        [cellView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:cellView];
    }else if (_eightCircleVO.category_list.count <= 0){
        cellView.frame = CGRectZero;
    }
    
    CGFloat picHeight = ScreenW/5*155/180;
    
    for (UIButton *btn in cellView.subviews) {
        [btn removeFromSuperview];
    }
    
    for (int i=0; i<_eightCircleVO.category_list.count; i++) {
        AdvVO *adv = _eightCircleVO.category_list[i];
        
        UIButton * Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //button设置网络图片
        [Btn sd_setBackgroundImageWithURL:[NSURL URLWithString:adv.Pic] forState:UIControlStateNormal placeholderImage:nil];
        Btn.backgroundColor = [UIColor clearColor];
        Btn.tag = 1000+i;
        
        if (i<5) {
            [Btn setFrame:CGRectMake(i*ScreenW/5, 0, ScreenW/5, picHeight)];
        }else{
            [Btn setFrame:CGRectMake((i-5)*ScreenW/5, picHeight, ScreenW/5, picHeight)];
        }
        
        [Btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:Btn];
    }
}

- (void)btnPressed:(UIButton *)sender
{
    for (int i = 0; i<_eightCircleVO.category_list.count; i++) {
        if (i == sender.tag-1000) {
            [self.delegate tapClick:_eightCircleVO.category_list[i]];
        }
    }
}


@end

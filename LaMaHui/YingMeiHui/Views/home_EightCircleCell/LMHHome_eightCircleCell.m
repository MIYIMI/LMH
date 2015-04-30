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
            cellHeight = ScreenW/4*155/180;
        }else{
            cellHeight = ScreenW/4*155/180*2;
        }
        
        cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, cellHeight)];
        [cellView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:cellView];
        
        for (int i = 0; i < 8; i++) {
            UIButton * Btn = [UIButton buttonWithType:UIButtonTypeCustom];
            Btn.backgroundColor = [UIColor clearColor];
            Btn.tag = 1000+i;
            
            [btnArray addObject:Btn];
            
            [Btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [cellView addSubview:Btn];
        }
    }else if (_eightCircleVO.category_list.count <= 0){
        cellView.frame = CGRectZero;
    }
    
    CGFloat picHeight = ScreenW/4*155/180;
    
    for (int i=0; i<_eightCircleVO.category_list.count; i++) {
        AdvVO *adv = _eightCircleVO.category_list[i];
        
        UIButton * Btn = btnArray[i];
        //button设置网络图片
        [Btn sd_setBackgroundImageWithURL:[NSURL URLWithString:adv.Pic] forState:UIControlStateNormal placeholderImage:nil];
        Btn.backgroundColor = [UIColor clearColor];
        Btn.tag = 1000+i;
        
        if (i<4) {
            [Btn setFrame:CGRectMake(i*ScreenW/4, 0, ScreenW/4, picHeight)];
        }else{
            [Btn setFrame:CGRectMake((i-4)*ScreenW/4, picHeight, ScreenW/4, picHeight)];
        }
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

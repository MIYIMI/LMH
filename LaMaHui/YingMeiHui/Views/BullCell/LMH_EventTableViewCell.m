//
//  LMH_EventTableViewCell.m
//  YingMeiHui
//
//  Created by work on 15/5/27.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "LMH_EventTableViewCell.h"

#define SPACE_HEIGHT    10.0f

@interface LMH_EventTableViewCell(){
    UIImageView *imgView;
    UILabel *eventDescLabel;
    UIButton *eventBtn;
}

@end

@implementation LMH_EventTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)layOutUI:(LMH_EventVO *)eventVO show:(BOOL)is_show{//是否点击了向下查看更多
    self.backgroundColor = [UIColor whiteColor];
    
    if (!imgView) {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(SPACE_HEIGHT, 5, ScreenW/6, ScreenW/12)];
        
        [self.contentView addSubview:imgView];
    }
    if (eventVO.image) {
        [imgView sd_setImageWithURL:[NSURL URLWithString:eventVO.image]];
    }
    
    if (!eventDescLabel) {
        eventDescLabel = [[UILabel alloc] initWithFrame:CGRectNull];
        eventDescLabel.font = LMH_FONT_13;
        eventDescLabel.textColor = LMH_COLOR_BLACK;
        eventDescLabel.numberOfLines = 0;
        eventDescLabel.lineBreakMode = NSLineBreakByCharWrapping;
        
        [self.contentView addSubview:eventDescLabel];
    }
    
    if (!eventBtn && !is_show) {
        eventBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 30, (ScreenW/12+10)/4, 20, (ScreenW/12+10)/2)];
        [eventBtn setBackgroundImage:LOCAL_IMG(@"new_down") forState:UIControlStateNormal];
        [eventBtn addTarget:self action:@selector(selectShow) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:eventBtn];
    }
    if (is_show) {
        eventBtn.hidden = YES;
    }else{
        eventBtn.hidden = NO;
    }
    
    CGSize lineSize;
    if (eventVO.text_words) {
        lineSize = [eventVO.text_words sizeWithFont:LMH_FONT_13 constrainedToSize:CGSizeMake(ScreenW-CGRectGetMaxX(imgView.frame)-20, 1000)];
    }
    
    eventDescLabel.text = eventVO.text_words;
    if (is_show && lineSize.height > ScreenW/12+10) {
        eventDescLabel.frame = CGRectMake(CGRectGetMaxX(imgView.frame)+10, 0, ScreenW-CGRectGetMaxX(imgView.frame)-20, lineSize.height+10);
    }else{
        eventDescLabel.frame = CGRectMake(CGRectGetMaxX(imgView.frame)+10, 0, ScreenW-CGRectGetMaxX(imgView.frame)-50, ScreenW/12+10);
    }
}

- (void)selectShow{
    eventBtn.hidden = YES;
    if ([self.eventDelegate respondsToSelector:@selector(downShow)]) {
        [self.eventDelegate downShow];
    }
}

@end

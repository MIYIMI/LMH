//
//  LMH_ReviewTableViewCell.m
//  YingMeiHui
//
//  Created by work on 15/5/28.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "LMH_ReviewTableViewCell.h"

#define SPACE_HEIGHT    10.0f

@interface LMH_ReviewTableViewCell(){
    UIImageView *imgView;
    UILabel *userLabel;
    UILabel *descLabel;
    UILabel *timeLabel;
    UIButton *revertBtn;
    UILabel *lineLabel;
    UITextField *hideField;
    
    LMH_EvaluatedVO *_evaluate;
}

@end

@implementation LMH_ReviewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)layoutUI:(LMH_EvaluatedVO *)evaluate{
    _evaluate = evaluate;
    
    CGFloat imgX = (ScreenW-20)/9;
    if (!imgView) {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(SPACE_HEIGHT, SPACE_HEIGHT, imgX, imgX)];
        
        [self.contentView addSubview:imgView];
    }
    if (evaluate.avatar) {
        [imgView sd_setImageWithURL:[NSURL URLWithString:evaluate.avatar]];
    }
    
    if (!userLabel) {
        userLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+SPACE_HEIGHT, SPACE_HEIGHT, ScreenW-120-CGRectGetMaxX(imgView.frame), 20)];
        userLabel.font = LMH_FONT_15;
        userLabel.textColor = LMH_COLOR_BLACK;
        
        [self.contentView addSubview:userLabel];
    }
    userLabel.text = evaluate.nickname;
    
    if (!descLabel) {
        descLabel = [[UILabel alloc] initWithFrame:CGRectNull];
        descLabel.font = LMH_FONT_12;
        descLabel.textColor = LMH_COLOR_GRAY;
        descLabel.numberOfLines = 2;
        descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        [self.contentView addSubview:descLabel];
    }
    NSString *revStr = @"";
    if (evaluate.reply_nickname.length > 0) {
        revStr = [NSString stringWithFormat:@"%@: %@",evaluate.reply_nickname,evaluate.content];
    }else{
        revStr = [NSString stringWithFormat:@"%@",evaluate.content];
    }
    CGSize revH = [revStr sizeWithFont:LMH_FONT_12 constrainedToSize:CGSizeMake(ScreenW-CGRectGetMaxX(imgView.frame)-SPACE_HEIGHT-40, 10000)];
    CGFloat descH = revH.height>18?35:revH.height;
    descLabel.frame = CGRectMake(CGRectGetMaxX(imgView.frame)+SPACE_HEIGHT, CGRectGetMaxY(userLabel.frame)+5, ScreenW-CGRectGetMaxX(imgView.frame)-SPACE_HEIGHT-40, descH);
    descLabel.text = revStr;
    
    if (!timeLabel) {
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW-110, SPACE_HEIGHT, 100, 20)];
        timeLabel.font = LMH_FONT_10;
        timeLabel.textColor = LMH_COLOR_LIGHTGRAY;
        
        [self.contentView addSubview:timeLabel];
    }
    timeLabel.text = evaluate.create_at;
    
    if (!revertBtn) {
        revertBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-40, CGRectGetMaxY(timeLabel.frame)+5, 30, 18)];
        [revertBtn setTitle:@"回复" forState:UIControlStateNormal];
        [revertBtn setTitleColor:LMH_COLOR_LIGHTbLUE forState:UIControlStateNormal];
        [revertBtn.titleLabel setFont:LMH_FONT_13];
        [revertBtn addTarget:self action:@selector(reverClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:revertBtn];
    }
    
    if (!lineLabel) {
        lineLabel = [[UILabel alloc] initWithFrame:CGRectNull];
        lineLabel.backgroundColor = LMH_COLOR_LINE;
        
        [self.contentView addSubview:lineLabel];
    }
    lineLabel.frame = CGRectMake(SPACE_HEIGHT, CGRectGetMaxY(descLabel.frame)+9.5, ScreenW-20, 0.5);
    
    if (!hideField) {//只是为了唤起键盘不做它用
        hideField = [UITextField new];
        hideField.hidden = YES;
    }
}

- (void)reverClick{
    if ([self.reviewDelegate respondsToSelector:@selector(sendSms:)]) {
        [self.reviewDelegate sendSms:_evaluate];
    }
}
@end

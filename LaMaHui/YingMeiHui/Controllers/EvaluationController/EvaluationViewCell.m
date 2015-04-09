//
//  EvaluationViewCell.m
//  YingMeiHui
//
//  Created by 王凯 on 15-1-30.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "EvaluationViewCell.h"
#import "EvaluationTableViewController.h"

@implementation EvaluationViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self addAllVIew];
    }
    return self;
}

- (void)addAllVIew
{
    _headView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, ScreenW/6, ScreenW/6/4*5)];
    _headView.image = [UIImage imageNamed:@"place_2"];
    [self addSubview:_headView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headView.frame) + 10, CGRectGetMinY(_headView.frame) + 3, ScreenW/2 + 10, CGRectGetHeight(_headView.frame)/3 + 5)];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = FONT(11);
    [self addSubview:_titleLabel];
    
    _colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headView.frame) + 10, CGRectGetMaxY(_titleLabel.frame), 150, CGRectGetHeight(_headView.frame)/4)];
    _colorLabel.textAlignment = 0;
    _colorLabel.textColor = [UIColor grayColor];
    _colorLabel.font = FONT(11);
    [self addSubview:_colorLabel];
    
    UILabel *chengLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headView.frame) + 10, CGRectGetMaxY(_colorLabel.frame) + 6, 8, 10)];
    chengLabel.text = @"x";
    chengLabel.textColor = [UIColor grayColor];
    chengLabel.font = FONT(11);
    [self addSubview:chengLabel];
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(chengLabel.frame), CGRectGetMaxY(_colorLabel.frame) + 3, 10, CGRectGetHeight(_headView.frame)/4)];
    _countLabel.textColor = [UIColor grayColor];
    _countLabel.font = FONT(12);
    [self addSubview:_countLabel];

    UILabel *jianLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_countLabel.frame), CGRectGetMaxY(_colorLabel.frame) + 3, 20, CGRectGetHeight(_headView.frame)/4)];
    jianLabel.text = @"件";
    jianLabel.textColor = [UIColor grayColor];
    jianLabel.font = FONT(12);
    [self addSubview:jianLabel];
    
    //价格
    UILabel *money = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame) + 5, CGRectGetMinY(_titleLabel.frame) + 15, 11, 11)];
    money.text = @"￥";
    money.textColor = ALL_COLOR;
    money.font = FONT(12);
    [self addSubview:money];
    
    _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(money.frame), CGRectGetMinY(_titleLabel.frame)+5, ScreenW/5, 27)];
    _moneyLabel.textAlignment = 0;
    _moneyLabel.textColor = ALL_COLOR;
    _moneyLabel.font = FONT(16);
    [self addSubview:_moneyLabel];
    
    _primeCost = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_moneyLabel.frame) - 10, CGRectGetMaxY(_moneyLabel.frame) - 5, ScreenW/5, 10)];
    _primeCost.textAlignment = 0;
    _primeCost.textColor = [UIColor grayColor];
    _primeCost.font = FONT(11);
    [self addSubview:_primeCost];
    
    _moneyView = [[UIView alloc] initWithFrame:CGRectMake(2, 5, 45, 1)];
    _moneyView.backgroundColor = [UIColor lightGrayColor];
    [_primeCost addSubview:_moneyView];
    
    UILabel *miaoshu = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_headView.frame) + 10, 45, 30)];
    miaoshu.textAlignment = 0;
    miaoshu.text = @"描述相符";
    miaoshu.font = FONT(11);
    [self addSubview:miaoshu];
    
    // 小星星
    self.starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(miaoshu.frame) + 20, CGRectGetMinY(miaoshu.frame), 170, 25) numberOfStars:5];
    _starRateView.scorePercent = 0.0;
    _starRateView.allowIncompleteStar = YES;
    _starRateView.hasAnimation = YES;
    _starRateView.scorePercent = 1.0f;
    [self addSubview: _starRateView];
    
    // 建议框
    _adviceView = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_starRateView.frame) + 10, ScreenW - 20, 70)];
    _adviceView.backgroundColor = [UIColor grayColor];
    _adviceView.layer.masksToBounds = YES;
    _adviceView.layer.cornerRadius = 8.0;
    _adviceView.backgroundColor = [UIColor clearColor];
    _adviceView.layer.masksToBounds=YES;
    _adviceView.delegate = self;
    _adviceView.layer.borderWidth=1.0;
    _adviceView.layer.borderColor=[GRAY_LINE_COLOR CGColor];
    [self addSubview:_adviceView];
    
    self.aLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, 200, 30)];
    _aLabel.text = @"其他买家，需要你的建议哦！";
    _aLabel.font = FONT(11);
    _aLabel.enabled = NO;
    [_adviceView addSubview:_aLabel];
    
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView

{
    [_aLabel setHidden:YES];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        [_aLabel setHidden:NO];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end

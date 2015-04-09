//
//  EvaluationViewCell.h
//  YingMeiHui
//
//  Created by 王凯 on 15-1-30.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"

@interface EvaluationViewCell : UITableViewCell<UITextViewDelegate>

@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *colorLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *primeCost;
@property (nonatomic, strong) UIView *moneyView;
@property (nonatomic, strong) CWStarRateView *starRateView;
//@property (nonatomic, strong) CWStarRateView *sendStar;
//@property (nonatomic, strong) CWStarRateView *logisticsStar;
@property (nonatomic, strong) UITextView *adviceView;
@property (nonatomic, strong) UILabel *aLabel;

@end

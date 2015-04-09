//
//  KTWalletDetailTableViewCell.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-22.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTWalletDetailTableViewCell.h"
#import "TradeInfoVO.h"

#define BACKGROUND_COLOR            [UIColor clearColor]

@interface KTWalletDetailTableViewCell ()
{
    UILabel *_typeNameLbl;
    UILabel *_timeLbl;
    UILabel *_valueLbl;
}

@end

@implementation KTWalletDetailTableViewCell

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

- (void)setTradeData:(TradeInfoVO *)tradeData
{
    _tradeData = tradeData;
    
    if (_tradeData) {
        CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
        
        if (!_typeNameLbl) {
            _typeNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, w - 92, 48)];
            [_typeNameLbl setBackgroundColor:[UIColor clearColor]];
            [_typeNameLbl setTextColor:[UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:1]];
            [_typeNameLbl setTextAlignment:NSTextAlignmentLeft];
            [_typeNameLbl setFont:[UIFont systemFontOfSize:13]];
            [_typeNameLbl setLineBreakMode:NSLineBreakByTruncatingTail];
            
            [self.contentView addSubview:_typeNameLbl];
        }
        
        if (_tradeData.TypeName) {
            [_typeNameLbl setText:_tradeData.TypeName];
        }
        
        if (!_timeLbl) {
            _timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(w - 75, 7, 55, 15)];
            [_timeLbl setBackgroundColor:[UIColor clearColor]];
            [_timeLbl setTextColor:[UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1]];
            [_timeLbl setTextAlignment:NSTextAlignmentRight];
            [_timeLbl setFont:[UIFont systemFontOfSize:9]];
            
            [self.contentView addSubview:_timeLbl];
        }
        
        if (_tradeData.Time) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[_tradeData.Time longLongValue]]];
            [_timeLbl setText:[NSString stringWithFormat:@"%@", dateStr]];
        }
        
        if (!_valueLbl) {
            _valueLbl = [[UILabel alloc] initWithFrame:CGRectMake(w - 220, CGRectGetMaxY(_timeLbl.frame), 200, 48 - CGRectGetMaxY(_timeLbl.frame))];
            [_valueLbl setBackgroundColor:[UIColor clearColor]];
            [_valueLbl setTextAlignment:NSTextAlignmentRight];
            [_valueLbl setFont:[UIFont boldSystemFontOfSize:11]];
            
            [self.contentView addSubview:_valueLbl];
        }
        
        if (_tradeData.Value) {
            if ([_tradeData.Value floatValue] >= 0) {
                [_valueLbl setText:[NSString stringWithFormat:@"+%.2f", [_tradeData.Value floatValue]]];
                [_valueLbl setTextColor:[UIColor colorWithRed:0.32 green:0.48 blue:0.27 alpha:1]];
            } else {
                [_valueLbl setText:[NSString stringWithFormat:@"%.2f", [_tradeData.Value floatValue]]];
                [_valueLbl setTextColor:[UIColor colorWithRed:0.98 green:0.43 blue:0.04 alpha:1]];
            }
        } else {
            [_valueLbl setText:@""];
        }
    }
}

@end

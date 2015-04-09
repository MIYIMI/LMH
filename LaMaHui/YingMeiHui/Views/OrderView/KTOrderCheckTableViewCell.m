//
//  KTOrderCheckTableViewCell.m
//  YingMeiHui
//
//  Created by work on 14-10-25.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTOrderCheckTableViewCell.h"

@interface KTOrderCheckTableViewCell()
{
    UILabel *_contentLbl;
}

@end

@implementation KTOrderCheckTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCheckArray:(NSArray *)checkArray
{
    _checkArray = checkArray;
    CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    self.contentView.backgroundColor = [UIColor whiteColor];
    if (_checkArray.count > 0) {
        if (!_contentLbl) {
            _contentLbl = [[UILabel alloc] initWithFrame:CGRectMake(w - 162, 0, 150, 39)];
            [_contentLbl setTextColor:LMH_COLOR_SKIN];
            [_contentLbl setFont:LMH_FONT_13];
            [_contentLbl setTextAlignment:NSTextAlignmentRight];
            _contentLbl.backgroundColor = [UIColor whiteColor];
            [self addSubview:_contentLbl];
        }
        [self.textLabel setText:_checkArray[0]];
        self.textLabel.backgroundColor = [UIColor whiteColor];
        [self.textLabel setFont:LMH_FONT_13];
        [self.textLabel setTextColor:LMH_COLOR_BLACK];
        
        [_contentLbl setText:_checkArray[1]];
    }
}

@end

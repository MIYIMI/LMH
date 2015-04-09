//
//  KTMsgListTableViewCell.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-21.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTMsgListTableViewCell.h"
#import "MessageBeanVO.h"

#define BACKGROUND_COLOR            [UIColor clearColor]

// CellBgView
@class CellBgView;

@interface CellBgView : UIView

@property (nonatomic, getter = isCustomer) BOOL customer;

@end

@implementation CellBgView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setCustomer:(BOOL)customer
{
    _customer = customer;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (self.customer) {
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        
        [bezierPath moveToPoint:CGPointMake(rect.origin.x + 6.0, 30.0)];
        [bezierPath addLineToPoint:CGPointMake(rect.origin.x, 36.0)];
        [bezierPath addLineToPoint:CGPointMake(rect.origin.x + 6.0, 42.0)];
        [bezierPath addLineToPoint:CGPointMake(rect.origin.x + 6.0, rect.size.height - 2.0)];
        [bezierPath addArcWithCenter:CGPointMake(rect.origin.x + 8.0, rect.size.height - 2.0)
                              radius:2.0
                          startAngle:M_PI * 1.0
                            endAngle:M_PI * 0.5
                           clockwise:NO];
        [bezierPath addLineToPoint:CGPointMake(rect.size.width - 2.0, rect.size.height)];
        [bezierPath addArcWithCenter:CGPointMake(rect.size.width - 2.0, rect.size.height - 2.0)
                              radius:2.0
                          startAngle:M_PI * 0.5
                            endAngle:M_PI * 0.0
                           clockwise:NO];
        [bezierPath addLineToPoint:CGPointMake(rect.size.width, 2.0)];
        [bezierPath addArcWithCenter:CGPointMake(rect.size.width - 2.0, 2.0)
                              radius:2.0
                          startAngle:M_PI * 0.0
                            endAngle:M_PI * 1.5
                           clockwise:NO];
        [bezierPath addLineToPoint:CGPointMake(rect.origin.x + 8.0, 0)];
        [bezierPath addArcWithCenter:CGPointMake(rect.origin.x + 8.0, 2.0)
                              radius:2.0
                          startAngle:M_PI * 1.5
                            endAngle:M_PI * 1.0
                           clockwise:NO];
        [bezierPath closePath];
        [[UIColor whiteColor] setFill];
        [bezierPath fill];
        
        [self.layer setShadowColor:[UIColor grayColor].CGColor];
        [self.layer setShadowOpacity:0.3];
        [self.layer setShadowOffset:CGSizeMake(0, 0)];
        [self.layer setShadowPath:bezierPath.CGPath];
        
    } else {
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        
        [bezierPath moveToPoint:CGPointMake(rect.size.width - 6.0, 30.0)];
        [bezierPath addLineToPoint:CGPointMake(rect.size.width, 36.0)];
        [bezierPath addLineToPoint:CGPointMake(rect.size.width - 6.0, 42.0)];
        [bezierPath addLineToPoint:CGPointMake(rect.size.width - 6.0, rect.size.height - 2.0)];
        [bezierPath addArcWithCenter:CGPointMake(rect.size.width - 8.0, rect.size.height - 2.0)
                              radius:2.0
                          startAngle:M_PI * 0.0
                            endAngle:M_PI * 0.5
                           clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(rect.origin.x + 2.0, rect.size.height)];
        [bezierPath addArcWithCenter:CGPointMake(rect.origin.x + 2.0, rect.size.height - 2.0)
                              radius:2.0
                          startAngle:M_PI * 0.5
                            endAngle:M_PI * 1.0
                           clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(rect.origin.x, 2.0)];
        [bezierPath addArcWithCenter:CGPointMake(rect.origin.x + 2.0, 2.0)
                              radius:2.0
                          startAngle:M_PI * 1.0
                            endAngle:M_PI * 1.5
                           clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(rect.size.width - 8.0, 0)];
        [bezierPath addArcWithCenter:CGPointMake(rect.size.width - 8.0, 2.0)
                              radius:2.0
                          startAngle:M_PI * 1.5
                            endAngle:M_PI * 0.0
                           clockwise:YES];
        
        [bezierPath closePath];
        [[UIColor whiteColor] setFill];
        [bezierPath fill];
        
        [self.layer setShadowColor:[UIColor grayColor].CGColor];
        [self.layer setShadowOpacity:0.1];
        [self.layer setShadowOffset:CGSizeMake(0, 0)];
        [self.layer setShadowPath:bezierPath.CGPath];
    }
}
@end

@interface KTMsgListTableViewCell ()
{
    CellBgView *_contentBg;
    UILabel *_lineLbl;
    UILabel *_timeLbl;
    UILabel *_contentLbl;
    UILabel *_fromCSLbl;
    UIImageView *_avatarIV;
}

@end

@implementation KTMsgListTableViewCell

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

//////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark init view
//////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setCellType:(KTMsgListCellType)cellType
{
    _cellType = cellType;
    
    switch (_cellType) {
        case KTMsgListCellCustomer:
        {
            [_contentBg setFrame:CGRectMake(42, 7, CGRectGetWidth(_contentBg.frame), CGRectGetHeight(_contentBg.frame))];
            [_lineLbl setFrame:CGRectMake(6, 25, CGRectGetWidth(_contentBg.frame) - 6, 0.5)];
            [_lineLbl setBackgroundColor:[UIColor colorWithRed:0.68 green:0.78 blue:0.36 alpha:1]];
            [_contentBg setCustomer:YES];
            [_timeLbl setFrame:CGRectMake(11, CGRectGetMinY(_timeLbl.frame), CGRectGetWidth(_timeLbl.frame), CGRectGetHeight(_timeLbl.frame))];
            [_timeLbl setTextAlignment:NSTextAlignmentRight];
            [_fromCSLbl setHidden:YES];
            [_contentLbl setFrame:CGRectMake(11, CGRectGetMinY(_contentLbl.frame), CGRectGetWidth(_contentLbl.frame), CGRectGetHeight(_contentLbl.frame))];
            [_avatarIV setImage:[UIImage imageNamed:@"customer_icon"]];
            [_avatarIV setFrame:CGRectMake(9, CGRectGetMinY(_avatarIV.frame), CGRectGetWidth(_avatarIV.frame), CGRectGetHeight(_avatarIV.frame))];
        }
            break;
            
        case KTMsgListCellCustomerService:
        {
            [_contentBg setFrame:CGRectMake(17, 7, CGRectGetWidth(_contentBg.frame), CGRectGetHeight(_contentBg.frame))];
            [_lineLbl setFrame:CGRectMake(0, 25, CGRectGetWidth(_contentBg.frame) - 6, 0.5)];
            [_lineLbl setBackgroundColor:[UIColor colorWithRed:0.96 green:0.81 blue:0.63 alpha:1]];
            [_contentBg setCustomer:NO];
            [_timeLbl setFrame:CGRectMake(5, CGRectGetMinY(_timeLbl.frame), CGRectGetWidth(_timeLbl.frame), CGRectGetHeight(_timeLbl.frame))];
            [_timeLbl setTextAlignment:NSTextAlignmentLeft];
            [_fromCSLbl setFrame:_timeLbl.frame];
            [_fromCSLbl setHidden:NO];
            [_contentLbl setFrame:CGRectMake(5, CGRectGetMinY(_contentLbl.frame), CGRectGetWidth(_contentLbl.frame), CGRectGetHeight(_contentLbl.frame))];
            [_avatarIV setImage:[UIImage imageNamed:@"cs_icon"]];
            [_avatarIV setFrame:CGRectMake(282, CGRectGetMinY(_avatarIV.frame), CGRectGetWidth(_avatarIV.frame), CGRectGetHeight(_avatarIV.frame))];
        }
            break;
            
        default:
            break;
    }
}

- (void)setMessageData:(MessageBeanVO *)messageData
{
    _messageData = messageData;
    if (_messageData) {
        if (!_contentBg) {
            _contentBg = [[CellBgView alloc] initWithFrame:CGRectMake(17, 7, ScreenW - 57, 50)];
            
            [self.contentView addSubview:_contentBg];
        }
        
        if (!_lineLbl) {
            _lineLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            [_contentBg addSubview:_lineLbl];
        }
        
        if (!_timeLbl) {
            _timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_contentBg.frame) - 16, 25)];
            [_timeLbl setBackgroundColor:[UIColor clearColor]];
            [_timeLbl setTextColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1]];
            [_timeLbl setFont:[UIFont systemFontOfSize:11.0]];
            [_contentBg addSubview:_timeLbl];
        }
        
        if (_messageData.Time) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *dateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[_messageData.Time longLongValue]]];
            [_timeLbl setText:dateStr];
        }
        
        if (!_fromCSLbl) {
            _fromCSLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            [_fromCSLbl setBackgroundColor:[UIColor clearColor]];
            [_fromCSLbl setTextColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1]];
            [_fromCSLbl setFont:[UIFont systemFontOfSize:11.0]];
            [_fromCSLbl setTextAlignment:NSTextAlignmentRight];
            [_fromCSLbl setHidden:YES];
            [_contentBg addSubview:_fromCSLbl];
            [_fromCSLbl setText:@"辣妈汇回复"];
        }
        
        if (!_contentLbl) {
            _contentLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(_contentBg.frame) - 16, 25)];
            [_contentLbl setBackgroundColor:[UIColor clearColor]];
            [_contentLbl setTextColor:[UIColor blackColor]];
            [_contentLbl setFont:[UIFont systemFontOfSize:14.0]];
            [_contentLbl setNumberOfLines:0];
            [_contentLbl setLineBreakMode:NSLineBreakByCharWrapping];
            [_contentBg addSubview:_contentLbl];
        }
        
        if (_messageData.Content) {
            [_contentLbl setText:_messageData.Content];
        }
        
        if (!_avatarIV) {
            _avatarIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"customer_icon"]];
            [_avatarIV setFrame:CGRectMake(9, 27, CGRectGetWidth(_avatarIV.frame), CGRectGetHeight(_avatarIV.frame))];
            
            [self.contentView addSubview:_avatarIV];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize contentsize = [_contentLbl.text sizeWithFont:_contentLbl.font constrainedToSize:CGSizeMake(247, 100000) lineBreakMode:_contentLbl.lineBreakMode];
    [_contentLbl setFrame:CGRectMake(CGRectGetMinX(_contentLbl.frame), CGRectGetMinY(_contentLbl.frame), CGRectGetWidth(_contentLbl.frame), contentsize.height)];
    [_contentBg setFrame:CGRectMake(CGRectGetMinX(_contentBg.frame), CGRectGetMinY(_contentBg.frame), CGRectGetWidth(_contentBg.frame), contentsize.height + 35)];
}

@end

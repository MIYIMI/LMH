//
//  KTPaymentTableViewCell.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-13.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTPaymentTableViewCell.h"
#import "PaymentVO.h"

#define BACKGROUND_COLOR            [UIColor clearColor]

@interface KTPaymentTableViewCell ()
{
    UIView *_paymentBgView;
    UIImageView *_selectionIcon;
    UIImageView *_payLogo;
    UILabel *_paynameLbl;
    UIButton *_bindBtn;
    UILabel *_moneyLbl;
    UILabel *_bindTipLbl;
}

@end

@implementation KTPaymentTableViewCell

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

- (void)bindBtnPressed
{
    if (self.paymentCellDelegate && [self.paymentCellDelegate respondsToSelector:@selector(bindWalletBtnPressed)]) {
        [self.paymentCellDelegate bindWalletBtnPressed];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark init view
////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setCellState:(KTPaymentCellState)cellState
{
    _cellState = cellState;
    
    if (_PaymentData.PayType) {
        NSInteger type = [_PaymentData.PayType intValue];
        
        switch (type) {
            case 1:
            {
                switch (_cellState) {
                    case KTPaymentNormal:
                    {
                        _selectionIcon.image = [UIImage imageNamed:@"payscheck"];
                    }
                        break;
                        
                    case KTPaymentSelected:
                    {
                        _selectionIcon.image = [UIImage imageNamed:@"payscheck_select"];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
                break;
                
            default:
            {
                switch (_cellState) {
                    case KTPaymentNormal:
                    {
                        _selectionIcon.image = [UIImage imageNamed:@"payselection"];
                    }
                        break;
                        
                    case KTPaymentSelected:
                    {
                        _selectionIcon.image = [UIImage imageNamed:@"payselection_selected"];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
                break;
        }
    }
}

- (void)setPaymentData:(PaymentVO *)PaymentData
{
    _PaymentData = PaymentData;
    
    if (_PaymentData) {
        CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
        
        if (!_paymentBgView) {
//            _paymentBgView = [[UIView alloc] initWithFrame:CGRectMake(10, -1, w - 20, 46)];
            _paymentBgView = [[UIView alloc] initWithFrame:CGRectMake(0, -1, w, 46)];
            [_paymentBgView setBackgroundColor:[UIColor whiteColor]];
//            [_paymentBgView.layer setBorderWidth:0.5];
//            [_paymentBgView.layer setBorderColor:[UIColor colorWithRed:0.87 green:0.83 blue:0.84 alpha:1].CGColor];
            
            [self.contentView addSubview:_paymentBgView];
            
            
            //分隔线
            UIView *seprateLineView = [[UIView alloc]initWithFrame:CGRectMake(15, 46, ScreenW - 30, 1)];
            seprateLineView.backgroundColor = [UIColor colorWithRed:0.87 green:0.83 blue:0.84 alpha:1];
            [_paymentBgView addSubview:seprateLineView];
        }
        
        if (!_selectionIcon) {
            _selectionIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"payscheck"]];
            [_selectionIcon setFrame:CGRectZero];
            [self.contentView addSubview:_selectionIcon];
        }
        
        if (!_payLogo) {
            _payLogo = [[UIImageView alloc] initWithImage:nil];
            [_payLogo setFrame:CGRectZero];
            
            [self.contentView addSubview:_payLogo];
        }
        
        if (_PaymentData.PayType) {
            NSInteger type = [_PaymentData.PayType intValue];
            
            switch (type) {
                case 1:
                {
                    [_selectionIcon setFrame:CGRectMake(18, 14, 18, 18)];
                    _payLogo.image = [UIImage imageNamed:@"walletlogo"];
                }
                    break;
                    
                case 2:
                {
                    [_selectionIcon setFrame:CGRectMake(20, 15, 15, 15)];
                    _payLogo.image = [UIImage imageNamed:@"alipaylogo"];
                }
                    break;
                    
                case 3:
                {
                    [_selectionIcon setFrame:CGRectMake(20, 15, 15, 15)];
                    _payLogo.image = [UIImage imageNamed:@"wechatlogo"];
                }
                    break;
                    
                case 4:
                {
                    [_selectionIcon setFrame:CGRectMake(20, 15, 15, 15)];
                    _payLogo.image = [UIImage imageNamed:@"unionpaylogo"];
                }
                    break;
                    
                default:
                    break;
            }
        }
        
        if (!_paynameLbl) {
            _paynameLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_selectionIcon.frame) + 55, 0, w - 100, 45)];
            _paynameLbl.backgroundColor = [UIColor clearColor];
            _paynameLbl.font = [UIFont systemFontOfSize:14.0];
            _paynameLbl.textColor = [UIColor colorWithRed:0.14 green:0.14 blue:0.14 alpha:1];
            _paynameLbl.textAlignment = NSTextAlignmentLeft;
            
            [_paymentBgView addSubview:_paynameLbl];
        }
        
        if (_PaymentData.PayName) {
            [_paynameLbl setText:_PaymentData.PayName];
        }
        
        if (!_moneyLbl) {
            _moneyLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_selectionIcon.frame) + 95, 0, w - 155, 45)];
            _moneyLbl.backgroundColor = [UIColor clearColor];
            _moneyLbl.font = [UIFont systemFontOfSize:14.0];
            _moneyLbl.textColor = [UIColor colorWithRed:0.98 green:0.3 blue:0.4 alpha:1];
            _moneyLbl.textAlignment = NSTextAlignmentLeft;
            
            [_paymentBgView addSubview:_moneyLbl];
        }
        
        if (_PaymentData.Money) {
            NSString *orderPrice;
            CGFloat afloat = [_PaymentData.Money floatValue];
            if ((afloat * 10) - (int)(afloat * 10) > 0) {
                orderPrice = [NSString stringWithFormat:@"¥%0.2f",[_PaymentData.Money floatValue]];
            } else if(afloat - (int)afloat > 0) {
                orderPrice = [NSString stringWithFormat:@"¥%0.1f",[_PaymentData.Money floatValue]];
            } else {
                orderPrice = [NSString stringWithFormat:@"¥%0.0f",[_PaymentData.Money floatValue]];
            }
            [_moneyLbl setText:orderPrice];
        }
        
        if (!_bindBtn) {
            _bindBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [_bindBtn setFrame:CGRectMake(CGRectGetWidth(_paymentBgView.frame) - 58, (CGRectGetHeight(_paymentBgView.frame) - 25) / 2, 49, 25)];
            [_bindBtn setTitle:@"绑定" forState:UIControlStateNormal];
            [_bindBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_bindBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
            UIImage *image = [UIImage imageNamed:@"logincancelbtn"];
            image = [image stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f];
            [_bindBtn setBackgroundImage:image forState:UIControlStateNormal];
            [_bindBtn addTarget:self action:@selector(bindBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            
            [_paymentBgView addSubview:_bindBtn];
        }
        
        if (!_bindTipLbl) {
            _bindTipLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_paynameLbl.frame), 23, w - 155, 22)];
            _bindTipLbl.backgroundColor = [UIColor clearColor];
            _bindTipLbl.font = [UIFont systemFontOfSize:13.0];
            _bindTipLbl.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
            _bindTipLbl.textAlignment = NSTextAlignmentLeft;
            _bindTipLbl.text = @"绑定钱包用于支付";
            
            [_paymentBgView addSubview:_bindTipLbl];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_PaymentData.PayType) {
        NSInteger type = [_PaymentData.PayType intValue];
        
        switch (type) {
            case 1:
            {
                [_payLogo setFrame:CGRectMake(CGRectGetMaxX(_selectionIcon.frame) + 15, 12, 26, 22)];
                [_paynameLbl setText:@"余额："];
                [_moneyLbl setHidden:NO];
                
                if (_PaymentData.Bind) {
                    [_bindBtn setHidden:[_PaymentData.Bind boolValue]];
                    [_bindTipLbl setHidden:[_PaymentData.Bind boolValue]];
                    
                    CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
                    if ([_PaymentData.Bind boolValue]) {
                        [_paynameLbl setFrame:CGRectMake(CGRectGetMaxX(_selectionIcon.frame) + 55, 0, w - 100, 45)];
                        [_moneyLbl  setFrame:CGRectMake(CGRectGetMaxX(_selectionIcon.frame) + 95, 0, w - 155, 45)];
                    } else {
                        [_paynameLbl setFrame:CGRectMake(CGRectGetMaxX(_selectionIcon.frame) + 55, 0, w - 100, 30)];
                        [_moneyLbl  setFrame:CGRectMake(CGRectGetMaxX(_selectionIcon.frame) + 95, 0, w - 155, 30)];
                    }
                    
                } else {
                    [_bindBtn setHidden:YES];
                    [_bindTipLbl setHidden:YES];
                }
            }
                break;
                
            case 2:
            {
                [_payLogo setFrame:CGRectMake(CGRectGetMaxX(_selectionIcon.frame) + 16, 11, 24, 24)];
                [_moneyLbl setHidden:YES];
                [_bindBtn setHidden:YES];
                [_bindTipLbl setHidden:YES];
            }
                break;
                
            case 3:
            {
                [_payLogo setFrame:CGRectMake(CGRectGetMaxX(_selectionIcon.frame) + 16, 11, 24, 24)];
                [_moneyLbl setHidden:YES];
                [_bindBtn setHidden:YES];
                [_bindTipLbl setHidden:YES];
            }
                break;
                
            case 4:
            {
                [_payLogo setFrame:CGRectMake(CGRectGetMaxX(_selectionIcon.frame) + 16, 11, 24, 24)];
                [_moneyLbl setHidden:YES];
                [_bindBtn setHidden:YES];
                [_bindTipLbl setHidden:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

@end

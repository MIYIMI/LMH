//
//  KTShopCartTableViewCell.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-8-13.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTShopCartTableViewCell.h"
#import "CartProductVO.h"
#import "CartBrandVO.h"
#import "EGOImageView.h"
#import "BOKUNoActionTextField.h"

@implementation KTShopCartTableViewCell
{
    UIView * _backView;
    EGOImageView * _iconView;
    UILabel *_discountWordLbl;
    UIImageView *_discountWordView;
    UILabel * _nameLabel;
    UILabel * _optionsLabel;
    UIButton *_optionsButton;
    UILabel * _priceLabel;
    UILabel * _marketPriceLbl;
    UILabel * _marketLine;
    UILabel * _stockLbl;
    SSCheckBoxView * _selectCB;
    UIButton *_cbBtn;
    UIButton * _minusBtn;
    UIButton * _plusBtn;
    UIButton * _deleteBtn;
    BOKUNoActionTextField * _countTF;
    id _shopCartVC;
    CartBrandVO *_eventVO;
    CartProductVO *_productVO;
    id _goodVO;
    NSInteger _section;
    
    UILabel *brandLbl;
    UIImageView *brandView;
    UILabel *brandDiscountLbl;
    NSString *brandDiscountTitleStr;

    UILabel *timeLbl;
    UILabel *payNumLbl;
    UILabel *lineLbl;
    NSString *optionsBtnStr;
    
    //倒计时
    NSNumber *discountTime;
    UIImageView *_timeOutView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier delegate:(id)delegate
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _shopCartVC = delegate;
        
        self.selectNum = 1;
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

- (void)setDataVO:(id)goodvo andSection:(NSInteger)section
{
    _goodVO = goodvo;
    _section = section;
    if ([_goodVO isKindOfClass:[CartBrandVO class]]) {
        _eventVO = _goodVO;
        [self setBackgroundColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1]];
        
        if (_eventVO) {
            //专场title
            if (!brandLbl) {
                brandLbl = [[UILabel alloc] initWithFrame:CGRectZero];
                [brandLbl setFont:LMH_FONT_15];
                [brandLbl setTextColor:LMH_COLOR_BLACK];
                brandLbl.numberOfLines = 1;// 不可少Label属性之一
                brandLbl.lineBreakMode = NSLineBreakByTruncatingTail;// 不可少Label属性之二
                brandLbl.backgroundColor = [UIColor clearColor];
                [self addSubview:brandLbl];
            }
            
            if (_eventVO.event_title) {
                [brandLbl setText:_eventVO.event_title];
            }
            
            //倒计时
            if (section >= 0) {
                if(!_timeOutView){
                    _timeOutView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenW - 80, 10, 15, 15)];
                    _timeOutView.image = [UIImage imageNamed:@"timeOut"];
                    _timeOutView.hidden = YES;
                    [self addSubview:_timeOutView];
                }
                
                if (!timeLbl) {
                    timeLbl = [[UILabel alloc] initWithFrame:CGRectNull];
                    [timeLbl setTextAlignment:NSTextAlignmentRight];
                    timeLbl.backgroundColor = [UIColor clearColor];
                    timeLbl.hidden = YES;
                    [self addSubview:timeLbl];
                }
            }
                
            //折扣title
            if (!brandView) {
                brandView = [[UIImageView alloc]initWithFrame:CGRectNull];
                brandView.image = [UIImage imageNamed:@"discountTitle"];
                brandView.hidden = YES;
                [self addSubview:brandView];
            }
            
            if (!brandDiscountLbl) {
                brandDiscountLbl = [[UILabel alloc] initWithFrame:CGRectNull];
                [brandDiscountLbl setFont:LMH_FONT_11];
                [brandDiscountLbl setTextColor:LMH_COLOR_GRAY];
                brandDiscountLbl.backgroundColor = [UIColor clearColor];
                brandDiscountLbl.hidden = YES;
                [self addSubview:brandDiscountLbl];
            }
            
            if (_eventVO.event_discount.count > 0) {
                timeLbl.hidden = NO;
                _timeOutView.hidden = NO;
                brandView.hidden = NO;
                brandDiscountLbl.hidden = NO;
            }else if(_section == -1){
                timeLbl.hidden = YES;
                _timeOutView.hidden = YES;
            }else{
                timeLbl.hidden = YES;
                _timeOutView.hidden = YES;
                brandView.hidden = YES;
                brandDiscountLbl.hidden = YES;
            }
            
            //折扣title 和 倒计时 label  折扣discountWord 赋值
            for (CartBrandDis *vo in _eventVO.event_discount) {
                if (vo.discount_title) {
                    discountTime = vo.discount_end_time;
                    
                    [brandDiscountLbl setText:[NSString stringWithFormat:@"%@", vo.discount_title]];
                    brandDiscountTitleStr = vo.discount_title;
                }
                
                if ([vo.discount_end_time integerValue] > 0) {
                    timeLbl.hidden = NO;
                    _timeOutView.hidden = NO;
                    brandView.hidden = NO;
                    brandDiscountLbl.hidden = NO;
                    
                    //计算时间
                    NSTimeInterval difftime = [vo.discount_end_time longLongValue];
                    NSInteger hours = (long)difftime/3600;
                    NSInteger minus = (long)difftime%3600/60;
                    NSInteger sec = (long)difftime%60;
                    if (hours < 24) {
                        [timeLbl setFont:LMH_FONT_12];
                        [timeLbl setTextColor:LMH_COLOR_SKIN];
                        [timeLbl setText:[NSString stringWithFormat:@"%02zi:%02zi:%02zi", hours,minus,sec]];
                    }else{
                        [timeLbl setFont:LMH_FONT_13];
                        [timeLbl setTextColor:LMH_COLOR_GRAY];
                        [timeLbl setText:[NSString stringWithFormat:@"剩%0.0f天", hours/24.0f]];
                    }
                }else{
                    timeLbl.hidden = YES;
                    _timeOutView.hidden = YES;
                    brandView.hidden = YES;
                    brandDiscountLbl.hidden = YES;
                }
            }
            
            if (!lineLbl) {
                lineLbl = [[UILabel alloc] initWithFrame:CGRectZero];
                
                lineLbl.backgroundColor = LMH_COLOR_LIGHTLINE;
                [self addSubview:lineLbl];
            }
        }
    }else if([_goodVO isKindOfClass:[CartProductVO class]]){
        self.contentView.backgroundColor = [UIColor whiteColor];
        _productVO = _goodVO;
        if (_productVO) {
            if (!_iconView) {
                _iconView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"productph"]];
                [_iconView setContentMode:UIViewContentModeScaleAspectFit];
                [_iconView setClipsToBounds:YES];
                
                _backView = [[UIView alloc] initWithFrame:CGRectZero];
                [_backView setBackgroundColor:[UIColor clearColor]];
                [_backView addSubview:_iconView];
                
                [self.contentView addSubview:_iconView];
            }
            if (_productVO.product_image) {
                NSString * imgUrlStr = [_productVO product_image];
                [_iconView setImageURL:[NSURL URLWithString:imgUrlStr]];
            }
            
            //折扣 discountWord View 图标
            if (!_discountWordView) { //折扣 discount_word
                _discountWordView = [[UIImageView alloc] initWithFrame:CGRectZero];
                _discountWordView.image = [UIImage imageNamed:@"discountWord"];
                _discountWordView.hidden = YES;
                
                [self.contentView addSubview:_discountWordView];
            }
            
            if (!_discountWordLbl) { //折扣 discount_word
                _discountWordLbl = [[UILabel alloc] initWithFrame:CGRectZero];
                [_discountWordLbl setBackgroundColor:[UIColor clearColor]];
                [_discountWordLbl setTextColor:LMH_COLOR_SKIN];
                [_discountWordLbl setFont:LMH_FONT_10];
                [_discountWordLbl setNumberOfLines:1];
                [_discountWordLbl setTextAlignment:NSTextAlignmentLeft];
                _discountWordLbl.hidden = YES;
                
                [self.contentView addSubview:_discountWordLbl];
            }
            //折扣discountWord 赋值
            for (CartBrandDis *VO in _productVO.discount_word) {
                _discountWordLbl.text = VO.discount_title;
            }
            
            if (!_nameLabel) { //名称
                _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                [_nameLabel setBackgroundColor:[UIColor clearColor]];
                [_nameLabel setTextColor:LMH_COLOR_GRAY];
                [_nameLabel setFont:LMH_FONT_12];
                [_nameLabel setNumberOfLines:2];
                [_nameLabel setLineBreakMode:NSLineBreakByTruncatingTail];
                
                [self.contentView addSubview:_nameLabel];
            }
            
            if (_productVO.product_name) {
                
                [_nameLabel setText:[_productVO product_name]];
            }
            
            if (!_optionsLabel) { //尺码 颜色 label
                _optionsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                [_optionsLabel setBackgroundColor:[UIColor clearColor]];
                [_optionsLabel setTextColor:LMH_COLOR_LIGHTGRAY];
                [_optionsLabel setFont:LMH_FONT_11];
                [_optionsLabel setNumberOfLines:1];
                [_optionsLabel setLineBreakMode:NSLineBreakByTruncatingTail];
                
                [self.contentView addSubview:_optionsLabel];
            }
            if (!_optionsButton) { //尺码 颜色  按钮
                _optionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [_optionsButton setBackgroundColor:[UIColor clearColor]];
                [_optionsButton setTitleColor:LMH_COLOR_LIGHTGRAY forState:UIControlStateNormal];
                [_optionsButton setImage:[UIImage imageNamed:@"goDown"] forState:UIControlStateNormal];
                _optionsButton.layer.borderColor = [LMH_COLOR_LIGHTLINE CGColor];
                _optionsButton.layer.borderWidth = 0.5;
                _optionsButton.layer.masksToBounds = YES;
                _optionsButton.layer.cornerRadius = 2.0;
                _optionsButton.titleLabel.font = LMH_FONT_11;
                _optionsButton.hidden = YES;
                _optionsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                _optionsButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
                [_optionsButton addTarget:self action:@selector(optionsBtnClick) forControlEvents:UIControlEventTouchUpInside];
                
                [self.contentView addSubview:_optionsButton];
            }
            
            if (_productVO.options && _productVO.options.count > 0) {
                NSString *optionStr = @"";
                for (NSInteger i = 0; i < _productVO.options.count; i++) {
                    if ([[_productVO.options objectAtIndex:i] isKindOfClass:[GoodOptionVO class]]) {
                        GoodOptionVO *option = (GoodOptionVO *)[_productVO.options objectAtIndex:i];
                        optionStr = [optionStr stringByAppendingFormat:@"%@:%@ ", option.Label, option.Value];
                        
                        optionsBtnStr = optionStr;
                    }
                }
                [_optionsLabel setText:optionStr];
                [_optionsButton setTitle:optionStr forState:UIControlStateNormal];
            }
            
            if (!_priceLabel){
                _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                [_priceLabel setBackgroundColor:[UIColor clearColor]];
                [_priceLabel setFont:LMH_FONT_12];
                [_priceLabel setTextColor:LMH_COLOR_GRAY];
                [_priceLabel setTextAlignment:NSTextAlignmentRight];
                [_priceLabel setNumberOfLines:1];
                [_priceLabel setLineBreakMode:NSLineBreakByTruncatingTail];
                
                [self.contentView addSubview:_priceLabel];
            }
            
            if (_productVO.sell_price) {
                [_priceLabel setText:[NSString stringWithFormat:@"¥%0.2f",[_productVO.sell_price floatValue]]];
            } else {
                [_priceLabel setText:@""];
            }
            
            if (!_marketPriceLbl) {
                _marketPriceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
                [_marketPriceLbl setBackgroundColor:[UIColor clearColor]];
                [_marketPriceLbl setFont:LMH_FONT_11];
                [_marketPriceLbl setTextColor:LMH_COLOR_LIGHTGRAY];
                [_marketPriceLbl setTextAlignment:NSTextAlignmentRight];
                [_marketPriceLbl setNumberOfLines:1];
                [_marketPriceLbl setLineBreakMode:NSLineBreakByTruncatingTail];
                
                [self.contentView addSubview:_marketPriceLbl];
            }
            
            if (_productVO.original_price) {
                [_marketPriceLbl setText:[NSString stringWithFormat:@"¥%0.2f",[_productVO.original_price floatValue]]];
            } else {
                [_marketPriceLbl setText:@""];
            }
            
            if (!_marketLine) {
                _marketLine = [[UILabel alloc] initWithFrame:CGRectZero];
                _marketLine.backgroundColor = LMH_COLOR_LIGHTGRAY;
                
                [_marketPriceLbl addSubview:_marketLine];
            }
            
            if (_section >= 0) {
                if (!_minusBtn) {
                    _minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    _minusBtn.backgroundColor = [UIColor clearColor];
                    [_minusBtn setImage:[UIImage imageNamed:@"minus_cart_disable"] forState:UIControlStateNormal];
                    [_minusBtn setImage:[UIImage imageNamed:@"minus_cart_disable"] forState:UIControlStateSelected];
                    [_minusBtn setImage:[UIImage imageNamed:@"minus_cart_disable"] forState:UIControlStateDisabled];
                    [_minusBtn setContentMode:UIViewContentModeCenter];
                    [_minusBtn addTarget:self action:@selector(minusBtnPressed) forControlEvents:UIControlEventTouchUpInside];
                    
                    [self.contentView addSubview:_minusBtn];
                }
                if ([_productVO.qty  integerValue] <= [_productVO.buy_min integerValue]) {
                    [_minusBtn setEnabled:NO];
                }else{
                    [_minusBtn setEnabled:YES];
                }
                
                if (!_countTF) {
                    _countTF = [[BOKUNoActionTextField alloc] initWithFrame:CGRectZero];
                    _countTF.backgroundColor = [UIColor clearColor];
                    [_countTF setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
                    [_countTF setTextAlignment:NSTextAlignmentCenter];
                    [_countTF setFont:LMH_FONT_12];
                    [_countTF setTextColor:LMH_COLOR_BLACK];
                    [_countTF setAlpha:1.0];
                    [_countTF setKeyboardType:UIKeyboardTypeNumberPad];
                    [_countTF setDelegate:_shopCartVC];
                    [_countTF.layer setBorderColor:LMH_COLOR_LINE.CGColor];
                    [_countTF.layer setBorderWidth:0.5];
                    [_countTF setTag:10101];
                    [_countTF setUserInteractionEnabled:NO];
                    
                    [self.contentView addSubview:_countTF];
                }
                
                if (_productVO.qty) {
                    [_countTF setText:[NSString stringWithFormat:@"%zi", [_productVO.qty integerValue]]];
                } else {
                    [_countTF setText:@"0"];
                }
                
                if (_productVO.product_id) {
                    [_countTF setAddtionInfo:_productVO.item_id];
                }
                
                if (!_plusBtn) {
                    _plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    _plusBtn.backgroundColor = [UIColor clearColor];
                    [_plusBtn setImage:[UIImage imageNamed:@"plus_cart_disable"] forState:UIControlStateNormal];
                    [_plusBtn setImage:[UIImage imageNamed:@"plus_cart_disable"] forState:UIControlStateSelected];
                    [_plusBtn setImage:[UIImage imageNamed:@"plus_cart_disable"] forState:UIControlStateDisabled];
                    [_plusBtn setContentMode:UIViewContentModeCenter];
                    [_plusBtn addTarget:self action:@selector(plusBtnPressed) forControlEvents:UIControlEventTouchUpInside];
                    
                    [self.contentView addSubview:_plusBtn];
                }
                if ([_productVO.qty  integerValue] >= [_productVO.stock integerValue] || [_productVO.qty  integerValue] >= [_productVO.buy_max integerValue]) {
                    [_plusBtn setEnabled:NO];
                }else{
                    [_plusBtn setEnabled:YES];
                }
                
                if (!_stockLbl) {
                    _stockLbl = [[UILabel alloc] initWithFrame:CGRectZero];
                    _stockLbl.backgroundColor = [UIColor clearColor];
                    [_stockLbl setText:@"商品已售完"];
                    [_stockLbl setFont:LMH_FONT_12];
                    [_stockLbl setTextColor:LMH_COLOR_SKIN];
                    
                    [self.contentView addSubview:_stockLbl];
                }
                if ([_productVO.stock integerValue] <= 0) {
                    [_stockLbl setHidden:NO];
                }else if([_productVO.stock integerValue] < [_productVO.qty integerValue]){
                    [_stockLbl setHidden:NO];
                    [_stockLbl setText:@"库存紧张"];
                }else{
                    [_stockLbl setHidden:YES];
                }
                
                if (!_deleteBtn) {
                    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    _deleteBtn.backgroundColor = [UIColor clearColor];
                    [_deleteBtn setImage:[UIImage imageNamed:@"cart_delete"] forState:UIControlStateNormal];
                    [_deleteBtn setImage:[UIImage imageNamed:@"cart_delete"] forState:UIControlStateSelected];
                    [_deleteBtn setImage:[UIImage imageNamed:@"cart_delete"] forState:UIControlStateDisabled];
                    [_deleteBtn setContentMode:UIViewContentModeCenter];
                    [_deleteBtn addTarget:self action:@selector(deleteBtnPressed) forControlEvents:UIControlEventTouchUpInside];
                    _deleteBtn.hidden = YES;
                    [self.contentView addSubview:_deleteBtn];
                }
            }else{
                if (!payNumLbl) {
                    payNumLbl = [[UILabel alloc] initWithFrame:CGRectZero];
                    payNumLbl.backgroundColor = [UIColor clearColor];
                    [payNumLbl setTextColor:LMH_COLOR_LIGHTGRAY];
                    [payNumLbl setFont:LMH_FONT_12];
                    [self addSubview:payNumLbl];
                }
                [payNumLbl setText:[NSString stringWithFormat:@"x %zi件", [_productVO.qty integerValue]]];
            }
            
            if (!lineLbl) {
                lineLbl = [[UILabel alloc] initWithFrame:CGRectZero];
                
                lineLbl.backgroundColor = LMH_COLOR_LIGHTLINE;
                [self addSubview:lineLbl];
            }
        }
    }
}
/**
 *  尺码颜色按钮 点击
 */
- (void)optionsBtnClick{

    if (self.cartCellDelegate && [self.cartCellDelegate respondsToSelector:@selector(clickSizeAndColorBtn:)]) {
        [self.cartCellDelegate clickSizeAndColorBtn:_productVO];
    }
}

- (void)minusBtnPressed
{
    if ([_countTF.text integerValue] != 1) {
        [_countTF setText:[NSString stringWithFormat:@"%zi", [_countTF.text integerValue]-1]];
        
        if (self.cartCellDelegate && [self.cartCellDelegate respondsToSelector:@selector(pressCountBtnAtCell:andCount:)]) {
            [self.cartCellDelegate pressCountBtnAtCell:_productVO.item_id andCount:[NSNumber numberWithInteger:[_countTF.text integerValue]]];
        }
    }
    if ([_countTF.text integerValue] <= [_productVO.buy_min integerValue]) {
        [_minusBtn setEnabled:NO];
    }else{
        [_minusBtn setEnabled:YES];
    }
    
    if ([_countTF.text integerValue] >= [_productVO.stock integerValue] || [_countTF.text integerValue] >= [_productVO.buy_max integerValue]) {
        [_plusBtn setEnabled:NO];
    }else{
        [_plusBtn setEnabled:YES];
    }
}

- (void)plusBtnPressed
{
    if ([_goodVO isKindOfClass:[CartProductVO class]]) {
        if ([_countTF.text integerValue] < [_productVO.buy_max integerValue] || [_countTF.text integerValue] < [_productVO.stock integerValue] || [_productVO.buy_max integerValue] == 0) {
            [_countTF setText:[NSString stringWithFormat:@"%zi", [_countTF.text integerValue]+1]];
            
            if (self.cartCellDelegate && [self.cartCellDelegate respondsToSelector:@selector(pressCountBtnAtCell:andCount:)]) {
                [self.cartCellDelegate pressCountBtnAtCell:_productVO.item_id andCount:[NSNumber numberWithInteger:[_countTF.text integerValue]]];
            }
        }else{
            [_plusBtn setEnabled:NO];
            //[self textStateHUD:[NSString stringWithFormat:@"该商品最多可购买%zi件", [_countTF.text integerValue]]];
        }
    }
    if ([_countTF.text integerValue] <= [_productVO.buy_min integerValue]) {
        [_minusBtn setEnabled:NO];
    }else{
        [_minusBtn setEnabled:YES];
    }
    
    if ([_countTF.text integerValue] >= [_productVO.stock integerValue] || [_countTF.text integerValue] >= [_productVO.buy_max integerValue]) {
        [_plusBtn setEnabled:NO];
    }else{
        [_plusBtn setEnabled:YES];
    }
}

- (void)deleteBtnPressed
{
    if (self.cartCellDelegate && [self.cartCellDelegate respondsToSelector:@selector(pressDeleteAtCell:)]) {
        [self.cartCellDelegate pressDeleteAtCell:_productVO];
    }
}

- (void)setSelectState:(BOOL)selectState
{
    _selectState = selectState;
    if (!_cbBtn) {
        _cbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cbBtn setBackgroundColor:[UIColor clearColor]];
        [_cbBtn addTarget:self action:@selector(setState:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_cbBtn];
    }
    
    if ([_goodVO isKindOfClass:[CartBrandVO class]]) {
        if (!_selectCB) {
            _selectCB = [[SSCheckBoxView alloc] initWithFrame:CGRectZero style:kSSCheckBoxViewStyleCustom4 checked:YES];
            [_selectCB setUserInteractionEnabled:NO];
            [self.contentView addSubview:_selectCB];
        }
        NSInteger brandNum = 0;
        for (CartProductVO *vo in _eventVO.product_arr) {
            brandNum += [vo.stock integerValue];
        }
        if (brandNum > 0) {
            [_selectCB setChecked:_selectState];
            [_cbBtn setUserInteractionEnabled:YES];
        }else{
            [_selectCB setChecked:NO];
            [_cbBtn setUserInteractionEnabled:NO];
        }
    }else{
        if (!_selectCB) {
            _selectCB = [[SSCheckBoxView alloc] initWithFrame:CGRectZero style:kSSCheckBoxViewStyleCustom4 checked:YES];
            [self.contentView addSubview:_selectCB];
            [_selectCB setUserInteractionEnabled:NO];
        }
        if ([_productVO.stock integerValue] > 0) {
            [_selectCB setChecked:_selectState];
            [_cbBtn setUserInteractionEnabled:YES];
            [_plusBtn setUserInteractionEnabled:YES];
            [_minusBtn setUserInteractionEnabled:YES];
        }else{
            [_selectCB setChecked:NO];
            [_cbBtn setUserInteractionEnabled:NO];
            [_plusBtn setUserInteractionEnabled:NO];
            [_minusBtn setUserInteractionEnabled:NO];
        }
    }
}

- (void)setState:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]]) {
        if (self.cartCellDelegate && [self.cartCellDelegate respondsToSelector:@selector(selectCheckBoxAtCell:andVO:andCheck:andSection:)]) {
            if ([_goodVO isKindOfClass:[CartBrandVO class]]) {
                [self.cartCellDelegate selectCheckBoxAtCell:self andVO:_eventVO andCheck:[NSNumber numberWithBool:_selectCB.checked] andSection:_section];
            }else if([_goodVO isKindOfClass:[CartProductVO class]]){
                [self.cartCellDelegate selectCheckBoxAtCell:self andVO:_productVO andCheck:[NSNumber numberWithBool:_selectCB.checked] andSection:_section];
            }
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    CGFloat vGap = 10.0f;
    
    if ([_goodVO isKindOfClass:[CartBrandVO class]]) {
        if (_section >= 0) {
            [_selectCB setFrame:CGRectMake(2, 0, 15, 15)];
            [_cbBtn setFrame:CGRectMake(0, 0, 35, 34.5)];
            
            [timeLbl setFrame:CGRectMake(CGRectGetMaxX(self.frame) - 65, 0, 55, 34.5)];
            
            //专场title frame
            CGSize brandTitleWide = [_eventVO.event_title sizeWithFont:LMH_FONT_15 constrainedToSize:CGSizeMake(ScreenW - CGRectGetMaxX(_cbBtn.frame)- 88 , 34.5)];
            [brandLbl setFrame:CGRectMake(45, 2, brandTitleWide.width, 34.5)];
            
            //折扣title frame
            CGSize brandDiscountTitleWide = [brandDiscountTitleStr sizeWithFont:LMH_FONT_11 constrainedToSize:CGSizeMake(ScreenW - CGRectGetMaxX(_cbBtn.frame) - CGRectGetWidth(brandLbl.frame) - 100, 18.5)];
            brandView.frame = CGRectMake(CGRectGetMaxX(brandLbl.frame), 10, brandDiscountTitleWide.width + 10, 18.5);
            brandDiscountLbl.frame = CGRectMake(CGRectGetMaxX(brandLbl.frame)+8, 12, brandDiscountTitleWide.width , 14.5);
        }else{
            [brandLbl setFrame:CGRectMake(12, 0, 250, 34.5)];
        }
        lineLbl.frame = CGRectMake(10, 34.5, ScreenW-20, 0.5);
    }else{
        if (_section >= 0) {
            [_selectCB setFrame:CGRectMake(2, 25, 13, 13)];
            [_cbBtn setFrame:CGRectMake(0, 7, 33, 70)];
            [_iconView setFrame:CGRectMake(43, vGap, 65, 65)];
        }else{
            [_iconView setFrame:CGRectMake(10, vGap, 65, 65)];
        }
    
        //商品 名称
        CGSize size = [[_productVO product_name] sizeWithFont:_nameLabel.font constrainedToSize:CGSizeMake(_nameLabel.frame.size.width, 30) lineBreakMode:NSLineBreakByWordWrapping];
        [_nameLabel setFrame:CGRectMake(CGRectGetMaxX(_iconView.frame) + 10, CGRectGetMinY(_iconView.frame)-3, w - 80 - CGRectGetMaxX(_iconView.frame), size.height>15?30:15)];
        
        //折扣 discountWord View
        [_discountWordView setFrame:CGRectMake(10, CGRectGetMaxY(_iconView.frame)+3, 8, 10)];
        //折扣 discountWord title
        [_discountWordLbl setFrame:CGRectMake(CGRectGetMaxX(_discountWordView.frame)+2, CGRectGetMaxY(_iconView.frame), ScreenW - CGRectGetMaxX(_cbBtn.frame) - 10, 15)];
        
        //尺码颜色 label Frame
        [_optionsLabel setFrame:CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame), w - CGRectGetMinX(_nameLabel.frame) - 60, CGRectGetMaxY(_iconView.frame)-23-CGRectGetMaxY(_nameLabel.frame))];
        
        //尺码颜色 button Frame
        [_optionsButton setFrame:CGRectMake(CGRectGetMaxX(_iconView.frame) + 10, CGRectGetMinY(_iconView.frame), w/5*2 ,30)];
        [_optionsButton setTitleEdgeInsets:UIEdgeInsetsMake(8, -25, 0, CGRectGetWidth(_optionsButton.frame)/4)];
        [_optionsButton setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(_optionsButton.frame)/4*3, 0,0)];
        
        [_priceLabel setFrame:CGRectMake(CGRectGetMaxX(_nameLabel.frame), CGRectGetMinY(_nameLabel.frame), w - 10 - CGRectGetMaxX(_nameLabel.frame), 16)];
        CGSize pricesize = [_marketPriceLbl.text sizeWithFont:_marketPriceLbl.font];
        [_marketPriceLbl setFrame:CGRectMake(CGRectGetMaxX(_priceLabel.frame) - pricesize.width, CGRectGetMaxY(_priceLabel.frame), pricesize.width, 16)];
        [_marketLine setFrame:CGRectMake(0, CGRectGetHeight(_marketPriceLbl.frame)/2, pricesize.width, 0.5)];
        if (_section < 0) {
            [payNumLbl setFrame:CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_optionsLabel.frame), 50, 20)];
            lineLbl.frame = CGRectMake(10, CGRectGetMaxY(payNumLbl.frame)+5, ScreenW-20, 0.5);
        }else{
            [_minusBtn setFrame:CGRectMake(CGRectGetMinX(_nameLabel.frame)-4, CGRectGetMaxY(_optionsLabel.frame), 30, 25)];
            [_countTF setFrame:CGRectMake(CGRectGetMaxX(_minusBtn.frame)-5, CGRectGetMinY(_minusBtn.frame)+3, 40, 19)];
            [_plusBtn setFrame:CGRectMake(CGRectGetMaxX(_countTF.frame)-5, CGRectGetMinY(_minusBtn.frame), 30, 25)];
            [_deleteBtn setFrame:CGRectMake(w - 35, CGRectGetMinY(_minusBtn.frame)-5, 35, 30)];
            [_stockLbl setFrame:CGRectMake(CGRectGetMaxX(_plusBtn.frame), CGRectGetMinY(_plusBtn.frame), 80, 25)];
        }
        
        //折扣 discountWord
        if (_productVO.discount_word.count > 0 && _section >= 0) {
            if (_productVO.discount_word.count > 0) {
                lineLbl.frame = CGRectMake(10, CGRectGetMaxY(_iconView.frame)+15.5, ScreenW-20, 0.5);
                _discountWordLbl.hidden = NO;
                _discountWordView.hidden = NO;
            }
        }else{
            lineLbl.frame = CGRectMake(10, CGRectGetMaxY(_iconView.frame)+9.5, ScreenW-20, 0.5);
            _discountWordLbl.hidden = YES;
            _discountWordView.hidden = YES;
        }
    }

    //判断导航栏右按钮的点击状态 2：编辑  1：完成
    if (self.selectNum == 2) { //点击“编辑”
        _deleteBtn.hidden = NO;
        _nameLabel.hidden = YES;
        
        //尺码颜色按钮处理
        _optionsLabel.hidden = YES;
        _optionsButton.hidden = NO;
        
        
    }else if (self.selectNum == 1){ //点击“完成”
        _deleteBtn.hidden  = YES;
        _nameLabel.hidden = NO;
        
        //尺码颜色按钮处理
        _optionsLabel.hidden = NO;
        _optionsButton.hidden = YES;
        
    }
}

- (void)prepareForReuse
{
    _iconView.imageURL = nil;
}

- (void)textStateHUD:(NSString *)text
{
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self];
        stateHud.delegate = self;
        [self addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeText;
    stateHud.labelText = text;
    stateHud.labelFont = [UIFont systemFontOfSize:13.0f];
    [stateHud show:YES];
    [stateHud hide:YES afterDelay:1.5];
}

#pragma mark - MBProgressHUD Delegate
- (void)hudWasHidden:(MBProgressHUD *)ahud
{
    [stateHud removeFromSuperview];
    stateHud = nil;
}

@end

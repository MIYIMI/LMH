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
    UILabel * _nameLabel;
    UILabel * _optionsLabel;
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
    UILabel *numLbl;
    UILabel *couponLbl;
    UIImageView *timeView;
    UILabel *timeLbl;
    UILabel *payNumLbl;
    UILabel *lineLbl;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier delegate:(id)delegate
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _shopCartVC = delegate;
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
            
            if (section >= 0) {
                if (!numLbl) {
                    numLbl = [[UILabel alloc] initWithFrame:CGRectZero];
                    [numLbl setFont:LMH_FONT_15];
                    [numLbl setTextColor:LMH_COLOR_BLACK];
                    [numLbl setTextAlignment:NSTextAlignmentRight];
                    numLbl.backgroundColor = [UIColor clearColor];
                    [self addSubview:numLbl];
                }
                NSInteger productNum = 0;
                for (CartProductVO *vo in _eventVO.product_arr) {
                    if ([vo.stock integerValue] > 0) {
                        productNum += [vo.qty integerValue];
                    }
                }
                [numLbl setText:[NSString stringWithFormat:@"共%zi件", productNum]];
                
                if (!couponLbl && section >= 0) {
                    couponLbl = [[UILabel alloc] initWithFrame:CGRectZero];
                    [couponLbl setFont:LMH_FONT_12];
                    [couponLbl setTextColor:LMH_COLOR_LIGHTGRAY];
                    couponLbl.numberOfLines = 2;// 不可少Label属性之一
                    couponLbl.lineBreakMode = NSLineBreakByTruncatingTail;// 不可少Label属性之二
                    couponLbl.backgroundColor = [UIColor clearColor];
//                    [self addSubview:couponLbl];
                }
                
                NSString *disStr = @"";
                for (NSString *str in _eventVO.event_discount) {
                    disStr = [disStr stringByAppendingString:str];
                    disStr = [disStr stringByAppendingString:@"    "];
                }
                [couponLbl setText:disStr];
                
                if (!lineLbl) {
                    lineLbl = [[UILabel alloc] initWithFrame:CGRectZero];
                    
                    lineLbl.backgroundColor = LMH_COLOR_LIGHTLINE;
                    [self addSubview:lineLbl];
                }
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
            
            if (!_nameLabel) {
                _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                [_nameLabel setBackgroundColor:[UIColor clearColor]];
                [_nameLabel setTextColor:LMH_COLOR_GRAY];
                [_nameLabel setFont:LMH_FONT_12];
                [_nameLabel setNumberOfLines:2];
                [_nameLabel setLineBreakMode:NSLineBreakByTruncatingTail];
                
                [self.contentView addSubview:_nameLabel];
            }
            
            if (_productVO.product_name) {
//                NSString *nameStr = [_productVO product_name];
//                if (nameStr.length > 25) {
//                    [nameStr isEqualToString:[nameStr substringFromIndex:24]];
//                }
                [_nameLabel setText:[_productVO product_name]];
            }
            
            if (!_optionsLabel) {
                _optionsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                [_optionsLabel setBackgroundColor:[UIColor clearColor]];
                [_optionsLabel setTextColor:LMH_COLOR_LIGHTGRAY];
                [_optionsLabel setFont:LMH_FONT_11];
                [_optionsLabel setNumberOfLines:1];
                [_optionsLabel setLineBreakMode:NSLineBreakByTruncatingTail];
                
                [self.contentView addSubview:_optionsLabel];
            }
            
            if (_productVO.options && _productVO.options.count > 0) {
                NSString *optionStr = @"";
                for (NSInteger i = 0; i < _productVO.options.count; i++) {
                    if ([[_productVO.options objectAtIndex:i] isKindOfClass:[GoodOptionVO class]]) {
                        GoodOptionVO *option = (GoodOptionVO *)[_productVO.options objectAtIndex:i];
                        optionStr = [optionStr stringByAppendingFormat:@"%@:%@ ", option.Label, option.Value];
                    }
                }
                [_optionsLabel setText:optionStr];
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
//                NSString *sell_price;
//                CGFloat sellPrice = [_productVO.sell_price floatValue];
//                if ((sellPrice * 10) - (int)(sellPrice * 10) > 0) {
//                    sell_price = [NSString stringWithFormat:@"¥%0.2f",[_productVO.sell_price floatValue]];
//                } else if(sellPrice - (int)sellPrice > 0) {
//                    sell_price = [NSString stringWithFormat:@"¥%0.1f",[_productVO.sell_price floatValue]];
//                } else {
//                    sell_price = [NSString stringWithFormat:@"¥%0.0f",[_productVO.sell_price floatValue]];
//                }
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
//                NSString *original_price;
//                CGFloat originalPrice = [_productVO.sell_price floatValue];
//                if ((originalPrice * 10) - (int)(originalPrice * 10) > 0) {
//                    original_price = [NSString stringWithFormat:@"¥%0.2f",[_productVO.original_price floatValue]];
//                } else if(originalPrice - (int)originalPrice > 0) {
//                    original_price = [NSString stringWithFormat:@"¥%0.1f",[_productVO.original_price floatValue]];
//                } else {
//                    original_price = [NSString stringWithFormat:@"¥%0.0f",[_productVO.original_price floatValue]];
//                }
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
                    [_stockLbl setText:[NSString stringWithFormat:@"库存%@件",_productVO.stock]];
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
            [brandLbl setFrame:CGRectMake(45, 0, ScreenW-CGRectGetMaxX(_cbBtn.frame)-100, 34.5)];
            [numLbl setFrame:CGRectMake(CGRectGetMaxX(self.frame) - 100, 0, 90, 34.5)];

//            [couponLbl setFrame:CGRectMake(35, CGRectGetMaxY(brandLbl.frame), CGRectGetWidth(self.frame)-45, 30)];
//            if (_eventVO.event_discount.count <= 0) {
//                [brandLbl setFrame:CGRectMake(35, 0, 210, ScreenW*0.111)];
//                [numLbl setFrame:CGRectMake(CGRectGetMaxX(self.frame) - 100, 0, 90, ScreenW*0.111)];
//            }
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
    
        CGSize size = [[_productVO product_name] sizeWithFont:_nameLabel.font constrainedToSize:CGSizeMake(_nameLabel.frame.size.width, 30) lineBreakMode:NSLineBreakByWordWrapping];
        [_nameLabel setFrame:CGRectMake(CGRectGetMaxX(_iconView.frame) + 10, CGRectGetMinY(_iconView.frame)-3, w - 80 - CGRectGetMaxX(_iconView.frame), size.height>15?30:15)];
        
        [_optionsLabel setFrame:CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame), w - CGRectGetMinX(_nameLabel.frame) - 60, CGRectGetMaxY(_iconView.frame)-23-CGRectGetMaxY(_nameLabel.frame))];
        
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
        lineLbl.frame = CGRectMake(10, CGRectGetMaxY(_iconView.frame)+9.5, ScreenW-20, 0.5);
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

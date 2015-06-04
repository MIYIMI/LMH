//
//  PopSkuView.m
//  YingMeiHui
//
//  Created by work on 14-10-10.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "PopSkuView.h"
#import "UIImageView+WebCache.h"
#import "ColorInfoVO.h"
#import "KTPropButton.h"
#import "SizeInfoVO.h"
#import "SkuListVO.h"
#import "kata_CartManager.h"
#import "kata_UserManager.h"
#import "KTProductNumRequest.h"
#import "KTProxy.h"

#define BOTTOMHEIGHT        50

@implementation PopSkuView{
    UIImageView *proimgView;
    ColorInfoVO *color_vo;
    NSString *_skuID;
}
@synthesize popSkuViewDelegate;
@synthesize skuTabeView;
@synthesize _productVO;
@synthesize _isShoppingCart;
@synthesize _proid;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.frame = frame;
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        _isShoppingCart = NO;
        
//        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"popback"]];
//        _scrollView.layer.contents = (id) [UIImage imageNamed:@"BigWhite_wave"].CGImage;
        _colorid = -1;
        _sizeid = -1;
        _qty = 1;
        colorBtnArray = [[NSMutableArray alloc] init];
        sizeBtnArray = [[NSMutableArray alloc] init];
        
        skuTabeView = [[UITableView alloc] initWithFrame:frame];
        skuTabeView.delegate = self;
        skuTabeView.dataSource = self;
        skuTabeView.backgroundColor = [UIColor whiteColor];
        skuTabeView.separatorStyle = UITableViewCellSeparatorStyleNone;
        skuTabeView.separatorColor = [UIColor grayColor];
        skuTabeView.bounces = NO;
        CGRect skuFrame = skuTabeView.frame;
        skuFrame.origin.y = 0;
        skuFrame.origin.x = 0;
        skuFrame.size.height -= BOTTOMHEIGHT;
        skuTabeView.frame = skuFrame;
        
        [self addSubview:skuTabeView];
        
        footView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(skuTabeView.frame), CGRectGetWidth(self.frame), BOTTOMHEIGHT)];
        [footView setBackgroundColor:[UIColor whiteColor]];
        
        UIButton *finishBtn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenW-100)/2, 10, 100, 30)];
        [finishBtn setTitle:@"确定" forState:UIControlStateNormal];
        [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [finishBtn setBackgroundColor:ALL_COLOR];
        [finishBtn setBackgroundImage:[UIImage imageNamed:@"red_btn_small"] forState:UIControlStateNormal];
        finishBtn.imageView.image = [UIImage imageNamed:@"red_btn_small"];
        [finishBtn addTarget:self action:@selector(finishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:finishBtn];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(footView.frame), 1)];
        [line setBackgroundColor:[UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:1]];
        [footView addSubview:line];
        
        [self addSubview:footView];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    cellRow = 1;
    if (_productVO.ColorInfo.count > 0) {
        cellRow += 1;
    }
    
    if (_productVO.SizeInfo.count > 0) {
        cellRow += 1;
    }
    
    return cellRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    NSInteger row = indexPath.row;
    CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    
    if(row == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        for (UIView *uview in cell.contentView.subviews) {
            [uview removeFromSuperview];
        }
        UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        
        if (_productVO.ColorInfo.count > 0 && row < cellRow - 1) {
//            if (_colorPropView) {
                _colorPropView = [[UIView alloc] initWithFrame:CGRectMake(0, 35, w, 35)];
            
            //颜色模块
                UILabel *propNameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
                [propNameLbl setBackgroundColor:[UIColor clearColor]];
                [propNameLbl setTextColor:[UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1]];
                [propNameLbl setTextAlignment:NSTextAlignmentLeft];
                [propNameLbl setFont:[UIFont systemFontOfSize:15.0]];
                [propNameLbl setNumberOfLines:2];
                [propNameLbl setLineBreakMode:NSLineBreakByTruncatingTail];
                [propNameLbl setText:[NSString stringWithFormat:@"%@", _productVO.ColorPropName]];
                [propNameLbl setTextColor:[UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:1]];
                CGSize nameSize = [propNameLbl.text sizeWithFont:propNameLbl.font];
                [propNameLbl setFrame:CGRectMake(10, 0, nameSize.width, 35)];
                [_colorPropView addSubview:propNameLbl];
                
                CGFloat xOffset = 10;
                CGFloat yOffset = 35;
                [colorBtnArray removeAllObjects];
                for (NSInteger i = 0; i < _productVO.ColorInfo.count; i++) {
                    ColorInfoVO *colorVO = (ColorInfoVO *)[_productVO.ColorInfo objectAtIndex:i];
                    
                    NSString *itemTitle = colorVO.Name;
                    CGSize titleSize = [itemTitle sizeWithFont:[UIFont systemFontOfSize:13.0]];
                    CGFloat targetWidth = titleSize.width + 20;
                    if (targetWidth < 46) {
                        targetWidth = 46;
                    }
                    
                    if (xOffset + targetWidth + 5 > w) {
                        xOffset = CGRectGetMinX(propNameLbl.frame);
                        yOffset += 35;
                    }
                    KTPropButton *propBtn = [[KTPropButton alloc] initWithFrame:CGRectMake(xOffset, yOffset, targetWidth, 25) andName:colorVO.Name withStock:[colorVO.SkuNum intValue]];
                    propBtn.colorData = colorVO;
                    [colorBtnArray addObject:propBtn];
                    
                    [propBtn addTarget:self action:@selector(colorPropBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [_colorPropView addSubview:propBtn];
                    xOffset = xOffset + targetWidth + 5;
                    
                    //设置默认按钮
                    if (_productVO.ColorInfo.count <= 1 && [colorVO.SkuNum integerValue] > 0)
                    {
                        _colorid = [colorVO.ColorID integerValue];
                        propBtn.buttonState = KTPropButtonSelected;
                    }
                    if ([_productVO.check_color_id integerValue] == [colorVO.ColorID integerValue]) {
                        _colorid = [colorVO.ColorID integerValue];
                        propBtn.buttonState = KTPropButtonSelected;
                    }
                }
                [_colorPropView setFrame:CGRectMake(0, 0, w, yOffset + 35)];
                [cell.contentView addSubview:_colorPropView];
//            }
            [self layoutColorBtn];
            
            [lineLbl setFrame:CGRectMake(10, CGRectGetHeight(_colorPropView.frame)-1, (CGRectGetWidth(self.frame) -20), 1)];
            [cell.contentView addSubview:lineLbl];
        }else if (_productVO.SizeInfo.count > 0 && row < cellRow -1) {
//            if (!_sizePropView) {
                _sizePropView = [[UIView alloc] initWithFrame:CGRectMake(0, 35, w, 35)];
            
            //尺寸模块
                UILabel *propNameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
                [propNameLbl setBackgroundColor:[UIColor clearColor]];
                [propNameLbl setTextColor:[UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1]];
                [propNameLbl setTextAlignment:NSTextAlignmentLeft];
                [propNameLbl setFont:[UIFont systemFontOfSize:15.0]];
                [propNameLbl setNumberOfLines:1];
                [propNameLbl setLineBreakMode:NSLineBreakByTruncatingTail];
                [propNameLbl setText:[NSString stringWithFormat:@"%@", _productVO.SizePropName]];
                [propNameLbl setTextColor:[UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:1]];
                CGSize nameSize = [propNameLbl.text sizeWithFont:propNameLbl.font];
                [propNameLbl setFrame:CGRectMake(10, 0, nameSize.width, 35)];
                [_sizePropView addSubview:propNameLbl];
                
                CGFloat xOffset = 10;
                CGFloat yOffset = 35;
                [sizeBtnArray removeAllObjects];
                for (NSInteger i = 0; i < _productVO.SizeInfo.count; i++) {
                    SizeInfoVO *sizeVO = (SizeInfoVO *)[_productVO.SizeInfo objectAtIndex:i];
                    
                    NSString *itemTitle = sizeVO.Name;
                    CGSize titleSize = [itemTitle sizeWithFont:[UIFont systemFontOfSize:13.0]];
                    CGFloat targetWidth = titleSize.width + 20;
                    if (targetWidth < 46) {
                        targetWidth = 46;
                    }
                    
                    if (xOffset + targetWidth + 5 > w) {
                        xOffset = CGRectGetMinX(propNameLbl.frame);
                        yOffset += 35;
                    }
                    KTPropButton *propBtn = [[KTPropButton alloc] initWithFrame:CGRectMake(xOffset, yOffset, targetWidth, 25) andName:sizeVO.Name withStock:[sizeVO.SkuNum integerValue]];
                    propBtn.sizeData = sizeVO;
                    [sizeBtnArray addObject:propBtn];
                    
                    [propBtn addTarget:self action:@selector(sizePropBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [_sizePropView addSubview:propBtn];
                    
                    xOffset = xOffset + targetWidth + 5;
                    
                    //设置商品默认尺寸
                    if (_productVO.SizeInfo.count <= 1 && [sizeVO.SkuNum integerValue])
                    {
                        _sizeid = [sizeVO.SizeID integerValue];
                        propBtn.buttonState = KTPropButtonSelected;
                    }
                    if ([_productVO.check_size_id integerValue] == [sizeVO.SizeID integerValue]) {
                        _sizeid = [sizeVO.SizeID integerValue];
                        propBtn.buttonState = KTPropButtonSelected;
                    }
                }
                [_sizePropView setFrame:CGRectMake(0, 0, w, yOffset + 35)];
                [cell.contentView addSubview:_sizePropView];
//            }
            [self layoutSizeBtn];
            
            [lineLbl setFrame:CGRectMake(10, CGRectGetHeight(_sizePropView.frame)-1, (CGRectGetWidth(self.frame) -20), 1)];
            [cell.contentView addSubview:lineLbl];
        }else{
            [lineLbl setFrame:CGRectMake(10, 79, (CGRectGetWidth(self.frame) -20), 1)];
            [cell.contentView addSubview:lineLbl];
        }
        
        [lineLbl setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        for (UIView *uview in cell.contentView.subviews) {
            [uview removeFromSuperview];
        }
        if (_productVO.SizeInfo.count > 0 && row < cellRow - 1) {
            
//            if (!_sizePropView) {
                _sizePropView = [[UIView alloc] initWithFrame:CGRectMake(0, 35, w, 35)];
                
                UILabel *propNameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
                [propNameLbl setBackgroundColor:[UIColor clearColor]];
                [propNameLbl setTextColor:[UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1]];
                [propNameLbl setTextAlignment:NSTextAlignmentLeft];
                [propNameLbl setFont:[UIFont systemFontOfSize:15.0]];
                [propNameLbl setNumberOfLines:1];
                [propNameLbl setLineBreakMode:NSLineBreakByTruncatingTail];
                [propNameLbl setText:[NSString stringWithFormat:@"%@", _productVO.SizePropName]];
                [propNameLbl setTextColor:[UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:1]];
                CGSize nameSize = [propNameLbl.text sizeWithFont:propNameLbl.font];
                [propNameLbl setFrame:CGRectMake(10, 0, nameSize.width, 35)];
                [_sizePropView addSubview:propNameLbl];
                
                CGFloat xOffset = 10;
                CGFloat yOffset = 35;
                [sizeBtnArray removeAllObjects];
                for (NSInteger i = 0; i < _productVO.SizeInfo.count; i++) {
                    SizeInfoVO *sizeVO = (SizeInfoVO *)[_productVO.SizeInfo objectAtIndex:i];
                    
                    NSString *itemTitle = sizeVO.Name;
                    CGSize titleSize = [itemTitle sizeWithFont:[UIFont systemFontOfSize:13.0]];
                    CGFloat targetWidth = titleSize.width + 20;
                    if (targetWidth < 46) {
                        targetWidth = 46;
                    }
                    
                    if (xOffset + targetWidth + 5 > w) {
                        xOffset = CGRectGetMinX(propNameLbl.frame);
                        yOffset += 35;
                    }
                    KTPropButton *propBtn = [[KTPropButton alloc] initWithFrame:CGRectMake(xOffset, yOffset, targetWidth, 25) andName:sizeVO.Name withStock:[sizeVO.SkuNum integerValue]];
                    propBtn.sizeData = sizeVO;
                    [sizeBtnArray addObject:propBtn];
                    
                    [propBtn addTarget:self action:@selector(sizePropBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                    [_sizePropView addSubview:propBtn];
                    xOffset = xOffset + targetWidth + 5;
                    
                    //设置商品默认尺寸
                    if (_productVO.SizeInfo.count <= 1 && [sizeVO.SkuNum integerValue] > 0)
                    {
                        _sizeid = [sizeVO.SizeID integerValue];
                        propBtn.buttonState = KTPropButtonSelected;
                    }
                    if ([_productVO.check_size_id integerValue] == [sizeVO.SizeID integerValue]) {
                        _sizeid = [sizeVO.SizeID integerValue];
                        propBtn.buttonState = KTPropButtonSelected;
                    }
                }
                [_sizePropView setFrame:CGRectMake(0, 0, w, yOffset + 35)];
                [cell.contentView addSubview:_sizePropView];
//            }
            [self layoutSizeBtn];
            
            [lineLbl setFrame:CGRectMake(10, CGRectGetHeight(_sizePropView.frame) - 1, (CGRectGetWidth(self.frame) -20), 1)];
            [cell.contentView addSubview:lineLbl];
        }else{
//            if (!_selectView) {
            for (UIView *sview in _selectView.subviews) {
                [sview removeFromSuperview];
            }
                _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 80)];
           
            //盘点是否是购物车界面 是否隐藏数量选择按钮    是：yes  否：no
            if (_isShoppingCart) {
                _selectView.hidden = YES;
            }
            
            
                UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 40, 35)];
                [titleLbl setText:@"数量"];
                [titleLbl setTextColor:[UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:1]];
                [titleLbl setFont:[UIFont systemFontOfSize:15.0]];
                [_selectView addSubview:titleLbl];
                
//                if (!_minusBtn) {
                    _minusBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 32, 40, 40)];
                    [_minusBtn setImage:[UIImage imageNamed:@"minus_normal"] forState:UIControlStateNormal];
                    [_minusBtn setImage:[UIImage imageNamed:@"minus_selected"] forState:UIControlStateSelected];
                    [_minusBtn setImage:[UIImage imageNamed:@"minus_disable"] forState:UIControlStateDisabled];
                    [_minusBtn setContentMode:UIViewContentModeCenter];
                    [_minusBtn addTarget:self action:@selector(minusBtnPressed) forControlEvents:UIControlEventTouchUpInside];
                    [_selectView addSubview:_minusBtn];
//                }
            
//                if (!_countTF) {
                    _countTF = [[BOKUNoActionTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_minusBtn.frame)-5, 37, 45, 30)];
                    [_countTF setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
                    [_countTF setTextAlignment:NSTextAlignmentCenter];
                    [_countTF setFont:[UIFont systemFontOfSize:11]];
                    [_countTF setTextColor:[UIColor colorWithRed:1 green:0.29 blue:0.4 alpha:1]];
                    [_countTF setAlpha:1.0];
                    [_countTF setKeyboardType:UIKeyboardTypeNumberPad];
                    [_countTF setDelegate:self];
                    [_countTF.layer setBorderColor:[UIColor colorWithRed:0.83 green:0.83 blue:0.83 alpha:1].CGColor];
                    [_countTF.layer setBorderWidth:0.5];
                    [_countTF setTag:10101];
                    [_countTF setEnabled:NO];
                    _qty = [_productVO.buy_min integerValue]>1?[_productVO.buy_min integerValue]:1;
                    [_countTF setText:[NSString stringWithFormat:@"%zi", _qty]];
                    [_selectView addSubview:_countTF];
//                }
            
//                if (!_plusBtn) {
                    _plusBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_countTF.frame)-5, 32, 40, 40)];
                    [_plusBtn setImage:[UIImage imageNamed:@"plus_normal"] forState:UIControlStateNormal];
                    [_plusBtn setImage:[UIImage imageNamed:@"plus_selected"] forState:UIControlStateSelected];
                    [_plusBtn setImage:[UIImage imageNamed:@"plus_disable"] forState:UIControlStateDisabled];
                    [_plusBtn setContentMode:UIViewContentModeCenter];
                    [_plusBtn addTarget:self action:@selector(plusBtnPressed) forControlEvents:UIControlEventTouchUpInside];
                    [_plusBtn setEnabled:YES];
                    [_selectView addSubview:_plusBtn];
//                }
                if ([_countTF.text integerValue] <= [_productVO.buy_min integerValue]) {
                    [_minusBtn setEnabled:NO];
                }else{
                    [_minusBtn setEnabled:YES];
                }
                
                [cell addSubview:_selectView];
            }
//        }
        
        [lineLbl setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    headHight = 100;
    
    return headHight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    if (!headView) {
    for (UIView *hview in headView.subviews) {
        [hview removeFromSuperview];
    }
        headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(skuTabeView.frame), tableView.sectionHeaderHeight)];
        [headView setBackgroundColor:[UIColor whiteColor]];
        
        proimgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (headHight-80)/2, 80, 80)];
        
        if (_productVO.ColorInfo.count > 0) {
            color_vo = _productVO.ColorInfo[0];
        }
        [proimgView sd_setImageWithURL:[NSURL URLWithString:color_vo.Pic?color_vo.Pic:@""] placeholderImage:nil];
        [headView addSubview:proimgView];
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLbl.numberOfLines = 2;// 不可少Label属性之一
        titleLbl.lineBreakMode = NSLineBreakByTruncatingTail;// 不可少Label属性之二
        [titleLbl setText:_productVO.Title];
        [titleLbl setFont:[UIFont systemFontOfSize:15.0]];
        [titleLbl setFrame:CGRectMake(CGRectGetMaxX(proimgView.frame) + 10, 10, CGRectGetMaxX(self.frame) - CGRectGetMaxX(proimgView.frame) - 10 - 30, 50)];
        [headView addSubview:titleLbl];
        
        UIImageView *btnImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.frame) - 30, 15, 18, 18)];
        [btnImgView setImage:[UIImage imageNamed:@"down_arrow"]];
        [headView addSubview:btnImgView];
        
        downBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.frame) - 50, 0, 50, 50)];
        [downBtn addTarget:self action:@selector(finishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:downBtn];
        
//        if (!__ourPriceLbl) {
            __ourPriceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            __ourPriceLbl.textColor = LMH_COLOR_SKIN;
            __ourPriceLbl.textAlignment = NSTextAlignmentCenter;
            __ourPriceLbl.lineBreakMode = NSLineBreakByTruncatingTail;
            __ourPriceLbl.numberOfLines = 1;
            __ourPriceLbl.font = [UIFont systemFontOfSize:18.0];
            
            [headView addSubview:__ourPriceLbl];
//        }
    
        if (_productVO.OurPrice) {
            NSString *ourPrice;
            CGFloat afloat = [_productVO.OurPrice floatValue];
            if ((afloat * 10) - (int)(afloat * 10) > 0) {
                ourPrice = [NSString stringWithFormat:@"¥%0.2f",[_productVO.OurPrice floatValue]];
            } else if(afloat - (int)afloat > 0) {
                ourPrice = [NSString stringWithFormat:@"¥%0.1f",[_productVO.OurPrice floatValue]];
            } else {
                ourPrice = [NSString stringWithFormat:@"¥%0.0f",[_productVO.OurPrice floatValue]];
            }
            [__ourPriceLbl setText:ourPrice];
            
        } else {
            [__ourPriceLbl setText:@"￥"];
        }
        CGSize ourSize = [__ourPriceLbl.text sizeWithFont:__ourPriceLbl.font];
        [__ourPriceLbl setFrame:CGRectMake(CGRectGetMinX(titleLbl.frame), CGRectGetMaxY(titleLbl.frame) + 5, ourSize.width, 20)];
        
//        if (!__marketPriceLbl) {
            __marketPriceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            __marketPriceLbl.font = [UIFont systemFontOfSize:15.0];
            __marketPriceLbl.textColor = LMH_COLOR_LIGHTGRAY;
            __marketPriceLbl.textAlignment = NSTextAlignmentCenter;
            __marketPriceLbl.lineBreakMode = NSLineBreakByTruncatingTail;
            __marketPriceLbl.numberOfLines = 1;
            
            [headView addSubview:__marketPriceLbl];
//        }
    
        if (_productVO.MarketPrice) {
            NSString *marketPrice;
            CGFloat bfloat = [_productVO.MarketPrice floatValue];
            if ((bfloat * 10) - (int)(bfloat * 10) > 0) {
                marketPrice = [NSString stringWithFormat:@"¥%0.2f",[_productVO.MarketPrice floatValue]];
            } else if(bfloat - (int)bfloat > 0) {
                marketPrice = [NSString stringWithFormat:@"¥%0.1f",[_productVO.MarketPrice floatValue]];
            } else {
                marketPrice = [NSString stringWithFormat:@"¥%0.0f",[_productVO.MarketPrice floatValue]];
            }
            __marketPriceLbl.text = marketPrice;
        } else {
            __marketPriceLbl.text = @"￥";
        }
        CGSize marketSize = [__marketPriceLbl.text sizeWithFont:__marketPriceLbl.font];
        [__marketPriceLbl setFrame:CGRectMake(CGRectGetMaxX(__ourPriceLbl.frame), CGRectGetMaxY(titleLbl.frame) + 5, marketSize.width + 4, 20)];
        UILabel *marketLine = [[UILabel alloc] initWithFrame:CGRectMake(4, CGRectGetHeight(__marketPriceLbl.frame)/2 - 0.5, marketSize.width, 0.5)];
        marketLine.backgroundColor = LMH_COLOR_LIGHTGRAY;
        [__marketPriceLbl addSubview:marketLine];
        
        UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(0,  headHight -1, CGRectGetWidth(self.frame), 1)];
        [lineLbl setBackgroundColor:LMH_COLOR_LIGHTLINE];
        [headView addSubview:lineLbl];
//    }
    
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    
    if(row == 0){
        if (_productVO.ColorInfo.count > 0 && row < cellRow - 1) {
            CGFloat xOffset = 10;
            CGFloat yOffset = 35;
            for (NSInteger i = 0; i < _productVO.ColorInfo.count; i++) {
                ColorInfoVO *colorVO = (ColorInfoVO *)[_productVO.ColorInfo objectAtIndex:i];
                
                NSString *itemTitle = colorVO.Name;
                CGSize titleSize = [itemTitle sizeWithFont:[UIFont systemFontOfSize:13.0]];
                CGFloat targetWidth = titleSize.width + 20;
                if (targetWidth < 46) {
                    targetWidth = 46;
                }
                if (xOffset + targetWidth + 5 > w) {
                    xOffset = 10;
                    yOffset += 35;
                }
                xOffset = xOffset + targetWidth + 5;
            }
            return yOffset + 35;
        }
        if (_productVO.SizeInfo.count > 0 && row < cellRow - 1) {
            CGFloat xOffset = 10;
            CGFloat yOffset = 35;
            for (NSInteger i = 0; i < _productVO.SizeInfo.count; i++) {
                SizeInfoVO *sizeVO = (SizeInfoVO *)[_productVO.SizeInfo objectAtIndex:i];
                
                NSString *itemTitle = sizeVO.Name;
                CGSize titleSize = [itemTitle sizeWithFont:[UIFont systemFontOfSize:13.0]];
                CGFloat targetWidth = titleSize.width + 20;
                if (targetWidth < 46) {
                    targetWidth = 46;
                }
                if (xOffset + targetWidth + 5 > w) {
                    xOffset = 10;
                    yOffset += 35;
                }
                xOffset = xOffset + targetWidth + 5;
            }
            return yOffset + 35;
        }
        return 80;
    }else{
        if (_productVO.SizeInfo.count > 0 && row < cellRow - 1) {
            CGFloat xOffset = 10;
            CGFloat yOffset = 35;
            for (NSInteger i = 0; i < _productVO.SizeInfo.count; i++) {
                SizeInfoVO *sizeVO = (SizeInfoVO *)[_productVO.SizeInfo objectAtIndex:i];
                
                NSString *itemTitle = sizeVO.Name;
                CGSize titleSize = [itemTitle sizeWithFont:[UIFont systemFontOfSize:13.0]];
                CGFloat targetWidth = titleSize.width + 20;
                if (targetWidth < 46) {
                    targetWidth = 46;
                }
                if (xOffset + targetWidth + 5 > w) {
                    xOffset = 10;
                    yOffset += 35;
                }
                xOffset = xOffset + targetWidth + 5;
            }
            return yOffset + 35;
        }
        return 80;
    }
    return 0;
}

- (void)colorPropBtnPressed:(id)sender
{
    _qty = 1;
    [_countTF setText:[NSString stringWithFormat:@"%zi", _qty]];
    if ([sender isKindOfClass:[KTPropButton class]]) {
        KTPropButton *btn = (KTPropButton *)sender;
        
        for (KTPropButton *colorbtn in colorBtnArray) {
            ColorInfoVO *vo = colorbtn.colorData;
            
            if (btn == colorbtn) {
                [proimgView sd_setImageWithURL:[NSURL URLWithString:vo.Pic?vo.Pic:@""] placeholderImage:nil];
                if ([vo.SkuNum integerValue] == 0) {
                    colorbtn.buttonState = KTPropButtonNoStock;
                } else {
                    colorbtn.buttonState = KTPropButtonSelected;
                    _colorid = [vo.ColorID integerValue];
                }
                
            } else {
                if (_sizeid >= 0) {
                    for (SkuListVO *skuVO in _productVO.PropTable) {
                        if (_sizeid == [skuVO.SizeID integerValue] && [vo.ColorID integerValue] == [skuVO.ColorID integerValue]) {
                            if ([skuVO.SkuNum integerValue] > 0) {
                                colorbtn.buttonState = KTPropButtonNormal;
                            }else{
                                colorbtn.buttonState = KTPropButtonNoStock;
                            }
                        }
                    }
                }else{
                    if ([vo.SkuNum integerValue] == 0) {
                        colorbtn.buttonState = KTPropButtonNoStock;
                    } else {
                        colorbtn.buttonState = KTPropButtonNormal;
                    }
                }
            }

        }
    }
    [self layoutSizeBtn];
    [self checkSkunum];
}

-(void)layoutSizeBtn{
    if (_colorid >= 0 && sizeBtnArray.count > 0) {
        for (SkuListVO *skuVO in _productVO.PropTable) {
            if (_colorid == [skuVO.ColorID integerValue]) {
                for (NSInteger i = 0; i < sizeBtnArray.count; i++) {
                    KTPropButton *sizebtn = (KTPropButton *)sizeBtnArray[i];
                    SizeInfoVO *sizeVO = sizebtn.sizeData;
                    
                    if ([skuVO.SizeID integerValue] == [sizeVO.SizeID integerValue]) {
                        if([skuVO.SkuNum integerValue] > 0){
                            if (sizebtn.buttonState == KTPropButtonSelected) {
                                sizebtn.buttonState = KTPropButtonSelected;
                            }else{
                                sizebtn.buttonState = KTPropButtonNormal;
                            }
                        }else{
                            if (sizebtn.buttonState == KTPropButtonSelected) {
                                _sizeid = -1;
                            }
                            sizebtn.buttonState = KTPropButtonNoStock;
                        }
                    }
                }
            }
        }
    }
}

- (void)sizePropBtnPressed:(id)sender
{
    _qty = [_productVO.buy_min integerValue];
    [_countTF setText:[NSString stringWithFormat:@"%zi", _qty]];
    if ([sender isKindOfClass:[KTPropButton class]]) {
        KTPropButton *btn = (KTPropButton *)sender;
        for (KTPropButton *sizebtn in sizeBtnArray) {
            SizeInfoVO *vo = sizebtn.sizeData;
            
            if (btn == sizebtn) {
                if ([vo.SkuNum integerValue] == 0) {
                    sizebtn.buttonState = KTPropButtonNoStock;
                } else {
                    sizebtn.buttonState = KTPropButtonSelected;
                    _sizeid = [vo.SizeID integerValue];
                }
            } else {
                if (_colorid >= 0) {
                    for (SkuListVO *skuVO in _productVO.PropTable) {
                        if (_colorid == [skuVO.ColorID integerValue] && [vo.SizeID integerValue] == [skuVO.SizeID integerValue]) {
                            if ([skuVO.SkuNum integerValue] > 0) {
                                sizebtn.buttonState = KTPropButtonNormal;
                            }else{
                                sizebtn.buttonState = KTPropButtonNoStock;
                            }
                        }
                    }
                }else{
                    if ([vo.SkuNum integerValue] == 0) {
                        sizebtn.buttonState = KTPropButtonNoStock;
                    } else {
                        sizebtn.buttonState = KTPropButtonNormal;
                    }
                }
            }
        }
    }
    [self layoutColorBtn];
    [self checkSkunum];
}

-(void)layoutColorBtn{
    if (_sizeid >= 0 && colorBtnArray.count > 0) {
        for (SkuListVO *skuVO in _productVO.PropTable) {
            if (_sizeid == [skuVO.SizeID integerValue]) {
                for (NSInteger i = 0; i < colorBtnArray.count; i++) {
                    KTPropButton *colorbtn = (KTPropButton *)colorBtnArray[i];
                    ColorInfoVO *colorVO = colorbtn.colorData;
                    if ([skuVO.ColorID integerValue] == [colorVO.ColorID integerValue]) {
                        if([skuVO.SkuNum integerValue] > 0){
                            if (colorbtn.buttonState == KTPropButtonSelected) {
                                colorbtn.buttonState = KTPropButtonSelected;
                            }else{
                                colorbtn.buttonState = KTPropButtonNormal;
                            }
                        }else{
                            if (colorbtn.buttonState == KTPropButtonSelected) {
                                _colorid = -1;
                            }
                            colorbtn.buttonState = KTPropButtonNoStock;
                        }
                    }
                }
            }
        }
    }
}

-(void)minusBtnPressed
{
    if (_qty <= [_productVO.buy_min integerValue]) {
        _qty = [_productVO.buy_min integerValue]>1?[_productVO.buy_min integerValue]:1;
    }else{
        _qty -= 1;
    }
    [self checkSkunum];
    [_countTF setText:[NSString stringWithFormat:@"%zi", _qty]];
}

-(void)checkSkunum{
    if (_colorid != -1 && _sizeid != -1) {
        for (id obj in _productVO.PropTable) {
            if ([obj isKindOfClass:[SkuListVO class]]) {
                SkuListVO *skuVO = (SkuListVO *)obj;
                if (skuVO.ColorID && skuVO.SizeID) {
                    if ([skuVO.ColorID integerValue] == _colorid && [skuVO.SizeID integerValue] == _sizeid) {
                        _skuNum = [skuVO.SkuNum intValue];
                        _skuID = skuVO.SkuID;
                        break;
                    }
                }
            }
        }
    } else if (_colorid != -1) {
        for (id obj in _productVO.PropTable) {
            if ([obj isKindOfClass:[SkuListVO class]]) {
                SkuListVO *skuVO = (SkuListVO *)obj;
                if (skuVO.ColorID && skuVO.SizeID) {
                    if ([skuVO.ColorID integerValue] == _colorid && [skuVO.SizeID integerValue] == 0) {
                        _skuNum = [skuVO.SkuNum intValue];
                        _skuID = skuVO.SkuID;
                        break;
                    }
                }
            }
        }
    } else if (_sizeid != -1) {
        for (id obj in _productVO.PropTable) {
            if ([obj isKindOfClass:[SkuListVO class]]) {
                SkuListVO *skuVO = (SkuListVO *)obj;
                if (skuVO.ColorID && skuVO.SizeID) {
                    if ([skuVO.ColorID integerValue] == 0 && [skuVO.SizeID integerValue] == _sizeid) {
                        _skuNum = [skuVO.SkuNum intValue];
                        _skuID = skuVO.SkuID;
                        break;
                    }
                }
            }
        }
    } else {
        for (id obj in _productVO.PropTable) {
            if ([obj isKindOfClass:[SkuListVO class]]) {
                SkuListVO *skuVO = (SkuListVO *)obj;
                if (skuVO.ColorID && skuVO.SizeID) {
                    if ([skuVO.ColorID integerValue] == 0 && [skuVO.SizeID integerValue] == 0) {
                        _skuNum = [skuVO.SkuNum intValue];
                        _skuID = skuVO.SkuID;
                        break;
                    }
                }
            }
        }
    }
    
    if (_qty <= 1) {
        [_minusBtn setEnabled:NO];
    }
    if ((_qty >= _skuNum || _qty >= [_productVO.buy_max integerValue]) && [_productVO.buy_max integerValue] != 0) {
        [_plusBtn setEnabled:NO];
    }else{
        [_plusBtn setEnabled:YES];
    }
}

-(void)plusBtnPressed
{
    if ((_colorid == -1) && (_productVO.ColorInfo.count > 0)) {
        [self textStateHUD:@"请选择商品颜色尺码"];
        return;
    }
    if ((_sizeid == -1) && (_productVO.SizeInfo.count > 0)) {
        [self textStateHUD:@"请选择商品颜色尺码"];
        return;
    }
    
    if ((_qty >= _skuNum || _qty >= [_productVO.buy_max integerValue]) && [_productVO.buy_max integerValue] != 0) {
        [self textStateHUD:[NSString stringWithFormat:@"该商品最多可购买%zi件", _qty]];
        [_plusBtn setEnabled:NO];
    }else{
        _qty += 1;
        [_minusBtn setEnabled:YES];
    }
    [self checkSkunum];
    
    [_countTF setText:[NSString stringWithFormat:@"%zi", _qty]];
}

-(void)finishBtnClick:(UIButton *)sender
{
    if (sender == downBtn) {
        if ([popSkuViewDelegate respondsToSelector:@selector(select_Color:select_Size:total_Num:andSku_id:)]) {
            [popSkuViewDelegate select_Color:-1 select_Size:-1 total_Num:-1 andSku_id:nil];
        }
            return;
    }else{
        if ((_colorid == -1) && (_productVO.ColorInfo.count > 0)) {
            [self textStateHUD:@"请选择商品颜色尺码"];
            return;
        }
        if ((_sizeid == -1) && (_productVO.SizeInfo.count > 0)) {
            [self textStateHUD:@"请选择商品颜色尺码"];
            return;
        }
        if ([popSkuViewDelegate respondsToSelector:@selector(select_Color:select_Size:total_Num:andSku_id:)]) {
            [popSkuViewDelegate select_Color:_colorid select_Size:_sizeid total_Num:_qty andSku_id:_skuID];
        }
        
    }
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
    [stateHud hide:YES afterDelay:1.0];
}

#pragma mark - MBProgressHUD Delegate
- (void)hudWasHidden:(MBProgressHUD *)ahud
{
    [stateHud removeFromSuperview];
    stateHud = nil;
}

@end

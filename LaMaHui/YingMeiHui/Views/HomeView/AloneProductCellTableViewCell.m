//
//  AloneProductCellTableViewCell.m
//  YingMeiHui
//
//  Created by work on 14-11-9.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

//哎，没时间注释，以后再说吧

#import "AloneProductCellTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "HomeVO.h"

@implementation AloneProductCellTableViewCell
@synthesize cellFrame;
@synthesize is_newEvent;//是否是新专场

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        viewArray      = [[NSMutableArray alloc] init];
        proImgArray    = [[NSMutableArray alloc] init];
        expertLblArray = [[NSMutableArray alloc] init];
        titleLblArray  = [[NSMutableArray alloc] init];
        sellLblArray   = [[NSMutableArray alloc] init];
        orgLblArray    = [[NSMutableArray alloc] init];
        lineLblArray   = [[NSMutableArray alloc] init];
        checkLblArray  = [[NSMutableArray alloc] init];
        sellnumLblArray= [[NSMutableArray alloc] init];
        tlabelArray    = [[NSMutableArray alloc] init];
        fitArray       = [[NSMutableArray alloc]init];
        iconArray      = [[NSMutableArray alloc] init];
        salesArray     = [[NSMutableArray alloc] init];
        imgArray       = [[NSMutableArray alloc] init];
        logoArray      = [[NSMutableArray alloc] init];
        ttArray        = [[NSMutableArray alloc] init];
        
        is_newEvent = NO;
    }
    
    return self;
}

-(void)layoutUI:(NSArray*)cellData andColnum:(NSInteger)colnum is_act:(BOOL)flag is_type:(BOOL)logoShow {
    CGFloat cellHeight;
    _cellData = cellData;
    _isFlag = flag;
    _logoShow = logoShow;
    
    // 2 -- 竖排   1 -- 横排
    NSInteger count = colnum;
    
    if (count == 2 && !is_newEvent) {
        cellHeight = (ScreenW-30)/2+75;
    }else if(count == 2){
        cellHeight = (ScreenW-30)/2+55;
    }else{
        cellHeight = 140*((ScreenW/320)-1)+140;
    }
    
    if (!cellView) {
        CGRect frame = self.frame;
        frame.size.width = ScreenW;
        frame.size.height = cellHeight;
        cellView = [[UIView alloc] initWithFrame:frame];
        [self addSubview:cellView];
        
        for (NSInteger i = 0; i < count; i++) {
            UIView *unitView = [[UIView alloc] initWithFrame:CGRectZero];
            [unitView setBackgroundColor:[UIColor whiteColor]];
            [viewArray addObject:unitView];
            [cellView addSubview:unitView];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(productTaped:)];
            [unitView addGestureRecognizer:tapGesture];
            
            UIImageView *proImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
            [proImgArray addObject:proImgView];
            [unitView addSubview:proImgView];
            
            UIImageView *outImg = [[UIImageView alloc] initWithFrame:CGRectZero];
            outImg.image = [UIImage imageNamed:@"icon_salesout"];
            [proImgView addSubview:outImg];
            [imgArray addObject:outImg];
            
            UIImageView *logoImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
            [logoArray addObject:logoImgView];
            [proImgView addSubview:logoImgView];
            
            UIImageView *ttImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            [ttArray addObject:ttImageView];
            [proImgView addSubview:ttImageView];
            
            UILabel *expertLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            [expertLbl setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7]];
            [expertLbl setTextColor:[UIColor colorWithRed:0.9 green:0.58 blue:0.2 alpha:1]];
            [expertLbl setTextAlignment:NSTextAlignmentCenter];
            expertLbl.adjustsFontSizeToFitWidth = YES;
            [expertLblArray addObject:expertLbl];
            [proImgView addSubview:expertLbl];
            
            UILabel *salesLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            [salesLbl setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6]];
            [salesLbl setTextColor:[UIColor whiteColor]];
            [salesLbl setTextAlignment:NSTextAlignmentCenter];
            [salesLbl setFont:[UIFont boldSystemFontOfSize:15.0]];
            [salesArray addObject:salesLbl];
            [proImgView addSubview:salesLbl];
            
            UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            [titleLbl setTextColor:RGB(51, 51, 51)];
            [titleLbl setFont:FONT(13.0)];
            [titleLbl setBackgroundColor:[UIColor clearColor]];
            [titleLblArray addObject:titleLbl];
            [unitView addSubview:titleLbl];
            
            UILabel *ttlabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [ttlabel setTextColor:RGB(153, 153, 153)];
            [ttlabel setFont:FONT(10.0)];
            [ttlabel setBackgroundColor:[UIColor clearColor]];
            [tlabelArray addObject:ttlabel];
            [unitView addSubview:ttlabel];
            
            UILabel *fitlabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [fitlabel setTextColor:RGB(153, 153, 153)];
            [fitlabel setFont:FONT(10.0)];
            [fitlabel setTextAlignment:NSTextAlignmentRight];
            [fitlabel setBackgroundColor:[UIColor clearColor]];
            [fitArray addObject:fitlabel];
            [unitView addSubview:fitlabel];
            
            UILabel *sellLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            [sellLbl setBackgroundColor:[UIColor clearColor]];
            [sellLbl setTextColor: ALL_COLOR];
            [sellLbl setFont:FONT(15.0)];
            [sellLbl setTextAlignment:NSTextAlignmentLeft];
            [sellLblArray addObject:sellLbl];
            [unitView addSubview:sellLbl];
            
            UILabel *orgLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            [orgLbl setBackgroundColor:[UIColor clearColor]];
            [orgLbl setTextColor:RGB(153, 153, 153)];
            [orgLbl setFont:FONT(10.0)];
            [orgLbl setTextAlignment:NSTextAlignmentRight];
            [orgLblArray addObject:orgLbl];
            [unitView addSubview:orgLbl];
            
            UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            [lineLbl setBackgroundColor:[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1]];
            [lineLblArray addObject:lineLbl];
            [orgLbl addSubview:lineLbl];
            
            UILabel *checkLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            [checkLbl setBackgroundColor:[UIColor clearColor]];
            checkLbl.textAlignment = NSTextAlignmentCenter;
            checkLbl.layer.borderColor = [[UIColor colorWithWhite:0.840 alpha:0.500] CGColor];
            checkLbl.layer.borderWidth = 0.5;
            checkLbl.layer.masksToBounds = YES;
            checkLbl.layer.cornerRadius = 2.0;
            [checkLbl setTextColor:[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1]];
            [checkLbl setFont:FONT(10.0)];
            [checkLblArray addObject:checkLbl];
            [unitView addSubview:checkLbl];
            
            if (count == 1){
                UILabel *sellnumLbl = [[UILabel alloc] initWithFrame:CGRectZero];
                [sellnumLbl setBackgroundColor:[UIColor clearColor]];
                [sellnumLbl setTextColor:RGB(153, 153, 153)];
                [sellnumLbl setFont:FONT(10.0)];
                [sellnumLbl setTextAlignment:NSTextAlignmentRight];
                [sellnumLblArray addObject:sellnumLbl];
                [unitView addSubview:sellnumLbl];
                
                UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
                [iconView setImage:LOCAL_IMG(@"icon_shop")];
                [iconArray addObject:iconView];
//                [unitView addSubview:iconView];
            }
        }
    }
    
    //改变背景色
    if(count == 2){
        [cellView setBackgroundColor:[UIColor whiteColor]];
    }else{
        if(self.row == 0)
            [cellView setBackgroundColor:[UIColor whiteColor]];
        else
            [cellView setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
    }
    
    for (NSInteger i = 0; i < cellData.count; i++) {
        HomeProductVO *pvo = cellData[i];
        UIView *uview = viewArray[i];
        UIImageView *pview = proImgArray[i];
        UILabel *elbl = expertLblArray[i];
        UILabel *tlbl = titleLblArray[i];
        UILabel *slbl = sellLblArray[i];     //售价
        UILabel *olbl = orgLblArray[i];      //老价格/原价
        UILabel *llbl = lineLblArray[i];
        UILabel *chlbl = checkLblArray[i];
        UILabel *tlabel = tlabelArray[i];
        UILabel *fitlbl = fitArray[i];
        UILabel *sabl = salesArray[i];
        UIImageView *oview = imgArray[i];
        UIImageView *lview = logoArray[i];
        UIImageView *ttIV = ttArray[i];
        
        if (count == 2 && cellData.count == 1) {
            ((UIView *)viewArray[i+1]).hidden = YES;
        }else{
            ((UIView *)viewArray[i]).hidden = NO;
        }
        
        [UIView beginAnimations:@"ToggleViews" context:nil];
        [UIView setAnimationDuration:1.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        // Make the animatable changes.
        pview.alpha = 0.0;
        pview.alpha = 1.0;
        [UIView commitAnimations];

        [pview sd_setImageWithURL:[NSURL URLWithString:pvo.pic] placeholderImage:nil];
        if (count == 1 && ([pvo.is_activity integerValue] == 1 || [pvo.is_activity integerValue] == 0)) {
            UILabel *nlbl = sellnumLblArray[i];
            nlbl.tag = 100001;
            UIImageView *iview = iconArray[i];
            iview.tag = 100002;
            uview.frame = CGRectMake(0, 5, ScreenW, cellHeight - 5);
            pview.frame = CGRectMake(10, 10, CGRectGetHeight(uview.frame)-20, CGRectGetHeight(uview.frame)-20);
            if ([pvo.stock integerValue] >0) {
                oview.hidden = YES;
            }else if(!is_newEvent){
                oview.frame = CGRectMake((ScreenW/3-ScreenW/3/5*4)/2, (CGRectGetHeight(pview.frame)-ScreenW/3/5*4)/2, CGRectGetWidth(pview.frame)/5*4, ScreenW/3/5*4);
                oview.hidden = NO;
            }
            
            elbl.frame = CGRectMake(0, CGRectGetHeight(pview.frame)-20, CGRectGetWidth(pview.frame), 20);
            CGFloat rwidth = CGRectGetWidth(uview.frame) - CGRectGetWidth(pview.frame) - 10;
            tlbl.frame = CGRectMake(CGRectGetMaxX(pview.frame)+10, 32, rwidth - 15, 35);
            tlabel.frame = CGRectMake(CGRectGetMaxX(pview.frame)+10, 6, 80, 15);
            fitlbl.frame = CGRectMake(ScreenW - 100, 6, 90, 15);
            fitlbl.text = pvo.age_group;
            [tlbl setNumberOfLines:2];
            [tlbl setLineBreakMode:NSLineBreakByTruncatingTail];
            if (pvo.source_platform_cn != nil) {
                tlabel.text = pvo.source_platform_cn;
            } else{
                [tlabel setHidden:YES];
                CGSize titleSize = [pvo.product_name sizeWithFont:FONT(15.0) constrainedToSize:CGSizeMake(rwidth - 10, 70) lineBreakMode:NSLineBreakByCharWrapping];
                tlbl.frame = CGRectMake(CGRectGetMaxX(pview.frame)+10, 20, rwidth - 10, titleSize.height);
                tlabel.frame = CGRectZero;
            }
            
            NSString *our_price;
            CGFloat ourPrice = [pvo.our_price floatValue];
            if ((ourPrice * 10) - (int)(ourPrice * 10) > 0) {
                our_price = [NSString stringWithFormat:@"¥%0.2f",[pvo.our_price floatValue]];
            } else if(ourPrice - (int)ourPrice > 0) {
                our_price = [NSString stringWithFormat:@"¥%0.1f",[pvo.our_price floatValue]];
            } else {
                our_price = [NSString stringWithFormat:@"¥%0.0f",[pvo.our_price floatValue]];
            }
            NSString *sellStr = our_price;
//            NSString *sellStr = [NSString stringWithFormat:@"¥%0.2f",[pvo.our_price floatValue]];
            CGSize selSize = [sellStr sizeWithFont:FONT(15.0) constrainedToSize:CGSizeMake((rwidth-10)/2, 20) lineBreakMode:NSLineBreakByCharWrapping];
            [slbl setFrame:CGRectMake(CGRectGetMaxX(pview.frame)+10, CGRectGetHeight(uview.frame)-60, selSize.width, 20)];
            [slbl setText:sellStr];
            
            NSString *market_price;
            CGFloat marketPrice = [pvo.market_price floatValue];
            if ((marketPrice * 10) - (int)(marketPrice * 10) > 0) {
                market_price = [NSString stringWithFormat:@"¥%0.2f",[pvo.market_price floatValue]];
            } else if(marketPrice - (int)marketPrice > 0) {
                market_price = [NSString stringWithFormat:@"¥%0.1f",[pvo.market_price floatValue]];
            } else {
                market_price = [NSString stringWithFormat:@"¥%0.0f",[pvo.market_price floatValue]];
            }
            
            NSString *orgStr = market_price;
//            NSString *orgStr = [NSString stringWithFormat:@"¥%0.2f",[pvo.market_price floatValue]];
            CGSize orgSize = [orgStr sizeWithFont:FONT(12.0) constrainedToSize:CGSizeMake((rwidth-10)/2, 20) lineBreakMode:NSLineBreakByCharWrapping];
            [olbl setFrame:CGRectMake(CGRectGetMaxX(slbl.frame)+20, CGRectGetMinY(slbl.frame), orgSize.width, 20)];
            [olbl setText:orgStr];
            
            llbl.frame = CGRectMake(0, CGRectGetHeight(olbl.frame)/2, CGRectGetWidth(olbl.frame), 1);
            //自适应label宽度  横版
            NSString *detailStr = [NSString stringWithFormat:@"%@%@",pvo.detail_label, [pvo.final_price integerValue]>0?pvo.final_price:@""];
            CGSize chlblWide = [detailStr sizeWithFont:FONT(11) constrainedToSize:CGSizeMake(150, 20) lineBreakMode:NSLineBreakByWordWrapping];
            chlbl.frame = CGRectMake(CGRectGetMaxX(pview.frame)+10, CGRectGetHeight(uview.frame)-30, chlblWide.width+5 , 15);
            
            //label  不同颜色定义
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:detailStr];
            [str addAttribute:NSForegroundColorAttributeName value:ALL_COLOR range:NSMakeRange(pvo.detail_label.length, str.length-pvo.detail_label.length)];
            nlbl.frame = CGRectMake(ScreenW - 90, CGRectGetHeight(uview.frame)-30, 80, 15);
            [nlbl setText:pvo.begin_time];
            
            [chlbl setAttributedText:str];
            if (stringIsEmpty(pvo.detail_label)) {
                chlbl.hidden = YES;
            }
            
            iview.frame = CGRectMake(CGRectGetWidth(uview.frame)-30, CGRectGetHeight(uview.frame)-35, 25, 25);
        }else if([pvo.is_activity integerValue] <= 1){
            uview.frame = CGRectMake(10+i*((ScreenW-30)/2+10), 10, (ScreenW-30)/2, cellHeight-10);
            [uview.layer setBorderWidth:0.5];
            [uview.layer setBorderColor:[[UIColor colorWithWhite:0.840 alpha:0.300] CGColor]];
            pview.frame = CGRectMake(0, 0, CGRectGetWidth(uview.frame), CGRectGetWidth(uview.frame));
            if ([pvo.stock integerValue] > 0) {
                oview.hidden = YES;
            }else if(!is_newEvent){
                oview.hidden = NO;
                oview.frame = CGRectMake((CGRectGetWidth(pview.frame)- CGRectGetWidth(pview.frame)/5*3)/2, (CGRectGetHeight(pview.frame)-CGRectGetWidth(pview.frame)/5*3)/2, CGRectGetWidth(pview.frame)/5*3, CGRectGetWidth(pview.frame)/5*3);
            }
            
            if (pvo.sales_title.length > 0 && _isFlag) {
                sabl.frame = CGRectMake(0, CGRectGetHeight(pview.frame)-40, CGRectGetWidth(pview.frame), 30);
                sabl.text = pvo.sales_title;
            }
            elbl.frame = CGRectMake(0, CGRectGetHeight(pview.frame)-20, CGRectGetWidth(pview.frame), 20);
            elbl.font  = [UIFont systemFontOfSize:13];
            
            CGFloat bheight = CGRectGetMaxY(pview.frame)+5;
            
            [tlbl setNumberOfLines:1];
            tlbl.frame = CGRectMake(5, bheight, (ScreenW-30)/2-5, 15);
            [tlbl setLineBreakMode:NSLineBreakByTruncatingTail];
        
            tlabel.text = pvo.source_platform_cn;
            
            NSString *our_price;
            CGFloat ourPrice = [pvo.our_price floatValue];
            if ((ourPrice * 10) - (int)(ourPrice * 10) > 0) {
                our_price = [NSString stringWithFormat:@"¥%0.2f",[pvo.our_price floatValue]];
            } else if(ourPrice - (int)ourPrice > 0) {
                our_price = [NSString stringWithFormat:@"¥%0.1f",[pvo.our_price floatValue]];
            } else {
                our_price = [NSString stringWithFormat:@"¥%0.0f",[pvo.our_price floatValue]];
            }
            NSString *sellStr = our_price;
//            NSString *sellStr = [NSString stringWithFormat:@"¥%0.1f",[pvo.our_price floatValue]];
            CGSize selSize = [sellStr sizeWithFont:FONT(15.0) constrainedToSize:CGSizeMake(CGRectGetWidth(uview.frame)/5*2, 20) lineBreakMode:NSLineBreakByCharWrapping];
            [slbl setFrame:CGRectMake(5, CGRectGetMaxY(tlbl.frame)+5, selSize.width, 15)];
            [slbl setText:sellStr];
            
            //自适应label宽度
            NSString *detailStr = [NSString stringWithFormat:@"%@%@",pvo.detail_label, [pvo.final_price integerValue]>0?pvo.final_price:@""];
            CGSize chlblWide = [detailStr sizeWithFont:FONT(10) constrainedToSize:CGSizeMake(150, 20) lineBreakMode:NSLineBreakByWordWrapping];
            chlbl.frame = CGRectMake(5, CGRectGetMaxY(slbl.frame)+5, chlblWide.width+5, 15);
            
            //label  不同颜色定义
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:detailStr];
            [str addAttribute:NSForegroundColorAttributeName value:ALL_COLOR range:NSMakeRange(pvo.detail_label.length, str.length-pvo.detail_label.length)];
            
            chlbl.attributedText = str;
            
            if (stringIsEmpty(pvo.detail_label)) {
                chlbl.hidden = YES;
            }
            
            NSString *market_price;
            CGFloat marketPrice = [pvo.market_price floatValue];
            if ((marketPrice * 10) - (int)(marketPrice * 10) > 0) {
                market_price = [NSString stringWithFormat:@"¥%0.2f",[pvo.market_price floatValue]];
            } else if(marketPrice - (int)marketPrice > 0) {
                market_price = [NSString stringWithFormat:@"¥%0.1f",[pvo.market_price floatValue]];
            } else {
                market_price = [NSString stringWithFormat:@"¥%0.0f",[pvo.market_price floatValue]];
            }
            NSString *orgStr = market_price;
            CGSize orgSize = [orgStr sizeWithFont:FONT(12.0) constrainedToSize:CGSizeMake(CGRectGetWidth(uview.frame)/5*2, 20) lineBreakMode:NSLineBreakByCharWrapping];
            [olbl setFrame:CGRectMake(CGRectGetWidth(uview.frame) - orgSize.width - 5 , CGRectGetMinY(slbl.frame), orgSize.width, 20)];
            if (is_newEvent) {//是否是专场的
                olbl.frame = CGRectMake(CGRectGetMaxX(slbl.frame)+5, CGRectGetMaxY(tlbl.frame)+5, orgSize.width, 15);
            }
            NSMutableAttributedString *old_attriStr = [[NSMutableAttributedString alloc] initWithString:market_price];
            [old_attriStr addAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]} range:NSMakeRange(0, old_attriStr.length)];
            olbl.attributedText = old_attriStr;
            
            tlabel.frame = CGRectMake(CGRectGetWidth(uview.frame) - 50, CGRectGetMaxY(slbl.frame)+5, 45, 15);
            [tlabel setTextAlignment:NSTextAlignmentRight];
            
            if (is_newEvent) {
                tlabel.frame = CGRectMake(CGRectGetWidth(uview.frame) - 50, CGRectGetMinY(slbl.frame), 45, 15);
                tlabel.text = pvo.age;
            }
        }else if([pvo.is_activity integerValue] == 2){
            if (count == 1) {
                uview.frame = CGRectMake(0, 5, ScreenW, cellHeight - 5);
                pview.frame = CGRectMake(0, 0, ScreenW, CGRectGetHeight(uview.frame));
                [pview sd_setImageWithURL:[NSURL URLWithString:pvo.activity_image_w] placeholderImage:nil];
            }else{
                uview.frame = CGRectMake(10+i*((ScreenW-30)/2+10), 10, (ScreenW-30)/2, cellHeight-10);
                [uview.layer setBorderWidth:0.5];
                [uview.layer setBorderColor:[[UIColor colorWithWhite:0.840 alpha:0.300] CGColor]];
                pview.frame = CGRectMake(0, 0, CGRectGetWidth(uview.frame), cellHeight-10);
                [pview sd_setImageWithURL:[NSURL URLWithString:pvo.activity_image_h] placeholderImage:nil];
            }
            elbl.frame = CGRectNull;
            tlbl.frame = CGRectNull;
            slbl.frame = CGRectNull;
            olbl.frame = CGRectNull;
            llbl.frame = CGRectNull;
            chlbl.frame = CGRectNull;
            tlabel.frame = CGRectNull;
            fitlbl.frame = CGRectNull;
            sabl.frame = CGRectNull;
            oview.frame = CGRectNull;
            lview.frame = CGRectNull;
            ttIV.frame = CGRectNull;
            
            for (UIView *rview in uview.subviews) {
                if (rview.tag == 100001 || rview.tag == 100002) {
                    rview.frame = CGRectNull;
                }
            }
        }
        
        
        if ([pvo.is_exclusive boolValue]) {
            NSString *exclusive_price;
            CGFloat exclusivePrice = [pvo.exclusive_price floatValue];
            if ((exclusivePrice * 10) - (int)(exclusivePrice * 10) > 0) {
                exclusive_price = [NSString stringWithFormat:@"¥%0.2f",[pvo.market_price floatValue]];
            } else if(exclusivePrice - (int)exclusivePrice > 0) {
                exclusive_price = [NSString stringWithFormat:@"¥%0.1f",[pvo.market_price floatValue]];
            } else {
                exclusive_price = [NSString stringWithFormat:@"¥%0.0f",[pvo.market_price floatValue]];
            }
            [elbl setText:[NSString stringWithFormat:@"新人专享价:¥%@",exclusive_price]];
            [elbl setHidden:NO];
        }else{
            [elbl setHidden:YES];
        }
        
        [tlbl setText:pvo.product_name];
        
        if (_logoShow == YES) {
            // 添加logo
            lview.frame = CGRectMake(pview.frame.size.width - CGRectGetWidth(pview.frame)/3, 0, CGRectGetWidth(pview.frame)/3, CGRectGetWidth(pview.frame)/6);
            if (is_newEvent) {
                [lview sd_setImageWithURL:[NSURL URLWithString:pvo.tag_url]];
                lview.frame = CGRectMake(0, 0, CGRectGetWidth(pview.frame)/3, CGRectGetWidth(pview.frame)/6);
            }else{
                [lview sd_setImageWithURL:[NSURL URLWithString:pvo.logo]];
            }
        }

        // 添加标签
        if ([pvo.source_platform isEqualToString:@"lamahui"]) {
            ttIV.image = nil;
            for (UIView *uview in pview.subviews) {
                if (uview.tag >= 10000 && uview.tag < 100000) {
                    [uview removeFromSuperview];
                }
            }
            if (pvo.product_tags.count > 0) {
                for (int j = 0; j < pvo.product_tags.count; j ++) {
                    NSString *imgStr = pvo.product_tags[j];
                    UIImageView *labelImage = (UIImageView *)[pview viewWithTag:1000+j];
                    if (!labelImage) {
                        labelImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(pview.frame) / 5 * j, 0, CGRectGetWidth(pview.frame) / 5, CGRectGetWidth(pview.frame) / 5 / 25 * 23)];
                        labelImage.tag = 10000+j;
                        
                        [pview addSubview:labelImage];
                    }
                    [labelImage sd_setImageWithURL:[NSURL URLWithString:imgStr]];
                }
            }
        } else {
            ttIV.image = nil;
            if ([pvo.is_boutique integerValue] >= 2000) {
                ttIV.frame = CGRectMake(0, 0, CGRectGetWidth(pview.frame) / 5, CGRectGetWidth(pview.frame) / 5 / 25 * 23);
                ttIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_cxJX_2"]];
            } else if ([pvo.is_buy_change integerValue] == 1) {
                ttIV.frame = CGRectMake(0, 0, CGRectGetWidth(pview.frame) / 5, CGRectGetWidth(pview.frame) / 5 / 25 * 23);
                ttIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_cxPXGJ"]];
            } else if ([pvo.free_postage integerValue] == 1) {
                ttIV.frame = CGRectMake(0, 0, CGRectGetWidth(pview.frame) / 5, CGRectGetWidth(pview.frame) / 5 / 25 * 23);
                ttIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_cxBY"]];
            }
        }
        
    }
}

- (void)productTaped:(id)sender
{
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *tapGR = (UITapGestureRecognizer *)sender;
        for (NSInteger i = 0; i < viewArray.count; i++) {
            if (viewArray[i] == tapGR.view) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(tapAtItem:)]) {
                    [self.delegate tapAtItem:_cellData[i]];
                }
            }
        }
    }
}

@end

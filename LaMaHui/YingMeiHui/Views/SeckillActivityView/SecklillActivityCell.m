//
//  SecklillActivityCell.m
//  YingMeiHui
//
//  Created by KevinKong on 14-8-27.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "SecklillActivityCell.h"
#import <CoreText/CoreText.h>
#import "EGOImageView.h"
@interface SecklillActivityCellItemModel()
{
    SeckillActivityProductModel *productModel;
}
@end
@implementation SecklillActivityCellItemModel

// 得到Head 时间的名字.
-(NSString *)getHeadTimerImageName{
    if (productModel) {
        NSNumber *timerInterval = productModel.begin_at;
        if (timerInterval) {
            NSString *hhmmStr = [self getCurrentTimerHHMM:timerInterval];
            if (hhmmStr.length>2) {
                NSString *hhstr =[hhmmStr substringToIndex:2];
                NSInteger hh  = [hhstr intValue];
                if (hh>12) {
                    hh -=12;
                }
                return [NSString stringWithFormat:@"Btime%zi.png",hh];
            }
        }
        
    }
    return @"Btime1.png";
}
// 得到Head 时间的 小时
-(NSString *)getHeadTimerStrHH{
    if (productModel) {
        NSNumber *timerInterval = productModel.begin_at;
        if (timerInterval) {
            NSString *hhmmStr = [self getCurrentTimerHHMM:timerInterval];
            if (hhmmStr.length>2) {
                NSString *hhstr =[hhmmStr substringToIndex:2];
                return hhstr;
            }
        }
        
    }
    return @"10";
}
// 得到Head 时间的 分钟
-(NSString *)getHeadTimerStrMM{
    if (productModel) {
        NSNumber *timerInterval = productModel.begin_at;
        if (timerInterval) {
            NSString *hhmmStr = [self getCurrentTimerHHMM:timerInterval];
            if (hhmmStr.length>2) {
                NSString *mmstr =[hhmmStr substringWithRange:NSMakeRange(hhmmStr.length-2, 2)];
                return mmstr;
            }
        }
    }
    return @"20";
}
// 得到 商品 的 URL
-(NSString *)getCommodityImageURL{
    if (productModel) {
        return productModel.product_image;
    }
    return nil;
}
// 得到 商品 的 title
-(NSString *)getCommodityTitle{
    if (productModel) {
        return productModel.product_name;
    }
    return @"";
}
// 得到 商品 的 原始价格.
-(NSString *)getCommodityOriginalPrice{
    if (productModel) {
        NSString *product_price;
        CGFloat productPrice = [productModel.product_price floatValue];
        if ((productPrice * 10) - (int)(productPrice * 10) > 0) {
            product_price = [NSString stringWithFormat:@"¥%0.2f",[productModel.product_price floatValue]];
        } else if(productPrice - (int)productPrice > 0) {
            product_price = [NSString stringWithFormat:@"¥%0.1f",[productModel.product_price floatValue]];
        } else {
            product_price = [NSString stringWithFormat:@"¥%0.0f",[productModel.product_price floatValue]];
        }

        return [NSString stringWithFormat:@"¥ %@",product_price];
    }
    return @"¥ 00.00";
}
// 得到 商品 的 旧价格
-(NSString *)getCommodityNewPrice{
    return @"1";
    return nil;
}
// 得到 商品 的 状态. //  立即抢购,即将开奖，已抢光.
-(NSString *)getCommodityStateStr{
    if (productModel) { // 1已开始 | 2已结束 | 3未开始 | 4已售完
        NSInteger state = [[productModel status] intValue];
        switch (state) {
            case 1:
               return  @"立即抢购";
                break;
            case 2:
                return  @"抢光了";
                break;
            case 3:
                return  @"即将开始";
                break;
            case 4:
                return  @"已售完";
                break;
                
            default:
                break;
        }
    }
    return nil;    
}

-(UIColor *)getCommodityStateStrColor{
    if (productModel) { // 1已开始 | 2已结束 | 3未开始 | 4已售完
        NSInteger state = [[productModel status] intValue];
        switch (state) {
            case 1:
                return UIColorRGBA(254, 239, 51, 1);
                break;
            case 2:
                return [UIColor whiteColor];
                break;
            case 3:
                return UIColorRGBA(254, 239, 51, 1);
                break;
            case 4:
                return [UIColor whiteColor];                
                break;
                
            default:
                break;
        }
        
    }
    
    return [UIColor whiteColor];
}

// 得到 商品 状态 背景图片.
-(NSString *)getCommodityStateImage{
    if (productModel) { // 1已开始 | 2已结束 | 3未开始 | 4已售完
        NSInteger state = [[productModel status] intValue];
        switch (state) {
            case 1:
                return @"红色but.png";
                break;
            case 2:
                return @"灰色but.png";
                break;
            case 3:
                return @"绿色but.png";
                break;
            case 4:
                return @"灰色but.png";
                break;
                
            default:
                break;
        }
        
    }
    return @"红色but.png";

}

+(CGFloat)getCellHeight{
    return 330;
}


-(void)setSeckllActivityProductModel:(SeckillActivityProductModel *)__productModel{
    productModel = __productModel;
}
#pragma mark - 
#pragma mark helper method
#pragma mark -
#pragma mark helper method
-(NSString *)getCurrentTimerHHMM:(NSNumber *)timerInterval{
    NSDate *date =[[NSDate date] initWithTimeIntervalSince1970:[timerInterval doubleValue]];
    NSDateFormatter *datefromter = [[NSDateFormatter alloc] init];
    [datefromter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *str = [datefromter stringForObjectValue:date];
    if (str.length>5) {
        return [str substringWithRange:NSMakeRange(str.length-5, 5)];
    }
    return str;
}
@end

/*====================================================================================*/
/*====================================================================================*/

@interface SecklillActivityCellHeadContentV()
{
    UIImageView *bgImageV;
    UIImageView *timerImageV;
    UILabel *timerHHLabel;
    UILabel *timerMMLabel;
    UILabel *timerIdentfierlabel;
}
@end

@implementation SecklillActivityCellHeadContentV
-(id)init{
    if (self=[super init]) {
        [self initParms];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (bgImageV) bgImageV.frame = [self bgImageVFrame];
    if(timerImageV) timerImageV.frame = [self timerImageVFrame];
    if(timerHHLabel) timerHHLabel.frame = [self timerHHLabelFrame];
    if(timerMMLabel) timerMMLabel.frame = [self timerMMLabelFrame];
    if(timerIdentfierlabel) timerIdentfierlabel.frame = [self timerIdentfierlabelFrame];
}

-(void)initParms{
    if (bgImageV ==nil) {
        bgImageV = [[UIImageView alloc] init];
        bgImageV.image = [UIImage imageNamed:@"时间背景框.png"];
        bgImageV.backgroundColor = [UIColor clearColor];
        [self addSubview:bgImageV];
    }
    
    if (timerImageV == nil) {
        timerImageV = [[UIImageView alloc] init];
        timerImageV.backgroundColor = [UIColor clearColor];
        [self addSubview:timerImageV];
    }
    
    if (timerHHLabel == nil) {
        timerHHLabel =[[UILabel alloc] init];
        timerHHLabel.backgroundColor = [UIColor colorWithRed:248/255.0
                                                       green:208/255.0
                                                        blue:15/255.0
                                                       alpha:1];
        timerHHLabel.textColor = [UIColor colorWithRed:146/255.0
                                                 green:0
                                                  blue:134/255.0
                                                 alpha:1];
        timerHHLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:timerHHLabel];
    }
    
    if (timerMMLabel == nil) {
        timerMMLabel = [[UILabel alloc] init];
        timerMMLabel.backgroundColor = [UIColor colorWithRed:248/255.0
                                                       green:208/255.0
                                                        blue:15/255.0
                                                       alpha:1];
        timerMMLabel.textColor = [UIColor colorWithRed:146/255.0
                                                 green:0
                                                  blue:134/255.0
                                                 alpha:1];
        timerMMLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:timerMMLabel];
    }
    if (timerIdentfierlabel==nil) {
        timerIdentfierlabel = [[UILabel alloc] init];
        timerIdentfierlabel.textColor = [UIColor colorWithRed:248/255.0
                                                              green:208/255.0
                                                               blue:15/255.0
                                                              alpha:1];
        timerIdentfierlabel.text=@":";
        timerIdentfierlabel.textAlignment = NSTextAlignmentCenter;
        timerIdentfierlabel.font = [UIFont boldSystemFontOfSize:15];
        timerIdentfierlabel.backgroundColor = [UIColor clearColor];
        [self addSubview:timerIdentfierlabel];
    }
}
#pragma mark -
#pragma mark public methods
-(void)setHeadImageVName:(NSString *)imageVName{
    if (timerImageV && imageVName) {
        timerImageV.image = [UIImage imageNamed:imageVName];
    }
}
-(void)setHeadHHStr:(NSString *)str{
    if (timerHHLabel) {
        timerHHLabel.text = str;
    }
}
-(void)setHeadMMStr:(NSString *)str{
    if (timerMMLabel) {
        timerMMLabel.text = str;
    }
}
#pragma mark -
#pragma mark layout frames
-(CGRect)getSelfFrame{
    CGRect selfFrame = self.frame;
    selfFrame.origin.x  = selfFrame.origin.y =0;
    return selfFrame;
}

-(CGRect)bgImageVFrame{
    CGFloat w = 108;
    CGFloat h = 27;
    CGFloat x = (ScreenW - w)/2.0;
    CGFloat y = CGRectGetMaxY([self getSelfFrame])-h;
    return CGRectMake(x, y, w, h);
}
-(CGRect)timerImageVFrame{
    CGFloat w = 18;
    CGFloat h = 18;
    CGFloat x = CGRectGetMinX([self bgImageVFrame])+10;
    CGFloat y = CGRectGetMaxY([self getSelfFrame])-h-1    ;
    return CGRectMake(x, y, w, h);
}
-(CGRect)timerHHLabelFrame{
    CGFloat w = 24;
    CGFloat h = 18;//CGRectGetHeight([self timerImageVFrame]);
    CGFloat x = CGRectGetMaxX([self timerImageVFrame])+6;
    CGFloat y = CGRectGetMinY([self timerImageVFrame]);
    return CGRectMake(x, y, w, h);
}

-(CGRect)timerIdentfierlabelFrame{
    CGRect timerHHLabelFrame = [self timerHHLabelFrame];
    CGFloat x = CGRectGetMaxX(timerHHLabelFrame);
    CGFloat y = CGRectGetMinY(timerHHLabelFrame);
    CGFloat w = 10;
    CGFloat h = CGRectGetHeight(timerHHLabelFrame);
    return CGRectMake(x, y, w, h);
}

-(CGRect)timerMMLabelFrame{
    CGRect identfierFrame = [self timerIdentfierlabelFrame];
    CGRect timerHHFrame = [self timerHHLabelFrame];
    CGFloat x = CGRectGetMaxX(identfierFrame);
    CGFloat y = CGRectGetMinY(timerHHFrame);
    CGFloat w = CGRectGetWidth(timerHHFrame);
    CGFloat h = CGRectGetHeight(timerHHFrame);
    return CGRectMake(x, y, w, h);
}
@end

@interface SecklillActivityCellBodyContentV()
{

    UIImageView *bgImageV;
    UIView *commodityContentV;
    EGOImageView *commodityImageV;
    UILabel *commodityTitle;
    
    UIImageView  *commodityPriceImageV;
    UIButton  *commodityStateBtn;
    
    UILabel *commodityOriginalPriceLabl;
    UILabel *commodityNewPriceLabl;
    UILabel *commodityOriginalPriceLineLabl;
    
}
@end

@implementation SecklillActivityCellBodyContentV
@synthesize delegate;
-(id)init{
    if (self=[super init]) {
        [self initParms];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if(bgImageV) bgImageV.frame = [self bgImageVFrame];
    if(commodityContentV) commodityContentV.frame = [self commodityContentVFrame];
    if(commodityImageV) commodityImageV.frame = [self commodityImageVFrame];
    if(commodityTitle) commodityTitle.frame = [self commodityTitleFrame];
    if(commodityPriceImageV) commodityPriceImageV.frame = [self commodityPriceImageVFrame];
    if(commodityStateBtn) commodityStateBtn.frame = [self commodityStateBtnFrame];
    if(commodityOriginalPriceLabl) commodityOriginalPriceLabl.frame = [self commodityOriginalPriceLablFrame];
    if(commodityNewPriceLabl) commodityNewPriceLabl.frame = [self commodityNewPriceLablFrame];
    if(commodityOriginalPriceLineLabl) commodityOriginalPriceLineLabl.frame =[self commodityOriginalPriceLineLablFrame];
}
-(void)initParms{

    if (!bgImageV) {
        bgImageV = [[UIImageView alloc] init];
        bgImageV.image = [UIImage imageNamed:@"背景框.png"];
        bgImageV.backgroundColor = [UIColor clearColor];
        [self addSubview:bgImageV];
    }
    if (!commodityContentV) {
        commodityContentV = [[UIView alloc] init];
        commodityContentV.backgroundColor = [UIColor whiteColor];
        [self addSubview:commodityContentV];
    }
    if (!commodityImageV) {
        commodityImageV = [[EGOImageView alloc] init];
        commodityImageV.backgroundColor = [UIColor clearColor];
        [self addSubview:commodityImageV];
    }
    if (!commodityTitle) {
        commodityTitle = [[UILabel alloc] init];
        commodityTitle.textColor = [UIColor colorWithRed:102/255.0
                                                   green:102/255.0
                                                    blue:102/255.0
                                                   alpha:1];
        commodityTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:commodityTitle];
    }
    
    if (!commodityPriceImageV) {
        commodityPriceImageV = [[UIImageView alloc] init];
        commodityPriceImageV.image = [UIImage imageNamed:@"黄色but.png"];
        commodityPriceImageV.backgroundColor = [UIColor clearColor];
        [self addSubview:commodityPriceImageV];
        
    }
    if (!commodityStateBtn) {
        commodityStateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [commodityStateBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:30]];
        [commodityStateBtn setBackgroundImage:[UIImage imageNamed:@"红色but.png"] forState:UIControlStateNormal];
        [commodityStateBtn addTarget:self action:@selector(commodityStateAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:commodityStateBtn];
    }
    
    if (!commodityNewPriceLabl) {
        commodityNewPriceLabl = [[UILabel alloc] init];
        commodityNewPriceLabl.backgroundColor = [UIColor clearColor];
        commodityNewPriceLabl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:commodityNewPriceLabl];
    }
    
    if (!commodityOriginalPriceLabl) {
        commodityOriginalPriceLabl = [[UILabel alloc] init];
        commodityOriginalPriceLabl.backgroundColor = [UIColor clearColor];
        commodityOriginalPriceLabl.textColor = UIColorRGBA(92, 92, 92, 1);
        commodityOriginalPriceLabl.textAlignment = NSTextAlignmentLeft;
//        [commodityOriginalPriceLabl setContentMode:UIViewContentModeBottomRight];
//        commodityOriginalPriceLabl.contentMode = UIViewContentModeBottom;
        commodityOriginalPriceLabl.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:commodityOriginalPriceLabl];
    }
    
    if (!commodityOriginalPriceLineLabl) {
        commodityOriginalPriceLineLabl = [[UILabel alloc] init];
        commodityOriginalPriceLineLabl.backgroundColor = UIColorRGBA(92, 92, 92, 1);
        [self addSubview:commodityOriginalPriceLineLabl];
    }
}

#pragma mark - 
#pragma mark refresh value methods
-(void)setCommodityIMageURLStr:(NSString *)str{
    //
    if (commodityImageV) {
//        LMHLog(@" imageurlstr = %@",str);
        [commodityImageV setImageURL:[NSURL URLWithString:str]];
    }
}
-(void)setCommodityOriginalPrice:(NSString *)str{
    if (commodityOriginalPriceLabl) {
        commodityOriginalPriceLabl.text = str;
        /*
        [commodityOriginalPriceLabl setBackgroundColor:[UIColor clearColor]];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        
        [attStr addAttribute:(NSString *)NSForegroundColorAttributeName
                       value:(id)UIColorRGBA(87,88,87,1).CGColor
                       range:NSMakeRange(0, attStr.length)];
        
        [attStr addAttribute:(NSString *)NSFontAttributeName
                       value:(id)[UIFont boldSystemFontOfSize:15.0]
                       range:NSMakeRange(0, str.length)];
        
        
        [commodityOriginalPriceLabl setAttributedText:attStr];
         */
        
    }
}
-(void)setCommodityImageState:(NSString *)stateStr{
    if (commodityStateBtn) {
        [commodityStateBtn setTitle:stateStr forState:UIControlStateNormal];
    }
}
-(void)setCommodityNewPrice:(NSString *)newPrice{
    if (commodityNewPriceLabl) {
        NSString *str = [NSString stringWithFormat:@"¥%@",newPrice];
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        

        [attStr setAttributes:@{NSForegroundColorAttributeName : UIColorRGBA(245,0,69,1),	NSFontAttributeName : [UIFont boldSystemFontOfSize:15.0]} range:NSMakeRange(0, 1)];

        [attStr setAttributes:@{NSForegroundColorAttributeName : UIColorRGBA(245,0,69,1),	NSFontAttributeName : [UIFont boldSystemFontOfSize:38.0]} range:NSMakeRange(1, 1)];
        
        
        
        [commodityNewPriceLabl setAttributedText:attStr];
    }
}

-(void)setCommodityTitle:(NSString *)titleStr{
    if (commodityTitle) {
        commodityTitle.text = titleStr;
    }
}
-(void)setCommoditySateStrColor:(UIColor *)textColor{
    if (commodityStateBtn) {
        [commodityStateBtn setTitleColor:textColor forState:UIControlStateNormal];
    }
}

-(void)setCommodityStateBgImageStr:(NSString *)imageStr{
    if (commodityStateBtn && imageStr) {
        [commodityStateBtn setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    }
}
#pragma mark -
#pragma mark layout methods

-(CGRect)selfFrame{
    CGRect selfFrame = self.frame;
    selfFrame.origin.x = selfFrame.origin.y = 0;
    return selfFrame;
}

//UIImageView *bgImageV;
-(CGRect)bgImageVFrame{
    CGFloat w = 282.5;
    CGFloat h = 291;
    CGFloat x = (CGRectGetWidth([self selfFrame])-w)/2;
    CGFloat y = 0;
    return CGRectMake(x, y, w, h);
}
//UIView *commodityContentV;
-(CGRect)commodityContentVFrame{
    CGRect bgImageVFrame = [self bgImageVFrame];
    CGFloat spaceX = 10;
    CGFloat spacey =10;
    CGFloat x = CGRectGetMinX(bgImageVFrame)+spaceX;
    CGFloat y = spacey;
    CGFloat w = CGRectGetWidth(bgImageVFrame)-spaceX*2;
    CGFloat h = CGRectGetHeight(bgImageVFrame)-spacey*2;
    return CGRectMake(x, y, w, h);
}
//UIImageView *commodityImageV;
-(CGRect)commodityImageVFrame{
    CGRect bgImageFrame = [self commodityContentVFrame];
    CGRect titleFrame = [self commodityTitleFrame];
    CGFloat x_space=5;
    CGFloat y_space=5;
    CGFloat x = CGRectGetMinX(bgImageFrame)+x_space;
    CGFloat y = CGRectGetMinY(bgImageFrame)+y_space;
    CGFloat w = CGRectGetWidth(bgImageFrame)-x_space*2;
    CGFloat h = CGRectGetMinY(titleFrame)-y_space*2;
    return CGRectMake(x, y, w, h);
}

//UIImageView  *commodityPriceImageV;
-(CGRect)commodityPriceImageVFrame{
    CGFloat w = 96;
    CGFloat x = CGRectGetMinX([self commodityContentVFrame])+(CGRectGetWidth([self commodityContentVFrame])-w-141)/2.0;
    CGFloat h = 41.5;
    CGFloat y = CGRectGetMaxY([self commodityContentVFrame])-h-10;
    return CGRectMake(x, y, w, h);
}
//UIButton  *commodityStateBtn;
-(CGRect)commodityStateBtnFrame{
    CGRect productPriceImageVframe = [self commodityPriceImageVFrame];
    CGFloat x = CGRectGetMaxX(productPriceImageVframe);
    CGFloat y = CGRectGetMinY(productPriceImageVframe);
    CGFloat w = 141.5;
    CGFloat h = CGRectGetHeight(productPriceImageVframe);
    return CGRectMake(x, y, w, h);
}

//UILabel *commodityTitle;
-(CGRect)commodityTitleFrame{
    CGFloat x = CGRectGetMinX([self commodityContentVFrame]);
    CGFloat h = 30;
    CGFloat y = CGRectGetMinY([self commodityStateBtnFrame])-h;
    CGFloat w = CGRectGetWidth([self commodityContentVFrame]);
    return CGRectMake(x, y, w, h);
}

-(CGRect)commodityNewPriceLablFrame{
    CGRect commodityPriceImageVFrame = [self commodityPriceImageVFrame];
    CGFloat h = CGRectGetHeight(commodityPriceImageVFrame)-5;
    CGFloat w = 38;
    CGFloat x = CGRectGetMinX(commodityPriceImageVFrame);
    CGFloat y = CGRectGetMaxY(commodityPriceImageVFrame)-h-5;
    return CGRectMake(x, y, w, h);
}

-(CGRect)commodityOriginalPriceLablFrame{
    CGRect newPriceFrame = [self commodityNewPriceLablFrame];
    CGRect commodityPriceImageVFrame = [self commodityPriceImageVFrame];
    CGFloat w = CGRectGetWidth(commodityPriceImageVFrame)-CGRectGetWidth(newPriceFrame);
    CGFloat h = 20;
    CGFloat x = CGRectGetMaxX(newPriceFrame)-2;
    CGFloat y = CGRectGetMaxY(newPriceFrame)-h;
    return CGRectMake(x, y, w, h);
}

-(CGRect)commodityOriginalPriceLineLablFrame{
    CGRect priceFrame = [self commodityOriginalPriceLablFrame];
    CGFloat h = 1;
    priceFrame.origin.y = CGRectGetMinY(priceFrame)+(CGRectGetHeight(priceFrame))/2.0;
    priceFrame.size.height = h;
    return priceFrame;
}
#pragma mark -
#pragma mark Action Methods
-(void)commodityStateAction:(id)sender{
    //
    if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(SecklillActivityCellBodyContentVSeckillBtnAction:)]) {
        [self.delegate SecklillActivityCellBodyContentVSeckillBtnAction:self];
    }

}

@end
/*====================================================================================*/
/*====================================================================================*/
#pragma mark - 
#pragma mark  --

@interface SecklillActivityCell()
{
    UIView *customV;
    SecklillActivityCellHeadContentV *headContentV;
    SecklillActivityCellBodyContentV *bodyContentV;

    
    // view model
    SecklillActivityCellItemModel *cellItemModel;
    
    
}
@end
@implementation SecklillActivityCell
@synthesize inexPath;
@synthesize cellDelegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView removeFromSuperview];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initParams];
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

-(void)initParams{
//    UIView *customV;
//    SecklillActivityCellHeadContentV *headContentV;
//    SecklillActivityCellBodyContentV *bodyContentV;
    if (customV==nil) {
        customV = [[UIView alloc] init];
        customV.backgroundColor = [UIColor clearColor];
        [self addSubview:customV];
    }
    
    if (headContentV==nil) {
        headContentV = [[SecklillActivityCellHeadContentV alloc] init];
        headContentV.backgroundColor = [UIColor clearColor];
        [self addSubview:headContentV];
    }
    
    if(!bodyContentV){
        bodyContentV = [[SecklillActivityCellBodyContentV alloc] init];
        bodyContentV.backgroundColor = [UIColor clearColor];
        bodyContentV.delegate =self;
        [self addSubview:bodyContentV];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if(customV) customV.frame = [self customvFrame];
    if(headContentV) headContentV.frame = [self headContentVFrame];
    if(bodyContentV) bodyContentV.frame = [self bodyContentVFrame];
}

-(void)reloadCellWithCellItemModel:(SecklillActivityCellItemModel *)__cellModel{
    if (cellItemModel!=__cellModel) {
        cellItemModel = __cellModel;
        [self layoutSubviews]; // layout subviews.. ...
        [headContentV setHeadImageVName:[cellItemModel getHeadTimerImageName]];
        [headContentV setHeadHHStr:[cellItemModel getHeadTimerStrHH]];
        [headContentV setHeadMMStr:[cellItemModel getHeadTimerStrMM]];
        
        [bodyContentV setCommodityImageState:[cellItemModel getCommodityStateStr]];
        [bodyContentV setCommodityNewPrice:[cellItemModel getCommodityNewPrice]];
        [bodyContentV setCommodityOriginalPrice:[cellItemModel getCommodityOriginalPrice]];
        [bodyContentV setCommoditySateStrColor:[cellItemModel getCommodityStateStrColor]];
        [bodyContentV setCommodityTitle:[cellItemModel getCommodityTitle]];
        [bodyContentV setCommodityStateBgImageStr:[cellItemModel getCommodityStateImage]];
        [bodyContentV setCommodityIMageURLStr:[cellItemModel getCommodityImageURL]];
        
    }
}

-(CGRect)customvFrame{
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = ScreenW;
    CGFloat h = [SecklillActivityCellItemModel getCellHeight];
    return CGRectMake(x, y, w, h);
}

-(CGRect )headContentVFrame{
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = ScreenW;
    CGFloat h = 30;
    return CGRectMake(x, y, w, h);
}

-(CGRect )bodyContentVFrame{
    CGFloat x = 0;
    CGFloat y = CGRectGetHeight([self headContentVFrame]);
    CGFloat w = ScreenW;
    CGFloat h = [SecklillActivityCellItemModel getCellHeight]- CGRectGetHeight([self headContentVFrame]);
    return CGRectMake(x, y, w, h);
}
#pragma mark -
#pragma mark SecklillActivityCellBodyContentVDelegate method
-(void)SecklillActivityCellBodyContentVSeckillBtnAction:(SecklillActivityCellBodyContentV *)contentV{
    if (self.cellDelegate!=nil && [self.cellDelegate respondsToSelector:@selector(SecklillActivityCell:didSelectedIndex:)]) {
        [self.cellDelegate SecklillActivityCell:self didSelectedIndex:self.inexPath];
    }
}
@end

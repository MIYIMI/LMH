//
//  SeckillActivityHeadV.m
//  YingMeiHui
//
//  Created by KevinKong on 14-8-28.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "SeckillActivityHeadV.h"

@interface SeckillActivityHeadVDataModel()
{
    NSArray *orignalDataArray;
}
@end

@implementation SeckillActivityHeadVDataModel

// 得到时间段个数.
-(NSInteger)getTimerNumCtn{
    if (orignalDataArray) {
        return orignalDataArray.count;
    }
    return 2;
}
// 得到时间 str.
-(NSString *)getTimerStrWithIndex:(NSInteger )index{
    if (orignalDataArray) {
        if (index<orignalDataArray.count) {
            NSNumber *timerInterval = [orignalDataArray objectAtIndex:index];
            if (timerInterval) {
                return [self getCurrentTimerHHMM:timerInterval];
            }

        }
    }
    return @"10:00";
}
// 得到时间的 图片 name;
-(NSString *)getTimerImageNameWithIndex:(NSInteger)index{
    if (orignalDataArray) {
        NSNumber *timerInterval = [orignalDataArray objectAtIndex:index];
        if (timerInterval) {
            NSString *hhmmStr = [self getCurrentTimerHHMM:timerInterval];
            if (hhmmStr.length>2) {
                NSString *hhstr =[hhmmStr substringToIndex:2];
                NSInteger hh  = [hhstr intValue];
                if (hh>12) {
                    hh -=12;
                }
                return [NSString stringWithFormat:@"Atime%zi.png",hh];
            }
        }
        
    }
    return @"Atime1.png";
}

-(void)setOrignalData:(NSArray *)timerArray{
    orignalDataArray = [NSArray arrayWithArray:timerArray];
}

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


@interface SeckillActivityHeadV()
{
    UIImageView *logoImageV;
    UIButton *todySeckillBtn;
    UIButton *tomorrowSeckillBtn;
    UIImageView *timerLineImageV;
    
    UIView *timerContentV;
    NSArray *timerBtnArray;
    NSArray *timerLableArray;
    
    SeckillActivityHeadVDataModel *currentDataModel;
}
@end

@implementation SeckillActivityHeadV
@synthesize delegate;

-(id)init{
    if (self = [super init]) {
        [self initParams];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - 
#pragma mark custom methods
-(void)initParams{
//    UIImageView *logoImageV;
    if (!logoImageV) {
        logoImageV =[[UIImageView alloc] init];
        logoImageV.image = [UIImage imageNamed:@"1元秒杀顶部.png"];
        logoImageV.backgroundColor = [UIColor clearColor];
        [self addSubview:logoImageV];
    }
    
    if (!timerContentV) {
        timerContentV = [[UIView alloc] init];
        timerContentV.backgroundColor = [UIColor clearColor];
        [self addSubview:timerContentV];
    }
    
//    UIButton *todySeckillBtn;
    if (!todySeckillBtn) {
        todySeckillBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        todySeckillBtn.backgroundColor = [UIColor clearColor];
        [todySeckillBtn setBackgroundImage:[UIImage imageNamed:@"今日秒杀(未选择).png"] forState:UIControlStateNormal];
        [todySeckillBtn setBackgroundImage:[UIImage imageNamed:@"今日秒杀(选中).png"] forState:UIControlStateSelected];
        [todySeckillBtn setBackgroundImage:[UIImage imageNamed:@"今日秒杀(选中).png"] forState:UIControlStateHighlighted];
        [todySeckillBtn addTarget:self action:@selector(SeckillTodayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:todySeckillBtn];
        todySeckillBtn.selected = YES;
    }
    
//    UIButton *tomorrowSeckillBtn;
    if (!tomorrowSeckillBtn) {
        tomorrowSeckillBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tomorrowSeckillBtn.backgroundColor = [UIColor clearColor];
        [tomorrowSeckillBtn setBackgroundImage:[UIImage imageNamed:@"明日预告未选择.png"] forState:UIControlStateNormal];
        [tomorrowSeckillBtn setBackgroundImage:[UIImage imageNamed:@"明日预告选中.png"] forState:UIControlStateSelected];
        [tomorrowSeckillBtn setBackgroundImage:[UIImage imageNamed:@"明日预告选中.png"] forState:UIControlStateHighlighted];
        [tomorrowSeckillBtn addTarget:self action:@selector(SeckillTomorrowBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tomorrowSeckillBtn];
    }
    
    if (!timerLineImageV) {
        timerLineImageV = [[UIImageView alloc] init];
        timerLineImageV.backgroundColor = [UIColor clearColor];
        timerLineImageV.image = [UIImage imageNamed:@"分割线.png"];
        [timerContentV addSubview:timerLineImageV];
    }
    
//    NSArray *timerBtnArray;
    if (!timerBtnArray) {
        timerBtnArray = [NSMutableArray array];
    }
    
//    NSArray *timerLableArray;
    if (!timerLableArray) {
        timerLableArray =[NSMutableArray array];
    }
}


-(void)reloadDataModel:(SeckillActivityHeadVDataModel *)dataModel{
    if (dataModel!=nil) {
        currentDataModel = dataModel;

        [self reloadDataSubViews];


    }
}

-(void)selectedCategoryWithIndex:(NSInteger)index{
    if (index==0)
        [self SeckillTodayBtnAction:nil];
    else
        [self SeckillTomorrowBtnAction:nil];
}

-(void)reloadDataSubViews{
    if (currentDataModel==nil) return;
    NSInteger maxCount = MAX([timerContentV subviews].count, [currentDataModel getTimerNumCtn]);
    for (NSInteger i = 0; i<maxCount; i++) {
        // timer btn .
        NSInteger  timerBtnTag = 1000+i;
        UIButton *timerBtn = (UIButton *)[timerContentV viewWithTag:timerBtnTag];
        if (i<[currentDataModel getTimerNumCtn]) {
            if (!timerBtn) {
                timerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [timerBtn addTarget:self action:@selector(seckillTimerSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
                timerBtn.tag = timerBtnTag;
                [timerContentV addSubview:timerBtn];
            }
            timerBtn.frame = [self timerBtnFrameWithIndex:i];
            NSString *imageName = [currentDataModel getTimerImageNameWithIndex:i];
            [timerBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            [timerBtn setNeedsDisplay];
            
        }else{
            if (timerBtn) {
                [timerBtn removeFromSuperview];
            }
        }
        
        // timer lable;
        
        NSInteger timerLablTag = 100+i;
        UILabel *timerLabl = (UILabel *)[timerContentV viewWithTag:timerLablTag];
        if (i<[currentDataModel getTimerNumCtn]) {
            if (!timerLabl) {
                timerLabl = [[UILabel alloc] init];
                timerLabl.textAlignment=NSTextAlignmentCenter;
                timerLabl.backgroundColor = [UIColor clearColor];
                timerLabl.textColor = [UIColor colorWithRed:253/255.0 green:223/255.0 blue:8/255.0 alpha:1];
                timerLabl.font = [UIFont systemFontOfSize:13];
                timerLabl.tag = timerLablTag;
                [timerContentV addSubview:timerLabl];
            }
            timerLabl.frame = [self timerLableArrayWithIndex:i];
            NSString *str = [currentDataModel getTimerStrWithIndex:i];
            timerLabl.text = str;
            [timerLabl setNeedsDisplay];
        }else{
            if (timerLabl) {
                [timerLabl removeFromSuperview];
            }
        }

//        LMHLog(@" timerLabel.frame ＝%@",NSStringFromCGRect(timerLabl.frame));
        
    }
}
#pragma mark -
#pragma mark Action Method
-(void)SeckillTodayBtnAction:(id)sender{
    if (!todySeckillBtn.selected) {
        todySeckillBtn.selected=YES;
        [self responseDeleagteWtihCategoryIndex:0];
    }
    tomorrowSeckillBtn.selected = NO;
    

}

-(void)seckillTimerSelectedAction:(id)sender{
    UIButton *tempButtn = (UIButton *)sender;
    NSInteger tagindex = tempButtn.tag -1000;
    if (self.delegate !=nil && [self.delegate respondsToSelector:@selector(SeckillActivityHeadv:timerBtnDidSelectedIndex:)]) {
        [self.delegate SeckillActivityHeadv:self timerBtnDidSelectedIndex:tagindex];
    }

}

-(void)SeckillTomorrowBtnAction:(id)sender{
    if (!tomorrowSeckillBtn.selected) {
        tomorrowSeckillBtn.selected = YES;
        [self responseDeleagteWtihCategoryIndex:1];
    }
    todySeckillBtn.selected = NO;
}

-(void)responseDeleagteWtihCategoryIndex:(NSInteger)index{
    if (index<0) return;
    if (self.delegate!=nil &&[self.delegate respondsToSelector:@selector(SeckillActivityHeadV:categroyDidSelectedIndex:)]) {
        [self.delegate SeckillActivityHeadV:self
                   categroyDidSelectedIndex:index];
    }
}
#pragma mark -
#pragma mark layout methods
//-(void)setFrame:(CGRect)frame{
//        [super setFrame:frame];
//    if (!CGRectIsEmpty(frame)) {
//        if(logoImageV) logoImageV.frame = [self logoImageVFrame];
//        if(todySeckillBtn) todySeckillBtn.frame = [self todySeckillBtnFrame];
//        if(tomorrowSeckillBtn) tomorrowSeckillBtn.frame = [self tommorrowSeckillBtn];
//        if (timerContentV) timerContentV.frame =[self timerContentVFrame];
//        LMHLog(@" --- timerContentV.frame = %@",timerContentV);
//        if(timerLineImageV) timerLineImageV.frame = [self timerLineImageVFrame];
//        if (currentDataModel==nil) return;
//
//    }
//}
-(void)layoutSubviews{
    [super layoutSubviews];
    if(logoImageV) logoImageV.frame = [self logoImageVFrame];
    if(todySeckillBtn) todySeckillBtn.frame = [self todySeckillBtnFrame];
    if(tomorrowSeckillBtn) tomorrowSeckillBtn.frame = [self tommorrowSeckillBtn];
    if (timerContentV) timerContentV.frame =[self timerContentVFrame];
    if(timerLineImageV) timerLineImageV.frame = [self timerLineImageVFrame];
    if (currentDataModel==nil) return;
}

-(CGRect)selfFame{
    CGRect selfFrame = self.frame;
    selfFrame.origin.x = selfFrame.origin.y = 0;
    return selfFrame;
}
-(CGRect)timerContentVFrame{
    return [self selfFame];
}
-(CGRect)logoImageVFrame{
    CGFloat w = 256;
    CGFloat h = 89;
    CGFloat x = (CGRectGetWidth([self selfFame])-w)/2.0;
    CGFloat y = 10;
    return CGRectMake(x, y, w, h);
}

-(CGRect)todySeckillBtnFrame{
    CGFloat w = 141.5;
    CGFloat h = 35.5;
    CGFloat x = (CGRectGetWidth([self selfFame])-w*2)/2.0;
    CGFloat y = CGRectGetMaxY([self logoImageVFrame])+10;
    return CGRectMake(x, y, w, h);
}

-(CGRect)tommorrowSeckillBtn{
    CGFloat w = CGRectGetWidth([self todySeckillBtnFrame]);
    CGFloat h = CGRectGetHeight([self todySeckillBtnFrame]);
    CGFloat x = CGRectGetMaxX([self todySeckillBtnFrame]);
    CGFloat y = CGRectGetMinY([self todySeckillBtnFrame]);
    return CGRectMake(x, y, w, h);
}
-(CGRect)timerLineImageVFrame{
    CGFloat w = 293;
    CGFloat h= 1;
    CGFloat x = (CGRectGetWidth([self selfFame])-w)/2.0;
    CGRect timerBtnFrame = [self timerBtnFrameWithIndex:0];
    CGFloat y = CGRectGetMaxY(timerBtnFrame)-((CGRectGetHeight(timerBtnFrame)-h)/2.0);
    return CGRectMake(x, y, w, h);
}
//NSArray *timerBtnArray;
-(CGRect)timerBtnFrameWithIndex:(NSInteger)index{
    CGFloat w = 21;
    CGFloat h =21;
    NSInteger count = [currentDataModel getTimerNumCtn];
    CGFloat x = (CGRectGetWidth([self selfFame])- w*count)/(count+1)*(index+1)+index*w;
    CGFloat y = CGRectGetMaxY([self tommorrowSeckillBtn])+5;
    return CGRectMake(x, y, w, h);
}
//NSArray *timerLableArray;
-(CGRect)timerLableArrayWithIndex:(NSInteger)index{
    
    CGFloat w = 50;
    CGRect timerBtnFrame = [self timerBtnFrameWithIndex:index];
    CGFloat x = CGRectGetMinX(timerBtnFrame)-((w-CGRectGetWidth(timerBtnFrame))/2.0);
    //(CGRectGetWidth([self selfFame])- w*count)/(count+1)*(index+1)+index*w;
    CGFloat y = CGRectGetMaxY(timerBtnFrame)+2;
    CGFloat h = 20;
    return CGRectMake(x, y, w, h);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

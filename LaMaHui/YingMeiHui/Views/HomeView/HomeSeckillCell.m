//
//  HomeSeckillCell.m
//  YingMeiHui
//
//  Created by work on 14-11-9.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "HomeSeckillCell.h"
#import "UIImageView+WebCache.h"
#import "LimitedSeckillVO.h"

@implementation HomeSeckillCell
{
    NSMutableArray *timeLblArray;
    
    //倒计时
    NSTimer *backTimer;
    NSTimeInterval startTime;
    NSTimeInterval curTime;
    
    HomeVO *_skillVO;
    UIImageView *proImgView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        proImgArray  = [[NSMutableArray alloc] init];
        otherImgArray = [[NSMutableArray alloc] init];
        disLblArray  = [[NSMutableArray alloc] init];
        sellLblArray = [[NSMutableArray alloc] init];
        orgLblArray  = [[NSMutableArray alloc] init];
        
        timeLblArray = [[NSMutableArray alloc] init];
    }
    
    
    return self;
}

//倒计时
-(void)compareCurrentTime
{
    NSTimeInterval difftime = [_skillVO.sell_time longLongValue] - 1;
    _skillVO.sell_time = [NSNumber numberWithLongLong:difftime];
    if (difftime < 0) {
        [backTimer invalidate];
        return;
    }
    
    NSInteger hours = (long)difftime/3600;
    NSInteger minus = (long)difftime%3600/60;
    NSInteger sec = (long)difftime%60;
    
    NSInteger temptime = 0;
    for (NSInteger i = 0; i < timeLblArray.count; i++) {
        if (i == 0) {
            temptime = hours;
        }else if (i==1){
            temptime = minus;
        }else{
            temptime = sec;
        }
        
        [timeLblArray[i] setText:[NSString stringWithFormat:@"%02zi", temptime]];
    }
}

-(void)layoutUI:(HomeVO*)seckillVO{
    
    _skillVO = seckillVO;
    
    if(!backTimer){
        backTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(compareCurrentTime) userInfo:nil repeats:YES];
    }else{
        [backTimer invalidate];
        backTimer = nil;
        backTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(compareCurrentTime) userInfo:nil repeats:YES];
    }
    
    CGFloat cellHeight = ScreenW*305/640;
    
    if (!cellView) {
        cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, cellHeight)];
        [cellView setBackgroundColor:GRAY_CELL_COLOR];
        cellView.userInteractionEnabled = YES;
        
        //限量秒杀
        UIView *unitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW*252/640-1, cellHeight)];
        [unitView setBackgroundColor:[UIColor whiteColor]];
        
        UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        unitView.tag = 1000;
        [unitView addGestureRecognizer:tap0];
        
        proImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 43, ScreenW*252/640-20, cellHeight - 50)];
        [unitView addSubview:proImgView];
        
        [cellView addSubview:unitView];
        
        
        //倒计时
        UILabel *limiteLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 4, 70, 20)];
        limiteLabel.text = @"掌上秒杀";
        limiteLabel.font = FONT(13);
        [limiteLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]]; //加粗
        limiteLabel.backgroundColor = [UIColor clearColor];
        limiteLabel.textColor = RGB(51, 51, 51);
        [cellView addSubview:limiteLabel];
        
        [timeLblArray removeAllObjects];
        CGFloat xoffset =  10;
        for (NSInteger i = 0; i < 3; i ++) {
            UILabel *timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(xoffset, 26.5, 15, 10.5)];
            [timeLblArray addObject:timeLbl];
            [timeLbl setBackgroundColor:RGB(51, 51, 51)];
            timeLbl.layer.masksToBounds = YES;
            timeLbl.layer.cornerRadius = 3.0f;
            [timeLbl setText:@"00"];
            [timeLbl setFont:FONT(10.0)];
            [timeLbl setTextAlignment:NSTextAlignmentCenter];
            [timeLbl setTextColor:[UIColor whiteColor]];
            [cellView addSubview:timeLbl];
            xoffset += CGRectGetWidth(timeLbl.frame)+1;
            if (i < 2) {
                UILabel *pointLbl = [[UILabel alloc] initWithFrame:CGRectMake(xoffset+0.6, 27, 4, 8)];
                [pointLbl setText:@":"];
                pointLbl.backgroundColor = [UIColor clearColor];
                pointLbl.font = FONT(10);
                [cellView addSubview:pointLbl];
                xoffset += CGRectGetWidth(pointLbl.frame)+0.5;
            }
        }

        
        
        //品牌团
        UIView *actView1 = [[UIView alloc] initWithFrame:CGRectMake(ScreenW*252/640 ,0 ,(ScreenW-ScreenW*252/640)/2,cellHeight/2)];
        UIImageView *actImgView1 = [[UIImageView alloc] initWithFrame:actView1.frame];
        if (seckillVO.activity.count >= 1) {
            [actImgView1 sd_setImageWithURL:[NSURL URLWithString:[[seckillVO.activity objectAtIndex:0] Pic]] placeholderImage:[UIImage imageNamed:@"place_3"]];
        }
        [otherImgArray addObject:actImgView1];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        actView1.tag = 1001;
        [actView1 addGestureRecognizer:tap1];
        [cellView addSubview:actImgView1];
        [cellView addSubview:actView1];
        
        //签到赚金豆
        UIView *actView2 = [[UIView alloc] initWithFrame:CGRectMake((ScreenW-ScreenW*252/640)/2+ScreenW*252/640+1, 0,(ScreenW-ScreenW*252/640)/2, cellHeight/2)];
        UIImageView *actImgView2 = [[UIImageView alloc] initWithFrame:actView2.frame];
        if (seckillVO.activity.count >= 2) {
            [actImgView2 sd_setImageWithURL:[NSURL URLWithString:[[seckillVO.activity objectAtIndex:1] Pic]] placeholderImage:[UIImage imageNamed:@"place_3"]];
        }
        [otherImgArray addObject:actImgView2];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        actView2.tag = 1002;
        [actView2 addGestureRecognizer:tap2];
        [cellView addSubview:actView2];
        [cellView addSubview:actImgView2];
        
        //红包裂变
        UIView *actView3 = [[UIView alloc] initWithFrame:CGRectMake(ScreenW*252/640, cellHeight/2+1,(ScreenW-ScreenW*252/640)/2, cellHeight/2-1)];
        UIImageView *actImgView3 = [[UIImageView alloc] initWithFrame:actView3.frame];
        if (seckillVO.activity.count >= 3) {
            [actImgView3 sd_setImageWithURL:[NSURL URLWithString:[[seckillVO.activity objectAtIndex:2] Pic]] placeholderImage:[UIImage imageNamed:@"place_3"]];
        }
        [otherImgArray addObject:actImgView3];
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        actView3.tag = 1003;
        [actView3 addGestureRecognizer:tap3];
        [cellView addSubview:actView3];
        [cellView addSubview:actImgView3];
        
        //九块九包邮
        UIView *actView4 = [[UIView alloc] initWithFrame:CGRectMake((ScreenW-ScreenW*252/640)/2+ScreenW*252/640+1, cellHeight/2+1,(ScreenW-ScreenW*252/640)/2, cellHeight/2-1)];
        UIImageView *actImgView4 = [[UIImageView alloc] initWithFrame:actView4.frame];
        if (seckillVO.activity.count >= 4) {
            [actImgView4 sd_setImageWithURL:[NSURL URLWithString:[[seckillVO.activity objectAtIndex:3] Pic]] placeholderImage:[UIImage imageNamed:@"place_3"]];
        }
        [otherImgArray addObject:actImgView4];
        UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        actView4.tag = 1004;
        [actView4 addGestureRecognizer:tap4];
        [cellView addSubview:actView4];
        [cellView addSubview:actImgView4];
        
        
        [self addSubview:cellView];
    }
    
    for (int i = 0; i < seckillVO.activity.count; i++) {
        UIImageView *imgV = otherImgArray[i];
        [imgV sd_setImageWithURL:[NSURL URLWithString:[[seckillVO.activity objectAtIndex:i] Pic]] placeholderImage:[UIImage imageNamed:@"place_3"]];
    }
    
    //判断秒杀数量 是否大于0
    if (seckillVO.seckill_list.count > 0) {
        LimitedSeckillVO *vo = seckillVO.seckill_list[0];
        NSURL *imgurl = [NSURL URLWithString:[vo pic]];
        [proImgView sd_setImageWithURL:imgurl placeholderImage:LOCAL_IMG(@"place_2")];
    }
}

- (void)tapClick:(UITapGestureRecognizer *)recognizer
{
    NSInteger tag = recognizer.view.tag - 1000;
    AdvVO *vo = [[AdvVO alloc] init];
    if(tag <= _skillVO.activity.count && tag > 0){
        vo = _skillVO.activity[tag -1];
    }else if(tag == 0){//掌上秒杀
        vo.Type = @101;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapClick:)]) {
        [self.delegate tapClick:vo];
    }
}

@end

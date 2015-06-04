//
//  KTReturnOrderTableViewCell.m
//  YingMeiHui
//
//  Created by work on 15-1-31.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "KTReturnOrderTableViewCell.h"

@implementation KTReturnOrderTableViewCell
{
    UILabel *timeLbl;
    
    NSInteger _type;
    NSTimer *backTimer;
    ReturnOrderDetailVO *_detailVO;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    
    return self;
}

- (void)layoutUI:(ReturnOrderDetailVO *)detailVO{
    _detailVO = detailVO;
    _type = [_detailVO.refund_status integerValue];
    
    [self setBackgroundColor:GRAY_CELL_COLOR];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    [self.contentView addSubview:imgView];
    
    UILabel *textLbl = [[UILabel alloc] initWithFrame: CGRectMake(CGRectGetMaxX(imgView.frame)+10, CGRectGetMinY(imgView.frame), ScreenW-CGRectGetMaxX(imgView.frame)-20, 20)];
    [textLbl setFont:[UIFont systemFontOfSize:15.0]];
    [textLbl setTextColor:TEXTV_COLOR];
    [self.contentView addSubview:textLbl];
    
    UILabel *detailLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    [detailLbl setNumberOfLines:0];
    [detailLbl setLineBreakMode:NSLineBreakByWordWrapping];
    [detailLbl setFont:[UIFont systemFontOfSize:12.0]];
    [detailLbl setTextColor:DETAIL_COLOR];
    [self.contentView addSubview:detailLbl];
    
    //    0=待确认售后，1=待上传快递单号,2=待商家收货（此状态现在弃用）,3=退款中，4=退款完成，5=拒绝退款，6=退款失败，-1=取消售后'
    if (_type == 0 || (_type == 3  && [_detailVO.need_refund_goods integerValue] == 0) || _type == 6)
    {
        [imgView setImage:[UIImage imageNamed:@"return_no"]];
        [textLbl setText:_detailVO.title];
        
        NSString *detailStr = _detailVO.content.length>0?_detailVO.content:@"null";
        detailStr = [detailStr stringByReplacingOccurrencesOfString:@";" withString:@"\n\n"];
        
        CGSize detailSize = [detailStr sizeWithFont:detailLbl.font constrainedToSize:CGSizeMake(CGRectGetWidth(textLbl.frame), 1000) lineBreakMode:NSLineBreakByCharWrapping];
        [detailLbl setFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+10, CGRectGetMaxY(textLbl.frame)+5, CGRectGetWidth(textLbl.frame), detailSize.height)];
        [detailLbl setText:detailStr];
    }
    else if (_type == 1)
    {
        imgView.hidden = YES;
        textLbl.hidden = YES;
        detailLbl.hidden = YES;
        
        timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, ScreenW-24, 20)];
        [self.contentView addSubview:timeLbl];
        
        UILabel *descLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(timeLbl.frame)+5, ScreenW-24, 20)];
        [descLbl setText:_detailVO.content];
        [descLbl setFont:[UIFont systemFontOfSize:15.0]];
        [descLbl setTextColor:TEXTV_COLOR];
        [self.contentView addSubview:descLbl];
        
        if(!backTimer){
            backTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(compareCurrentTime) userInfo:nil repeats:YES];
            [backTimer fire];
        }else{
            [backTimer invalidate];
            backTimer = nil;
            backTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(compareCurrentTime) userInfo:nil repeats:YES];
            [backTimer fire];
        }
    }
    else if (_type == 3)
    {
        [imgView setImage:[UIImage imageNamed:@"return_no"]];
        [textLbl setText:_detailVO.title];
        
        NSString *detailStr = _detailVO.content;
        CGSize detailSize = [detailStr sizeWithFont:detailLbl.font constrainedToSize:CGSizeMake(CGRectGetWidth(textLbl.frame), 1000) lineBreakMode:NSLineBreakByCharWrapping];
        [detailLbl setFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+10, CGRectGetMaxY(textLbl.frame)+5, CGRectGetWidth(textLbl.frame), detailSize.height)];
        [detailLbl setText:detailStr];
        
        UIButton *seqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        seqBtn.frame = CGRectMake(ScreenW - 100, CGRectGetMaxY(detailLbl.frame)+5, 90, 30);
        [seqBtn.layer setCornerRadius:5.0];
        [seqBtn setBackgroundColor:[UIColor whiteColor]];
        [seqBtn.layer setBorderColor:[DETAIL_COLOR CGColor]];
        [seqBtn.layer setBorderWidth:0.5];
        [seqBtn addTarget:self action:@selector(seqBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:seqBtn];
        
        UIImageView *seqImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
        seqImg.image = [UIImage imageNamed:@"seq"];
        [seqBtn addSubview:seqImg];
        
        UILabel *seqLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(seqImg.frame), 0, 60, 30)];
        [seqLbl setBackgroundColor:[UIColor clearColor]];
        [seqLbl setTextColor:TEXTV_COLOR];
        [seqLbl setFont:[UIFont systemFontOfSize:15.0]];
        [seqLbl setText:@"联系客服"];
        [seqBtn addSubview:seqLbl];
    }
    else if (_type == 4)
    {
        [imgView setImage:[UIImage imageNamed:@"return_ok"]];
        [textLbl setText:_detailVO.title];
        UILabel *returnLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+10, CGRectGetMaxY(imgView.frame), CGRectGetWidth(textLbl.frame), 20)];
        [returnLbl setFont:[UIFont systemFontOfSize:13.0]];
        [returnLbl setTextColor:DETAIL_COLOR];
        [returnLbl setText:detailVO.content];
        [self.contentView addSubview:returnLbl];
        
        NSString *detailStr = @"";
        for (int i = 1; i < detailVO.refund_success_arr.count; i++) {
            NSString *sucStr = detailVO.refund_success_arr[i];
            
            if ([sucStr length] > 0) {
                detailStr = [detailStr stringByAppendingString:@"\n"];
                detailStr = [detailStr stringByAppendingString:sucStr];
            }
        }
        CGSize detailSize = [detailStr sizeWithFont:detailLbl.font constrainedToSize:CGSizeMake(CGRectGetWidth(returnLbl.frame), 1000) lineBreakMode:NSLineBreakByCharWrapping];
        [detailLbl setFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+10, CGRectGetMaxY(returnLbl.frame)+5, CGRectGetWidth(returnLbl.frame), detailSize.height)];
        [detailLbl setTextColor:TEXTV_COLOR];
        [detailLbl setText:detailStr];
    }else if (_type == 5){
        [imgView setImage:[UIImage imageNamed:@"return_no"]];
        [textLbl setText:_detailVO.title];
        
        NSString *detailStr =detailVO.refuse_reason;
        CGSize detailSize = [detailStr sizeWithFont:detailLbl.font constrainedToSize:CGSizeMake(CGRectGetWidth(textLbl.frame), 1000) lineBreakMode:NSLineBreakByCharWrapping];
        [detailLbl setFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+10, CGRectGetMaxY(textLbl.frame)+5, CGRectGetWidth(textLbl.frame), detailSize.height)];
        [detailLbl setText:detailStr];
    }
}

- (void)seqBtnClick{
    NSString *telStr = [NSString stringWithFormat:@"tel://%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"service_phone"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
}

//倒计时
-(void)compareCurrentTime
{
    NSTimeInterval difftime = [_detailVO.order_time longLongValue] - 1;
    _detailVO.order_time = [NSNumber numberWithLongLong:difftime];
    if (difftime < 0) {
        [backTimer invalidate];
        return;
    }
    
    NSInteger day = difftime/3600/24;
    NSInteger hours = (long)difftime%(3600*24)/3600;
    NSInteger minus = (long)difftime%3600/60;
    NSInteger sec = (long)difftime%60;
    
    NSString *fstr = @"退款剩余时间: ";
    NSString *timeStr = [NSString stringWithFormat:@"%zi天%zi小时%zi分%zi秒", day, hours, minus, sec];
    NSString *bstr = [NSString stringWithFormat:@"%@%@", fstr,timeStr];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:bstr];
    [attrStr addAttribute:NSForegroundColorAttributeName value:DETAIL_COLOR range:NSMakeRange(0, fstr.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:ALL_COLOR range:NSMakeRange(fstr.length, bstr.length-fstr.length)];
    [attrStr addAttribute:NSFontAttributeName value:FONT(15.0) range:NSMakeRange(0, fstr.length)];
    [attrStr addAttribute:NSFontAttributeName value:FONT(15.0) range:NSMakeRange(fstr.length, bstr.length-fstr.length)];
    [timeLbl setAttributedText:attrStr];
}

@end

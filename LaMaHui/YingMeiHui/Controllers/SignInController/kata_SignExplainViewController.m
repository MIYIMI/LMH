//
//  kata_SignExplainViewController.m
//  YingMeiHui
//
//  Created by work on 14-11-15.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "kata_SignExplainViewController.h"

@interface kata_SignExplainViewController (){
    UITextView *textView;
    UILabel *titleLbl;
}

@end

@implementation kata_SignExplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"金豆说明";
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    if (!titleLbl) {
        titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, ScreenW-20, 20)];
        [titleLbl setText:@"签到赢金豆规则:"];
        [titleLbl setTextColor:[UIColor colorWithRed:1 green:0.4 blue:0.5 alpha:1]];
        [titleLbl setFont:FONT(20.0)];
        [self.contentView addSubview:titleLbl];
    }
    if (!textView) {
        CGRect frame = self.contentView.frame;
        frame.size.height -= CGRectGetMaxY(titleLbl.frame) - 10;
        frame.origin.y = CGRectGetMaxY(titleLbl.frame) + 10;
        frame.size.width -= 20;
        frame.origin.x = 10;
        textView = [[UITextView alloc] initWithFrame:frame];
        textView.userInteractionEnabled = NO;
        NSString *textstr = @"1.初次签到奖励2个金豆\n"
        @"2.连续第二次签到奖励4个金豆\n"
        @"3.连续第三次签到奖励6个金豆\n"
        @"4.连续第4次签到奖励8个金豆\n"
        @"5.连续第5次签到奖励10个金豆\n"
        @"6.连续第6次签到奖励12个金豆\n"
        @"7.连续第7次及以上签到奖励16个金豆\n"
        @"\n\n断开签到就从2个金豆开始了，辣妈们记得天天来签到哦!\n\n"
        @"邀请好友注册额外奖励200金豆=人民币2元，是不是很心动呢!";
        
        NSString *endStr = @"邀请好友注册额外奖励200金豆=人名币2元，是不是很心动呢!";
        NSInteger lenght1 = textstr.length;
        NSInteger length2 = endStr.length;
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:textstr];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:1] range:NSMakeRange(0,lenght1-length2)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.98 green:0.21 blue:0.36 alpha:1] range:NSMakeRange(lenght1-length2,length2)];
        [str addAttribute:NSFontAttributeName value:FONT(16.0) range:NSMakeRange(0, lenght1-length2)];
        [str addAttribute:NSFontAttributeName value:FONT(16.0) range:NSMakeRange(lenght1-length2, length2)];
        
        textView.attributedText = str;
        [self.contentView addSubview:textView];
    }
}

@end

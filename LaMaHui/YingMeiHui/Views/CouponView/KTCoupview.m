//
//  KTCoupview.m
//  YingMeiHui
//
//  Created by work on 14-9-23.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTCoupview.h"
#import <QuartzCore/QuartzCore.h>
#import "CouponVO.h"

@implementation KTCoupview
@synthesize coupon_table;
@synthesize dataArray;
@synthesize delegate;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        btnArray = [[NSMutableArray alloc] init];
        
        self.frame = frame;
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        
        coupon_table = [[UITableView alloc] initWithFrame:frame];
        coupon_table.delegate = self;
        coupon_table.dataSource = self;
        coupon_table.layer.cornerRadius = 5;
        coupon_table.backgroundColor = [UIColor whiteColor];
        coupon_table.separatorStyle = UITableViewCellSeparatorStyleNone;
        coupon_table.separatorColor = [UIColor grayColor];
        [self setExtraCellLineHidden:coupon_table];
        coupon_table.bounces = NO;
        CGRect skuFrame = coupon_table.frame;
        skuFrame.origin.y = 0;
        skuFrame.origin.x = 0;
        coupon_table.frame = skuFrame;
        
        [self addSubview:coupon_table];
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!headView) {
        headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 40)];
        [headView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *headLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 40)];
        [headLbl setText:@"请选择优惠券"];
        [headLbl setTextColor:[UIColor colorWithRed:0.96 green:0.38 blue:0.49 alpha:1]];
        [headLbl setFont:[UIFont systemFontOfSize:18.0]];
        [headLbl setTextAlignment:NSTextAlignmentCenter];
        [headLbl setBackgroundColor:[UIColor whiteColor]];
        [headView addSubview:headLbl];
        
        UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headLbl.frame), CGRectGetWidth(headLbl.frame), 1)];
        [lineLbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"line"]]];
        [headView addSubview:lineLbl];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(headLbl.frame)-20, -3, 22, 22)];
        cancelBtn.layer.cornerRadius = 22/2;
        [cancelBtn setBackgroundImage:LOCAL_IMG(@"icon_close") forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancleBtn) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setBackgroundColor:[UIColor colorWithRed:0.98 green:0.33 blue:0.43 alpha:1]];
        [self addSubview:cancelBtn];
    }
    
    return headView;
}

-(void)cancleBtn{
    [self.delegate closeView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (!bootView) {
        bootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 40)];
        [bootView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *noLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(self.frame) - 40, 40)];
        [noLbl setText:@"不使用优惠券"];
        [noLbl setTextColor:[UIColor blackColor]];
        [noLbl setFont:[UIFont systemFontOfSize:15]];
        [bootView addSubview:noLbl];
        
        bootBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 40, 9, 22, 22)];
        [bootBtn setBackgroundImage:[UIImage imageNamed:@"noselect"] forState:UIControlStateNormal];
        [bootBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateHighlighted];
        [bootBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
        [bootBtn addTarget:self action:@selector(btnSelect:) forControlEvents:UIControlEventTouchUpInside];
        [bootBtn setSelected:YES];
        [bootView addSubview:bootBtn];
        
        UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, -1, CGRectGetWidth(self.frame), 1)];
        [lineLbl setBackgroundColor:[UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1]];
        [bootView addSubview:lineLbl];
    }
    for (UIButton *btn in btnArray) {
        bootBtn.selected = YES;
        if (btn.selected) {
            bootBtn.selected = NO;
        }
    }

    return bootView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return  80;
    }
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count] + 1;
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *COUPONID = @"couponid";
    
    NSInteger row = indexPath.row;
    NSString *IFIER = [NSString stringWithFormat:@"ifier%zi",row];
    if(row == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:COUPONID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:COUPONID];
            UILabel *couponLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, (CGRectGetWidth(self.frame) -30)/4*3, 40)];
            [couponLbl setText:@"请输入优惠券号: "];
            [couponLbl setTextColor:[UIColor blackColor]];
            [couponLbl setFont:[UIFont systemFontOfSize:15.0]];
            [cell addSubview:couponLbl];
            
            couponFied = [[UITextField alloc] initWithFrame:CGRectMake(15, 40, (CGRectGetWidth(self.frame) -30)/4*3, 30)];
            couponFied.borderStyle = UITextBorderStyleRoundedRect;
            couponFied.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            couponFied.delegate = self;
            [cell addSubview:couponFied];
            
            _checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(couponFied.frame) + 5, 40, (CGRectGetWidth(self.frame) -30)/4 - 5, 30)];
            [_checkBtn setTitle:@"确定" forState:UIControlStateNormal];
            [_checkBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [_checkBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
            [_checkBtn addTarget:self action:@selector(btnSelect:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:_checkBtn];
            
            UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 79, (CGRectGetWidth(coupon_table.frame) - 30), 1)];
            [lineLbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"line"]]];
            [cell addSubview:lineLbl];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IFIER];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IFIER];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            
            UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 39, (CGRectGetWidth(coupon_table.frame) - 30), 1)];
            [lineLbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"line"]]];
            [cell addSubview:lineLbl];
            
            UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 40, 9, 22, 22)];
            [selectBtn setBackgroundImage:[UIImage imageNamed:@"noselect"] forState:UIControlStateNormal];
            [selectBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateHighlighted];
            [selectBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
            [selectBtn addTarget:self action:@selector(btnSelect:) forControlEvents:UIControlEventTouchUpInside];
            [btnArray addObject:selectBtn];
            [cell addSubview:selectBtn];
        }
        
        CouponVO *cpVo = [self.dataArray objectAtIndex:indexPath.row - 1];
        cell.textLabel.text = cpVo.coupon_rule;
        [cell.textLabel setTextColor:[UIColor blackColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
    return nil;
}

-(void)btnSelect:(UIButton *)sender
{
    [_checkBtn setUserInteractionEnabled:NO];
    if (sender == _checkBtn) {
        NSString *nonemailRegex = @"^[A-Za-z0-9]+$";
        NSPredicate *nonemailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nonemailRegex];
        if (![nonemailPredicate evaluateWithObject:couponFied.text]) {
            [self textStateHUD:@"请输入正确的优惠券号"];
            [_checkBtn setUserInteractionEnabled:YES];
            return;
        }else{
            [self.delegate selectMethod:couponFied.text];
            return;
        }
    }
    
    if (sender == bootBtn) {
        bootBtn.selected = YES;
        [self.delegate selectMethod:@"no"];
    }
    
    for (NSInteger i = 0; i < btnArray.count; i ++) {
        if (sender == btnArray[i]) {
            [((UIButton *)btnArray[i]) setSelected:YES];
            bootBtn.selected = NO;
            [btnArray[i] setUserInteractionEnabled:NO];
            CouponVO *vo = self.dataArray[i];
            [self.delegate selectMethod:vo.coupon_id];
        }else{
            [((UIButton *)btnArray[i]) setSelected:NO];
            [btnArray[i] setUserInteractionEnabled:YES];
        }
    }
}

//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//点击textField隐藏键盘
- (UIView *)hitTest:(CGPoint)poNSInteger withEvent:(UIEvent *)event
{
    UIView *result = [super hitTest:poNSInteger withEvent:event];
    if (result != couponFied) {
        [couponFied endEditing:YES];
    }
    
    return result;
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

//
//  category_selectView.m
//  YingMeiHui
//
//  Created by Zhumingming on 15-4-16.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "Category_selectView.h"
#import "SizeInfoVO.h"
#import "KTPropButton.h"
@implementation Category_selectView
{
    UIView *footView;
    UIView *_priceView;
    UIView *_ageView;
    UIView *_categoeyView;
    
    CGFloat btnWith;
    CGFloat sonViewHight;
    
    NSMutableArray *priceBtnArray;
    NSMutableArray *sonViewArray;
    
    NSMutableDictionary *sonDict;
    NSMutableDictionary *selectDict;
    
    BOOL is_default;//子分类默认选中
}
@synthesize fitArray;

#define BOTTOMHEIGHT        45
#define btnWith             (ScreenW - 35)/4
#define sonBtnWith          (ScreenW - 50)/5

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.tableview = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        
        self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableview.backgroundColor = [UIColor whiteColor];
        self.tableview.delegate = self;
        self.tableview.dataSource = self;
        [self addSubview:self.tableview];
        
        CGRect skuFrame = self.tableview.frame;
        skuFrame.origin.y = 0;
        skuFrame.origin.x = 0;
        skuFrame.size.height -= BOTTOMHEIGHT;
        self.tableview.frame = skuFrame;
        
        is_default = YES;
        
        sonDict = [[NSMutableDictionary alloc] init];
        priceBtnArray    = [[NSMutableArray alloc] init];
        sonViewArray = [[NSMutableArray alloc] init];
        selectDict = [[NSMutableDictionary alloc] init];
        
        footView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(frame)-BOTTOMHEIGHT, ScreenW, BOTTOMHEIGHT)];
        [footView setBackgroundColor:LMH_COLOR_LIGHTLINE];
        
        UIButton *finishBtn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenW-100)/2, 7.5, 100, 30)];
        [finishBtn setTitle:@"确认" forState:UIControlStateNormal];
        finishBtn.titleLabel.font = FONT(15);
        [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [finishBtn setBackgroundImage:[UIImage imageNamed:@"red_btn_small"] forState:UIControlStateNormal];
        finishBtn.imageView.image = [UIImage imageNamed:@"red_btn_small"];
        [finishBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:finishBtn];
        
        [self addSubview:footView];
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return fitArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *propNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 30)];
    [propNameLbl setBackgroundColor:[UIColor clearColor]];
    [propNameLbl setFont:LMH_FONT_14];
    [propNameLbl setNumberOfLines:1];
    [propNameLbl setTextColor:LMH_COLOR_BLACK];

    if (fitArray.count > section) {
        FiterVO *fvo = fitArray[section];
        NSString *tagTitle = @"";
        for (FiterSonVO *sonvo in fvo.list_array) {
            if ([sonvo.is_chcek integerValue]) {
                tagTitle = sonvo.title;
            }
            for (FiterSonVO *svo in sonvo.list_son) {
                if ([svo.is_chcek integerValue]) {
                    tagTitle = [NSString stringWithFormat:@"%@>%@", sonvo.title, svo.title];
                }
            }
        }
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"    %@%@",fvo.list_name,tagTitle]];
        [str addAttribute:NSForegroundColorAttributeName value:LMH_COLOR_BLACK range:NSMakeRange(0, fvo.list_name.length+4)];
        [str addAttribute:NSForegroundColorAttributeName value:LMH_COLOR_SKIN range:NSMakeRange(fvo.list_name.length+4,tagTitle.length)];
        [propNameLbl setAttributedText:str];
    }
    
    return propNameLbl;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *fsarray;
    if (fitArray.count > indexPath.section) {
        FiterVO *fvo = fitArray[indexPath.section];
        fsarray = fvo.list_array;
    }
    if (sonViewArray.count > indexPath.section) {
        UIView *sview = (UIView*)sonViewArray[indexPath.section];
        if (sview.hidden) {
            return 40*ceilf(fsarray.count/4.0f)+5;
        }else{
            CGFloat h = 0;
            
            NSArray *cellArray = priceBtnArray[indexPath.section];
            for (int i = 0; i < cellArray.count; i++) {
                UIButton *btn = cellArray[i];
                if (btn.selected) {
                    FiterSonVO *fsvo;
                    if (fsarray.count > i) {
                        fsvo = fsarray[i];
                    }
                    NSInteger nnss = ceilf(fsvo.list_son.count/5.0f) ;
                    h = nnss*35;
                    if (h<=0) {
                        sview.hidden = YES;
                    }else{
                        sview.hidden = NO;
                    }
                }
            }
            return h+40*ceilf(fsarray.count/4.0f);
        }
    }
    
    return 40*ceilf(fsarray.count/4.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = [NSString stringWithFormat:@"cell%zi",indexPath.section];
    NSInteger section = indexPath.section;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        lineLbl.tag = 111;
        [lineLbl setBackgroundColor:LMH_COLOR_LIGHTLINE];
        [cell addSubview:lineLbl];
        
        UIView *sonView = [[UIView alloc] initWithFrame:CGRectNull];
        sonView.backgroundColor = LMH_COLOR_LIGHTLINE;
        sonView.hidden = YES;
        [cell.contentView addSubview:sonView];
        [sonViewArray addObject:sonView];
    }
    
    CGFloat cellH = 0;
    
    NSArray *fsarray;
    if (fitArray.count > section) {
        FiterVO *fvo = fitArray[section];
        fsarray = fvo.list_array;
    }
    NSInteger p = (section+1)*1000;
    NSInteger pnum = priceBtnArray.count>indexPath.section?[priceBtnArray[section] count]:0;
    NSMutableArray *pAry = [[NSMutableArray alloc] init];
    for (int i = 0; i < fsarray.count && pnum < fsarray.count; i++) {
        FiterSonVO *sonvo = fsarray[i];
        UIButton *propBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [propBtn setTitle:sonvo.title forState:UIControlStateNormal];
        [propBtn setTitleColor:LMH_COLOR_BLACK forState:UIControlStateNormal];
        [propBtn setTitleColor:LMH_COLOR_SKIN forState:UIControlStateSelected];
        propBtn.titleLabel.font = LMH_FONT_13;
        propBtn.backgroundColor = [UIColor clearColor];
        propBtn.layer.cornerRadius = 2.0;
        propBtn.layer.masksToBounds = YES;
        propBtn.layer.borderColor = [LMH_COLOR_LIGHTGRAY CGColor];
        propBtn.layer.borderWidth = 0.5;
        propBtn.tag = p++;
        [propBtn addTarget:self action:@selector(priceBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [pAry addObject:propBtn];
        if ([sonvo.is_chcek boolValue]) {
            propBtn.selected = YES;
        }
        [cell addSubview:propBtn];
        if (i == fsarray.count-1) {
            [priceBtnArray addObject:pAry];
        }
    }
    
    FiterSonVO *fsvo;
    NSInteger pidNum = -1;
    if (priceBtnArray.count > section) {
        for (int i = 0; i < [priceBtnArray[section] count]; i++) {
            UIButton *btna = priceBtnArray[section][i];
            if (btna.selected) {
                fsvo = fsarray[i];
                pidNum = i;
            }
        }
    }
    
    UIView *sView = sonViewArray[section];
    
    NSMutableArray *sonAry = [[NSMutableArray alloc] init];
    
    NSMutableArray *sonArray = sonDict[cellID];
    for (UIButton *rbtn in [sonViewArray[section] subviews]) {
        [rbtn removeFromSuperview];
    }
    
    [sonArray removeAllObjects];
    NSInteger m = (section+1)*100 + (pidNum+1)*10000;
    for (int i = 0; i < fsvo.list_son.count && ((NSArray*)sonDict[cellID]).count < fsvo.list_son.count; i++) {
        FiterSonVO *sonvo = fsvo.list_son[i];
        UIButton *propBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        propBtn.frame = CGRectMake(5+(i%5)*(sonBtnWith+5), 5+i/5*(35), sonBtnWith, 30);
        [propBtn setTitle:sonvo.title forState:UIControlStateNormal];
        [propBtn setTitleColor:LMH_COLOR_BLACK forState:UIControlStateNormal];
        [propBtn setTitleColor:LMH_COLOR_SKIN forState:UIControlStateSelected];
        propBtn.titleLabel.font = LMH_FONT_12;
        propBtn.backgroundColor = [UIColor whiteColor];
        propBtn.layer.cornerRadius = 2.0;
        propBtn.layer.masksToBounds = YES;
        propBtn.layer.borderColor = [LMH_COLOR_LIGHTGRAY CGColor];
        propBtn.layer.borderWidth = 0.5;
        propBtn.tag = m++;
        [propBtn addTarget:self action:@selector(sonBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [sonAry addObject:propBtn];
        [sView addSubview:propBtn];
        [selectDict removeObjectForKey:sonvo.id_name];
        if (i == fsvo.list_son.count-1) {
            [sonDict setObject:sonAry forKey:cellID];
        }
        if ([sonvo.is_chcek boolValue]) {
            propBtn.selected = YES;
            [selectDict setObject:sonvo.list_id forKeyedSubscript:[NSString stringWithFormat:@"%@_son",sonvo.id_name]];
        }else{
            propBtn.selected = NO;
        }
    }
    sonArray = sonDict[cellID];
    if (!sView.hidden) {
        for (UIButton *sbtn in priceBtnArray[section]) {
            if (sbtn.selected && sonArray.count > 0) {
                sView.frame = CGRectMake(10, CGRectGetMaxY(sbtn.frame)+5, ScreenW-20, 5+ceilf(sonArray.count/5.0f)*35);
            }
        }
    }else{
        sView.frame = CGRectNull;
    }
    
    NSInteger btnNum = -1;
    for (int i = 0; i < (priceBtnArray.count>indexPath.section?[priceBtnArray[section] count]:0); i++) {
        UIButton *btn = priceBtnArray[section][i];
        if (btn.selected && !sView.hidden) {
            btnNum = ceilf(i/4);
        }
    }

    CGFloat inserH = 0;
    for (int i = 0; i < fsarray.count; i++) {
        FiterSonVO *vo = fsarray[i];
        
        if((i/4 == btnNum+1) && btnNum!=-1 && !sView.hidden){
            inserH = CGRectGetMaxY(sView.frame)+5;
        }else{
            inserH = i/4*(30+5);
            if (i/4>btnNum+1) {
                inserH = i/4*(30+5) + CGRectGetHeight(sView.frame)+5;
            }
        }
        UIButton *btn = priceBtnArray[section][i];
        btn.frame = CGRectMake(10+i%4*(btnWith+5), inserH, btnWith, 30);
        cellH = CGRectGetMaxY(btn.frame)+10;
        if (ceilf(i/4.0f) <= btnNum && !sView.hidden) {
            cellH = CGRectGetMaxY(sView.frame)+10;
        }
        
        if ([vo.is_chcek boolValue]) {
            btn.selected = YES;
            [selectDict setObject:vo.list_id forKeyedSubscript:vo.id_name];
            if (sView.hidden && sonAry.count > 0) {
                [self priceBtnPressed:btn];
            }
        }else{
            btn.selected = NO;
        }
    }

    UILabel *line = (UILabel *)[cell viewWithTag:111];
    line.frame = CGRectMake(10, cellH-0.5, ScreenW -20, 0.5);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)priceBtnPressed:(UIButton *)sender
{
    NSInteger cellNum = sender.tag/1000-1;
    
    NSArray *fsarray;
    if (fitArray.count > cellNum) {
        FiterVO *fvo = fitArray[cellNum];
        fsarray = fvo.list_array;
    }
    
    for (int i = 0; i < [priceBtnArray[cellNum] count]; i++) {
        UIButton *btn = priceBtnArray[cellNum][i];
        btn.frame = CGRectMake(10+(i%4)*(btnWith+5), i/4*(30+5), btnWith, 30);
    }
    
    for (int i = 0; i < fsarray.count; i ++) {
        FiterSonVO *so = fsarray[i];
        for (FiterSonVO *vo in so.list_son) {
            if ([vo.is_chcek boolValue] && is_default) {
                is_default = NO;
            }else{
                vo.is_chcek = @0;
            }
        }
    }
    
    NSArray *parry = priceBtnArray[cellNum];
    for (UIButton *priceBtn in parry) {
        FiterSonVO *svo = fsarray[priceBtn.tag%1000];
        if (priceBtn != sender) {
            svo.is_chcek = @0;
            priceBtn.selected = NO;
        }else{
            priceBtn.selected = YES;
            svo.is_chcek = @1;
            [(UIView*)sonViewArray[cellNum] setHidden:NO];
        }
    }
    
    [self.tableview reloadData];
}

- (void)sonBtnPressed:(UIButton*)sender{
    NSInteger cellNum = sender.tag%10000/100-1;
    NSInteger pidNum = sender.tag/10000 - 1;
    
    NSArray *fsarray;
    if (fitArray.count > cellNum) {
        FiterVO *fvo = fitArray[cellNum];
        fsarray = fvo.list_array;
    }
    for (int i = 0; i < fsarray.count; i ++) {
        FiterSonVO *so = fsarray[i];
        for (FiterSonVO *vo in so.list_son) {
            vo.is_chcek = @0;
        }
    }
    FiterSonVO *svo = fsarray[pidNum];
    NSArray *btnArray = [sonViewArray[cellNum] subviews];
    for(int i = 0; i < btnArray.count; i++){
        FiterSonVO *sonvo = svo.list_son[i];
        UIButton *btn = btnArray[i];
        if (btn.tag == sender.tag) {
            sonvo.is_chcek = @1;
            btn.selected = YES;
        }else{
            sonvo.is_chcek = @0;
            btn.selected = NO;
        }
    }
    [self.tableview reloadData];
}

- (void)sureBtnClick:(UIButton *)sender
{
    for (int i = 0; i < fitArray.count; i ++) {
        FiterVO *tvo = fitArray[i];
        NSString *secStr = [NSString stringWithFormat:@"%@_list_id_son",tvo.name];
        if (selectDict[secStr]) {
            [selectDict setValue:selectDict[secStr] forKey:[NSString stringWithFormat:@"%@_list_id",tvo.name]];
            [selectDict removeObjectForKey:[NSString stringWithFormat:@"%@_list_id_son",tvo.name]];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(fiter:)]) {
        [self.delegate fiter:selectDict];
    }
}

@end

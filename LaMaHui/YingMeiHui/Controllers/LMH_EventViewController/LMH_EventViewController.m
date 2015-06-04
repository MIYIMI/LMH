//
//  LMH_EventViewController.m
//  YingMeiHui
//
//  Created by work on 15/5/27.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "LMH_EventViewController.h"
#import "LMH_EventTableViewCell.h"
#import "XLCycleScrollView.h"
#import "AloneProductCellTableViewCell.h"
#import "LMH_BullTableViewCell.h"
#import "LMH_ToolTableViewCell.h"
#import "LMH_ImageTableViewCell.h"
#import "LMH_ReviewTableViewCell.h"
#import "AloneProductCellTableViewCell.h"
#import "LMH_KeyBoradView.h"
#import "LMH_EventVO.h"
#import "kata_WebViewController.h"
#import "kata_ProductDetailViewController.h"
#import "LMH_EvaluateViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "kata_LoginViewController.h"
#import "AdvVO.h"

@interface LMH_EventViewController ()<LMH_EventTableViewCellDelegate,XLCycleScrollViewDatasource,XLCycleScrollViewDelegate,LMH_BullTableViewCellDelegate,LMH_ToolTableViewCellDelegate,LMH_ReviewTableViewCellDelegate,LMH_KeyBoradViewDelegate,UITextFieldDelegate,AloneProductCellTableViewCellDelgate,UMSocialUIDelegate,LoginDelegate>
{
    XLCycleScrollView *cycleScrollView;
    UIView *headView;
    UITextField *textField;
    LMH_KeyBoradView *keyView;
    
    BOOL is_show;
    CGRect vFrame;
    LMH_EventVO *eventVO;
    NSMutableArray *eventArray;
    NSMutableArray *recomArray;
    AdvVO *_advo;
    
    
    NSString *shareURL;
    NSString *shareTent;
    
    NSNumber *eveluateUserid;//被回复用户的id
    NSNumber *eveluatesmsID;          //被回复的内容id
    NSString *eveluateTent;
    NSString *userid;
    NSString *usertoken;
}

@end

@implementation LMH_EventViewController
@synthesize eventID;
@synthesize scrollType;
@synthesize vcTitle;

- (id)initWithDataVO:(AdvVO *)advo{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        is_show = NO;
        scrollType = 0;
        self.ifAddPullToRefreshControl = NO;
        
        _advo = advo;
        if (_advo.Key.length > 0) {//如果是首页banner过来的走下面
            eventID = [_advo.Key integerValue];
        }
        
        eventArray = [[NSMutableArray alloc] init];
        recomArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self layoutAdverView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    vFrame = self.tableView.frame;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShow:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.title = vcTitle;
    
    [self getEventRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    keyView.hidden = YES;
    [keyView.textField resignFirstResponder];
    [textField resignFirstResponder];
}

- (void)createUI{
    headView = [[UIView alloc] initWithFrame:CGRectNull];
    headView.backgroundColor = self.tableView.backgroundColor;
    
    keyView = [[LMH_KeyBoradView alloc] initWithFrame:CGRectMake(0, ScreenH-104, ScreenW, 40)];
    keyView.backgroundColor = [UIColor whiteColor];
    keyView.keyDelegate = self;
    [self.view addSubview:keyView];
    keyView.hidden = YES;
}

- (void )getEventRequest
{
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    [self loadHUD];
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    NSMutableDictionary *paramsDict = [req params];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInteger:eventID] forKey:@"campaign_id"];
    if (userid) {
        [dict setObject:userid forKey:@"user_id"];
    }
    if (usertoken) {
        [dict setObject:usertoken forKey:@"user_token"];
    }
    
    [paramsDict setObject:dict forKey:@"params"];
    
    [paramsDict setObject:@"get_activity_page" forKey:@"method"];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        [self hideHUD];
        [self performSelectorOnMainThread:@selector(getEventResponse:) withObject:resp waitUntilDone:YES];
    } failed:^(NSError *error) {
        [self hideHUD];
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)getEventResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if (respDict[@"data"] != nil && ![respDict[@"data"] isEqual:[NSNull null]] && [respDict[@"data"] isKindOfClass:[NSDictionary class]]) {
                eventVO = [LMH_EventVO LMH_EventVOWithDictionary:respDict[@"data"]];
                if (eventVO.banner_img.length > 0) {
                    [self layoutAdverView];
                }
                
                //专场商品
                for (NSInteger i = 0; i < ceil((CGFloat)eventVO.goods.count / 2.0); i++) {
                    NSMutableArray *cellArr = [[NSMutableArray alloc] init];
                    if ([eventVO.goods objectAtIndex:i * 2] && [[eventVO.goods objectAtIndex:i * 2] isKindOfClass:[HomeProductVO class]]) {
                        [cellArr addObject:[eventVO.goods objectAtIndex:i * 2]];
                    }
                    
                    if (eventVO.goods.count > i * 2 + 1) {
                        if ([eventVO.goods objectAtIndex:i * 2 + 1] && [[eventVO.goods objectAtIndex:i * 2 + 1] isKindOfClass:[HomeProductVO class]]) {
                            [cellArr addObject:[eventVO.goods objectAtIndex:i * 2 + 1]];
                        }
                    }
                    
                    [eventArray addObject:cellArr];
                }
                
                //推荐商品
                for (NSInteger i = 0; i < ceil((CGFloat)eventVO.recommend_goods.count / 2.0); i++) {
                    NSMutableArray *cellArr = [[NSMutableArray alloc] init];
                    if ([eventVO.recommend_goods objectAtIndex:i * 2] && [[eventVO.recommend_goods objectAtIndex:i * 2] isKindOfClass:[HomeProductVO class]]) {
                        [cellArr addObject:[eventVO.recommend_goods objectAtIndex:i * 2]];
                    }
                    
                    if (eventVO.recommend_goods.count > i * 2 + 1) {
                        if ([eventVO.recommend_goods objectAtIndex:i * 2 + 1] && [[eventVO.recommend_goods objectAtIndex:i * 2 + 1] isKindOfClass:[HomeProductVO class]]) {
                            [cellArr addObject:[eventVO.recommend_goods objectAtIndex:i * 2 + 1]];
                        }
                    }
                    
                    [recomArray addObject:cellArr];
                }
                
                if (eventVO.share_content) {
                    shareTent = eventVO.share_content;
                }
                
                if (eventVO.click_url) {
                    shareURL = eventVO.click_url;
                }
                
                [self.tableView reloadData];
                
                if (scrollType == 1) {
                    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] animated:YES scrollPosition:UITableViewScrollPositionTop];
                }else if (scrollType == 2){
                    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4] animated:YES scrollPosition:UITableViewScrollPositionTop];
                }
                return;
            }
        }
    }
    [self textStateHUD:@"网络问题，请稍后重试"];
}

- (void)layoutAdverView{
    if (cycleScrollView) {
        [cycleScrollView removeFromSuperview];
        [cycleScrollView.animationTimer invalidate];
        cycleScrollView.animationTimer = nil;
        cycleScrollView = nil;
    }
    
    if (!cycleScrollView) {
        cycleScrollView = [[XLCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenW*290/720) animationDuration:0];
        [headView addSubview:cycleScrollView];
    }
    headView.frame = CGRectMake(0, 0, ScreenW, CGRectGetHeight(cycleScrollView.frame));
    cycleScrollView.xldelegate = self;
    cycleScrollView.xldatasource = self;
    [self.tableView setTableHeaderView:headView];
}

- (NSInteger)numberOfPages
{
    return 1;
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    if (eventVO.banner_img) {
        UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenW*290/720)];
        [imgview sd_setImageWithURL:[NSURL URLWithString:eventVO.banner_img]];
        return imgview;
    }
    return nil;
}

- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index
{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (eventVO.text_words) {
            return 1;
        }
        return 0;
    }else if (section == 1){
        return eventArray.count;
    }else if (section == 2){
        if (eventVO.topic_ios) {
            return 2;
        }else if(eventVO){
            return 2;
        }
        return 0;
    }else if (section == 3){
        if (eventVO.fav_img.count > 0) {
            return 2;
        }
        return 0;
    }else if(section == 4){
        if (eventVO.evaluate_list.count > 3) {
            return 6;
        }else if(eventVO){
            return eventVO.evaluate_list.count + 3;
        }
        return 0;
    }else if (section == 5){
        if (recomArray.count > 0) {
            return recomArray.count + 1;
        }
        return 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CELL_SECTION0 = @"CELL0";
    static NSString *CELL_SECTION1 = @"CELL1";
    static NSString *CELL_SECTION2_0 = @"CELL2_0";
    static NSString *CELL_SECTION2_1 = @"CELL2_1";
    static NSString *CELL_SECTION3_0 = @"CELL3_0";
    static NSString *CELL_SECTION3_1 = @"CELL3_1";
    static NSString *CELL_SECTION4_0 = @"CELL4_0";
    static NSString *CELL_SECTION4_1 = @"CELL4_1";
    static NSString *CELL_SECTION4_2_NONE = @"CELL4_2_NONE";
    static NSString *CELL_SECTION4_2 = @"CELL4_2";
    static NSString *CELL_SECTION4_3 = @"CELL4_3";
    static NSString *CELL_SECTION5_0 = @"CELL5_0";
    static NSString *CELL_SECTION5_1 = @"CELL5_1";
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_SECTION0];
        if (!cell) {
            cell = [[LMH_EventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_SECTION0];
        }
        [(LMH_EventTableViewCell*)cell layOutUI:eventVO show:is_show];
        [(LMH_EventTableViewCell*)cell setEventDelegate:self];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if(section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_SECTION1];
        if (!cell) {
            cell = [[AloneProductCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_SECTION1];
        }
        [(AloneProductCellTableViewCell *)cell setIs_newEvent:YES];
        [(AloneProductCellTableViewCell *)cell layoutUI:eventArray[row] andColnum:2 is_act:NO is_type:YES];
        [(AloneProductCellTableViewCell *)cell setDelegate:self];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if(section == 2){
        if (row == 0) {
            if (eventVO.topic_ios.length <= 0) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_SECTION2_0];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_SECTION2_0];
                }
                
                return cell;
            }
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_SECTION2_0];
            if (!cell) {
                cell = [[LMH_BullTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_SECTION2_0];
            }
            [(LMH_BullTableViewCell *)cell layOutUI:NO andVO:eventVO.topic_ios];
            [(LMH_BullTableViewCell *)cell setBullDelegate:self];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_SECTION2_1];
            if (!cell) {
                cell = [[LMH_ToolTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_SECTION2_1];
            }
            
            NSDictionary *toolDict = [NSDictionary dictionaryWithObjectsAndKeys:eventVO.fav, @"fav", eventVO.evaluate_count, @"evaluate", eventVO.fav_count, @"favcount", nil];
            [(LMH_ToolTableViewCell *)cell layoutUI:toolDict and_home:NO];
            [(LMH_ToolTableViewCell *)cell setToolDelegate:self];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else if(section == 3){
        if (row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_SECTION3_0];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_SECTION3_0];
                
                UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 39.5, ScreenW-20,0.5)];
                lineLabel.backgroundColor = LMH_COLOR_LINE;
                [cell.contentView addSubview:lineLabel];
            }
            
            UIImageView *imgView = (UIImageView*)[cell.contentView viewWithTag:3001];
            if (!imgView) {
                imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 20, 18)];
                imgView.image = LOCAL_IMG(@"new_fav");
                imgView.tag = 3001;
                
                [cell.contentView addSubview:imgView];
            }
            
            UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:3002];
            if (!textLabel) {
                textLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+5, 0, ScreenW-CGRectGetMaxX(imgView.frame)-10, 40)];
                textLabel.font = LMH_FONT_15;
                textLabel.textColor = LMH_COLOR_BLACK;
                textLabel.tag = 3002;
                
                [cell.contentView addSubview:textLabel];
            }
            textLabel.text = [NSString stringWithFormat:@"%zi人喜欢了",[eventVO.fav_count integerValue]];
    
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_SECTION3_1];
            if (!cell) {
                cell = [[LMH_ImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_SECTION3_1];
            }
            [(LMH_ImageTableViewCell *)cell layoutUI:eventVO.fav_img];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else if(section == 4){
        if (row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_SECTION4_0];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_SECTION4_0];
                
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 20, 18)];
                imgView.image = LOCAL_IMG(@"new_coment");
                [cell.contentView addSubview:imgView];
                
                UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 39.5, ScreenW-20,0.5)];
                lineLabel.backgroundColor = LMH_COLOR_LINE;
                [cell.contentView addSubview:lineLabel];
            }
            
            UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:3002];
            if (!textLabel) {
                textLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, 0, ScreenW-33, 40)];
                textLabel.font = LMH_FONT_15;
                textLabel.textColor = LMH_COLOR_BLACK;
                textLabel.tag = 3002;
                
                [cell.contentView addSubview:textLabel];
            }
            textLabel.text = [NSString stringWithFormat:@"评论(%zi)",[eventVO.evaluate_count integerValue]];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else if(row <= (eventVO.evaluate_list.count>3?3:eventVO.evaluate_list.count)){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_SECTION4_1];
            if (!cell) {
                cell = [[LMH_ReviewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_SECTION4_1];
            }
            if (row <= eventVO.evaluate_list.count) {
                [(LMH_ReviewTableViewCell *)cell layoutUI:eventVO.evaluate_list[row-1]];
                [(LMH_ReviewTableViewCell *)cell setReviewDelegate:self];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else if(row == (eventVO.evaluate_list.count>3?4:eventVO.evaluate_list.count+1)){
            if (eventVO.evaluate_list.count <= 3) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_SECTION4_2_NONE];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_SECTION4_2_NONE];
                }
                
                return cell;
            }
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_SECTION4_2];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_SECTION4_2];
                
                UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
                [moreBtn setTitle:@"更多评论" forState:UIControlStateNormal];
                [moreBtn.titleLabel setFont:LMH_FONT_15];
                [moreBtn setTitleColor:LMH_COLOR_BLACK forState:UIControlStateNormal];
                [moreBtn setImage:LOCAL_IMG(@"new_rightrow") forState:UIControlStateNormal];
                moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                moreBtn.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
                [moreBtn addTarget:self action:@selector(pushMoreVC) forControlEvents:UIControlEventTouchUpInside];
                
//                UIEdgeInsetsMake (CGFloat top, CGFloat left, CGFloat bottom, CGFloat right);
                [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -120)];
                [moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 0)];
                
                [cell.contentView addSubview:moreBtn];
                
                UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 39.5, ScreenW-20,0.5)];
                lineLabel.backgroundColor = LMH_COLOR_LINE;
                [cell.contentView addSubview:lineLabel];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_SECTION4_3];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_SECTION4_3];
                
                textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, ScreenW-80, 30)];
                textField.placeholder = @"说点儿什么吧~";
                textField.backgroundColor = LMH_COLOR_LIGHTLINE;
                textField.font = LMH_FONT_15;
                textField.delegate = self;
                [cell.contentView addSubview:textField];
                
                UIButton *reverBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-60, 10, 50, 30)];
                [reverBtn setTitle:@"发表" forState:UIControlStateNormal];
                [reverBtn.titleLabel setFont:LMH_FONT_15];
                [reverBtn setTitleColor:LMH_COLOR_GRAY forState:UIControlStateNormal];
                reverBtn.layer.borderColor = LMH_COLOR_LINE.CGColor;
                reverBtn.layer.borderWidth = 0.5;
                [reverBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:reverBtn];
                
                UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(reverBtn.frame)+9.5, ScreenW-20, 0.5)];
                lineLabel.backgroundColor = LMH_COLOR_LINE;
                [cell.contentView addSubview:lineLabel];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else{
        if (recomArray.count <= 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_SECTION5_0];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_SECTION5_0];
            }
            
            return cell;
        }
        if (row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_SECTION5_0];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_SECTION5_0];
                
                UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenW-20, 40)];
                textLabel.font = LMH_FONT_15;
                textLabel.textColor = LMH_COLOR_BLACK;
                textLabel.text = @"热门爆款";
                [cell.contentView addSubview:textLabel];
            }
            
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_SECTION5_1];
            if (!cell) {
                cell = [[AloneProductCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_SECTION5_1];
            }
            [(AloneProductCellTableViewCell *)cell setIs_newEvent:YES];
            [(AloneProductCellTableViewCell *)cell layoutUI:recomArray[row-1] andColnum:2 is_act:NO is_type:YES];//is_type 是否显示logo
            [(AloneProductCellTableViewCell *)cell setDelegate:self];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        CGSize lineSize;
        if (eventVO.text_words) {
            lineSize = [eventVO.text_words sizeWithFont:LMH_FONT_13 constrainedToSize:CGSizeMake(ScreenW-ScreenW/6-30, 1000)];
            
            if (is_show && lineSize.height > ScreenW/12+10) {
                return lineSize.height+10;
            }else{
                return ScreenW/12+10;
            }
        }
        
        return 0;
    }else if(section == 1){
        if (row < eventArray.count-1) {
            return (ScreenW-30)/2+55;
        }else if (row == eventArray.count - 1){
            return (ScreenW-30)/2+65;
        }
        return 0;
    }else if(section == 2){
        if (row == 0) {
            if (eventVO.topic_ios.length > 0) {
                NSString *html = eventVO.topic_ios;
                NSString *content = [LMH_HtmlParase filterHTML:html];
                if (content.length <= 0) {
                    return 0;
                }
                CGSize csize = [content sizeWithFont:LMH_FONT_15 constrainedToSize:CGSizeMake(ScreenW - 10, 10000)];
                CGSize usize = [content sizeWithFont:LMH_FONT_15 constrainedToSize:CGSizeMake(10000000, 0)];
                NSInteger h = csize.height+ ((csize.height/usize.height)+1)*(usize.height/4);
                
                return h+10;
            }
            
            return 0;
        }else{
            return 40;
        }
    }else if(section == 3){
        if (row == 0) {
            return 40;
        }else{
            CGFloat offsetX = (ScreenW-20)/27;//7(图像个数)*3(占比)+6(间隔个数)=27(除去两边的空白的份数)
            CGFloat imgX = offsetX*3;
            NSInteger imgcount = eventVO.fav_img.count + 1;
            CGFloat imgH = 10+ceilf((imgcount>14?14:imgcount)/7.0)*(imgX+offsetX);
            
            return imgH;
        }
    }else if(section == 4){
        if (row == 0) {
            return 40;
        }else if(row <= (eventVO.evaluate_list.count>3?3:eventVO.evaluate_list.count)){
            CGFloat imgX = (ScreenW-20)/9;
            
            LMH_EvaluatedVO *vo = eventVO.evaluate_list[row - 1];
            if (vo.content) {
                CGSize revH = [vo.content sizeWithFont:LMH_FONT_12 constrainedToSize:CGSizeMake(ScreenW-imgX-60, 10000)];
                if (revH.height > 18) {
                    return 80;
                }else{
                    return 45+revH.height;
                }
            }
            return 0;
        }else if(row == (eventVO.evaluate_list.count>3?4:eventVO.evaluate_list.count+1) && eventVO.evaluate_list.count > 3){
            if (eventVO.evaluate_list.count > 3) {
                return 40;
            }
        }else if(row == (eventVO.evaluate_list.count>3?5:eventVO.evaluate_list.count + 2)){
            return 50;
        }
    }else{
        if (row == 0) {
            return 40;
        }else{
            if (eventVO.goods.count > 0) {
                return (ScreenW-30)/2+55;
            }
            return 0;
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 2){
        if (eventVO) {
            return 10.0;
        }
    }else if(section == 3){
        if (eventVO.fav_img.count) {
            return 10;
        }
    }else if (section == 4){
        if (eventVO) {
            return 10;
        }
    }else if (section == 5){
        if (recomArray.count > 0) {
            return 10;
        }
    }
    
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (void)pushMoreVC{
    LMH_EvaluateViewController *evaluateVC = [[LMH_EvaluateViewController alloc] initWithEventID:[NSNumber numberWithInteger:eventID] andType:1];
    evaluateVC.navigationController = self.navigationController;
    evaluateVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:evaluateVC animated:YES];
}

- (BOOL)checkLogin{
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    if (userid.length <= 0) {
        [kata_LoginViewController showInViewController:self];
        return NO;
    }
    
    return YES;
}

//收藏专场
- (void )favRequest
{
    if (![self checkLogin]) {
        return;
    }
    [self loadHUD];
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    NSMutableDictionary *paramsDict = [req params];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInteger:eventID] forKey:@"campaign_id"];
    [dict setObject:userid forKey:@"user_id"];
    [dict setObject:usertoken forKey:@"user_token"];
    
    [paramsDict setObject:dict forKey:@"params"];
    [paramsDict setObject:@"get_activity_like" forKey:@"method"];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        [self hideHUD];
        [self performSelectorOnMainThread:@selector(favResponse:) withObject:resp waitUntilDone:YES];
    } failed:^(NSError *error) {
        [self hideHUD];
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)favResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if (respDict[@"data"] != nil && ![respDict[@"data"] isEqual:[NSNull null]] && [respDict[@"data"] isKindOfClass:[NSDictionary class]]) {
                LMH_EventVO *favVO = [LMH_EventVO LMH_EventVOWithDictionary:respDict[@"data"]];
                eventVO.fav_count = favVO.fav_count;
                eventVO.fav = @1;
                eventVO.fav_img = favVO.fav_img;
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:eventVO.fav_count, @"fav_num", [NSNumber numberWithInteger:eventID], @"eventid", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE" object:nil userInfo:dict];
                
                //一个section刷新
                [self.tableView reloadData];
                [self textStateHUD:@"喜欢成功"];
                return;
            }
        }
    }
    [self textStateHUD:@"网络问题，请稍后重试"];
}

//评论
- (void )evaluateRequest
{
    if (![self checkLogin]) {
        return;
    }
    
    [self loadHUD];
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    NSMutableDictionary *paramsDict = [req params];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInteger:eventID] forKey:@"id"];
    [dict setObject:@"campaign" forKey:@"type"];
    [dict setObject:eveluateTent forKey:@"content"];
    [dict setObject:eveluatesmsID forKey:@"reply_id"];
    [dict setObject:eveluateUserid forKey:@"reply_user_id"];
    [dict setObject:userid forKey:@"user_id"];
    [dict setObject:usertoken forKey:@"user_token"];
    
    [paramsDict setObject:dict forKey:@"params"];
    [paramsDict setObject:@"add_evaluate" forKey:@"method"];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        [self hideHUD];
        [self performSelectorOnMainThread:@selector(evaluateResponse:) withObject:resp waitUntilDone:YES];
    } failed:^(NSError *error) {
        [self hideHUD];
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)evaluateResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if (respDict[@"data"] != nil && ![respDict[@"data"] isEqual:[NSNull null]] && [respDict[@"data"] isKindOfClass:[NSDictionary class]]) {
                LMH_EventVO *eVO = [LMH_EventVO LMH_EventVOWithDictionary:respDict[@"data"]];
                eventVO.evaluate_count = eVO.evaluate_count;
                eventVO.evaluate_list = eVO.evaluate_list;
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:eventVO.evaluate_count, @"eve_num", [NSNumber numberWithInteger:eventID], @"eventid", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE" object:nil userInfo:dict];
                
                keyView.textField.text = @"";
                textField.text = @"";
                
                [self.tableView reloadData];
                [self textStateHUD:@"评论成功"];
                return;
            }
        }
    }
    [self textStateHUD:@"网络问题，请稍后重试"];
}

//发送评论
- (void)sendClick{
    [textField resignFirstResponder];
    [keyView.textField resignFirstResponder];
    
    eveluateTent = textField.text;
    eveluateTent =[eveluateTent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //过滤中间空格
    eveluateTent = [eveluateTent stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (eveluateTent.length > 0) {
        eveluateTent = textField.text;
    }else{
        return;
    }
    eveluateUserid = @0;
    eveluatesmsID = @0;
    
    [self evaluateRequest];
}

#pragma mark - 专场描述按钮点击后的代理
- (void)downShow{
    is_show = YES;
    //一个section刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - 商品推荐内容点击后的代理
- (void)pushProduct:(NSInteger)productID{
    // 商品详情
    kata_ProductDetailViewController *vc = [[kata_ProductDetailViewController alloc] initWithProductID:productID andType:nil andSeckillID:-1];
    vc.navigationController = self.navigationController;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 工具按钮点击后的代理
- (void)toolClick:(NSInteger)index andVO:(CampaignVO *)camvo{
    keyView.hidden = YES;
    [keyView.textField resignFirstResponder];
    [textField resignFirstResponder];
    
    if (index == 1) {
        if ([eventVO.fav boolValue]) {
            return;
        }
        [self favRequest];
    }else if (index == 2){
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4] animated:YES scrollPosition:UITableViewScrollPositionTop];
        [textField becomeFirstResponder];
    }else if (index == 3){
        [self shareBtn];
    }
    NSLog(@"toolindex = %zi",index);
}

#pragma mark - 回复按钮点击后的代理
- (void)sendSms:(LMH_EvaluatedVO *)evaVO{
    textField.text = @"";
    keyView.hidden = NO;
    [keyView.textField becomeFirstResponder];
    
    eveluateUserid = evaVO.reply_user_id?evaVO.reply_user_id:@0;
    eveluatesmsID = evaVO.evaluaid?evaVO.evaluaid:@0;
}

#pragma mark - 信息发送按钮点击后的代理
- (void)keySendSms:(NSString *)smsInfo{
    keyView.hidden = YES;
    [keyView.textField resignFirstResponder];
    [textField resignFirstResponder];
    
    eveluateTent = keyView.textField.text;
    eveluateTent =[eveluateTent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //过滤中间空格
    eveluateTent = [eveluateTent stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (eveluateTent.length > 0) {
        eveluateTent = keyView.textField.text;
    }else{
        return;
    }
    [self evaluateRequest];
}

- (void)keyHeight:(CGFloat)height{
    CGRect frame = vFrame;
    if (textField.isFirstResponder || keyView.textField.isFirstResponder) {
        frame.size.height -= height;
    }
    self.tableView.frame = frame;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    keyView.textField.text = @"";
    keyView.hidden = YES;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (textField.isFirstResponder) {
        return;
    }
    keyView.hidden = YES;
    [keyView.textField resignFirstResponder];
    
    self.tableView.frame = vFrame;
}

- (void) keyboardWasShow:(NSNotification *) notif{
    NSDictionary *info = [notif userInfo];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat hOffset = endKeyboardRect.size.height;
    
    [self keyHeight:hOffset];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    keyView.hidden = YES;
    [keyView.textField resignFirstResponder];
    [textField resignFirstResponder];
    
    self.tableView.frame = vFrame;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - AloneProductCellTableViewCell Delegate
- (void)tapAtItem:(HomeProductVO *)vo
{
    keyView.hidden = YES;
    [keyView.textField resignFirstResponder];
    [textField resignFirstResponder];
    
    if(![vo.source_platform isEqualToString:@"lamahui"]){
        kata_WebViewController *webVC = [[kata_WebViewController alloc] initWithUrl:vo.click_url title:nil andType:vo.source_platform];
        webVC.navigationController = self.navigationController;
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }else{
        // 商品详情
        kata_ProductDetailViewController *vc = [[kata_ProductDetailViewController alloc] initWithProductID:[vo.product_id integerValue] andType:nil andSeckillID:-1];
        vc.navigationController = self.navigationController;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)pushUser:(NSString *)user_url{
    kata_WebViewController *webVC = [[kata_WebViewController alloc] initWithUrl:user_url title:nil andType:@"lamahui"];
    webVC.navigationController = self.navigationController;
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)shareBtn{
    keyView.hidden = YES;
    [keyView.textField resignFirstResponder];
    [textField resignFirstResponder];
    
    if (shareURL) {
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        shareTent = [NSString stringWithFormat:@"%@%@",shareTent,shareURL];
    }else{
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeText;
    }
    
    [UMSocialData defaultData].extConfig.qqData.url = shareURL;
    [UMSocialData defaultData].extConfig.qzoneData.url = shareURL;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = shareURL;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareURL;
    [UMSocialData defaultData].extConfig.title = eventVO.title;
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APPKEY
                                      shareText:shareTent
                                     shareImage:nil
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToSina,UMShareToSms,nil]
                                       delegate:self];
}

//登陆后的委托
- (void)didLogin{
    
}

- (void)loginCancel{

}

@end

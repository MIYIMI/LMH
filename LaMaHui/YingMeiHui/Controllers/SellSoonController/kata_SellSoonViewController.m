//
//  kata_SellSoonViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-31.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_SellSoonViewController.h"
#import "KTSellsoonListDataGetRequest.h"
#import "KTSubscribePostRequest.h"
#import "SellsoonSectionListVO.h"

#define TABLE_COLOR         [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1]

@interface kata_SellSoonViewController ()
{
    NSInteger _menuid;
    UIBarButtonItem *_menuItem;
    UIView *_headerView;
    BOOL _subscribedFlag;
}

@end

@implementation kata_SellSoonViewController

- (id)initWithMenuID:(NSInteger)menuid
            andTitle:(NSString *)title
              isRoot:(BOOL)isroot
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        self.ifShowTableSeparator = NO;
        self.isCountingRows = NO;
        _menuid = menuid;
        _isroot = isroot;
        self.title = title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self loadNewer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI
{
    if (_isroot) {
        [self setupLeftMenuButton];
    }
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.pullToRefreshView setBackgroundColor:TABLE_COLOR];
}

-(void)setupLeftMenuButton
{
    if (!_menuItem) {
        UIButton * menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuBtn setFrame:CGRectMake(0, 0, 20, 27)];
        UIImage *image = [UIImage imageNamed:@"menubtn"];
        [menuBtn setImage:image forState:UIControlStateNormal];
        //[menuBtn addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
        _menuItem = menuItem;
    }
    [self.navigationController addLeftBarButtonItem:_menuItem animation:NO];
}

- (KTBaseRequest *)request
{
    //KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    KTSellsoonListDataGetRequest *req = [[KTSellsoonListDataGetRequest alloc] initWithMenuID:_menuid];
    return req;
}

- (NSArray *)parseResponse:(NSString *)resp
{
    NSArray *objArr = nil;
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if ([respDict objectForKey:@"data"] != nil && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]]) {
                id dataObj = [respDict objectForKey:@"data"];
                
                if ([dataObj isKindOfClass:[NSDictionary class]]) {
                    SellsoonSectionListVO *listVO = [SellsoonSectionListVO SellsoonSectionListVOWithDictionary:dataObj];
                    
                    if ([listVO.Code intValue] == 0) {
                        objArr = listVO.SellsoonSectionList;
                        [self performSelectorOnMainThread:@selector(setTableHeaderView) withObject:nil waitUntilDone:YES];
                        
                        if (self.max == -1) {
                            self.max = 0;
                            if (self.max == 0) {
                                self.max = 1;
                            }
                        }
                    } else {
                        //listVO.Msg
                        self.statefulState = FTStatefulTableViewControllerError;
                    }
                } else {
                    self.statefulState = FTStatefulTableViewControllerError;
                }
            } else {
                self.statefulState = FTStatefulTableViewControllerError;
            }
        } else {
            self.statefulState = FTStatefulTableViewControllerError;
        }
    } else {
        self.statefulState = FTStatefulTableViewControllerError;
    }
    
    return objArr;
}

- (void)setTableHeaderView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40)];
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:_headerView.frame];
        titleLbl.backgroundColor = TABLE_COLOR;
        titleLbl.font = [UIFont boldSystemFontOfSize:12.3];
        titleLbl.textColor = [UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:1];
        titleLbl.textAlignment = NSTextAlignmentCenter;
        titleLbl.lineBreakMode = NSLineBreakByTruncatingTail;
        titleLbl.numberOfLines = 1;
        titleLbl.text = @"马上订阅您喜爱的品牌，开售当天通知您";
        [_headerView addSubview:titleLbl];
        
        UIImageView *clock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titleclock"]];
        [clock setFrame:CGRectMake(32, 5, 22, 24)];
        [_headerView addSubview:clock];
        
        UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fadeline"]];
        [line setFrame:CGRectMake(0, 37, 320, 1)];
        [_headerView addSubview:line];
    }
    [self.tableView setTableHeaderView:_headerView];
}

- (UIView *)idleView
{
    UIView *idleview = [[UIView alloc] initWithFrame:self.tableView.frame];
    [idleview setBackgroundColor:TABLE_COLOR];
    UILabel *barLbl = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 2, CGRectGetHeight(idleview.frame))];
    [barLbl setBackgroundColor:[UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1]];
    [idleview addSubview:barLbl];
    
    return idleview;
}

#pragma mark -
#pragma tableView delegate && datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id vo = [self.listData objectAtIndex:section];
    if ([vo isKindOfClass:[SellsoonSectionVO class]]) {
        SellsoonSectionVO *sectionVO = (SellsoonSectionVO *)vo;
        return ceil((CGFloat)sectionVO.SellsoonList.count / 2.0);
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    static NSString *CELL_IDENTIFI = @"CATEINFO_CELL";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFI];
    if (!cell) {
        cell = [[KTSellsoonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFI];
    }
    
    id vo = [self.listData objectAtIndex:section];
    if ([vo isKindOfClass:[SellsoonSectionVO class]]) {
        SellsoonSectionVO *sectionVO = (SellsoonSectionVO *)vo;
        
        NSMutableArray *cellArr = [[NSMutableArray alloc] init];
        if ([sectionVO.SellsoonList objectAtIndex:row * 2] && [[sectionVO.SellsoonList objectAtIndex:row * 2] isKindOfClass:[SellsoonbrandVO class]]) {
            [cellArr addObject:[sectionVO.SellsoonList objectAtIndex:row * 2]];
        }
        
        if (sectionVO.SellsoonList.count > row * 2 + 1) {
            if ([sectionVO.SellsoonList objectAtIndex:row * 2 + 1] && [[sectionVO.SellsoonList objectAtIndex:row * 2 + 1] isKindOfClass:[SellsoonbrandVO class]]) {
                [cellArr addObject:[sectionVO.SellsoonList objectAtIndex:row * 2 + 1]];
            }
        }
        
        [(KTSellsoonTableViewCell *)cell setSellsoonDataArr:cellArr];
        [(KTSellsoonTableViewCell *)cell setSellsoonCellDelegate:self];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 168.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat w = self.view.bounds.size.width;
    CGFloat originx = 20;
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 40)];
    [header setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *roundpoint = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"roundpoint"]];
    [roundpoint setFrame:CGRectMake(2, 8, 14, 14)];
    [header addSubview:roundpoint];
    
    id vo = [self.listData objectAtIndex:section];
    if ([vo isKindOfClass:[SellsoonSectionVO class]]) {
        SellsoonSectionVO *sectionVO = (SellsoonSectionVO *)vo;
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        [titleLbl setBackgroundColor:[UIColor clearColor]];
        [titleLbl setFont:[UIFont systemFontOfSize:13.0]];
        [titleLbl setTextColor:[UIColor blackColor]];
        [titleLbl setTextAlignment:NSTextAlignmentRight];
        [titleLbl setNumberOfLines:1];
        [titleLbl setLineBreakMode:NSLineBreakByClipping];
        if (sectionVO.Title) {
            titleLbl.text = sectionVO.Title;
            CGSize titleSize = [titleLbl.text sizeWithFont:titleLbl.font];
            [titleLbl setFrame:CGRectMake(originx, 0, titleSize.width + 10, 37)];
        }
        
        UILabel *tipLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        [tipLbl setBackgroundColor:[UIColor clearColor]];
        [tipLbl setFont:[UIFont systemFontOfSize:13.0]];
        [tipLbl setTextColor:[UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:1]];
        [tipLbl setTextAlignment:NSTextAlignmentCenter];
        [tipLbl setNumberOfLines:1];
        [tipLbl setLineBreakMode:NSLineBreakByClipping];
        if (sectionVO.TitleTip) {
            tipLbl.text = sectionVO.TitleTip;
            CGSize tipSize = [tipLbl.text sizeWithFont:tipLbl.font];
            [tipLbl setFrame:CGRectMake(CGRectGetMaxX(titleLbl.frame), 0, tipSize.width + 10, 37)];
        }
        
        UIImage *image = [UIImage imageNamed:@"dialogbg"];
        image = [image stretchableImageWithLeftCapWidth:15.0f topCapHeight:15.0f];
        UIImageView *dialogbg = [[UIImageView alloc] initWithImage:image];
        [dialogbg setFrame:CGRectMake(originx, 4, CGRectGetMaxX(tipLbl.frame) - originx + 4, 32)];
        [header addSubview:dialogbg];
        
        [header addSubview:titleLbl];
        [header addSubview:tipLbl];
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

#pragma mark - KTSellsoonTableViewCell Delegate
- (void)tapAtBrand:(NSInteger)brandid andIsSubscribed:(BOOL)subscribed
{
    [self SubscribeOperation:brandid andSubscribed:subscribed];
}

- (void)SubscribeOperation:(NSInteger)brandid andSubscribed:(BOOL)subscribed
{
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
        stateHud.delegate = self;
        [self.contentView addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeIndeterminate;
    [stateHud show:YES];
    
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    if (brandid != -1) {
        req = [[KTSubscribePostRequest alloc] initWithBrandID:brandid
                                                      andType:(subscribed?@"delete":@"add")];
        _subscribedFlag = subscribed;
    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(subscribeParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        NSString *hudPrefixStr = _subscribedFlag?@"取消订阅":@"订阅";
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)subscribeParseResponse:(NSString *)resp
{
    NSString *hudPrefixStr = _subscribedFlag?@"取消订阅":@"订阅";
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if (nil != [respDict objectForKey:@"data"] && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]] && [[respDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dataObj = (NSDictionary *)[respDict objectForKey:@"data"];
                if ([[dataObj objectForKey:@"code"] integerValue] == 0) {
                    
                    id messageObj = [dataObj objectForKey:@"msg"];
                    if (messageObj) {
                        if ([messageObj isKindOfClass:[NSString class]] && ![messageObj isEqualToString:@""]) {
                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:messageObj waitUntilDone:YES];
                        } else {
                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"成功"] waitUntilDone:YES];
                        }
                    } else {
                        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"成功"] waitUntilDone:YES];
                    }
                    [self loadNoState];
                    
                } else {
                    id messageObj = [dataObj objectForKey:@"msg"];
                    if (messageObj) {
                        if ([messageObj isKindOfClass:[NSString class]] && ![messageObj isEqualToString:@""]) {
                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:messageObj waitUntilDone:YES];
                        } else {
                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
                        }
                    } else {
                        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
                    }
                }
            } else {
                [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
            }
        } else {
            id messageObj = [respDict objectForKey:@"msg"];
            if (messageObj) {
                if ([messageObj isKindOfClass:[NSString class]] && ![messageObj isEqualToString:@""]) {
                    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:messageObj waitUntilDone:YES];
                } else {
                    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
                }
            } else {
                [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
            }
        }
    } else {
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
    }
}

@end

//
//  kata_AdressListTableViewController.m
//  YingMeiHui
//
//  Created by work on 14-7-23.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_AdressListTableViewController.h"
#import "KTAddressRegionInfoGetRequest.h"
#include "KTProxy.h"
#import "kata_AddressEditViewController.h"
#import "LMHMybabyViewController.h"

@interface kata_AdressListTableViewController ()
{
    UITableView *mytableview;
    NSDictionary *adressName;
    NSNumber *_regionPid;
    NSArray *_regionArr;
    NSInteger _addressid;
    NSString *_regionFlag;
    MBProgressHUD *stateHud;
    NSString *unitAdrr;
    NSMutableArray *Adrr;
    NSMutableArray *paraArr;
    UIView *_netErrView;
    NSString *titleStr;
}

@end

@implementation kata_AdressListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
          andRegion:(NSString*)regionFlag
       andRegionPid:(NSNumber*)regionPid
          andAddres:(NSMutableArray*)adress
{
    self = [super init];
    if (self) {
        // Custom initialization
        Adrr = [[NSMutableArray alloc] init];
        Adrr = adress;
        _regionPid = regionPid;
        _regionFlag = regionFlag;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    mytableview = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    // 设置tableView的数据源
    mytableview.dataSource = self;
    // 设置tableView的委托
    mytableview.delegate = self;
    
    [self setExtraCellLineHidden:mytableview];
    if ([mytableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [mytableview setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_regionFlag isEqualToString: @"province"])
    {
        self.title = @"请选择省份";
    }
    else if([_regionFlag isEqualToString: @"city"])
    {
         self.title = @"请选择城市";
    }
    else
    {
        self.title = @"请选择地区";
    }
    
    titleStr = self.title;
    
    [self regionOperation];
    paraArr = [[NSMutableArray alloc] init];
    
    CGRect rect = self.contentView.frame;
    mytableview.frame = rect;
    [self.view addSubview:mytableview];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectAddr) name:@"addrSelect" object:nil];
}

- (void)selectAddr
{
    if ([titleStr isEqualToString:@"请选择省份"]) {
        _regionFlag = @"province";
        _regionPid = 0;
    }
    else if ([titleStr isEqualToString:@"请选择城市"])
    {
        _regionFlag = @"city";
    }
}

//去掉多余的分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (_regionArr.count == 0)
    {
        mytableview.scrollEnabled = NO;
    }
    else
    {
        mytableview.scrollEnabled = YES;
    }
    return _regionArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellWithIdentifier];
        if(![_regionFlag isEqualToString: @"country"])
        {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    cell.textLabel.text = [[_regionArr objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addrSelect" object:nil userInfo:nil];
    _regionPid = [[_regionArr objectAtIndex:indexPath.row] objectForKey:@"code"];

    unitAdrr = [[_regionArr objectAtIndex:indexPath.row] objectForKey:@"name"];
    if ([_regionFlag isEqualToString: @"province"])
    {
        _regionFlag = @"city";
        [Adrr replaceObjectAtIndex:0 withObject:unitAdrr];
        kata_AdressListTableViewController *addressControlVC = [[kata_AdressListTableViewController alloc] initWithStyle:UITableViewStylePlain andRegion:_regionFlag andRegionPid:_regionPid andAddres:Adrr];
        addressControlVC.navigationController = self.navigationController;
        [self.navigationController pushViewController:addressControlVC animated:YES];
    }
    else if([_regionFlag isEqualToString: @"city"])
    {
        _regionFlag = @"country";
        [Adrr replaceObjectAtIndex:1 withObject:unitAdrr];
        kata_AdressListTableViewController *addressControlVC = [[kata_AdressListTableViewController alloc] initWithStyle:UITableViewStylePlain andRegion:_regionFlag andRegionPid:_regionPid andAddres:Adrr];
        addressControlVC.navigationController = self.navigationController;
        [self.navigationController pushViewController:addressControlVC animated:YES];
    }
    else if([_regionFlag isEqualToString: @"country"])
    {
        _regionFlag = @"";
        [Adrr replaceObjectAtIndex:2 withObject:unitAdrr];
        
        //消息通知传递参数
        [paraArr addObject:_regionPid];
        //NSString *addstr = [NSString stringWithFormat:@"%@/%@/%@",Adrr[0],Adrr[1],Adrr[2]];
        [paraArr addObjectsFromArray:Adrr];
        NSDictionary *dict;
        dict = [NSDictionary dictionaryWithObjectsAndKeys:paraArr,@"para",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"backEditView" object:nil userInfo:dict];
        
        //返回编辑地址页或新增地址页 或 我的宝宝页
        for (UIViewController *temp in self.navigationController.viewControllers)
        {
            if ([temp isKindOfClass:[kata_AddressEditViewController class]] || [temp isKindOfClass:[LMHMybabyViewController class]])
            {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
    }

}

#pragma mark - RegionRequest
- (void)regionOperation
{
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
        stateHud.delegate = self;
        [mytableview addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeIndeterminate;
    stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
    [stateHud show:YES];
    
    KTAddressRegionInfoGetRequest *req = [[KTAddressRegionInfoGetRequest alloc] initWithCode:[_regionPid intValue]];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(regionParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        [self performSelector:@selector(errView) withObject:nil afterDelay:0.5];
    }];
    
    [proxy start];
}

- (void)regionParseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            id dataObj = [respDict objectForKey:@"data"];
            
            if ([[dataObj objectForKey:@"code"] intValue] == 0) {
                if ([dataObj objectForKey:@"region_list"]) {
                    if ([[dataObj objectForKey:@"region_list"] isKindOfClass:[NSArray class]]) {
                        
                        _regionArr = (NSArray *)[dataObj objectForKey:@"region_list"];
                        [stateHud hide:YES afterDelay:0.2];
                        [mytableview reloadData];
                    } else {
                        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"地区信息载入失败" waitUntilDone:YES];
                    }
                } else {
                    [self errView];
                    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"地区信息为空" waitUntilDone:YES];
                }
            } else {
                id messageObj = [dataObj objectForKey:@"msg"];
                if (messageObj && [messageObj isKindOfClass:[NSString class]]) {
                    if (![messageObj isEqualToString:@""]) {
                        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:messageObj waitUntilDone:YES];
                    } else {
                        [self errView];
                        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"地区信息载入失败" waitUntilDone:YES];
                    }
                } else {
                    [self errView];
                    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"地区信息载入失败" waitUntilDone:YES];
                }
            }
        } else {
            id messageObj = [respDict objectForKey:@"msg"];
            if (messageObj && [messageObj isKindOfClass:[NSString class]]) {
                if (![messageObj isEqualToString:@""]) {
                    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:messageObj waitUntilDone:YES];
                } else {
                    [self errView];
                    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"地区信息载入失败" waitUntilDone:YES];
                }
            } else {
                [self errView];
                [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"地区信息载入失败" waitUntilDone:YES];
            }
        }
    } else {
        [self errView];
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"地区信息载入失败" waitUntilDone:YES];
    }
}

//网络错误加载该视图
- (void)errView
{
    _netErrView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    CGFloat w = _netErrView.frame.size.width;
    CGFloat h = _netErrView.frame.size.height;
    
    [_netErrView setBackgroundColor:[UIColor lightGrayColor]];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"neterror"]];
    [image setFrame:CGRectMake((w - CGRectGetWidth(image.frame)) / 2, h/2 - CGRectGetHeight(image.frame), CGRectGetWidth(image.frame), CGRectGetHeight(image.frame))];
    [_netErrView addSubview:image];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, h/2 + 10, w, 34)];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setNumberOfLines:2];
    [lbl setTextColor:[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1]];
    [lbl setFont:[UIFont systemFontOfSize:14.0]];
    [lbl setText:@"网络抛锚\r\n请检查网络后点击屏幕重试！"];
    [_netErrView addSubview:lbl];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen)];
    [_netErrView addGestureRecognizer:tapGesture];
    
    [self.view addSubview:_netErrView];
    [stateHud removeFromSuperview];
}

- (void)tapScreen
{
    [_netErrView removeFromSuperview];
    [self regionOperation];
}

- (void)textStateHUD:(NSString *)text
{
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
        stateHud.delegate = self;
        [mytableview addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeText;
    stateHud.labelText = text;
    stateHud.labelFont = [UIFont systemFontOfSize:13.0f];
    [stateHud show:YES];
    [stateHud hide:YES afterDelay:1.0];
}

#pragma mark - MBProgressHUD Delegate
- (void)hudWasHidden:(MBProgressHUD *)ahud
{
	[stateHud removeFromSuperview];
	stateHud = nil;
}

@end

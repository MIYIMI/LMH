//
//  kata_QAListViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-7-3.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_QAListViewController.h"
#import "KTQAListGetRequest.h"
#import "QAListVO.h"
#import "KTQAContentTableViewCell.h"

@interface kata_QAListViewController ()
{
    NSMutableArray *_flodArr;
    UIView *_headerView;
}

@end

@implementation kata_QAListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        self.ifAddPullToRefreshControl = NO;
        self.ifShowTableSeparator = NO;
        _flodArr = [[NSMutableArray alloc] init];
        self.title = @"常见问题";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    if (!_headerView) {
        CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 45)];
        [_headerView setBackgroundColor:[UIColor clearColor]];
        
        UILabel *tipLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, w - 20, 17)];
        [tipLbl setBackgroundColor:[UIColor clearColor]];
        [tipLbl setFont:[UIFont systemFontOfSize:11.0]];
        [tipLbl setTextAlignment:NSTextAlignmentLeft];
        [tipLbl setTextColor:[UIColor colorWithRed:0.98 green:0.3 blue:0.4 alpha:1]];
        [tipLbl setText:@"客服温馨提示"];
        
        UILabel *tip2Lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(tipLbl.frame), 171, 17)];
        [tip2Lbl setBackgroundColor:[UIColor clearColor]];
        [tip2Lbl setFont:[UIFont systemFontOfSize:10.0]];
        [tip2Lbl setTextAlignment:NSTextAlignmentLeft];
        [tip2Lbl setTextColor:[UIColor blackColor]];
        [tip2Lbl setText:@"为了减少您可能的等待时间，建议您先"];
        
        UILabel *tip3Lbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tip2Lbl.frame), CGRectGetMinY(tip2Lbl.frame), 124, 17)];
        [tip3Lbl setBackgroundColor:[UIColor clearColor]];
        [tip3Lbl setFont:[UIFont systemFontOfSize:10.0]];
        [tip3Lbl setTextAlignment:NSTextAlignmentLeft];
        [tip3Lbl setTextColor:[UIColor colorWithRed:0.98 green:0.3 blue:0.4 alpha:1]];
        [tip3Lbl setText:@"仔细阅读下面的常见问题"];
        
        [_headerView addSubview:tipLbl];
        [_headerView addSubview:tip2Lbl];
        [_headerView addSubview:tip3Lbl];
    }
}

#pragma mark - stateful tableview datasource && stateful tableview delegate
//stateful表格的数据和委托
//////////////////////////////////////////////////////////////////////////////////
- (KTBaseRequest *)request
{
    //KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    KTQAListGetRequest *req = [[KTQAListGetRequest alloc] initWithNone];
    
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
                    QAListVO *listVO = [QAListVO QAListVOWithDictionary:dataObj];
                    
                    if ([listVO.Code intValue] == 0) {
                        objArr = listVO.QAList;
                        [self.tableView performSelectorOnMainThread:@selector(setTableHeaderView:) withObject:_headerView waitUntilDone:YES];
                        
                        for (NSInteger i = 0; i < listVO.QAList.count; i++) {
                            [_flodArr addObject:[NSNumber numberWithBool:NO]];
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
    } else {
        self.statefulState = FTStatefulTableViewControllerError;
    }
    
    return objArr;
}

#pragma mark -
#pragma tableView delegate && datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[_flodArr objectAtIndex:section] boolValue]) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (row == 0) {
        static NSString *CELL_IDENTIFI = @"QAINFO_CELL";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFI];
        
        CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, w - 20, 27)];
        [titleLbl setBackgroundColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1]];
        [titleLbl setFont:[UIFont systemFontOfSize:12.0]];
        [titleLbl setTextAlignment:NSTextAlignmentLeft];
        [cell.contentView addSubview:titleLbl];
        
        id vo = [self.listData objectAtIndex:section];
        if ([vo isKindOfClass:[QAInfoVO class]]) {
            QAInfoVO *qaVO = (QAInfoVO *)vo;
            [titleLbl setText:[NSString stringWithFormat:@" %zi) %@", section, qaVO.QATitle]];
        }
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    } else if (row == 1) {
        static NSString *CONTENT_IDENTIFI = @"QACONTENT_CELL";
        KTQAContentTableViewCell *cell = [[KTQAContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CONTENT_IDENTIFI];
        id vo = [self.listData objectAtIndex:section];
        if ([vo isKindOfClass:[QAInfoVO class]]) {
            QAInfoVO *qaVO = (QAInfoVO *)vo;
            [cell setQaContent:qaVO.QAContent];
        }
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (row == 0) {
        return 37;
    } else if (row == 1) {
        id vo = [self.listData objectAtIndex:section];
        if ([vo isKindOfClass:[QAInfoVO class]]) {
            QAInfoVO *qaVO = (QAInfoVO *)vo;
            CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
            CGSize contentSize = [qaVO.QAContent sizeWithFont:[UIFont systemFontOfSize:11.0] constrainedToSize:CGSizeMake(w - 34, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            
            return contentSize.height + 14;
        }
        return 0;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (row == 0) {
        if ([[_flodArr objectAtIndex:section] boolValue]) {
            [_flodArr setObject:[NSNumber numberWithBool:NO] atIndexedSubscript:section];
        } else {
            for (NSInteger i = 0; i < _flodArr.count; i++) {
                if ([[_flodArr objectAtIndex:i] boolValue]) {
                    [_flodArr replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
                    break;
                }
            }
            [_flodArr setObject:[NSNumber numberWithBool:YES] atIndexedSubscript:section];
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.listData.count)] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end

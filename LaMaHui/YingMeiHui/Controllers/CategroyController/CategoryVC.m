//
//  CategoryVC.m
//  YingMeiHui
//
//  Created by KevinKong on 14-9-19.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "CategoryVC.h"
#import "CategroyTableCell.h"
#import "KTBrandlistDataGetRequest.h"
#import "CategoryDataModel.h"
#import "CategoryDetailVC.h"
#import "kata_CategoryViewController.h"

@interface CategoryVC ()<CategroyTableCellDelegate>{
    NSString *dataFlag;
}

@end

@implementation CategoryVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init{
    if (self=[super init]) {
        self.ifAddPullToRefreshControl=YES;
        self.ifShowTableSeparator = YES;
    }
    return self;
}

-(void)loadView{
    [super loadView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self  createUI];
    [self  loadNewer];
    self.tableView.backgroundColor=[UIColor clearColor];
    CGRect tableFrame =  self.tableView.frame;
    tableFrame.size.height-=44;
    tableFrame.size.width -= 100;

    self.tableView.frame=tableFrame;
    self.tableView.layer.borderColor = [[UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1] CGColor];
    self.tableView.layer.borderWidth = 0.5;
    if (!self.listData) {
        self.listData=[NSMutableArray array];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark overwrite super methods
-(UIView *)emptyView{
    return nil;// 不需要？
}

- (KTBaseRequest *)request
{
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    NSMutableDictionary *paramsDict = [req params];
    [paramsDict setObject:@"get_category_list" forKey:@"method"];
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
                    if ([[dataObj objectForKey:@"cate_list"] isKindOfClass:[NSArray class]]) {
                        objArr = [CategoryDataModel CategoryDataModelWithArray:[dataObj objectForKey:@"cate_list"]];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.listData.count > 0) {
        return [self.listData[section] cate_son].count;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CategoryDataModel *model = self.listData[section];
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 20)];
    sectionView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    
    UILabel *tiltleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenW-15, 20)];
    [tiltleLbl setText:model.title];
    [tiltleLbl setTextColor:[UIColor whiteColor]];
    [tiltleLbl setFont:FONT(16.0)];
    [tiltleLbl setBackgroundColor:[UIColor clearColor]];
    [sectionView addSubview:tiltleLbl];
    
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *categoryCellIdentifer = @"CategroyIdentifer";
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryCellIdentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:categoryCellIdentifer];
    }
    CategoryDataModel *dataModel = [[(CategoryDataModel*)self.listData[section] cate_son] objectAtIndex:row];
    [cell.textLabel setText:dataModel.title];
    [cell.textLabel setFont:FONT(15.0)];
    cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    [cell.textLabel setTextColor:[UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    [[(kata_AppDelegate *)[[UIApplication sharedApplication] delegate] deckController] closeRightViewAnimated:YES];
    CategoryDataModel *dataModel = [[(CategoryDataModel*)self.listData[section] cate_son] objectAtIndex:row];
    dataFlag = [self.listData[section] flag];
    CategoryDetailVC *detailVC = [[CategoryDetailVC alloc] initWithPid:dataModel.pid withCateID:dataModel.cate_id withFlag:dataFlag];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.navigationItem.title = dataModel.title;
    detailVC.navigationController = self.navigationController;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark -
#pragma mark helper methods
-(CategoryDataModel *)getCategroyModelWithRowIndex:(NSInteger)index{
    if (index < self.listData.count) {
        return [self.listData objectAtIndex:index];
    }
    return nil;
}
#pragma mark -
#pragma mark CategroyTableCellDeleate Methods
-(void)CategroyTableCell:(CategroyTableCell *)tableCell selectedRowIndexPath:(NSIndexPath *)indexPath didSelectBtnIndex:(NSInteger)index{
    [self pushProductListVCWithIndexPath:indexPath withIndex:index];
}

-(void)pushProductListVCWithIndexPath:(NSIndexPath *)indexPath withIndex:(NSInteger)index{
    CategoryDataModel *dataModel = [self getCategroyModelWithRowIndex:indexPath.row];
    NSNumber *pid =nil;
    NSNumber *cateId =nil;
    NSString *flag =nil;
    NSString *title=@"";
    if (dataModel) {
        if ([dataModel.flag isEqualToString:@"category"]) {
            // next to push child viewcontroller.
            pid = dataModel.pid;
            cateId = dataModel.cate_id;
            flag = dataModel.flag;

        }else{
            //
            NSInteger tempIndex = index;
            if (tempIndex==-1) {
                tempIndex = dataModel.cate_son.count-1;
                CategoryDataModel *childDataModel = [dataModel.cate_son objectAtIndex:tempIndex];
                if (childDataModel) {
                    // push
                    pid = childDataModel.pid;
                    cateId = [NSNumber numberWithInteger:0];
                    flag = childDataModel.flag;
                }
            }else{
                CategoryDataModel *childDataModel = [dataModel.cate_son objectAtIndex:tempIndex];
                if (childDataModel) {
                    // push
                    pid = childDataModel.pid;
                    cateId = childDataModel.cate_id;
                    flag = childDataModel.flag;
                    title = childDataModel.title;
                }
            }
        }
        title = [dataModel.title stringByAppendingString:title];
        
    }

    if (pid!=nil && cateId!=nil && flag !=nil) {
        CategoryDetailVC *detailVC = [[CategoryDetailVC alloc] initWithPid:pid withCateID:cateId withFlag:flag];
        detailVC.navigationItem.title = title;
        detailVC.navigationController = self.navigationController;
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}

//-(void)test{
//    NSURL *url = [NSURL URLWithString:@"http://api-base-url.com"];
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
//    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"时间背景框.ong"], 0.5);
//    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/upload" parameters:nil constructingBodyWithBlock: ^(id formData) {
//        [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
//    }];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
//    }];
//    [operation start];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@" cacacaca .. success ?");
//    }
//                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                         NSLog(@" failed ...");
//                                     }];
//}
@end

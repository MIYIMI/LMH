//
//  BrandVC.m
//  YingMeiHui
//
//  Created by KevinKong on 14-9-19.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "BrandVC.h"
#import "BrandVO.h"
#import "kata_ProductListViewController.h"
#pragma mark -
#pragma mark section index views

@class BrandSectionIndexV;
@protocol BrandSectionIndexVDelegate <NSObject>

-(void)BrandSectionIndexV:(BrandSectionIndexV *)indexV didSelectedIndex:(NSInteger)index;

@end
@interface BrandSectionIndexV : UIScrollView
{
    NSArray *dataArray;
}
@property (nonatomic,strong) id<BrandSectionIndexVDelegate> indexDelegate;
-(void)setDatas:(NSArray *)datas;
@end

@implementation BrandSectionIndexV
@synthesize indexDelegate;
-(id)init{
    if (self =[super init]) {
        self.alpha = 0.7;
    }
    return self;
}
-(void)setDatas:(NSArray *)datas{
    dataArray=datas;
    if (datas) {
        NSInteger itemCount = self.subviews.count;
        NSInteger currentCount = datas.count;
        NSInteger maxCount = MAX(itemCount, currentCount);
        NSInteger tagIdentifer = 1000;
        CGFloat maxHeight = 0;
        for (NSInteger i = 0;i<maxCount ; i++) {
            NSInteger tempTag = tagIdentifer +i;
            UIButton *tempBtn = (UIButton *)[self viewWithTag:tempTag];
            if (i<currentCount) {
            NSString *str = [datas objectAtIndex:i];
                if (!tempBtn) {
                    tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [tempBtn setTitleColor:UIColorRGBA(243, 50, 84, 1) forState:UIControlStateNormal];
                    tempBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
                    [tempBtn setTag:tempTag];
                    [tempBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [self addSubview:tempBtn];
                }
                tempBtn.frame = [self getBtnFrameWithIndex:i];
                if (i==currentCount-1) {
                    maxHeight=CGRectGetMaxY(tempBtn.frame);
                }

                [tempBtn setTitle:str forState:UIControlStateNormal];
            }else{
                if (tempBtn) {
                    [tempBtn removeFromSuperview];
                }
            }
        }
        maxHeight = MAX(CGRectGetHeight(self.frame), maxHeight);
        self.contentSize=CGSizeMake(CGRectGetWidth(self.frame), maxHeight);
    }
}
#pragma mark -
#pragma mark layout item frame
-(CGFloat )getItemHeight{
    if (dataArray && dataArray.count>0) {
        return 30;
        return (CGRectGetHeight(self.frame)/dataArray.count);
    }
    return 0;
}
-(CGRect)getBtnFrameWithIndex:(NSInteger)index{
    CGFloat w = 30;//CGRectGetWidth(self.frame);
    CGFloat h = [self getItemHeight];
    CGFloat x = (CGRectGetWidth(self.frame)-w)/2.0;
    CGFloat y = 0;
    if (index<=0) {
        y = 0;
        return CGRectMake(x, y, w, h);
    }else{
        CGRect priusFrame = [self getBtnFrameWithIndex:index-1];
        y = CGRectGetMaxY(priusFrame);
        return CGRectMake(x, y, w, h);
    }
}
-(void)btnAction:(id)sender{
    UIButton *tempBtn = (UIButton *)sender;
    if (tempBtn) {
        NSInteger index = tempBtn.tag - 1000;
        if (self.indexDelegate !=nil && [self.indexDelegate respondsToSelector:@selector(BrandSectionIndexV:didSelectedIndex:)]) {
            [self.indexDelegate BrandSectionIndexV:self didSelectedIndex:index];
        }
    }
}
@end

#pragma mark - 
#pragma mark BrandVC

@interface BrandVC ()<BrandSectionIndexVDelegate>
{
    NSMutableDictionary *brandCategoryDict;
    BrandSectionIndexV *indexV;
    
}
@end

@implementation BrandVC

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
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self  createUI];
    [self  loadNewer];
    self.tableView.backgroundColor=[UIColor whiteColor];
    CGRect tableFrame =  self.tableView.frame;
    CGFloat currentVersion = CurrentOSVersion;
    if (currentVersion<7.0) {
        tableFrame.size.height-=44;
    }else
        tableFrame.size.height-=44;
    
    tableFrame.size.width -= 100;
    self.tableView.frame=tableFrame;
    self.tableView.layer.borderColor = [[UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1] CGColor];
    self.tableView.layer.borderWidth = 0.5;
    
    [self initDataParams];
    [self initParams];

}
#pragma mark -
#pragma mark custom methods

-(void)initDataParams{

    
    if (!self.listData) {
        self.listData=[NSMutableArray array];
    }
    
    if (!brandCategoryDict) {
        brandCategoryDict = [NSMutableDictionary dictionary];
    }
}

-(void)initParams{
    if (indexV == nil) {
        indexV = [[BrandSectionIndexV alloc] init];
        [indexV setBackgroundColor:[UIColor whiteColor]];
        indexV.indexDelegate=self;
        [self.contentView addSubview:indexV];
    }
    indexV.layer.zPosition = 1;
    indexV.frame = CGRectMake(ScreenW-100-50, 0, 50, CGRectGetHeight(self.tableView.frame));
}

-(void)refreshTableIndexV:(NSMutableArray *)array{
    [indexV setDatas:array];
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
    [paramsDict setObject:@"get_brand_list" forKey:@"method"];
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
                NSArray *hotArray = [dataObj objectForKey:@"hot_brand"];
                NSDictionary *brandDict = [dataObj objectForKey:@"itemslist"];
                if (hotArray.count==0 && brandDict.count==0) {
                    self.statefulState = FTStatefulTableViewControllerStateEmpty;
                }else{
                    NSMutableArray *sectionArray = [NSMutableArray array];
                    // brand detail
                    NSMutableArray *tempHotArray=[NSMutableArray array];
                    for (NSDictionary *hotBrandDict in hotArray) {
                        BrandVOcounterpart *vo = [[BrandVOcounterpart alloc] initWithDictionary:hotBrandDict];
                        [tempHotArray addObject:vo];
                    }
                    

                    for (NSString *key in brandDict.allKeys) {
                        NSMutableArray *tempBrandArray = [NSMutableArray array];
                        NSArray *brandArray = [brandDict objectForKey:key];
                        for (NSDictionary *dict in brandArray) {
                            BrandVOcounterpart *vo = [[BrandVOcounterpart alloc] initWithDictionary:dict];
                            [tempBrandArray addObject:vo];
                        }
                        [sectionArray addObject:key];
                        [brandCategoryDict setObject:tempBrandArray forKey:key];
                    }
                    
                    [sectionArray sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
                        if ([obj2 isEqualToString:@"#"]) {
                            return NSOrderedSame;
                        }
                        return [obj1 compare:obj2];
                    }];

                    
                    // Hot detail
                    NSString *hotKey = @"热";
                    if (hotArray.count>0) {
                        [sectionArray insertObject:hotKey atIndex:0];
                    }
                    if (tempHotArray.count>0) {
                        [brandCategoryDict setObject:tempHotArray forKey:hotKey];
                    }
                    objArr = sectionArray;
                    [self performSelectorOnMainThread:@selector(refreshTableIndexV:) withObject:sectionArray waitUntilDone:YES];
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listData.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc] init];
    UILabel *childV  = [[UILabel alloc] init];
    childV.backgroundColor =[UIColor clearColor];
    bgView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    childV.frame = CGRectMake(12, 0, ScreenW-100, 20);
    if (section<self.listData.count) {
        NSString *indexText = [self.listData objectAtIndex:section];
        indexText = [indexText isEqualToString:@"热"] ? @"热门品牌":indexText;
        childV.text = indexText;
    }

    [childV setTextColor:[UIColor whiteColor]];
    [childV setFont:[UIFont boldSystemFontOfSize:15]];
    [bgView addSubview:childV];
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *brandArray = [self getBrandArrayWithIndexPathSection:section];
    if (brandArray) {
        return brandArray.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *categoryCellIdentifer = @"CategroyIdentifer";
    UITableViewCell *itemCell = [tableView dequeueReusableCellWithIdentifier:categoryCellIdentifer];
    
    if (!itemCell) {
        itemCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:categoryCellIdentifer];
    }
    UIImageView *lineImageV = (UIImageView *)[itemCell.contentView viewWithTag:1000];
    UILabel *brandLabel = (UILabel *)[itemCell.contentView viewWithTag:1001];
    if (lineImageV==nil) {
        lineImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CategoryTableCellLine.png"]];
        lineImageV.frame = CGRectMake(0, CGRectGetHeight(itemCell.contentView.frame)-1.5, CGRectGetWidth(self.tableView.frame), 2);
        lineImageV.tag = 1000;
        [itemCell.contentView addSubview:lineImageV];
    }
    
    if (brandLabel==nil) {
        brandLabel = [[UILabel alloc] init];
        brandLabel.tag = 1001;
        brandLabel.font =[UIFont systemFontOfSize:15];
        brandLabel.frame = CGRectMake(12, 10, 200, 30);
        
        [itemCell.contentView addSubview:brandLabel];
    }
    lineImageV.layer.zPosition =1;
    BrandVO *vo  = [self getBrandWithIndexPath:indexPath];
    if (vo) {
        brandLabel.text=vo.BrandName;
        [brandLabel setTextColor:[UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1]];
    }

    return itemCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // push .
    [[(kata_AppDelegate *)[[UIApplication sharedApplication] delegate] deckController] closeRightViewAnimated:YES];
    BrandVO *brandVo = [self getBrandWithIndexPath:indexPath];
    kata_ProductListViewController *productListVc = [[kata_ProductListViewController alloc]
                                                     initWithBrandID:[brandVo.BrandID intValue]
                                                     andTitle:brandVo.BrandName
                                                     andProductID:0
                                                     andPlatform:nil
                                                     isChannel:YES];
    productListVc.navigationController = self.navigationController;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.viewDeckController toggleRightView];
    productListVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:productListVc animated:YES];
    
}
#pragma mark -
#pragma mark table show ui hepler methods
-(NSMutableArray *)getBrandArrayWithIndexPathSection:(NSInteger)section{
    if (section<self.listData.count) {
        NSString *key = [self.listData objectAtIndex:section];
        if (key) {
           NSMutableArray *brandArray = [brandCategoryDict objectForKey:key];
            return brandArray;
        }
    }
    return nil;
}

-(BrandVO *)getBrandWithIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *brandArray = [self getBrandArrayWithIndexPathSection:indexPath.section];
    if (indexPath.row < brandArray.count) {
        return [brandArray objectAtIndex:indexPath.row];
    }
    return nil;
}
#pragma mark - 
#pragma mark BrandSectionIndexVDelegate Methods
-(void)BrandSectionIndexV:(BrandSectionIndexV *)indexV didSelectedIndex:(NSInteger)index{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

@end

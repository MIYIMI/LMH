//
//  LMH_CategoryViewController.m
//  YingMeiHui
//
//  Created by work on 15-1-16.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "LMH_CategoryViewController.h"
#import "CategroyCollectionViewCell.h"
#import "CategoryDetailVC.h"
#import "CategoryDataModel.h"

@interface LMH_CategoryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UICollectionView *_collectionView;
    UISearchBar *_searchBar;
    UIButton *_searchBtn;
    UIButton *_clearBtn;
    UITableView *_leftView;
    UIView *_expView;
    UIImageView *expImage;
    UILabel *expLbl;
    
    NSArray *_leftArray;
    BOOL is_first;//是不是第一个cell被选中
    NSArray *_rightArray;
    NSString *_keyWord;
}

@end

@implementation LMH_CategoryViewController

@synthesize is_root;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"分类";
        is_first = YES;
        is_root = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    _clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    [_clearBtn setBackgroundColor:[UIColor clearColor]];
    [_clearBtn addTarget:self action:@selector(removeKeyBord) forControlEvents:UIControlEventTouchUpInside];
    [_clearBtn setHidden:YES];
    [[[UIApplication sharedApplication].delegate window] addSubview:_clearBtn];
    
    [self categoryRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI{
    self.view.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.98 alpha:1];
    [self.contentView removeFromSuperview];
    
    if (self.is_root) {
        CGRect frame =  self.view.frame;
        frame.size.height -= 49;
        self.view.frame=frame;
    }
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 5, ScreenW-60, 30)];
    [_searchBar setBackgroundColor:[UIColor whiteColor]];
    _searchBar.layer.cornerRadius = 5.0;
    _searchBar.placeholder = @"输入商品关键词搜索";
    _searchBar.delegate = self;
    
    for (UIView *view in _searchBar.subviews) {
        // for before iOS7.0
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    [self.view addSubview:_searchBar];
    
    _searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_searchBar.frame)+5, 5, 40, 30)];
    [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [_searchBtn setTitleColor:ALL_COLOR forState:UIControlStateNormal];
    [_searchBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [_searchBtn addTarget:self action:@selector(seachBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchBtn];
    
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
    flowLayout.minimumLineSpacing = 10.0;//行间距(最小值)
    flowLayout.minimumInteritemSpacing = 20.0;//item间距(最小值)
    flowLayout.itemSize = CGSizeMake((ScreenW/4*3-60)/2, (ScreenW/4*3-60)/2*1.3);//item的大小
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);//设置section的边距
    
    //创建右屏的视图大小
    CGRect rightFrame = self.view.frame;
    
    if (IOS_7) {
        rightFrame.size.height -= 64;
    }else{
        rightFrame.size.height -= 44;
    }
    rightFrame.origin.y += CGRectGetMaxY(_searchBar.frame)+5;
    rightFrame.size.height -= CGRectGetMaxY(_searchBar.frame)+5;
    rightFrame.origin.x += ScreenW/4;
    rightFrame.size.width = ScreenW/4*3;
    
    //创建左屏试图大小
    CGRect leftFrame = rightFrame;
    leftFrame.origin.x = 0;
    leftFrame.size.width = ScreenW/4;
    
    _leftView = [[UITableView alloc] initWithFrame:leftFrame style:UITableViewStylePlain];
    _leftView.dataSource = self;
    _leftView.delegate = self;
    _leftView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.98 alpha:1];
    _leftView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_leftView];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:rightFrame collectionViewLayout:flowLayout];
    //对Cell注册(必须否则程序会挂掉)
    [_collectionView registerClass:[CategroyCollectionViewCell class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"_brandCell"]];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [_collectionView setUserInteractionEnabled:YES];
    
    [_collectionView setDelegate:self]; //代理－视图
    [_collectionView setDataSource:self]; //代理－数据
    _collectionView.bounces = YES;
    
    [_searchBar setHidden:YES];
    [_searchBtn setHidden:YES];
    [_leftView setHidden:YES];
    [_collectionView setHidden:YES];
    [self.view addSubview:_collectionView];
}

- (void)seachBtnClick{
    _keyWord = _searchBar.text;
    
    //过滤字符串前后的空格
    _keyWord = [_keyWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //过滤中间空格
    _keyWord = [_keyWord stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(_keyWord.length <= 0){
        [_searchBar becomeFirstResponder];
        return;
    }
    CategoryDetailVC *cateVC = [[CategoryDetailVC alloc] initWithAdvData:nil andFlag:_keyWord];
    cateVC.pid = @0;
    cateVC.cateid = @0;
    cateVC.navigationController = self.navigationController;
    cateVC.hidesBottomBarWhenPushed = YES;
    cateVC.is_search = YES;
    [cateVC.navigationController pushViewController:cateVC animated:YES];
}

- (void)categoryRequest{
    [self loadHUD];
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    NSMutableDictionary *paramsDict = [req params];
    [paramsDict setObject:@"get_category_list" forKey:@"method"];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        [self performSelector:@selector(categoryRespone:) withObject:resp withObject:nil];
    } failed:^(NSError *error) {
        [self expView:NO];
    }];
    [proxy start];
}

- (void)categoryRespone:(NSString *)resp{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if ([respDict objectForKey:@"data"] != nil && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]]) {
                id dataObj = [respDict objectForKey:@"data"];
                if ([dataObj isKindOfClass:[NSDictionary class]]) {
                    if ([[dataObj objectForKey:@"cate_list"] isKindOfClass:[NSArray class]]) {
                        _leftArray = [CategoryDataModel CategoryDataModelWithArray:[dataObj objectForKey:@"cate_list"]];
                        if (_leftArray.count > 0) {
                            [self performSelectorOnMainThread:@selector(layoutUI) withObject:nil waitUntilDone:YES];
                        }else{
                            [self expView:YES];
                        }
                        return;
                    }
                } else {
                }
            } else {
            }
        } else {
        }
    } else {
    }
    [self expView:NO];
}

- (void)layoutUI{
    [self hideHUD];
    [_leftView reloadData];
    [self layOutCell:0];
    [_searchBar setHidden:NO];
    [_searchBtn setHidden:NO];
    [_leftView setHidden:NO];
    [_collectionView setHidden:NO];
}

//集合代理-每一部分数据项
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _rightArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategroyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"_brandCell" forIndexPath:indexPath];
    CategoryDataModel *model = _rightArray[indexPath.row];
    [cell layoutView:model];
    return cell;
}

//代理－选择行的触发事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //点击推出页面
    CategoryDataModel *model = _rightArray[indexPath.row];
    CategoryDetailVC *rvc = [[CategoryDetailVC alloc] initWithAdvData:nil andFlag:@"category"];
    rvc.pid = model.pid;
    rvc.cateid = model.cate_id;
    rvc.navigationController = self.navigationController;
    rvc.title = model.title;
    rvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rvc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _leftArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    UILabel *leftLabel = (UILabel *)[cell viewWithTag:99];
    if (!leftLabel) {
        leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW/4, 44.0f)];
        [leftLabel setFont:[UIFont systemFontOfSize:14.0]];
        [leftLabel setTextAlignment:NSTextAlignmentCenter];
        [leftLabel setBackgroundColor:[UIColor clearColor]];
        leftLabel.tag = 99;
        
        UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 43.7, ScreenW/4, 0.3)];
        [lineLbl setBackgroundColor:[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:0.9]];
        [leftLabel addSubview:lineLbl];
        [cell addSubview:leftLabel];
    }
    [leftLabel setTextColor:[UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1]];
    cell.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.98 alpha:1];
    if (indexPath.row == 0 && is_first) {
        [cell setBackgroundColor:[UIColor whiteColor]];
        [leftLabel setTextColor:ALL_COLOR];
    }

    CategoryDataModel *cateVO = _leftArray[indexPath.row];
    [leftLabel setText:cateVO.title];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    
    if (row == 0) {
        is_first = YES;
    }else{
        is_first = NO;
    }
    
    [tableView reloadData];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    UILabel *textLbl = (UILabel *)[cell viewWithTag:99];
    [textLbl setTextColor:ALL_COLOR];
    
    [self layOutCell:row];
}

//right布局
- (void)layOutCell:(NSInteger)row{
    CategoryDataModel *model = _leftArray[row];
    
    _rightArray = [CategoryDataModel CategoryDataModelWithArray:model.cate_son];
    [_collectionView reloadData];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [_clearBtn setHidden:NO];
    return YES;
}

//点击SearchButton隐藏键盘
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder];
    [_clearBtn setHidden:YES];
    [self seachBtnClick];
}

//点击屏幕隐藏键盘
- (void)removeKeyBord{
    [_searchBar resignFirstResponder];
    [_clearBtn setHidden:YES];
}

- (void)expView:(BOOL)is_empty{
    [self hideHUD];
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.view.bounds.size.height;
    
    if (!_expView) {
        _expView = [[UIView alloc] initWithFrame:self.view.frame];
        
        //数据为空
        expImage = [[UIImageView alloc] init];
        [_expView addSubview:expImage];
        
        expLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        [expLbl setBackgroundColor:[UIColor clearColor]];
        [expLbl setTextAlignment:NSTextAlignmentCenter];
        expLbl.numberOfLines = 0;
        [expLbl setTextColor:[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1]];
        [expLbl setFont:[UIFont systemFontOfSize:14.0]];
        [_expView addSubview:expLbl];
        
        [self.view addSubview:_expView];
    }

    [_expView setHidden:NO];
    if (is_empty) {
        expImage.image = [UIImage imageNamed:@"productlistempty"];
        [expLbl setText:@"暂无商品信息"];
    }else{
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapErr)];
        [_expView addGestureRecognizer:tap];
        expImage.image = [UIImage imageNamed:@"neterror"];
        [expLbl setText:@"网络抛锚\r\n请检查网络后点击屏幕重试！"];
    }
    [expImage setFrame:CGRectMake((w - expImage.image.size.width) / 2, h/2-expImage.image.size.width, expImage.image.size.width, expImage.image.size.height)];
    expLbl.frame = CGRectMake(0, CGRectGetMaxY(expImage.frame)+20, w, 35);
}

- (void)tapErr{
    [_expView setHidden:YES];
    [self categoryRequest];
}

@end

//
//  kata_DescribeViewController.m
//  YingMeiHui
//
//  Created by work on 15-1-5.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "kata_DescribeViewController.h"
#import "KTBaseRequest.h"
#import "DescribeVO.h"
#import "KTProxy.h"
#import "kata_WebViewController.h"
#import "KTProxy.h"
#import <UIImageView+WebCache.h>
#import "kata_AppDelegate.h"

@interface kata_DescribeViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation kata_DescribeViewController{
    UITableView *myTableview;
    UIView *footview;
    UILabel *salLbl;
    UILabel *favnumLbl;
    UIView *excepView;
    
    NSInteger _productid;
    NSString *_platform;
    DescribeVO *_descvo;
}

- (id)initWithProductID:(NSInteger)productid andPlatform:(NSString *)platform{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _platform = platform;
        _productid = productid;
        
        self.title = @"推荐详情";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self describeRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[(kata_AppDelegate *)[[UIApplication sharedApplication] delegate] deckController] setPanningMode:IIViewDeckNoPanning];
}

- (void)createUI{
    CGRect frame = self.view.frame;
    if (IOS_7) {
        frame.size.height -= 64;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = frame;
    footview = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-50, ScreenW, 50)];
    [footview setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *linelbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
    [linelbl setBackgroundColor:[UIColor colorWithRed:0.83 green:0.83 blue:0.83 alpha:1]];
    [footview addSubview:linelbl];
    
    salLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
    [salLbl setTextAlignment:NSTextAlignmentLeft];
    [salLbl setFont:[UIFont systemFontOfSize:13.0]];
    [footview addSubview:salLbl];
    
    UIButton *webBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 90, 10, 80, 30)];
    [webBtn setBackgroundImage:[UIImage imageNamed:@"red_btn_small"] forState:UIControlStateNormal];
    [webBtn addTarget:self action:@selector(toweb) forControlEvents:UIControlEventTouchUpInside];
    webBtn.layer.cornerRadius = 20;
    if ([_platform isEqualToString:@"tmall"]) {
        [webBtn setTitle:@"去天猫看看" forState:UIControlStateNormal];
    }else if ([_platform isEqualToString:@"taobao"]){
        [webBtn setTitle:@"去淘宝看看" forState:UIControlStateNormal];
    }
    [webBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [webBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [footview addSubview:webBtn];
    [footview setHidden:YES];
    
    frame.size.height -= 50;
    myTableview = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    myTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableview.dataSource = self;
    myTableview.delegate = self;
    
    [self.view addSubview:myTableview];
    [self.view addSubview:footview];
}

- (void)toweb{
    kata_WebViewController *webVC = [[kata_WebViewController alloc] initWithUrl:_descvo.click_url title:nil andType:_platform];
    webVC.navigationController = self.navigationController;
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)describeRequest{
    [self loadHUD];
    KTBaseRequest *req = [[KTBaseRequest alloc] initWithNone];
    
    NSMutableDictionary *paramsDict = [req params];
    [paramsDict setObject:@"get_transition_detail" forKey:@"method"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (_productid > 0) {
        [dict setObject:[NSNumber numberWithInteger:_productid] forKey:@"product_id"];
    }
    if (_platform) {
        [dict setObject:_platform forKey:@"source_platform"];
    }
    
    [paramsDict setObject:dict forKey:@"params"];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(describeResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        [self performSelectorOnMainThread:@selector(loadExcepView) withObject:nil waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)describeResponse:(NSString *)resp{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        if ([[respDict objectForKey:@"code"] integerValue] == 0) {
            if ([[respDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                _descvo = [DescribeVO DescribeVOWithDictionary:[respDict objectForKey:@"data"]];
                [self performSelectorOnMainThread:@selector(layoutView) withObject:nil waitUntilDone:YES];
                return;
            }
        }
    }
    [self performSelectorOnMainThread:@selector(loadExcepView) withObject:nil waitUntilDone:YES];
}

- (void)layoutView{
    [myTableview reloadData];
    [footview setHidden:NO];
    [excepView removeFromSuperview];
    [self hideHUD];
    
    [salLbl setText:[NSString stringWithFormat:@"已售: %@件",_descvo.taobao_month_orders]];
    [favnumLbl setText:[NSString stringWithFormat:@"%@次",_descvo.fav_num]];
}

#pragma mark - tableView delegate && datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_descvo) {
        return 4;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    
    NSString *IDEFIER = [NSString stringWithFormat:@"cell_%zi",row];
    
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:IDEFIER];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IDEFIER];
        if (row == 0) {
            UIImageView *proImgView = (UIImageView *)[cell viewWithTag:10001];
            if (!proImgView) {
                UIImageView *proImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenW/320*400)];
                proImgView.contentMode = UIViewContentModeScaleAspectFill;
                [proImgView sd_setImageWithURL:[NSURL URLWithString:_descvo.image?_descvo.image:@"null"] placeholderImage:[UIImage imageNamed:@"place_2"]];
                [cell addSubview:proImgView];
                
                // 已验货标签
                UIImageView *check = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW/4*3 - 10, ScreenW/320*400 - ScreenW/4 - 10, ScreenW/4, ScreenW/4)];
                check.image = [UIImage imageNamed:[NSString stringWithFormat:@"is_check"]];
                [proImgView addSubview:check];
            }
            [proImgView sd_setImageWithURL:[NSURL URLWithString:_descvo.image?_descvo.image:@"null"] placeholderImage:[UIImage imageNamed:@"place_2"]];
        }else if(row == 1){
            UILabel *lbl = (UILabel *)[cell viewWithTag:1002];
            if (!lbl) {
                lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenW-20, 40)];
                [lbl setTextColor:[UIColor colorWithRed:0.31 green:0.31 blue:0.31 alpha:1]];
                [lbl setFont:[UIFont systemFontOfSize:15.0]];
                lbl.numberOfLines = 2;
                lbl.lineBreakMode = NSLineBreakByTruncatingTail;
                
                [cell addSubview:lbl];
            }
            [lbl setText:_descvo.title];
        }else if(row == 2){
            UILabel *slbl = (UILabel *)[cell viewWithTag:1003];
            CGSize size = [_descvo.sales_price sizeWithFont:[UIFont systemFontOfSize:22.0] constrainedToSize:CGSizeMake(180, 30) lineBreakMode:NSLineBreakByWordWrapping];
            if (!slbl) {
                UILabel *alabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 10, 20)];
                alabel.font = [UIFont systemFontOfSize:13];
                alabel.textColor = [UIColor colorWithRed:0.96 green:0.27 blue:0.52 alpha:1];
                alabel.text = @"¥";
                [cell addSubview:alabel];
                slbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(alabel.frame), 0, size.width, 30)];
                [slbl setFont:[UIFont systemFontOfSize:22.0]];
                [slbl setTextColor:[UIColor colorWithRed:0.96 green:0.27 blue:0.52 alpha:1]];
                [cell addSubview:slbl];
            }
            NSString *sales_price;
            CGFloat salesPrice = [_descvo.sales_price floatValue];
            if ((salesPrice * 10) - (int)(salesPrice * 10) > 0) {
                sales_price = [NSString stringWithFormat:@"%0.2f",[_descvo.sales_price floatValue]];
            } else if(salesPrice - (int)salesPrice > 0) {
                sales_price = [NSString stringWithFormat:@"%0.1f",[_descvo.sales_price floatValue]];
            } else {
                sales_price = [NSString stringWithFormat:@"%0.0f",[_descvo.sales_price floatValue]];
            }
            [slbl setText:sales_price];
//            [slbl setText:[NSString stringWithFormat:@"¥%@",_descvo.sales_price]];
            
            size = [_descvo.market_price sizeWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake(180, 30) lineBreakMode:NSLineBreakByWordWrapping];
            UILabel *mlbl = (UILabel *)[cell viewWithTag:1004];
            if (!mlbl) {
                mlbl = [[UILabel alloc] initWithFrame:CGRectZero];
                [mlbl setTextColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1]];
                [mlbl setFont:[UIFont systemFontOfSize:13.0]];
                [mlbl setFrame:CGRectMake(CGRectGetMaxX(slbl.frame)+5, 8, size.width+10, 20)];
                [cell addSubview:mlbl];
            }
            
            NSString *market_price;
            CGFloat marketPrice = [_descvo.market_price floatValue];
            if ((marketPrice * 10) - (int)(marketPrice * 10) > 0) {
                market_price = [NSString stringWithFormat:@"¥%0.2f",[_descvo.market_price floatValue]];
            } else if(marketPrice - (int)marketPrice > 0) {
                market_price = [NSString stringWithFormat:@"¥%0.1f",[_descvo.market_price floatValue]];
            } else {
                market_price = [NSString stringWithFormat:@"¥%0.0f",[_descvo.market_price floatValue]];
            }
            [mlbl setText:market_price];
//            [mlbl setText:[NSString stringWithFormat:@"¥%@",_descvo.market_price]];
            
            UILabel *llbl = (UILabel *)[cell viewWithTag:1005];
            if (!llbl) {
                llbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(mlbl.frame) - 20, 1)];
                [llbl setBackgroundColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1]];
                [mlbl addSubview:llbl];
            }
            
            UILabel *cellbl = (UILabel *)[cell viewWithTag:1006];
            if (!cellbl) {
                cellbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 29, ScreenW, 0.5)];
                [cellbl setBackgroundColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1]];
                [cell addSubview:cellbl];
            }
//            NSLog(@">>>>>>>>>>>>>%@,  %@",_descvo.free_postage, _descvo.is_buy_change);
            UILabel *postage = [[UILabel alloc] init];
            if ([_descvo.free_postage integerValue] == 1) {
                postage.frame = CGRectMake(CGRectGetMaxX(mlbl.frame), 8, 35, 15);
                postage.backgroundColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:153/255.0 alpha:1.0];
                postage.textAlignment = 1;
                postage.layer.masksToBounds = YES;
                postage.layer.cornerRadius = 3.0;
                postage.font = [UIFont systemFontOfSize:12];
                postage.textColor = [UIColor whiteColor];
                postage.text = @"包邮";
                [cell addSubview:postage];
            }
            UILabel *change = [[UILabel alloc] init];
            if ([_descvo.is_buy_change integerValue] == 1) {
                if ([_descvo.free_postage integerValue] == 1) {
                    change.frame = CGRectMake(CGRectGetMaxX(postage.frame) + 10, 8, 55, 15);
                } else {
                    change.frame = CGRectMake(CGRectGetMaxX(mlbl.frame), 8, 55, 15);
                }
                change.backgroundColor = [UIColor colorWithRed:102/255.0 green:204/255.0 blue:153/255.0 alpha:1.0];
                change.textAlignment = 1;
                change.layer.masksToBounds = YES;
                change.layer.cornerRadius = 3.0;
                change.font = [UIFont systemFontOfSize:12];
                change.textColor = [UIColor whiteColor];
                change.text = @"拍下改价";
                [cell addSubview:change];
            }
//            UILabel *xxxx = [[UILabel alloc] init];
//            if ([_descvo.xxxxxxx integerValue] == 1) {
//                if (change) {
//                    xxxx.frame = CGRectMake(CGRectGetMaxX(change.frame) + 10, 8, 45, 15);
//                } else if (!change && postage) {
//                    xxxx.frame = CGRectMake(CGRectGetMaxX(postage.frame) + 10, 8, 45, 15);
//                } else {
//                    xxxx.frame = CGRectMake(CGRectGetMaxX(mlbl.frame), 8, 35, 15);
//                }
//                xxxx.backgroundColor = [UIColor colorWithRed:255/255.0 green:157/255.0 blue:3/255.0 alpha:1.0];
//                xxxx.textAlignment = 1;
//                xxxx.layer.masksToBounds = YES;
//                xxxx.layer.cornerRadius = 3.0;
//                xxxx.font = [UIFont systemFontOfSize:12];
//                xxxx.textColor = [UIColor whiteColor];
//                xxxx.text = @"拍下改价";
//                [cell addSubview:xxxx];
//            }
        }else if(row == 3){
            UIImageView *cellimgview = (UIImageView *)[cell viewWithTag:10007];
            if (!cellimgview) {
                cellimgview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
                [cellimgview setImage:[UIImage imageNamed:@"describe"]];
                [cell addSubview:cellimgview];
            }
            
            UILabel *celbl = (UILabel *)[cell viewWithTag:10008];
            if (!celbl) {
                celbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cellimgview.frame)+10, 10, ScreenW-CGRectGetMaxX(cellimgview.frame)-20, 20)];
                [celbl setText:@"辣妈有话要说"];
                [celbl setFont:[UIFont systemFontOfSize:15.0]];
                [celbl setTextColor:[UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:1]];
                [cell addSubview:celbl];
            }
        
            CGSize size = [_descvo.editor_comment sizeWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake(ScreenW-80, 1000) lineBreakMode:NSLineBreakByWordWrapping];
            UILabel *detailbl = (UILabel *)[cell viewWithTag:1009];
            if (!detailbl) {
                detailbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cellimgview.frame)+10, CGRectGetMaxY(celbl.frame)+10, ScreenW-CGRectGetMaxX(cellimgview.frame)-20, size.height)];
                [detailbl setFont:[UIFont systemFontOfSize:13.0]];
                [detailbl setTextColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1]];
                [detailbl setNumberOfLines:0];
                [cell addSubview:detailbl];
            }
            [detailbl setText:_descvo.editor_comment];
            
            UILabel *deslbl = (UILabel *)[cell viewWithTag:1010];
            if (!deslbl) {
                deslbl = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(detailbl.frame)+20, ScreenW-20, 35)];
                [deslbl setTextColor:[UIColor colorWithRed:0.73 green:0.73 blue:0.73 alpha:1]];
                [deslbl setFont:[UIFont systemFontOfSize:13.0]];
                deslbl.numberOfLines = 0;
                deslbl.lineBreakMode = NSLineBreakByWordWrapping;
                [cell addSubview:deslbl];
            }
            [deslbl setText:@"本商品由小编亲自验货并提供验货报告，仅代表小编观点。"];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    
    if (row == 0) {
        return ScreenW/320*400;
    }else if(row == 1){
        return 40;
    }else if(row == 2){
        return 30;
    }else if(row == 3){
        CGSize size = [_descvo.editor_comment sizeWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake(ScreenW-80, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        return 50 + size.height+65;
    }
    
    return 0;
}

- (void )loadExcepView{
    [self hideHUD];
    if (!excepView) {
        excepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"neterror"]];
        [image setFrame:CGRectMake((ScreenW - CGRectGetWidth(image.frame)) / 2, (ScreenH - CGRectGetHeight(image.frame))/2, CGRectGetWidth(image.frame), CGRectGetHeight(image.frame))];
        [excepView addSubview:image];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 105, ScreenW, 34)];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setNumberOfLines:2];
        [lbl setTextColor:[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1]];
        [lbl setFont:[UIFont systemFontOfSize:14.0]];
        [lbl setText:@"网络抛锚\r\n请检查网络后点击屏幕重试！"];
        [excepView addSubview:lbl];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadErr)];
        [excepView addGestureRecognizer:tap];
        
    }
    [excepView removeFromSuperview];
    [self.view addSubview:excepView];
}

- (void)reloadErr{
    [self describeRequest];
}

@end

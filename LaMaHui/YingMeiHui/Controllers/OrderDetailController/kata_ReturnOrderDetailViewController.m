//
//  kata_ReturnOrderDetailViewController.m
//  YingMeiHui
//
//  Created by work on 15-1-30.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "kata_ReturnOrderDetailViewController.h"
#import "KTOrderDetailProductTableViewCell.h"
#import "KTReturnOrderTableViewCell.h"
#import "OrderDetailVO.h"
#import "kata_UserManager.h"
#import "ReturnOrderDetailVO.h"
#import "kata_ReturnGoodsViewController.h"
#import "kata_OrderManageViewController.h"
#import "kata_AllOrderListViewController.h"

@interface kata_ReturnOrderDetailViewController ()<KTOrderDetailProductTableViewCellDelegate,UIAlertViewDelegate>
{
    OrderGoodsVO *_goodVO;
    detailAddressVO *_addressVO;
    ReturnOrderDetailVO *detailReturnVO;
    NSString *_orderID;
    NSInteger _type;
}

@end

@implementation kata_ReturnOrderDetailViewController

- (id)initWithGoodVO:(OrderGoodsVO *)goodVO  andOrderID:(NSString *)orderID andType:(NSInteger)type{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.ifAddPullToRefreshControl = NO;
        self.ifShowTableSeparator = NO;
        
        _goodVO = goodVO;
        _orderID  = orderID;
        _type = type;
        
        self.title = @"退款订单详情";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = GRAY_CELL_COLOR;
    self.tableView.bounces = NO;
    
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadRetrunOrderDetail];
}

- (void)createUI{
    UIButton * backBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 27)];
    [backBarButton setImage:[UIImage imageNamed:@"icon_goback_gray"] forState:UIControlStateNormal];
    [backBarButton setImage:[UIImage imageNamed:@"icon_goback_gray"] forState:UIControlStateHighlighted];
    [backBarButton addTarget:self action:@selector(popToVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
    backBarButtonItem.style = UIBarButtonItemStylePlain;
    [self.navigationController addLeftBarButtonItem:backBarButtonItem animation:NO];
}

#pragma mark - Load ReturnOrderDetail
- (void)loadRetrunOrderDetail
{
    [self loadHUD];
    
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    NSString *userid = nil;
    NSString *usertoken = nil;
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    NSMutableDictionary *paramsDict = [req params];
    
    NSMutableDictionary *subParams = [[NSMutableDictionary alloc] init];
    if (userid) {
        [subParams setObject:[NSNumber numberWithLong:[userid integerValue]] forKey:@"user_id"];
    }
    
    if (usertoken) {
        [subParams setObject:usertoken forKey:@"user_token"];
    }
    
    if ([_goodVO.order_part_id integerValue] > 0) {
        [subParams setObject:_goodVO.order_part_id forKey:@"order_part_id"];
    }
    [paramsDict setObject:subParams forKey:@"params"];
    [paramsDict setObject:@"get_refund_info" forKey:@"method"];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        [self hideHUD];
        [self performSelectorOnMainThread:@selector(RetrunOrderDetailParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        [self hideHUD];
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)RetrunOrderDetailParseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if ([respDict objectForKey:@"data"] != nil && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]]) {
                detailReturnVO = [ReturnOrderDetailVO ReturnOrderDetailVOWithDictionary:[respDict objectForKey:@"data"]];
                _addressVO = detailReturnVO.partner_info;
                [self.tableView reloadData];
                return;
            }
        }else{
            if ([[respDict objectForKey:@"code"] integerValue]== 308) {
                [self textStateHUD:@"暂无此订单退款信息"];
                return;
            }
        }
    }

    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
}

- (NSString *)statusName:(NSInteger)status{
//    0=待确认售后，1=待上传快递单号,2=待商家收货（此状态现在弃用）,3=退款中，4=退款完成，5=拒绝退款，6=退款失败， -1=取消售后'
    switch (status) {
        case -1:
            return @"售后取消";
            break;
        case 0:
            return @"等待审核";
            break;
        case 1:
            return @"等待寄回";
            break;
        case 2:
            return @"等待审核";
            break;
        case 3:
            return @"等待审核";
            break;
        case 4:
            return @"退款完成";
            break;
        case 5:
            return @"审核失败";
            break;
        case 6:
            return @"等待审核";
            break;
        default:
            break;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (detailReturnVO) {
        return 5;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSString *CELLIDFER = [NSString stringWithFormat:@"CELL_%zi",row];
    
    UITableViewCell *cell;
    cell = nil;
    if (!cell) {
        if (row == 0) {
            cell = [[KTReturnOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELLIDFER];
            [(KTReturnOrderTableViewCell *)cell layoutUI:detailReturnVO];
            
        }else if (row == 1){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELLIDFER];
            
            if ([detailReturnVO.refund_status integerValue] != 1) {
                return cell;
            }
            CGFloat _headViewH = 0;
            //订单详情地址信息
            
            cell.backgroundColor = GRAY_CELL_COLOR;
            UIImageView *headImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
            headImgView.image = [UIImage imageNamed:@"order_w"];
            
            if (_addressVO) {
                [cell.contentView addSubview:headImgView];
                
                UIImageView *adressImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
                [adressImgView setImage:[UIImage imageNamed:@"address"]];
                [headImgView addSubview:adressImgView];
                
                UILabel *adressDetailLbl = [[UILabel alloc] initWithFrame:CGRectZero];
                [adressDetailLbl setTextColor:[UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1]];
                [adressDetailLbl setFont:[UIFont systemFontOfSize:12.0]];
                adressDetailLbl.numberOfLines = 0;// 不可少Label属性之一
                adressDetailLbl.lineBreakMode = NSLineBreakByCharWrapping;// 不可少Label属性之二
                [headImgView addSubview:adressDetailLbl];
                
                NSString *addrStr = [NSString stringWithFormat:@"退货地址 : %@", _addressVO.address];
                [adressDetailLbl setText:addrStr];
                CGSize addrSize = [addrStr sizeWithFont:adressDetailLbl.font constrainedToSize:CGSizeMake(ScreenW - 60, 100000) lineBreakMode:NSLineBreakByCharWrapping];
                [adressDetailLbl setFrame:CGRectMake(45, 5, addrSize.width, addrSize.height)];
                
                UILabel *adressNameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
                [adressNameLbl setTextColor:[UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1]];
                [adressNameLbl setFont:[UIFont systemFontOfSize:12.0]];
                adressNameLbl.numberOfLines = 0;// 不可少Label属性之一
                adressNameLbl.lineBreakMode = NSLineBreakByCharWrapping;// 不可少Label属性之二
                [headImgView addSubview:adressNameLbl];
    
                NSString *nameStr = [NSString stringWithFormat:@"收货人 : %@", _addressVO.name];
                [adressNameLbl setText:nameStr];
                CGSize nameSize = [nameStr sizeWithFont:adressNameLbl.font constrainedToSize:CGSizeMake(ScreenW - 60, 100000) lineBreakMode:NSLineBreakByCharWrapping];
                [adressNameLbl setFrame:CGRectMake(45, CGRectGetMaxY(adressDetailLbl.frame) + 10, nameSize.width, nameSize.height)];
                
                UILabel *adressPhoneLbl = [[UILabel alloc] initWithFrame:CGRectZero];
                [adressPhoneLbl setTextColor:LMH_COLOR_BLACK];
                [adressPhoneLbl setFont:[UIFont systemFontOfSize:12.0]];
                adressPhoneLbl.numberOfLines = 0;// 不可少Label属性之一
                adressPhoneLbl.lineBreakMode = NSLineBreakByCharWrapping;// 不可少Label属性之二
                adressPhoneLbl.textAlignment = NSTextAlignmentRight;
                [headImgView addSubview:adressPhoneLbl];
    
                NSString *phoneStr = [NSString stringWithFormat:@"手机 : %@", _addressVO.mobile];
                [adressPhoneLbl setText:phoneStr];
                CGSize phoneSize = [phoneStr sizeWithFont:adressPhoneLbl.font constrainedToSize:CGSizeMake(ScreenW - 60, 100000) lineBreakMode:NSLineBreakByCharWrapping];
                if (CGRectGetMaxX(adressNameLbl.frame) + 15 + phoneSize.width > (ScreenW - 60)) {
                    [adressPhoneLbl setFrame:CGRectMake(45, CGRectGetMaxY(adressNameLbl.frame) + 10, phoneSize.width, phoneSize.height)];
                }else{
                    [adressPhoneLbl setFrame:CGRectMake(ScreenW - (phoneSize.width+18), 5, phoneSize.width, phoneSize.height)];
                }
                
                _headViewH += CGRectGetMaxY(adressPhoneLbl.frame)+10;
                [headImgView setFrame:CGRectMake(0, 0, ScreenW, _headViewH)];
                [adressImgView setFrame:CGRectMake(12, (_headViewH - 25)/2, 20, 25)];
            }
        } else if(row == 2){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELLIDFER];
            
            [cell.imageView setImage:[UIImage imageNamed:@"order_l"]];
            NSString *textStr = [NSString stringWithFormat:@"售后状态 : %@", detailReturnVO.refund_status_name];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:textStr];
            [str addAttribute:NSForegroundColorAttributeName value:LMH_COLOR_GRAY range:NSMakeRange(0,7)];
            [str addAttribute:NSForegroundColorAttributeName value:LMH_COLOR_SKIN range:NSMakeRange(7,textStr.length-7)];
            [str addAttribute:NSFontAttributeName value:FONT(14.0) range:NSMakeRange(0, textStr.length)];
            cell.textLabel.attributedText = str;
        }else if(row == 3){
            cell = [[KTOrderDetailProductTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELLIDFER];
            [(KTOrderDetailProductTableViewCell *)cell setItemData:_goodVO andReturnData:detailReturnVO andType:1];
            [(KTOrderDetailProductTableViewCell *)cell setDelegate:self];
        }else if(row == 4){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELLIDFER];
            
            UILabel *grayLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
            grayLbl.backgroundColor = GRAY_CELL_COLOR;
            [cell.contentView addSubview:grayLbl];
            
            UILabel *applyLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(grayLbl.frame)+5, ScreenW-24, 20)];
            [applyLbl setText:@"申请详情"];
            [applyLbl setFont:[UIFont systemFontOfSize:15.0]];
            [applyLbl setTextColor:TEXTV_COLOR];
            [cell.contentView addSubview:applyLbl];
            
            UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(applyLbl.frame)+5, ScreenW-20, 0.5)];
            lineLbl.backgroundColor = GRAY_LINE_COLOR;
            [cell.contentView addSubview:lineLbl];
            
            NSInteger i = 0;
            for(i = 0;i < 3; i++){
                UILabel *infoLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(lineLbl.frame)+5+i*25, ScreenW-24, 20)];
                if (i == 0) {
                    [infoLbl setText:[NSString stringWithFormat:@"订单编号: %@",_orderID]];
                }else if (i == 1){
                    [infoLbl setText:[NSString stringWithFormat:@"退款原因: %@",detailReturnVO.refund_comment]];
                }else if (i == 2){
                    [infoLbl setText:[NSString stringWithFormat:@"退款金额: %@",detailReturnVO.refund_money_service]];
                }
                [infoLbl setFont:[UIFont systemFontOfSize:14.0]];
                [infoLbl setTextColor:TEXTV_COLOR];
                [cell.contentView addSubview:infoLbl];
            }
            
            UILabel *remarkLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            [remarkLbl setFont:[UIFont systemFontOfSize:14.0]];
            [remarkLbl setTextColor:TEXTV_COLOR];
            
            remarkLbl.text = [NSString stringWithFormat:@"备注说明: %@", [detailReturnVO.refund_note length]?detailReturnVO.refund_note:@"无"];
            CGSize textSize =  [remarkLbl.text sizeWithFont:remarkLbl.font constrainedToSize:CGSizeMake(ScreenW-24, 1000) lineBreakMode:NSLineBreakByCharWrapping];
            [remarkLbl setFrame:CGRectMake(12, CGRectGetMaxY(lineLbl.frame)+5+25*i, ScreenW-24, textSize.height)];
            [cell.contentView addSubview:remarkLbl];
            
            UILabel *expressage = [[UILabel alloc] initWithFrame:CGRectZero];
            [expressage setFont:[UIFont systemFontOfSize:14.0]];
            [expressage setTextColor:TEXTV_COLOR];
            expressage.text = [NSString stringWithFormat:@"快递名称: %@", [detailReturnVO.refund_express_name length]?detailReturnVO.refund_express_name:@"无"];
            expressage.frame = CGRectMake(12, CGRectGetMaxY(remarkLbl.frame) + 5, ScreenW-24, 20);
            [cell.contentView addSubview:expressage];
            
            UILabel *expressage_num = [[UILabel alloc] initWithFrame:CGRectZero];
            [expressage_num setFont:[UIFont systemFontOfSize:14.0]];
            [expressage_num setTextColor:TEXTV_COLOR];
            expressage_num.text = [NSString stringWithFormat:@"快递单号: %@", [detailReturnVO.refund_express_num length]?detailReturnVO.refund_express_num:@"无"];
            expressage_num.frame = CGRectMake(12, CGRectGetMaxY(expressage.frame) + 5, ScreenW-24, 20);
            [cell.contentView addSubview:expressage_num];
        }
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    CGFloat h = 0;
    if (row == 0) {
        //    0=待确认售后，1=待上传快递单号,2=待商家收货（此状态现在弃用）,3=退款中，4=退款完成，5=拒绝退款，6=退款失败，-1=取消售后'
        NSString *detailStr = @"";
        switch ([detailReturnVO.refund_status integerValue]) {
            case 0:
            case 6:
                detailStr = detailReturnVO.content.length>0?detailReturnVO.content:@"null";
                detailStr = [detailStr stringByReplacingOccurrencesOfString:@";" withString:@"\n\n"];
                break;
            case 1:
                return 65;
                break;
            case 2:
                detailStr = @"null";
                break;
            case 3:
                detailStr = detailReturnVO.content.length>0?detailReturnVO.content:@"null";
                detailStr = [detailStr stringByReplacingOccurrencesOfString:@";" withString:@"\n\n"];
                if([detailReturnVO.need_refund_goods integerValue]==1){
                    h += 30;
                }
                break;
            case 4:
                h += 20;
                for (int i = 1; i < detailReturnVO.refund_success_arr.count; i++) {
                    NSString *sucStr = detailReturnVO.refund_success_arr[i];
                    
                    if ([sucStr length] > 0) {
                        detailStr = [detailStr stringByAppendingString:@"\n"];
                        detailStr = [detailStr stringByAppendingString:sucStr];
                    }
                }
                break;
            case 5:
                detailStr = detailReturnVO.fail_reason?detailReturnVO.refuse_reason:@"您的退款申请未通过";
                break;
            default:
                break;
        }
        
        CGSize detailSize = [detailStr sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(ScreenW-50, 1000) lineBreakMode:NSLineBreakByCharWrapping];
        return 45 + detailSize.height + h;
    }else if (row == 1){
        //    0=待确认售后，1=待上传快递单号,2=待商家收货（此状态现在弃用）,3=退款中，4=退款完成，5=拒绝退款，-1=取消售后'
        CGFloat h = 0;
        if (_addressVO) {
            NSString *nameStr = [NSString stringWithFormat:@"收货人 : %@", _addressVO.name];
            CGSize nameSize = [nameStr sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(ScreenW - 60, 100000) lineBreakMode:NSLineBreakByCharWrapping];
            NSString *phoneStr = [NSString stringWithFormat:@"手机 : %@", _addressVO.mobile];
            CGSize phoneSize = [phoneStr sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(ScreenW - 60, 100000) lineBreakMode:NSLineBreakByCharWrapping];
            if (nameSize.width + 15 + phoneSize.width > (ScreenW - 60)) {
                h = 5 + nameSize.height + 10 + phoneSize.height + 10;
            }else{
                h = 5 + nameSize.height+10;
            }
            NSString *addrStr = [NSString stringWithFormat:@"地址 : %@", _addressVO.address];
            CGSize addrSize = [addrStr sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(ScreenW - 60, 100000) lineBreakMode:NSLineBreakByCharWrapping];
            h += addrSize.height+40;
        }
        switch ([detailReturnVO.refund_status integerValue]) {
            case 1:
                return h;
                break;
            default:
                return 0;
                break;
        }
    } else if(row == 2){
        return 30;
    }else if (row == 3){
        return 110;
    }else{
        NSString *comment = [NSString stringWithFormat:@"备注说明: %@",detailReturnVO.refund_note];
        CGSize textSize = [comment sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(ScreenW-24, 1000) lineBreakMode:NSLineBreakByCharWrapping];
        return 125+textSize.height+5 + 50;
    }
    return 0;
}

#pragma mark - 取消退款申请
- (void)cancelRefundOperation
{
    [self loadHUD];
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    NSString *userid = nil;
    NSString *usertoken = nil;
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    NSMutableDictionary *paramsDict = [req params];
    NSMutableDictionary *subParams = [[NSMutableDictionary alloc] init];
    if (userid) {
        [subParams setObject:[NSNumber numberWithLong:[userid integerValue]] forKey:@"user_id"];
    }
    
    if (usertoken) {
        [subParams setObject:usertoken forKey:@"user_token"];
    }
    
    if (_goodVO.order_part_id) {
        [subParams setObject:_goodVO.order_part_id forKey:@"order_part_id"];
    }
    
    if (_orderID) {
        [subParams setObject:_orderID forKey:@"order_id"];
    }
    
    [paramsDict setObject:subParams forKey:@"params"];
    [paramsDict setObject:@"cancel_refund_order" forKey:@"method"];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        [self hideHUD];
        [self performSelectorOnMainThread:@selector(cancelRefundResponse:) withObject:resp waitUntilDone:YES];
    } failed:^(NSError *error) {
        [self hideHUD];
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)cancelRefundResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        if ([statusStr isEqualToString:@"OK"] && [statusStr isEqualToString:@"code"] == 0) {
            [self textStateHUD:@"取消退款已成功"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"flashOrder" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"flashDetail" object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self textStateHUD:[respDict objectForKey:@"msg"]];
        }
    }else {
        [self textStateHUD:@"取消退款失败"];
    }
}

//取消退款
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self cancelRefundOperation];
    }
}

#pragma mark - 退款商品按钮操作
- (void)orderBtnClick:(NSInteger)tag andVO:(OrderGoodsVO *)orderData{
    switch (tag) {
        case 8://取消退款
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"取消退款" message:@"确定取消退款?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            
            [alertView show];
        }
        default:
            break;
    }
}

#pragma mark - 填写寄件信息
- (void)writeOrder:(OrderGoodsVO *)orderData{
    kata_ReturnGoodsViewController *returnGoodsVC = [[kata_ReturnGoodsViewController alloc] initWithAddress:_addressVO andPartID:[_goodVO.order_part_id integerValue]];
    returnGoodsVC.navigationController = self.navigationController;
    returnGoodsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:returnGoodsVC animated:YES];
}

#pragma mark - 返回
- (void)popToVC{
    if (!_type) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[kata_OrderManageViewController class]] || [vc isKindOfClass:[kata_AllOrderListViewController class]] || [vc isKindOfClass:[kata_AllOrderListViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }
}

@end

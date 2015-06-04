//
//  kata_ReturnGoodsViewController.m
//  YingMeiHui
//
//  Created by work on 15-2-2.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "kata_ReturnGoodsViewController.h"
#import "kata_TextField.h"
#import "kata_UserManager.h"

@interface kata_ReturnGoodsViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    detailAddressVO *_addressVO;
    NSMutableArray *_expresArray;
    NSString *_expressNum;
    NSInteger _partid;
    NSInteger _expressID;
    
    UIPickerView *pickView;
    UIToolbar *toolBar;
    kata_TextField *trackField;
    kata_TextField *logisticsField;
    UIButton *submitBtn;
}

@end

@implementation kata_ReturnGoodsViewController

- (id)initWithAddress:(detailAddressVO *)address andPartID:(NSInteger)partid{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.title = @"寄件信息";
        self.ifAddPullToRefreshControl = NO;
        _expressID = -1;
        _partid = partid;
        
        _addressVO = address;
        _expresArray = [[NSMutableArray alloc] init];
        [_expresArray addObject:@"请选择快递公司"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height-150, ScreenW, 150)];
    pickView.backgroundColor = [UIColor whiteColor];
    pickView.delegate = self;
    pickView.dataSource = self;
    pickView.showsSelectionIndicator = YES;
    
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 44)];
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(closeKeyBord)];
    [spaceButtonItem setWidth:ScreenW-54];
    
    toolBar.items = [NSArray arrayWithObjects:spaceButtonItem,right, nil];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = TABLE_COLOR;
    
    [self getTrackList];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load ReturnOrderDetail
- (void)getTrackList
{
    [self loadHUD];
    
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    NSMutableDictionary *paramsDict = [req params];
    [paramsDict setObject:@"get_express_list" forKey:@"method"];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        [self hideHUD];
        [self performSelectorOnMainThread:@selector(getTrackParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        [self hideHUD];
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)getTrackParseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if ([respDict objectForKey:@"data"] != nil && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]]) {
                [_expresArray addObjectsFromArray:[ExpressVO ExpressVOWithArray:[respDict objectForKey:@"data"]]];
                [self hideHUD];
                [self.tableView reloadData];
                return;
            }
        }
    }
    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"快递公司信息获取失败" waitUntilDone:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_expresArray.count > 0) {
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSString *CELLIDFER = [NSString stringWithFormat:@"CELL_%zi",row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDFER];
    if (row == 0) {
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELLIDFER];
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
                
                UILabel *adressNameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
                [adressNameLbl setTextColor:[UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1]];
                [adressNameLbl setFont:[UIFont systemFontOfSize:12.0]];
                adressNameLbl.numberOfLines = 0;// 不可少Label属性之一
                adressNameLbl.lineBreakMode = NSLineBreakByCharWrapping;// 不可少Label属性之二
                [headImgView addSubview:adressNameLbl];
                
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
                
                NSString *nameStr = [NSString stringWithFormat:@"收货人 : %@", _addressVO.name];
                [adressNameLbl setText:nameStr];
                CGSize nameSize = [nameStr sizeWithFont:adressNameLbl.font constrainedToSize:CGSizeMake(ScreenW - 60, 100000) lineBreakMode:NSLineBreakByCharWrapping];
                [adressNameLbl setFrame:CGRectMake(45, CGRectGetMaxY(adressDetailLbl.frame) + 10, nameSize.width, nameSize.height)];
                
                UILabel *adressPhoneLbl = [[UILabel alloc] initWithFrame:CGRectZero];
                [adressPhoneLbl setTextColor:[UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:1]];
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
                [headImgView setFrame:CGRectMake(0, 10, ScreenW, _headViewH)];
                [adressImgView setFrame:CGRectMake(12, (_headViewH - 25)/2, 20, 25)];
                
            }
        }
    }else if (row == 1){
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLIDFER];
            cell.backgroundColor = [UIColor whiteColor];
            
            UILabel *trackLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 70, 30)];
            [trackLbl setBackgroundColor:[UIColor clearColor]];
            [trackLbl setText:@"快递公司: "];
            [trackLbl setTextColor:TEXTV_COLOR];
            [trackLbl setFont:[UIFont systemFontOfSize:15.0]];
            [cell.contentView addSubview:trackLbl];
            
            trackField = [[kata_TextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(trackLbl.frame)+10, CGRectGetMinY(trackLbl.frame), ScreenW/2, 30)];
            [trackField setTextColor:TEXTV_COLOR];
            [trackField setFont:[UIFont systemFontOfSize:15.0]];
            [trackField.layer setBorderWidth:0.5];
            [trackField.layer setBorderColor:[DETAIL_COLOR CGColor]];
            [trackField.layer setCornerRadius:3.0];
            trackField.text = @"请选择快递公司";
            trackField.inputView = pickView;
            trackField.inputAccessoryView = toolBar;
            trackField.delegate = self;
            [cell.contentView addSubview:trackField];
            
            UIImageView *selectView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(trackField.frame)-30, 0, 30, 30)];
            selectView.image = [UIImage imageNamed:@"select_track"];
            [trackField addSubview:selectView];
            
            UILabel *logisticsLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(trackLbl.frame), CGRectGetMaxY(trackLbl.frame)+10, CGRectGetWidth(trackLbl.frame), CGRectGetHeight(trackLbl.frame))];
            [logisticsLbl setBackgroundColor:[UIColor clearColor]];
            [logisticsLbl setText:@"物流单号: "];
            [logisticsLbl setTextColor:TEXTV_COLOR];
            [logisticsLbl setFont:[UIFont systemFontOfSize:15.0]];
            [cell.contentView addSubview:logisticsLbl];
            
            logisticsField = [[kata_TextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logisticsLbl.frame)+10, CGRectGetMinY(logisticsLbl.frame), ScreenW - CGRectGetMaxX(logisticsLbl.frame)-20, 30)];
            [logisticsField setTextColor:TEXTV_COLOR];
            [logisticsField setFont:[UIFont systemFontOfSize:15.0]];
            [logisticsField.layer setBorderWidth:0.5];
            [logisticsField.layer setCornerRadius:3.0];
            logisticsField.clearButtonMode = UITextFieldViewModeWhileEditing;
            logisticsField.placeholder = @"请填写物流单号";
            [logisticsField.layer setBorderColor:[DETAIL_COLOR CGColor]];
            trackField.delegate = self;
            [cell.contentView addSubview:logisticsField];
            
            submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(logisticsField.frame), CGRectGetMaxY(logisticsField.frame)+20, 90, 30)];
            [submitBtn setBackgroundColor:ALL_COLOR];
            [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [submitBtn setTitle:@"提交信息" forState:UIControlStateNormal];
            [submitBtn.layer setCornerRadius:5.0];
            [submitBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
            [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:submitBtn];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (row == 0) {
        CGFloat h = 10;
        if (_addressVO) {
            NSString *nameStr = [NSString stringWithFormat:@"收货人 : %@", _addressVO.name];
            CGSize nameSize = [nameStr sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(ScreenW - 60, 100000) lineBreakMode:NSLineBreakByCharWrapping];
            NSString *phoneStr = [NSString stringWithFormat:@"手机 : %@", _addressVO.mobile];
            CGSize phoneSize = [phoneStr sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(ScreenW - 60, 100000) lineBreakMode:NSLineBreakByCharWrapping];
            if (nameSize.width + 15 + phoneSize.width > (ScreenW - 60)) {
                h += 5 + nameSize.height + 10 + phoneSize.height + 10;
            }else{
                h += 5 + nameSize.height+10;
            }
            NSString *addrStr = [NSString stringWithFormat:@"地址 : %@", _addressVO.address];
            CGSize addrSize = [addrStr sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(ScreenW - 60, 100000) lineBreakMode:NSLineBreakByCharWrapping];
            h += addrSize.height+15;
        }
        
        return h+25;
    }else{
        return 140;
    }
    return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([_expresArray[row] isKindOfClass:[NSString class]]) {
        return _expresArray[row];
    }else{
        ExpressVO *express = _expresArray[row];
        return express.name;
    }
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _expresArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if ([_expresArray[row] isKindOfClass:[NSString class]]) {
        trackField.text = _expresArray[row];
        _expressID = row;
    }else{
        ExpressVO *express = _expresArray[row];
        _expressID = [express.express_id integerValue];
        trackField.text = express.name;
    }
}

- (void)submitBtnClick{
    [self.view endEditing:YES];
    if(_expressID <= 0){
        [self textStateHUD:@"请选择快递公司"];
        //[trackField becomeFirstResponder];
        return;
    }
    //过滤字符串前后的空格
    _expressNum = [logisticsField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //过滤中间空格
    _expressNum = [_expressNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (_expressNum.length > 0) {
        [self submitExpress];
    }else{
        [self textStateHUD:@"请填写快递单号"];
    }
}

#pragma mark - 提交物流信息
- (void)submitExpress
{
    [self loadHUD];
    
    [submitBtn setEnabled:NO];
    
    NSString *userid = nil;
    NSString *usertoken = nil;
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    NSMutableDictionary *paramsDict = [req params];
    NSMutableDictionary *subParams = [[NSMutableDictionary alloc] init];
    if (userid) {
        [subParams setObject:[NSNumber numberWithLong:[userid integerValue]] forKey:@"user_id"];
    }
    
    if (usertoken) {
        [subParams setObject:usertoken forKey:@"user_token"];
    }
    
    if (_partid > 0) {
        [subParams setObject:[NSNumber numberWithInteger:_partid] forKey:@"order_part_id"];
    }
    if (_expressID > 0) {
        [subParams setObject:[NSNumber numberWithInteger:_expressID] forKey:@"express_id"];
    }
    if (_expressNum > 0) {
        [subParams setObject:_expressNum forKey:@"express_num"];
    }
    [paramsDict setObject:subParams forKey:@"params"];
    [paramsDict setObject:@"upload_express_info" forKey:@"method"];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        [submitBtn setEnabled:YES];
        [self hideHUD];
        [self performSelectorOnMainThread:@selector(submitExpressResponse:) withObject:resp waitUntilDone:YES];
    } failed:^(NSError *error) {
        [self hideHUD];
        [submitBtn setEnabled:YES];
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)submitExpressResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"] && [[respDict objectForKey:@"code"] integerValue] == 0) {
            [self textStateHUD:@"信息提交成功"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"flashOrder" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"flashDetail" object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"信息提交失败" waitUntilDone:YES];
}

- (void)closeKeyBord{
    [self.view endEditing:YES];
}

- (void)keyboardWillChange:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    frame.size.height -= keyboardRect.size.height;
    self.tableView.frame = frame;
}

- (void)keyboardWillHide:(NSNotification *)notification{
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    
    self.tableView.frame = frame;
}

@end

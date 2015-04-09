//
//  EvaluationTableViewController.m
//  YingMeiHui
//
//  Created by 王凯 on 15-1-30.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "EvaluationTableViewController.h"
#import "EvaluationViewCell.h"
#import "CWStarRateView.h"
#import <UIImageView+WebCache.h>
#import "KTBaseRequest.h"
#import "kata_UserManager.h"
#import "ZYQAssetPickerController.h"
#import "KTProxy.h"
#import "LMHSaveEvaluateInfoRequest.h"
#import "UpYun.h"

@interface EvaluationTableViewController ()<UITextViewDelegate>
{
    NSMutableArray *describeArr;
    CWStarRateView *sendStar;
    CWStarRateView *logisticsStar;
    UIButton *okButton;
    NSMutableArray *imageViewArr;
    NSMutableArray *imageUrlArr;
    NSInteger select;
    NSInteger imageTag;
    NSMutableArray *textArr;
    OrderEventVO *_eventVO;
    NSMutableArray *OKArr;
    UpYun *upYun;
}

@end

@implementation EvaluationTableViewController

- (id)initWithOrderEventVO:(OrderEventVO *) eventVO{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.ifAddPullToRefreshControl = NO;
        
        describeArr = [[NSMutableArray alloc] init];
        imageViewArr = [[NSMutableArray alloc] init];
        textArr = [[NSMutableArray alloc] init];
        imageUrlArr = [[NSMutableArray alloc] init];
        OKArr = [[NSMutableArray alloc] init];
        
        _eventVO = eventVO;
        for (int i = 0; i < eventVO.goods.count; i++) {
            NSMutableArray *MUarry = [[NSMutableArray alloc] init];
            [imageViewArr addObject:MUarry];
        }
        
        upYun = [[UpYun alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"评价订单";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return _eventVO.goods.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == _eventVO.goods.count) {
        if (_eventVO.goods.count == 1) {
            return self.view.bounds.size.height - 320;
        } else{
          return 150;
        }
    } else {
        return 260;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_eventVO.goods.count == 1) {
        return 0;
    } else{
        return 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 声明重用标识
    static NSString *cellIdentifier_1 = @"cellIdentifier_1";
    NSString *cellIdentifier_2 = [NSString stringWithFormat:@"cellIdentifierd_%d", indexPath.section];
//    NSLog(@"%@",cellIdentifier_2);
    if (indexPath.section == _eventVO.goods.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_1];
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier_1];
            UILabel *sendLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 45, 30)];
            sendLabel.textAlignment = 0;
            sendLabel.text = @"发货速度";
            sendLabel.font = FONT(11);
            [cell addSubview:sendLabel];
            
            sendStar = [[CWStarRateView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sendLabel.frame) + 20, CGRectGetMinY(sendLabel.frame), 170, 25) numberOfStars:5];
            sendStar.scorePercent = 0.0;
            sendStar.allowIncompleteStar = YES;
            sendStar.hasAnimation = YES;
            sendStar.scorePercent = 1.0f;
            [cell addSubview: sendStar];
            
            UILabel *logisticsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(sendLabel.frame), 45, 30)];
            logisticsLabel.textAlignment = 0;
            logisticsLabel.text = @"物流速度";
            logisticsLabel.font = FONT(11);
            [cell addSubview:logisticsLabel];
            
            logisticsStar = [[CWStarRateView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logisticsLabel.frame) + 20, CGRectGetMinY(logisticsLabel.frame), 170, 25) numberOfStars:5];
            logisticsStar.scorePercent = 0.0;
            logisticsStar.allowIncompleteStar = YES;
            logisticsStar.hasAnimation = YES;
            logisticsStar.scorePercent = 1.0f;
            [cell addSubview: logisticsStar];
            
            okButton = [UIButton buttonWithType:UIButtonTypeSystem];
            okButton.frame = CGRectMake(ScreenW/8*3, CGRectGetMaxY(logisticsLabel.frame) + 20, ScreenW/4, ScreenW/4/170*55);
            [okButton setBackgroundImage:[UIImage imageNamed:@"red_btn_small"] forState:UIControlStateNormal];
            [okButton setTitle:@"提交评论" forState:UIControlStateNormal];
            okButton.tintColor = [UIColor whiteColor];
            [okButton addTarget:self action:@selector(uploadFile) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:okButton];
            if (_eventVO.goods.count == 1) {
                okButton.frame = CGRectMake(ScreenW/8*3, (self.view.bounds.size.height-320 - (ScreenW/4/170*55) + 60)/2 - 10 , ScreenW/4, ScreenW/4/170*55);
            }

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    } else {
        EvaluationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_2];
        if (!cell) {
            cell = [[EvaluationViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier_2];
            // 添加相片
            for (int i = 0; i < 5; i++) {
                UIImageView *uploadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 + (i * 65), CGRectGetMaxY(cell.adviceView.frame) + 15, 40 , 40)];
                uploadImageView.image = nil;
                uploadImageView.image = [UIImage imageNamed:@"upLoadImage"];
                uploadImageView.userInteractionEnabled = YES;
                uploadImageView.tag = (indexPath.section + 1) * 1000+i;
                [cell addSubview:uploadImageView];
                UITapGestureRecognizer *uploadImageViewTap = [[UITapGestureRecognizer alloc]init];
                [uploadImageViewTap addTarget:self action:@selector(tap:)];
                [uploadImageView addGestureRecognizer:uploadImageViewTap];
            }
        }
        
        if (imageViewArr.count > 0) {
            for (int j = 0; j < [imageViewArr[indexPath.section] count]; j++) {
                UIImageView *addImageView = (UIImageView *)[cell viewWithTag:(indexPath.section + 1) * 1000 + j];
                addImageView.image = imageViewArr[indexPath.section][j];
            }
            for (int j = [imageViewArr[indexPath.section] count]; j < 5; j++) {
                UIImageView *addImageView = (UIImageView *)[cell viewWithTag:(indexPath.section + 1) * 1000 + j];
                addImageView.image = [UIImage imageNamed:@"upLoadImage"];
            }
        }
        [describeArr addObject:cell.starRateView];
//        cell.adviceView.delegate = self;
        OrderGoodsVO *goods = _eventVO.goods[indexPath.section];
        [cell.headView sd_setImageWithURL:[NSURL URLWithString:goods.image]];
        cell.titleLabel.text = goods.goods_title;
        cell.countLabel.text = [goods.quantity stringValue];
        cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f",[goods.sales_price floatValue]];
        cell.primeCost.text = [NSString stringWithFormat:@"￥%.2f",[goods.market_price floatValue]];
        CGSize oldPriceLineHight = [[NSString stringWithFormat:@"￥%.2f",[goods.market_price floatValue]] sizeWithFont:FONT(11) constrainedToSize:CGSizeMake(500, 15)];
        cell.moneyView.frame = CGRectMake(2, 5, oldPriceLineHight.width, 1);
        
        NSString *colorSize = @"";
        if(goods.goods_iguige_label != nil && goods.goods_iguige_value != nil){
            colorSize = [NSString stringWithFormat:@"%@: %@;", goods.goods_iguige_label, goods.goods_iguige_value];
            cell.colorLabel.text = colorSize;
        }
        if (goods.goods_guige_label != nil && goods.goods_guige_value != nil) {
            cell.colorLabel.text = [NSString stringWithFormat:@"%@ %@: %@", colorSize, goods.goods_guige_label, goods.goods_guige_value];
        }
        [textArr addObject:cell.adviceView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    return nil;
}
//-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
//
//{
//    
//    NSLog(@"dafease");
//    
//    return YES;
//    
//}


- (void)okLogin
{
    [OKArr removeAllObjects];
    for (int i = 0; i<_eventVO.goods.count; i++) {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        // 添加商品子订单号
        OrderGoodsVO *goods = _eventVO.goods[i];
        NSString *partID = goods.order_part_id;
        [dic setObject:partID forKey:@"order_part_id"];
        
        // 添加评价内容
        UITextView *textView = textArr[i];
        NSString *textStr = textView.text;
        if (textStr.length > 0) {
            [dic setObject:textStr forKey:@"content"];
        }else{
            [dic setObject:[NSNull null] forKey:@"content"];
        }

        // 添加评价评级
        [dic setObject:[NSNumber numberWithInteger:0] forKey:@"rate"];
        // 添加描述相符评价
        CWStarRateView *star = describeArr[i];
        NSInteger des = (int)(star.scorePercent * 10) + 1;
        if (star.scorePercent < 0.03) {
            des = 0;
        }
        if (star.scorePercent >= 1) {
            des = 10;
        }
        CGFloat desf = des;
        [dic setObject:[NSString stringWithFormat:@"%.1f", desf/2]forKey:@"description_score"];
        // 添加发货速度评价
        NSInteger sen = (int)(sendStar.scorePercent * 10) + 1;
        if (sendStar.scorePercent < 0.03) {
            sen = 0;
        }if (sendStar.scorePercent >= 1) {
            sen = 10;
        }
        CGFloat senf = sen;
        [dic setObject:[NSString stringWithFormat:@"%.1f", senf/2] forKey:@"delivery_score"];
        // 添加物流速度评价
        NSInteger log = (int)(logisticsStar.scorePercent * 10) + 1;
        if (logisticsStar.scorePercent < 0.03) {
            log = 0;
        }if (logisticsStar.scorePercent >= 1) {
            log = 10;
        }
        CGFloat logf = log;
        [dic setObject:[NSString stringWithFormat:@"%0.1f", logf/2] forKey:@"express_score"];
        //添加电脑晒图图片集合
        if (i < imageUrlArr.count) {
            if ([imageUrlArr[i] isKindOfClass:[NSArray class]]) {
                [dic setObject:imageUrlArr[i] forKey:@"image_urls"];
            }else{
                [dic setObject:[NSNull null] forKey:@"image_urls"];
            }
        }
        [OKArr addObject:dic];
    }
    [self commiteInfoOperation];
}

#pragma mark - 上传图片
- (void)uploadFile{
    
    //上传过程 显示加载菊花
    [self loadHUD];
    [imageUrlArr removeAllObjects];
    [imageUrlArr addObjectsFromArray:_eventVO.goods];
    
    __block NSInteger imgCount = 0;
    __block NSInteger useImgCount = 0;
    __block NSMutableArray *marray = [[NSMutableArray alloc] init];
    for(int j = 0; j < imageViewArr.count; j++){
        for (int i = 0; i < [imageViewArr[j] count]; i++) {
            useImgCount++;
        }
    }
    
    if (useImgCount <= 0) {
        [self okLogin];
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    for(int j = 0; j < imageViewArr.count; j++){
        OrderGoodsVO *goodsVo = _eventVO.goods[j];
        for (int i = 0; i < [imageViewArr[j] count]; i++){
            [manager POST:@"http://121.41.77.48:8001/uploadphoto" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                // 上传图片，以文件流的格式
                UIImage *uimg = imageViewArr[j][i];
                NSData *imageData = UIImageJPEGRepresentation(uimg, 0.2);
                [formData appendPartWithFileData:imageData name:@"photo" fileName:[self getSaveKey:arc4random()%10000000+1 andPartid:[goodsVo.goods_id integerValue]] mimeType:@"image/jpeg"];
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *urlStr = operation.responseString;
                NSLog(@"%@",urlStr);
                [marray addObject:urlStr];
                
                if (marray.count == useImgCount) {
                    imgCount = 0;
                    for (int i = 0; i < imageUrlArr.count; i++) {
                        OrderGoodsVO *gvo = imageUrlArr[i];
                        NSMutableArray *urlArray = [[NSMutableArray alloc] init];
                        NSString *idstr = [NSString stringWithFormat:@"%@",gvo.goods_id];
                        for (NSString *goodsid in marray) {
                            NSRange range = [goodsid rangeOfString:idstr];
                            if (range.length > 0) {
                                [urlArray addObject:goodsid];
                            }
                            imgCount ++;
                        }
                        [imageUrlArr replaceObjectAtIndex:i withObject:urlArray];
                    }
                }
                if(imgCount == imageUrlArr.count*marray.count){
                    [self okLogin];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                imgCount++;
                if(imgCount == imageUrlArr.count*marray.count){
                    [self okLogin];
                }
            }];
        }
    }
}

-(NSString * )getSaveKey:(NSInteger)imgno andPartid:(NSInteger)partid{
    // 上传图片，以文件流的格式
    NSString *userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    NSString *fileName = [NSString stringWithFormat:@"%@%zi_%d.jpg", userid,imgno,partid];
    
    return fileName;
}

#pragma mark - 网络请求
- (void)commiteInfoOperation
{
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    NSString *userid = nil;
    NSString *usertoken = nil;
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    if (userid && usertoken) {
        req = [[LMHSaveEvaluateInfoRequest alloc] initWithUserID:[userid integerValue] andUserToken:usertoken andEvaluationArr:OKArr];
    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(commiteInfoParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        [self textStateHUD:@"获取失败"];
    }];
    
    [proxy start];
}

- (void)commiteInfoParseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        if([respDict isKindOfClass:[NSDictionary class]]){
            NSString *statusStr = [respDict objectForKey:@"status"];
            
            if ([statusStr isEqualToString:@"OK"] && [statusStr isEqualToString:@"code"] == 0) {
                [self textStateHUD:@"评价成功"];
                [self performSelector:@selector(reloadList) withObject:nil afterDelay:1.0];
                [self.navigationController popViewControllerAnimated:YES];
                
            } else {
                id messageObj = [respDict objectForKey:@"msg"];
                [self textStateHUD:messageObj];
            }
        } else {
            [self textStateHUD:@"评价失败"];
        }
    }else{
        [self textStateHUD:@"评价失败"];
    }
    
}

- (void)reloadList{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"flashOrder" object:nil userInfo:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)tap:(UITapGestureRecognizer *)tap{
    UITapGestureRecognizer *tapZer = tap;
    if ([tapZer.view isKindOfClass:[UIImageView class]]) {
        imageTag = tapZer.view.tag;
        NSInteger cllCount = imageTag / 1000 ;
        if (tapZer.view.tag - cllCount * 1000 + 1 > [imageViewArr[cllCount-1] count]) {
            select = 1;
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照相机" otherButtonTitles:@"图片库",nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
            [actionSheet showFromRect:self.view.bounds inView:self.view animated:YES];
        }else {
            select = 0;
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
            [actionSheet showFromRect:self.view.bounds inView:self.view animated:YES];
        }
    }
}
#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            if (select == 1) {
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;//设置UIImagePickerController的代理，同时要遵循UIImagePickerControllerDelegate，UINavigationControllerDelegate协议
                    picker.allowsEditing = YES;//设置拍照之后图片是否可编辑，如果设置成可编辑的话会在代理方法返回的字典里面多一些键值。PS：如果在调用相机的时候允许照片可编辑，那么用户能编辑的照片的位置并不包括边角。
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;//UIImagePicker选择器的类型，UIImagePickerControllerSourceTypeCamera调用系统相机
                    [self presentViewController:picker animated:YES completion:nil];
                }
            else{
                //如果当前设备没有摄像头
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"哎呀，当前设备没有摄像头。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                }
            } else {
                NSInteger cllCount = imageTag / 1000 ;
                
                UIImageView *imageView = (UIImageView *)[self.view viewWithTag:imageTag];
                imageView.image = [UIImage imageNamed:@"upLoadImage"];
                [imageViewArr[cllCount - 1] removeObjectAtIndex:(imageTag - cllCount * 1000)];
                [self.tableView reloadData];
            }
            break;
        }
        case 1:
        {
            if (select == 1) {
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
                    picker.delegate = self;
                    picker.allowsEditing = YES;//是否可以对原图进行编辑
                    //打开相册选择照片
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    [self presentViewController:picker animated:YES completion:nil];
                }
                else{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"图片库不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                }
            }
            break;
        }
        case 2:
        {
            break;
        }
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate
#pragma mark - 拍照/选择图片结束
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    NSLog(@"如果允许编辑%@",info);//picker.allowsEditing= YES允许编辑的时候 字典会多一些键值。
    //获取图片
    //    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];//原始图片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];//编辑后的图片
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//把图片存到图片库
        NSInteger cllCount = imageTag / 1000 ;
        [imageViewArr[cllCount - 1] addObject:image];
        
        [self.tableView reloadData];
    }else{
        NSInteger cllCount = imageTag / 1000 ;
        [imageViewArr[cllCount - 1] addObject:image];

        [self.tableView reloadData];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark - 取消拍照/选择图片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)keyboardWillChange:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    CGRect frame = self.contentView.frame;
    frame.origin.y = 0;
    frame.size.height -= keyboardRect.size.height;
    
    self.tableView.frame = frame;
}

- (void)keyboardWillHide:(NSNotification *)notification{
    CGRect frame = self.contentView.frame;
    frame.origin.y = 0;
    self.tableView.frame = frame;
}

@end

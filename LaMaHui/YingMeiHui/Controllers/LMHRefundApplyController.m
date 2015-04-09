//
//  LMHRefundApplyController.m
//  YingMeiHui
//
//  Created by Zhumingming on 15-1-30.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "LMHRefundApplyController.h"
#import "kata_UserManager.h"
#import "KTBaseRequest.h"
#import "KTProxy.h"
#import <UIImageView+WebCache.h>
#import "LMHRefundApplyRequest.h"

@interface LMHRefundApplyController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate,UINavigationBarDelegate>
{
    UIScrollView *_scrollView;
    UITextField *_refundAmountTextField;
    UITextField *_refundNumberTextField;
    UITextField *_phoneTextField;
    UITextView *_remarkExplainTextView;
    UILabel *refundReasonLabel;
    UILabel *selectRefundReasonLabel;
    UIImageView *uploadImageView;
    UITableView *_selectTableView;
    NSArray *refundReasonArr;
    NSMutableArray *imageViewArr;
    UIActionSheet *sheetView;
    NSInteger replaceIndex;
    NSInteger insertNum;
}
@end

@implementation LMHRefundApplyController

- (void)viewWillAppear:(BOOL)animated
{
    [_scrollView removeFromSuperview];
    [self getRefundReasonOperation];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"退款订单";
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGRect frame = self.contentView.frame;
    frame.size.height += 64;
    self.contentView.frame = frame;
    
    imageViewArr = [NSMutableArray arrayWithCapacity:0];
    
    replaceIndex = 0;
    insertNum = 0;
}
- (void)createUI
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    _scrollView.contentSize = CGSizeMake(ScreenW, ScreenH);
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.bounces = NO;
    _scrollView.scrollEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:_scrollView];
    
    UITapGestureRecognizer *scrollViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewTapClick:)];
    scrollViewTap.delegate = self;
    [_scrollView addGestureRecognizer:scrollViewTap];
    
    //订单编号
    UILabel *orderIdLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, ScreenW - 20, 30)];
    orderIdLabel.backgroundColor = [UIColor clearColor];
    orderIdLabel.text = @"订单编号：123456789";
    orderIdLabel.textColor = GRAY_COLOR;
    orderIdLabel.font = FONT(15);
    [_scrollView addSubview:orderIdLabel];
    
    //退款金额
    UILabel *refundAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(orderIdLabel.frame), 75, 30)];
    refundAmountLabel.backgroundColor = [UIColor clearColor];
    refundAmountLabel.text = @"退款金额：";
    refundAmountLabel.textColor = GRAY_COLOR;
    refundAmountLabel.font = FONT(15);
    [_scrollView addSubview:refundAmountLabel];
    
    _refundAmountTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(refundAmountLabel.frame), CGRectGetMaxY(orderIdLabel.frame), 70, 30)];
    _refundAmountTextField.backgroundColor = [UIColor clearColor];
    _refundAmountTextField.layer.cornerRadius = 3.0f;
    _refundAmountTextField.layer.masksToBounds = YES;
    _refundAmountTextField.layer.borderColor = [GRAY_LINE_COLOR CGColor];
    _refundAmountTextField.layer.borderWidth = 1.0f;
    _refundAmountTextField.textColor = GRAY_COLOR;
    _refundAmountTextField.font = FONT(15);
    _refundAmountTextField.delegate = self;
    _refundAmountTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _refundAmountTextField.returnKeyType = UIReturnKeyNext;
    [_scrollView addSubview:_refundAmountTextField];
    
    UILabel *maxAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_refundAmountTextField.frame), CGRectGetMaxY(orderIdLabel.frame), 150, 30)];
    maxAmountLabel.backgroundColor = [UIColor clearColor];
    maxAmountLabel.textColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1];
    maxAmountLabel.font = FONT(13);
    [_scrollView addSubview:maxAmountLabel];
    
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"元  %@",@"(最多可退款16元)"]];
    [attribute addAttribute:NSFontAttributeName value:FONT(15.0) range:NSMakeRange(0, 1)];
    [attribute addAttribute:NSForegroundColorAttributeName value:GRAY_COLOR range:NSMakeRange(0,1)];
    maxAmountLabel.attributedText = attribute;
                                            
    //退款数量
    UILabel *refundNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(refundAmountLabel.frame) +10, 75, 30)];
    refundNumberLabel.backgroundColor = [UIColor clearColor];
    refundNumberLabel.text = @"退款数量：";
    refundNumberLabel.textColor = GRAY_COLOR;
    refundNumberLabel.font = FONT(15);
    [_scrollView addSubview:refundNumberLabel];
    
    _refundNumberTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(refundNumberLabel.frame), CGRectGetMaxY(refundAmountLabel.frame) +10, 70, 30)];
    _refundNumberTextField.backgroundColor = [UIColor clearColor];
    _refundNumberTextField.layer.cornerRadius = 3.0f;
    _refundNumberTextField.layer.masksToBounds = YES;
    _refundNumberTextField.layer.borderColor = [GRAY_LINE_COLOR CGColor];
    _refundNumberTextField.layer.borderWidth = 1.0f;
    _refundNumberTextField.textColor = GRAY_COLOR;
    _refundNumberTextField.font = FONT(15);
    _refundNumberTextField.delegate = self;
    _refundNumberTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _refundNumberTextField.returnKeyType = UIReturnKeyNext;
    [_scrollView addSubview:_refundNumberTextField];

    UILabel *numberTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_refundNumberTextField.frame), CGRectGetMaxY(refundAmountLabel.frame) +10, 150, 30)];
    numberTextLabel.backgroundColor = [UIColor clearColor];
    numberTextLabel.text = @"件";
    numberTextLabel.textColor = GRAY_COLOR;
    numberTextLabel.font = FONT(15);
    [_scrollView addSubview:numberTextLabel];
    
    //联系方式
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(refundNumberLabel.frame) +10, 75, 30)];
    phoneLabel.backgroundColor = [UIColor clearColor];
    phoneLabel.text = @"联系方式：";
    phoneLabel.textColor = GRAY_COLOR;
    phoneLabel.font = FONT(15);
    [_scrollView addSubview:phoneLabel];
    
    _phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(phoneLabel.frame), CGRectGetMaxY(refundNumberLabel.frame) +10, ScreenW - 85 - 30, 30)];
    _phoneTextField.backgroundColor = [UIColor clearColor];
    _phoneTextField.layer.cornerRadius = 3.0f;
    _phoneTextField.layer.masksToBounds = YES;
    _phoneTextField.layer.borderColor = [GRAY_LINE_COLOR CGColor];
    _phoneTextField.layer.borderWidth = 1.0f;
    _phoneTextField.textColor = GRAY_COLOR;
    _phoneTextField.font = FONT(15);
    _phoneTextField.delegate = self;
    _phoneTextField.clearButtonMode = YES;
    _phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    _phoneTextField.returnKeyType = UIReturnKeyNext;
    [_scrollView addSubview:_phoneTextField];
    
    //退款原因
    refundReasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(phoneLabel.frame) +10, 75, 30)];
    refundReasonLabel.backgroundColor = [UIColor clearColor];
    refundReasonLabel.text = @"退款原因：";
    refundReasonLabel.textColor = GRAY_COLOR;
    refundReasonLabel.font = FONT(15);
    [_scrollView addSubview:refundReasonLabel];
    
    selectRefundReasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(refundReasonLabel.frame), CGRectGetMaxY(phoneLabel.frame) +10, ScreenW - 85 - 30, 30)];
    selectRefundReasonLabel.backgroundColor = [UIColor clearColor];
    selectRefundReasonLabel.layer.cornerRadius = 3.0f;
    selectRefundReasonLabel.layer.masksToBounds = YES;
    selectRefundReasonLabel.layer.borderColor = [GRAY_LINE_COLOR CGColor];
    selectRefundReasonLabel.layer.borderWidth = 1.0f;
    selectRefundReasonLabel.text = @" 请选择退款原因";
    selectRefundReasonLabel.textColor = GRAY_COLOR;
    selectRefundReasonLabel.font = FONT(14);
    selectRefundReasonLabel.userInteractionEnabled = YES;
    [_scrollView addSubview:selectRefundReasonLabel];
    
    UIImageView *selectView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(selectRefundReasonLabel.frame) - 22, CGRectGetMaxY(phoneLabel.frame) +15, 20, 20)];
    selectView.backgroundColor = [UIColor whiteColor];
    selectView.image = [UIImage imageNamed:@"icon_selectRefundReason"];
    selectView.hidden = NO;
    [_scrollView addSubview:selectView];
    
    UITapGestureRecognizer *selectViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectViewTapClick)];
    
    [selectRefundReasonLabel addGestureRecognizer:selectViewTap];
    
    //备注说明
    UILabel *remarkExplainLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(refundReasonLabel.frame) +10, 75, 30)];
    remarkExplainLabel.backgroundColor = [UIColor clearColor];
    remarkExplainLabel.text = @"备注说明：";
    remarkExplainLabel.textColor = GRAY_COLOR;
    remarkExplainLabel.font = FONT(15);
    [_scrollView addSubview:remarkExplainLabel];
    
    _remarkExplainTextView = [[UITextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(remarkExplainLabel.frame), CGRectGetMaxY(refundReasonLabel.frame) +10, ScreenW - 85 - 30, 100)];
    _remarkExplainTextView.backgroundColor = [UIColor clearColor];
    _remarkExplainTextView.scrollEnabled = YES;   //当文字超过视图的边框时是否允许滑动，默认为“YES”
    _remarkExplainTextView.editable = YES;        //是否允许编辑内容，默认为“YES”
    _remarkExplainTextView.delegate = self;       //设置代理方法的实现类
    _remarkExplainTextView.layer.cornerRadius = 3.0f;
    _remarkExplainTextView.layer.masksToBounds = YES;
    _remarkExplainTextView.layer.borderColor = [GRAY_LINE_COLOR CGColor];
    _remarkExplainTextView.layer.borderWidth = 1.0f;
    _remarkExplainTextView.textColor = GRAY_COLOR;
    _remarkExplainTextView.font = FONT(15);
    _remarkExplainTextView.returnKeyType = UIReturnKeyDone;
    [_scrollView addSubview:_remarkExplainTextView];
    
    //上传图片
    UILabel *uploadImageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_remarkExplainTextView.frame) +20, 75, 30)];
    uploadImageLabel.backgroundColor = [UIColor clearColor];
    uploadImageLabel.text = @"上传图片:";
    uploadImageLabel.textColor = GRAY_COLOR;
    uploadImageLabel.font = FONT(15);
    [_scrollView addSubview:uploadImageLabel];
    
    NSInteger num = 0;
    CGFloat  numY = 0;
    //循环
    for (int i = 0; i<imageViewArr.count; i++,num++) {
        if(i == 4){
            num  = 0;
            numY = 1;
        }
        CGFloat imageWight = (CGRectGetWidth(_remarkExplainTextView.frame) - 8*3)/4;
        CGFloat frameX = CGRectGetMaxX(uploadImageLabel.frame) +(imageWight +8)*num;
        
        uploadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(frameX, CGRectGetMaxY(_remarkExplainTextView.frame) +15+numY*(imageWight +8), imageWight, imageWight)];
        uploadImageView.image = [UIImage imageNamed:@"upLoadImage"];
        uploadImageView.userInteractionEnabled = YES;
        uploadImageView.image = imageViewArr[i];
        uploadImageView.tag = 1000+i;
        [_scrollView addSubview:uploadImageView];
        
        UITapGestureRecognizer *uploadImageViewTap = [[UITapGestureRecognizer alloc]init];
        [uploadImageViewTap addTarget:self action:@selector(openCameraOrPhotoalbum:)];
        [uploadImageView addGestureRecognizer:uploadImageViewTap];
    }
    
    if (imageViewArr.count < 8) {
        if(imageViewArr.count >= 4){
            num  = 0;
            numY = 1;
        }
        CGFloat imageWight = (CGRectGetWidth(_remarkExplainTextView.frame) - 8*3)/4;
        CGFloat frameX = CGRectGetMaxX(uploadImageLabel.frame) +(imageWight +8)*num;
        
        uploadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(frameX, CGRectGetMaxY(_remarkExplainTextView.frame) +15+numY*(imageWight +8), imageWight, imageWight)];
        uploadImageView.image = [UIImage imageNamed:@"upLoadImage"];
        uploadImageView.userInteractionEnabled = YES;
        uploadImageView.tag = imageViewArr.count+1000;
        [_scrollView addSubview:uploadImageView];
        
        UITapGestureRecognizer *uploadImageViewTap = [[UITapGestureRecognizer alloc]init];
        [uploadImageViewTap addTarget:self action:@selector(openCameraOrPhotoalbum:)];
        [uploadImageView addGestureRecognizer:uploadImageViewTap];
    }
    //提交/取消按钮
    UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenW/2 -100, CGRectGetMaxY(uploadImageView.frame) +20, 80, 25)];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"red_btn_small"] forState:UIControlStateNormal];
    [submitBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = FONT(13);
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:submitBtn];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenW/2 +20, CGRectGetMaxY(uploadImageView.frame) +20, 80, 25)];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消退款" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = FONT(14);
    [cancelBtn setTitleColor:GRAY_COLOR forState:UIControlStateNormal];
    cancelBtn.layer.borderColor = [GRAY_LINE_COLOR CGColor];
    cancelBtn.layer.borderWidth = 1.0;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = 3.0;
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:cancelBtn];
    
    //选择退款原因
    _selectTableView = [[UITableView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(refundReasonLabel.frame), CGRectGetMaxY(selectRefundReasonLabel.frame) - 2, ScreenW - 85 - 30, 180) style:UITableViewStylePlain];
    _selectTableView.delegate = self;
    _selectTableView.dataSource = self;
    _selectTableView.hidden = YES;
    _selectTableView.layer.borderColor = [GRAY_LINE_COLOR CGColor];
    _selectTableView.layer.borderWidth = 1.0;
    _selectTableView.layer.masksToBounds = YES;
    _selectTableView.layer.cornerRadius = 3.0;
    _selectTableView.backgroundColor = GRAY_CELL_COLOR;
    [_scrollView addSubview:_selectTableView];
    
}
#pragma mark - RegionRequest
- (void)getRefundReasonOperation
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
        req = [[LMHRefundApplyRequest alloc] initWithUserID:[userid integerValue]
                                               andUserToken:usertoken
                                            andorder_part_id:@"156355"];
    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(getRefundReasonResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)getRefundReasonResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
        
            [self createUI];
            //退款原因
            refundReasonArr = [[respDict objectForKey:@"data"] objectForKey:@"reason"];
            
        }else{
            [self textStateHUD:[respDict objectForKey:@"msg"]];
        }
    }else {
        [self textStateHUD:@"获取退款原因失败"];
    }
}

#pragma mark -- textView 代理
//开始编辑
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _scrollView.contentOffset = CGPointMake(0, 216 - 50);
}
//结束编辑
- (void)textViewDidEndEditing:(UITextView *)textView
{
    _scrollView.contentOffset = CGPointMake(0, 0);
}

#pragma mark -- 键盘处理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _refundAmountTextField) {
        [_refundNumberTextField becomeFirstResponder];
    }
    if (textField == _refundNumberTextField) {
        [_phoneTextField becomeFirstResponder];
    }
    
    return YES;
}

- (void)scrollViewTapClick:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    
    _selectTableView.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 按钮/tap点击
//提交
- (void)submitBtnClick
{
    NSLog(@"提交");
}
//取消
- (void)cancelBtnClick
{
    NSLog(@"取消");
}

#pragma mark -- 选择拍照还是图库
- (void)openCameraOrPhotoalbum:(id)inValue{

    [self.view endEditing:YES];
    _scrollView.contentOffset = CGPointMake(0, 0);
    
    NSString *title = @"添加图片";
    sheetView = [[UIActionSheet alloc] init];
    [sheetView addButtonWithTitle:@"从相册选择"];
    [sheetView addButtonWithTitle:@"照相"];
    sheetView.delegate = self;
    if ([inValue isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *tapZer = inValue;
        if ([tapZer.view isKindOfClass:[UIImageView class]]) {
            replaceIndex = tapZer.view.tag - 1000;
            if (replaceIndex < imageViewArr.count) {
                insertNum = 1;
                title = @"更换图片";
                [sheetView addButtonWithTitle:@"删除"];
            }else{
                insertNum = 8 - imageViewArr.count;
            }
        }
    }
    sheetView.title = title;
    [sheetView addButtonWithTitle:@"取消"];
    sheetView.cancelButtonIndex = sheetView.numberOfButtons -1;
    [sheetView showInView:self.view];
}
// actionSheet  代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //从相册选择
            [self locationPhoto];
            break;
        case 1:
            //拍 照
            [self takePhoto];
            break;
        case 2:
            //替换/删除选中图片
            if (actionSheet.cancelButtonIndex == 3) {
                [self delPhoto];
            }
            break;
        default:
            break;
    }
}
//相册选择
- (void)locationPhoto
{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = insertNum;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self presentViewController:picker animated:YES completion:NULL];
}
//拍照
- (void)takePhoto
{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有照相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        [self textStateHUD:@"模拟器中无法打开照相机，请在真机中使用"];
    }
}
//替换/删除选中照片
- (void)delPhoto
{
    [imageViewArr removeObjectAtIndex:replaceIndex];
    [_scrollView reloadInputViews];
}
#pragma mark -- 当选择一张(拍照后)后进入这里
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)info
{
    //关闭相册界面
    [picker dismissModalViewControllerAnimated:YES];
    if (replaceIndex+1 <= imageViewArr.count && insertNum == 1) {
        [imageViewArr replaceObjectAtIndex:replaceIndex withObject:uploadImageView];
    }else{
        [imageViewArr addObject:uploadImageView];
    }
    [_scrollView reloadInputViews];
}

//退款原因
- (void)selectViewTapClick
{
    _selectTableView.hidden = NO;
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    [_scrollView removeFromSuperview];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (int i=0; i<assets.count; i++) {
            ALAsset *asset=assets[i];
            
            [imageViewArr addObject:asset];
    
        }
        NSLog(@"___将图片存入数组_____________%@",imageViewArr);
    });
}
#pragma mark -- tableView delegate and dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return refundReasonArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [refundReasonArr objectAtIndex:indexPath.row];
    cell.backgroundColor = GRAY_CELL_COLOR;
    cell.textLabel.textColor = GRAY_COLOR;
    cell.textLabel.font = FONT(13);
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectTableView.hidden = YES;
    
    selectRefundReasonLabel.text = [NSString stringWithFormat:@" %@",[refundReasonArr objectAtIndex:indexPath.row]];
}

#pragma mark - UIGestureRecognizerDelegate tap手势代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
//    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

@end

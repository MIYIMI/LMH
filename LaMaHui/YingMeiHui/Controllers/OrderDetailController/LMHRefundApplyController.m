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
#import "kata_TextField.h"
#import "ReturnOrderDetailVO.h"
#import "kata_ReturnOrderDetailViewController.h"

@interface LMHRefundApplyController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate,UINavigationBarDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    UIScrollView *_scrollView;
    UITextField *_refundAmountTextField;
    UITextField *_refundNumberTextField;
    UITextField *_phoneTextField;
    UITextField *_userTextField;
    UITextView *_remarkExplainTextView;
    UILabel *refundReasonLabel;
    UILabel *uploadImageLabel;
    kata_TextField *selectRefundReasonLabel1;
    kata_TextField *selectRefundReasonLabel2;
    UITableView *_selectTableView;
    UIPickerView *pickView;
    UIToolbar *toolBar;
    UIButton *submitBtn;
    
    NSArray *refundReasonArr;
    NSMutableArray *imageViewArr;
    UIActionSheet *sheetView;
    NSInteger replaceIndex;
    NSInteger insertNum;
    WriteReasonVO *reasonVO;
    NSMutableArray *_reasonArray1;
    NSMutableArray *_reasonArray2;
    NSArray *pickArray;
    NSInteger _reasonID1;
    NSInteger _reasonID2;
    
    OrderGoodsVO *_goodVO;
    NSString *_userRealname;
    NSString *_userMobile;
    NSString *_refundComment;
    NSString *_refundMoney;
    NSString *_refundQuantity;
    NSMutableArray *_imagesArray;
    NSInteger _type;
}
@end

@implementation LMHRefundApplyController

- (id)initWithGoodVO:(OrderGoodsVO *)goodVO  andType:(NSInteger)type{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        imageViewArr = [[NSMutableArray alloc] init];
        _reasonArray1 = [[NSMutableArray alloc] init];
        _reasonArray2 = [[NSMutableArray alloc] init];
        _imagesArray = [[NSMutableArray alloc] init];
        
        [_reasonArray1 addObject:@"请选择退款原因"];
        [_reasonArray2 addObject:@"请选择退款原因"];
        
        _reasonID1 = -1;
        _reasonID2 = -1;
        
        _goodVO = goodVO;
        _type = type;
        
        self.title = @"申请退款";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGRect frame = self.contentView.frame;
    frame.size.height += 64;
    self.contentView.frame = frame;
    
    replaceIndex = 0;
    insertNum = 0;
    
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
    [self createUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)createUI
{
    CGRect frame = self.view.frame;
    if (IOS_7) {
        frame.size.height -= 64;
    }else{
        frame.size.height -= 44;
        frame.origin.y -= 20;
    }
    _scrollView = [[UIScrollView alloc]initWithFrame:frame];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.bounces = NO;
    _scrollView.scrollEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:_scrollView];
    
    UITapGestureRecognizer *scrollViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewTapClick:)];
    scrollViewTap.delegate = self;
    [_scrollView addGestureRecognizer:scrollViewTap];
    
    [self getRefundReasonOperation];
}

- (void)layoutView{
    //订单编号
    UILabel *orderIdLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, ScreenW - 20, 30)];
    orderIdLabel.backgroundColor = [UIColor clearColor];
    orderIdLabel.text = [NSString stringWithFormat:@"订单编号: %@",reasonVO.order_id];
    orderIdLabel.textColor = GRAY_COLOR;
    orderIdLabel.font = FONT(15);
    [_scrollView addSubview:orderIdLabel];
    
    //退款金额
    UILabel *refundAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(orderIdLabel.frame)+5, 75, 30)];
    refundAmountLabel.backgroundColor = [UIColor clearColor];
    refundAmountLabel.text = @"退款金额：";
    refundAmountLabel.textColor = GRAY_COLOR;
    refundAmountLabel.font = FONT(15);
    [_scrollView addSubview:refundAmountLabel];
    
    _refundAmountTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(refundAmountLabel.frame), CGRectGetMaxY(orderIdLabel.frame)+5, 70, 30)];
    _refundAmountTextField.backgroundColor = [UIColor clearColor];
    _refundAmountTextField.layer.cornerRadius = 3.0f;
    _refundAmountTextField.layer.masksToBounds = YES;
    _refundAmountTextField.layer.borderColor = [GRAY_LINE_COLOR CGColor];
    _refundAmountTextField.layer.borderWidth = 1.0f;
    _refundAmountTextField.textColor = GRAY_COLOR;
    _refundAmountTextField.text = [NSString stringWithFormat:@" %@", reasonVO.max_money];
    _refundAmountTextField.font = FONT(15);
    _refundAmountTextField.delegate = self;
    _refundAmountTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _refundAmountTextField.returnKeyType = UIReturnKeyNext;
    [_scrollView addSubview:_refundAmountTextField];
    
    UILabel *maxAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_refundAmountTextField.frame), CGRectGetMaxY(orderIdLabel.frame)+5, 150, 30)];
    maxAmountLabel.backgroundColor = [UIColor clearColor];
    maxAmountLabel.textColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1];
    maxAmountLabel.font = FONT(13);
    [_scrollView addSubview:maxAmountLabel];
    
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"元  (最多可退款%0.2f元)",[reasonVO.max_money floatValue]]];
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
    _refundNumberTextField.text = [NSString stringWithFormat:@" %@", @"1"];
    _refundNumberTextField.font = FONT(15);
    _refundNumberTextField.delegate = self;
    _refundNumberTextField.keyboardType = UIKeyboardTypePhonePad;
    _refundNumberTextField.returnKeyType = UIReturnKeyNext;
    [_scrollView addSubview:_refundNumberTextField];
    
    UILabel *numberTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_refundNumberTextField.frame), CGRectGetMaxY(refundAmountLabel.frame) +10, 150, 30)];
    numberTextLabel.backgroundColor = [UIColor clearColor];
    numberTextLabel.textColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1];
    numberTextLabel.font = FONT(13);
    [_scrollView addSubview:numberTextLabel];
    
    NSMutableAttributedString *numAttribute = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"件  (最多可退%@件)",reasonVO.quantity]];
    [numAttribute addAttribute:NSFontAttributeName value:FONT(15.0) range:NSMakeRange(0, 1)];
    [numAttribute addAttribute:NSForegroundColorAttributeName value:GRAY_COLOR range:NSMakeRange(0,1)];
    numberTextLabel.attributedText = numAttribute;
    
    //联系人
    UILabel *userLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(refundNumberLabel.frame) +10, 75, 30)];
    userLbl.backgroundColor = [UIColor clearColor];
    userLbl.text = @"联系人：";
    userLbl.textColor = GRAY_COLOR;
    userLbl.font = FONT(15);
    [_scrollView addSubview:userLbl];
    
    _userTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(userLbl.frame), CGRectGetMaxY(refundNumberLabel.frame) +10, ScreenW/2, 30)];
    _userTextField.backgroundColor = [UIColor clearColor];
    _userTextField.layer.cornerRadius = 3.0f;
    _userTextField.layer.masksToBounds = YES;
    _userTextField.layer.borderColor = [GRAY_LINE_COLOR CGColor];
    _userTextField.layer.borderWidth = 1.0f;
    _userTextField.textColor = GRAY_COLOR;
    _userTextField.text = [NSString stringWithFormat:@" %@", reasonVO.realname];
    _userTextField.font = FONT(15);
    _userTextField.delegate = self;
    _userTextField.clearButtonMode = YES;
    _userTextField.keyboardType = UIKeyboardTypeDefault;
    _userTextField.returnKeyType = UIReturnKeyNext;
    [_scrollView addSubview:_userTextField];
    
    //联系方式
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(userLbl.frame) +10, 75, 30)];
    phoneLabel.backgroundColor = [UIColor clearColor];
    phoneLabel.text = @"联系方式：";
    phoneLabel.textColor = GRAY_COLOR;
    phoneLabel.font = FONT(15);
    [_scrollView addSubview:phoneLabel];
    
    _phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(phoneLabel.frame), CGRectGetMinY(phoneLabel.frame), ScreenW - 95, 30)];
    _phoneTextField.backgroundColor = [UIColor clearColor];
    _phoneTextField.layer.cornerRadius = 3.0f;
    _phoneTextField.layer.masksToBounds = YES;
    _phoneTextField.layer.borderColor = [GRAY_LINE_COLOR CGColor];
    _phoneTextField.layer.borderWidth = 1.0f;
    _phoneTextField.textColor = GRAY_COLOR;
    _phoneTextField.font = FONT(15);
    _phoneTextField.delegate = self;
    _phoneTextField.clearButtonMode = YES;
    _phoneTextField.text = [NSString stringWithFormat:@" %@", reasonVO.mobile];
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
    
    selectRefundReasonLabel1 = [[kata_TextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(refundReasonLabel.frame), CGRectGetMaxY(phoneLabel.frame) +10, (ScreenW - 105)/2, 30)];
    selectRefundReasonLabel1.backgroundColor = [UIColor clearColor];
    selectRefundReasonLabel1.layer.cornerRadius = 3.0f;
    selectRefundReasonLabel1.layer.masksToBounds = YES;
    selectRefundReasonLabel1.layer.borderColor = [GRAY_LINE_COLOR CGColor];
    selectRefundReasonLabel1.layer.borderWidth = 1.0f;
    selectRefundReasonLabel1.textColor = GRAY_COLOR;
    selectRefundReasonLabel1.font = FONT(14);
    selectRefundReasonLabel1.inputView = pickView;
    selectRefundReasonLabel1.inputAccessoryView = toolBar;
    selectRefundReasonLabel1.delegate = self;
    selectRefundReasonLabel1.userInteractionEnabled = YES;
    [_scrollView addSubview:selectRefundReasonLabel1];
    
    UIImageView *selectView1 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(selectRefundReasonLabel1.frame) - 22, 5, 20, 20)];
    selectView1.backgroundColor = [UIColor whiteColor];
    selectView1.image = [UIImage imageNamed:@"icon_selectRefundReason"];
    selectView1.hidden = NO;
    [selectRefundReasonLabel1 addSubview:selectView1];
    
    selectRefundReasonLabel2 = [[kata_TextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(selectRefundReasonLabel1.frame)+10, CGRectGetMaxY(phoneLabel.frame) +10, (ScreenW - 105)/2, 30)];
    selectRefundReasonLabel2.backgroundColor = [UIColor clearColor];
    selectRefundReasonLabel2.layer.cornerRadius = 3.0f;
    selectRefundReasonLabel2.layer.masksToBounds = YES;
    selectRefundReasonLabel2.layer.borderColor = [GRAY_LINE_COLOR CGColor];
    selectRefundReasonLabel2.layer.borderWidth = 1.0f;
    selectRefundReasonLabel2.textColor = GRAY_COLOR;
    selectRefundReasonLabel2.font = FONT(14);
    selectRefundReasonLabel2.inputView = pickView;
    selectRefundReasonLabel2.inputAccessoryView = toolBar;
    selectRefundReasonLabel2.delegate = self;
    selectRefundReasonLabel2.userInteractionEnabled = YES;
    [_scrollView addSubview:selectRefundReasonLabel2];
    
    UIImageView *selectView2 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(selectRefundReasonLabel1.frame) - 22, 5, 20, 20)];
    selectView2.backgroundColor = [UIColor whiteColor];
    selectView2.image = [UIImage imageNamed:@"icon_selectRefundReason"];
    selectView2.hidden = NO;
    [selectRefundReasonLabel2 addSubview:selectView2];
    
    //备注说明
    UILabel *remarkExplainLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(refundReasonLabel.frame) +10, 75, 30)];
    remarkExplainLabel.backgroundColor = [UIColor clearColor];
    remarkExplainLabel.text = @"备注说明：";
    remarkExplainLabel.textColor = GRAY_COLOR;
    remarkExplainLabel.font = FONT(15);
    [_scrollView addSubview:remarkExplainLabel];
    
    _remarkExplainTextView = [[UITextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(remarkExplainLabel.frame), CGRectGetMaxY(refundReasonLabel.frame) +10, ScreenW - 95, 100)];
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
    uploadImageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_remarkExplainTextView.frame) +20, 75, 30)];
    uploadImageLabel.backgroundColor = [UIColor clearColor];
    uploadImageLabel.text = @"上传图片:";
    uploadImageLabel.textColor = GRAY_COLOR;
    uploadImageLabel.font = FONT(15);
    [_scrollView addSubview:uploadImageLabel];
    
    [self changeImg];
}

- (void)changeImg{
    for (UIView *uview in _scrollView.subviews) {
        if (uview.tag >= 1000) {
            [uview removeFromSuperview];
        }
    }
    NSInteger num = 0;
    CGFloat  numY = 0;
    CGFloat imageWight = (CGRectGetWidth(_remarkExplainTextView.frame) - 8*3)/4;

    //循环
    for (int i = 0; i<imageViewArr.count; i++,num++) {
        if(i == 4){
            num  = 0;
            numY = 1;
        }
        CGFloat frameX = CGRectGetMaxX(uploadImageLabel.frame) +(imageWight +8)*num;
        UIImageView *uploadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(frameX, CGRectGetMaxY(_remarkExplainTextView.frame) +15+numY*(imageWight +8), imageWight, imageWight)];
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
            num  =  imageViewArr.count - 4;
            numY = 1;
        }
        CGFloat frameX = CGRectGetMaxX(uploadImageLabel.frame) +(imageWight +8)*num;
        
        UIImageView *uploadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(frameX, CGRectGetMaxY(_remarkExplainTextView.frame) +15+numY*(imageWight +8), imageWight, imageWight)];
        uploadImageView.image = [UIImage imageNamed:@"upLoadImage"];
        uploadImageView.userInteractionEnabled = YES;
        uploadImageView.tag = 1000+imageViewArr.count;
        [_scrollView addSubview:uploadImageView];
        
        UITapGestureRecognizer *uploadImageViewTap = [[UITapGestureRecognizer alloc]init];
        [uploadImageViewTap addTarget:self action:@selector(openCameraOrPhotoalbum:)];
        [uploadImageView addGestureRecognizer:uploadImageViewTap];
    }
    
    //提交/取消按钮
    submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenW/2 -100, CGRectGetMaxY(_remarkExplainTextView.frame) +20 + (numY+1)*(imageWight+15), 80, 25)];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"red_btn_small"] forState:UIControlStateNormal];
    [submitBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = FONT(13);
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.tag = 10000;
    [_scrollView addSubview:submitBtn];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenW/2 +20, CGRectGetMaxY(_remarkExplainTextView.frame) +20 + (numY+1)*(imageWight+15), 80, 25)];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消退款" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = FONT(14);
    [cancelBtn setTitleColor:GRAY_COLOR forState:UIControlStateNormal];
    cancelBtn.layer.borderColor = [GRAY_LINE_COLOR CGColor];
    cancelBtn.layer.borderWidth = 1.0;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = 3.0;
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = 10001;
    [_scrollView addSubview:cancelBtn];
    
    _scrollView.contentSize = CGSizeMake(ScreenW, CGRectGetMaxY(cancelBtn.frame)+20);
}

#pragma mark - RegionRequest
- (void)getRefundReasonOperation
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
    
    if (userid && usertoken) {
        req = [[LMHRefundApplyRequest alloc] initWithUserID:[userid integerValue]
                                               andUserToken:usertoken
                                            andorder_part_id:_goodVO.order_part_id//@"156355"
                                   andrefund_express_status:_type];
    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        [self hideHUD];
        [self performSelectorOnMainThread:@selector(getRefundReasonResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        [self hideHUD];
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
            if ([[respDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                reasonVO = [WriteReasonVO WriteReasonVOWithDictionary:[respDict objectForKey:@"data"]];
                if (reasonVO.reason_type.count > 0) {
                    [_reasonArray1 addObjectsFromArray:reasonVO.reason_type];
                }
                for (NSArray *array in reasonVO.reason_type2) {
                    NSMutableArray *marry = [NSMutableArray arrayWithObject:@"请选择退款原因"];
                    [marry addObjectsFromArray:array];
                    [_reasonArray2 addObject:marry];
                }
                [self layoutView];
            }
        }else{
            [self textStateHUD:[respDict objectForKey:@"msg"]];
        }
    }else {
        [self textStateHUD:@"获取退款原因失败"];
    }
}

#pragma mark -- textView 代理

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

//开始编辑
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _scrollView.contentOffset = CGPointMake(0, 216 - 50);
}
//结束编辑
- (void)textViewDidEndEditing:(UITextView *)textView
{
    _scrollView.contentOffset = CGPointMake(0, 0);
    [self.view endEditing:YES];
}
//点击return收回键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark -- 键盘处理
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == selectRefundReasonLabel1) {
        pickArray = _reasonArray1;
        selectRefundReasonLabel1.text = @"";
        selectRefundReasonLabel2.text = @"";
        _reasonID1 = -1;
        _reasonID2 = -1;
        [pickView reloadAllComponents];
        [pickView selectRow:0 inComponent:0 animated:NO];
    }else if (textField == selectRefundReasonLabel2){
        if (_reasonID1 < 0) {
            [textField resignFirstResponder];
            return NO;
        }
        selectRefundReasonLabel2.text = @"";
        pickArray = _reasonArray2[_reasonID1+1];
        [pickView reloadAllComponents];
        [pickView selectRow:0 inComponent:0 animated:NO];
    }
    
    return YES;
}

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)regStr:(NSString*)inStr{
    //过滤字符串前后的空格
    NSString *outStr = [inStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //过滤中间空格
    outStr = [outStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return outStr;
}

#pragma mark -- 按钮/tap点击
//提交
- (void)submitBtnClick
{
    [self.view endEditing:YES];
    _refundMoney = [self regStr:_refundAmountTextField.text];
    if (_refundMoney.length <= 0) {
        [self textStateHUD:@"退款金额不能为空"];
        return;
    }else{
        NSInteger money = [_refundMoney doubleValue]*100;
        NSInteger reMomey = [reasonVO.max_money doubleValue]*100;
        if (money > reMomey) {
            [self textStateHUD:@"退款金额不能大于可退款金额"];
            return;
        }
        if (money <= 0) {
            [self textStateHUD:@"请输入正确的退款金额"];
            return;
        }
    }
    _refundQuantity = [self regStr:_refundNumberTextField.text];
    if (_refundQuantity.length <= 0) {
        [self textStateHUD:@"商品件数不能为空"];
        return;
    }else{
        if ([_refundQuantity integerValue] > [reasonVO.quantity integerValue]) {
            [self textStateHUD:@"商品件数不能大于可退款件数"];
            return;
        }
        if ([_refundQuantity integerValue] <= 0) {
            [self textStateHUD:@"请输入正确的商品件数"];
            return;
        }
    }
    _userRealname = [self regStr:_userTextField.text];
    if (_userRealname.length <= 0) {
        [self textStateHUD:@"联系人不能为空"];
        return;
    }else if (_userRealname.length > 50){
        [self textStateHUD:@"联系人不能大于50个字符"];
        return;
    }
    
    _userMobile = [self regStr:_phoneTextField.text];
    if (_userMobile.length <= 0) {
        [self textStateHUD:@"联系方式不能为空"];
        return;
    }else if (_userMobile.length > 50){
        [self textStateHUD:@"联系方式不能大于50个字符"];
        return;
    }
    if (_reasonID1 < 0 || _reasonID2 < 0) {
        [self textStateHUD:@"请选择退款原因"];
        return;
    }
    _refundComment = [self regStr:_remarkExplainTextView.text];
    if (_refundComment.length > 500) {
        [self textStateHUD:@"备注不能大于500个字符"];
        return;
    }
    
    if(imageViewArr.count > 0){
        [self uploadFile];
    }else{
        [self submitRefundOperation];
    }
}

- (void)uploadFile{
    [self.view endEditing:YES];
    //上传过程 显示加载菊花
    [self loadHUD];
    
    __block NSInteger imgCount = 0;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    for(int i = 0; i < imageViewArr.count; i++){
        [manager POST:@"http://121.41.77.48:8001/uploadphoto" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            // 上传图片，以文件流的格式
            UIImage *uimg = imageViewArr[i];
            NSData *imageData = UIImageJPEGRepresentation(uimg, 0.2);
            [formData appendPartWithFileData:imageData name:@"photo" fileName:[self getSaveKey:i] mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *urlStr = operation.responseString;
            [_imagesArray addObject:urlStr];
            imgCount ++;
            if(imgCount == imageViewArr.count){
                [self submitRefundOperation];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            imgCount++;
            if(imgCount == imageViewArr.count){
                [self submitRefundOperation];
            }
        }];
    }
}

-(NSString * )getSaveKey:(NSInteger)imgno {
    // 上传图片，以文件流的格式
    NSString *userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    NSString *fileName = [NSString stringWithFormat:@"_refund_%@%@_%zi.jpg", userid, _goodVO.goods_id,imgno];
    
    return fileName;
}

#pragma mark - 提交退款申请
- (void)submitRefundOperation
{
    [submitBtn setEnabled:NO];
    
    if (imageViewArr.count <= 0) {
        [self loadHUD];
    }
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
    
    if (_userRealname) {
        [subParams setObject:_userRealname forKey:@"user_realname"];
    }
    
    if (_userMobile) {
        [subParams setObject:_userMobile forKey:@"user_mobile"];
    }
    
    if (_refundComment) {
        [subParams setObject:_refundComment forKey:@"refund_comment"];
    }
    
    if (_refundQuantity) {
        [subParams setObject:_refundQuantity forKey:@"refund_quantity"];
    }
    
    if (_reasonID1 >= 0) {
        [subParams setObject:[NSNumber numberWithInteger:_reasonID1] forKey:@"refund_reason"];
    }
    
    if (_reasonID2 >= 0) {
        [subParams setObject:[NSNumber numberWithInteger:_reasonID2] forKey:@"refund_reason2"];
    }
    
    [subParams setObject:[NSNumber numberWithInteger:_type] forKey:@"refund_express_status"];
    
    if (_imagesArray.count > 0) {
        [subParams setObject:_imagesArray forKey:@"images"];
    }
    [paramsDict setObject:subParams forKey:@"params"];
    [paramsDict setObject:@"user_apply_refund" forKey:@"method"];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        [self hideHUD];
        [submitBtn setEnabled:YES];
        [self performSelectorOnMainThread:@selector(submitRefundResponse:) withObject:resp waitUntilDone:YES];
    } failed:^(NSError *error) {
        [self hideHUD];
        [submitBtn setEnabled:YES];
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)submitRefundResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        if ([statusStr isEqualToString:@"OK"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"flashOrder" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"flashDetail" object:nil];
            
            kata_ReturnOrderDetailViewController *detailVC = [[kata_ReturnOrderDetailViewController alloc] initWithGoodVO:_goodVO andOrderID:reasonVO.order_id andType:1];
            detailVC.navigationController = self.navigationController;
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        }else{
            [self textStateHUD:[respDict objectForKey:@"msg"]];
        }
    }else {
        [self textStateHUD:@"提交信息失败"];
    }
}

//取消申请退款
- (void)cancelBtnClick
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"取消退款" message:@"确定取消退款?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    picker.zyDelegate=self;
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
    [self changeImg];
}

#pragma mark -- 当选择一张(拍照后)后进入这里
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)info
{
    //关闭相册界面
    [picker dismissModalViewControllerAnimated:YES];
    if (replaceIndex < imageViewArr.count) {
        [imageViewArr replaceObjectAtIndex:replaceIndex withObject:image];
    }else{
        [imageViewArr addObject:image];
    }
    [self changeImg];
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i=0; i<assets.count; i++) {
            ALAsset *asset=assets[i];
            UIImage *tempImg= [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (replaceIndex < imageViewArr.count && insertNum == 1) {
                    [imageViewArr replaceObjectAtIndex:replaceIndex withObject:tempImg];
                }else{
                    [imageViewArr addObject:tempImg];
                }
                [self changeImg];
            });
        }
    });
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    
    pickerLabel.text= pickArray[row];
    return pickerLabel;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (selectRefundReasonLabel1.isFirstResponder) {
        selectRefundReasonLabel1.text = pickArray[row];
        _reasonID1 = row-1;
    }else if(selectRefundReasonLabel2.isFirstResponder){
        selectRefundReasonLabel2.text = pickArray[row];
        _reasonID2 = row-1;
    }
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
    
    _scrollView.frame = frame;
}

- (void)keyboardWillHide:(NSNotification *)notification{
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    _scrollView.frame = frame;
}

@end

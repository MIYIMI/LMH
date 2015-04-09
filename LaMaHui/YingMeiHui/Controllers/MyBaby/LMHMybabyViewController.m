//
//  LMHMybabyViewController.m
//  YingMeiHui
//
//  Created by Zhumingming on 14-11-26.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "LMHMybabyViewController.h"
#import "kata_AdressListTableViewController.h"
#import "kata_UserManager.h"
#import "LMHGetMybabyInfoRequest.h"
#import "LMHSaveBabyInforRequest.h"


@interface LMHMybabyViewController ()
{
    NSString *_msgStr;
    
    UIButton *_addRightBtn;
    
    UIButton *_saveBtn;
    UIButton *_boyBtn;
    UIButton *_girlBtn;
    
    UITextField *_smallNameTextField;
    UITextField *_birthdayTextField;
    UITextField *_motherAgeTextField;
    UITextField *_cityTextField;
    
    //判断男女 1:男    2：女
    NSString *_sexStr;
    
    
    NSNumber *_addressID;
    
    //地址选择器
    NSString *_provinceName;
    NSString *_cityName;
//    NSNumber *_countyID;
    NSString *_countyName;
    
    //宝宝生日选择器
    UIDatePicker *datePicker_baby;
    //妈妈生日选择器
    UIDatePicker *datePicker_mother;
    
}
@end

@implementation LMHMybabyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"我的宝宝";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createUI];
    
    [self getMybabyInfoOperation];
    
    if (!_addRightBtn) {
        UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [addBtn setFrame:CGRectMake(0, 0, 50, 30)];
        [addBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addBtn.titleLabel setFont:FONT(15.0)];
        [addBtn addTarget:self action:@selector(RightBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * addItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
        [self.navigationController addRightBarButtonItem:addItem animation:NO];
        _addRightBtn = addBtn;
    }
    
    CGRect frame = self.contentView.frame;
    frame.size.height += 64;
    self.contentView.frame = frame;
    self.contentView.backgroundColor = [UIColor colorWithRed:1 green:0.97 blue:0.97 alpha:1];

    //我的所在城市  通知
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(showIndex:) name:@"backEditView" object:nil];
}

//选择城市  回调
- (void)showIndex:(NSNotification*)sender
{
    NSDictionary *dict = [sender userInfo];
    NSArray *arr = [dict objectForKey:@"para"];
    _addressID = [arr objectAtIndex:0];
    _provinceName = arr[1];
    _cityName = arr[2];
    _countyName = arr[3];
    NSString *addstr = [NSString stringWithFormat:@"%@/%@/%@",_provinceName,_cityName,_countyName];
    _cityTextField.text = addstr;
}

- (void)createUI
{
#pragma mark -- 白色背景
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, ScreenW, 250)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
#pragma mark -- 分隔线
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(10, 49, ScreenW - 10, 1)];
    lineView1.backgroundColor = GRAY_LINE_COLOR;
    [bgView addSubview:lineView1];

    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(10, 49+50, ScreenW - 10, 1)];
    lineView2.backgroundColor = GRAY_LINE_COLOR;
    [bgView addSubview:lineView2];
    
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(10, 49+100, ScreenW - 10, 1)];
    lineView3.backgroundColor = GRAY_LINE_COLOR;
    [bgView addSubview:lineView3];
    
    UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake(10, 49+150, ScreenW - 10, 1)];
    lineView4.backgroundColor = GRAY_LINE_COLOR;
    [bgView addSubview:lineView4];
    
    UIView *lineView5 = [[UIView alloc]initWithFrame:CGRectMake(0, 49+200, ScreenW , 1)];
    lineView5.backgroundColor = GRAY_LINE_COLOR;
    [bgView addSubview:lineView5];
    
#pragma mark -- 保存按钮
    
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveBtn.frame = CGRectMake(10, 300, ScreenW - 20, 40);
    [_saveBtn setBackgroundImage:[UIImage imageNamed:@"red_btn_big"] forState:UIControlStateNormal];
    [_saveBtn setTitle:@"保存信息" forState:UIControlStateNormal];
    _saveBtn.titleLabel.font = FONT(16);
    [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveBtn];

#pragma mark -- 文字属性
    
    UILabel *smallNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 80, 30)];
    smallNameLabel.backgroundColor = [UIColor clearColor];
    smallNameLabel.textAlignment = NSTextAlignmentCenter;
    smallNameLabel.text = @"宝宝小名：";
    smallNameLabel.font = FONT(16);
    smallNameLabel.textColor = BLACK_COLOR;
    [bgView addSubview:smallNameLabel];
    
    UILabel *babysexLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10+50, 80, 30)];
    babysexLabel.backgroundColor = [UIColor clearColor];
    babysexLabel.textAlignment = NSTextAlignmentCenter;
    babysexLabel.text = @"宝宝性别：";
    babysexLabel.font = FONT(16);
    babysexLabel.textColor = BLACK_COLOR;
    [bgView addSubview:babysexLabel];
    
    UILabel *birthdayLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10+100, 80, 30)];
    birthdayLabel.backgroundColor = [UIColor clearColor];
    birthdayLabel.textAlignment = NSTextAlignmentCenter;
    birthdayLabel.text = @"宝宝生日：";
    birthdayLabel.font = FONT(16);
    birthdayLabel.textColor = BLACK_COLOR;
    [bgView addSubview:birthdayLabel];
    
    UILabel *motherAgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10+150, 80, 30)];
    motherAgeLabel.backgroundColor = [UIColor clearColor];
    motherAgeLabel.textAlignment = NSTextAlignmentCenter;
    motherAgeLabel.text = @"妈妈生日：";
    motherAgeLabel.font = FONT(16);
    motherAgeLabel.textColor = BLACK_COLOR;
    [bgView addSubview:motherAgeLabel];
    
    UILabel *cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10+200, 80, 30)];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    cityLabel.text = @"所在城市：";
    cityLabel.font = FONT(16);
    cityLabel.textColor = BLACK_COLOR;
    [bgView addSubview:cityLabel];
    
#pragma mark -- textField 以及 选项
    
    //宝宝小名/昵称
    _smallNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 10, ScreenW - 110, 30)];
    _smallNameTextField.placeholder = @"请输入宝宝小名";
    _smallNameTextField.textColor = BLACK_COLOR;
    _smallNameTextField.font = FONT(16);
    _smallNameTextField.backgroundColor = [UIColor clearColor];
//    _smallNameTextField.clearButtonMode = UITextFieldViewModeAlways;
    _smallNameTextField.delegate = self;
    _smallNameTextField.returnKeyType = UIReturnKeyNext;
    [bgView addSubview:_smallNameTextField];
    
    //宝宝性别
    _boyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _boyBtn.frame = CGRectMake(100, 10+50, 80, 30);
    _boyBtn.backgroundColor = [UIColor clearColor];
    [_boyBtn setTitle:@"男孩" forState:UIControlStateNormal];
    [_boyBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
    _boyBtn.titleLabel.font = FONT(16);
    [_boyBtn setImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateNormal];
    [_boyBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [_boyBtn addTarget:self action:@selector(boyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_boyBtn];
    
    _girlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _girlBtn.frame = CGRectMake(180, 10+50, 80, 30);
    _girlBtn.backgroundColor = [UIColor clearColor];
    [_girlBtn setTitle:@"女孩" forState:UIControlStateNormal];
    [_girlBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
    _girlBtn.titleLabel.font = FONT(16);
    [_girlBtn setImage:[UIImage imageNamed:@"icon_noSelect"] forState:UIControlStateNormal];
    [_girlBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [_girlBtn addTarget:self action:@selector(girlBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_girlBtn];
    
    //宝宝生日
    _birthdayTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 10+100, ScreenW - 110, 30)];
    _birthdayTextField.placeholder = @"请点击选择";
    _birthdayTextField.backgroundColor = [UIColor clearColor];
    _birthdayTextField.textColor = BLACK_COLOR;
    _birthdayTextField.delegate = self;
    _birthdayTextField.returnKeyType = UIReturnKeyNext;
    [bgView addSubview:_birthdayTextField];
    
    //妈妈生日
    _motherAgeTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 10+150, ScreenW - 110, 30)];
    _motherAgeTextField.placeholder = @"请点击选择";
    _motherAgeTextField.textColor = BLACK_COLOR;
    _motherAgeTextField.backgroundColor = [UIColor clearColor];
    _motherAgeTextField.returnKeyType = UIReturnKeyNext;
    _motherAgeTextField.delegate = self;
    [bgView addSubview:_motherAgeTextField];
    
    //所在城市
    _cityTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 10+200, ScreenW - 110, 30)];
    _cityTextField.placeholder = @"请点击选择";
    _cityTextField.textColor = BLACK_COLOR;
    _cityTextField.font = FONT(16);
    _cityTextField.backgroundColor = [UIColor clearColor];
    _cityTextField.delegate = self;
    [bgView addSubview:_cityTextField];
    
    
    
    _smallNameTextField.userInteractionEnabled = NO;
    _birthdayTextField.userInteractionEnabled  = NO;
    _motherAgeTextField.userInteractionEnabled = NO;
    _cityTextField.userInteractionEnabled      = NO;
    _saveBtn.hidden = YES;
    _boyBtn.userInteractionEnabled = NO;
    _girlBtn.userInteractionEnabled = NO;
}


#pragma mark -- 网路 获取宝宝信息

- (void)getMybabyInfoOperation
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
        req = [[LMHGetMybabyInfoRequest alloc] initWithUserID:[userid integerValue]
                                              andUserToken:usertoken];
    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(getMybabyInfoParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)getMybabyInfoParseResponse:(NSString *)resp
{
    NSString *hudPrefixStr = @"获取宝宝信息";
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        //错误信息
        _msgStr = [respDict objectForKey:@"msg"];
        if ([_msgStr isEqualToString:@"宝宝信息不存在"]) {
            
            [self textStateHUD:@"请编辑宝宝状态"];
            
            [self performSelector:@selector(RightBtnPressed) withObject:nil afterDelay:2];
        }
        
        
        if ([statusStr isEqualToString:@"OK"]) {
            if (nil != [respDict objectForKey:@"data"] && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]] && [[respDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {

                
                NSDictionary *respDictList = [respDict objectForKey:@"data"];
                
                _smallNameTextField.text = [respDictList objectForKey:@"baby_name"];
                _birthdayTextField.text  = [respDictList objectForKey:@"baby_birthday_at"];
                
                _motherAgeTextField.text = [respDictList objectForKey:@"mother_birthday_at"];
                _cityTextField.text      = [NSString stringWithFormat:@"%@%@%@",[respDictList objectForKey:@"province"],[respDictList objectForKey:@"city"],[respDictList objectForKey:@"area"]];
                
                _addressID = [respDictList objectForKey:@"address"];
                
                
                NSString *sexssss = [respDictList objectForKey:@"baby_sex"];
                if ([sexssss integerValue] == 1 ) {
                    [self boyBtnClick];
                }
                if ([sexssss integerValue] == 2) {
                    [self girlBtnClick];
                }
            } else {
                [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
            }
        }
    } 
}

#pragma mark -- 网络 保存宝宝信息

- (void)saveMybabyInfoOperation
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
        
        
        req = [[LMHSaveBabyInforRequest alloc]initWithUserID:[userid integerValue]
                                               andUserToken:usertoken
                                               andbaby_name:_smallNameTextField.text
                                                andbaby_sex:_sexStr
                                        andbaby_birthday_at:_birthdayTextField.text
                                              andmother_birthday_at:_motherAgeTextField.text
                                                 andaddress:[_addressID stringValue]];
    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(saveMybabyInfoParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)saveMybabyInfoParseResponse:(NSString *)resp
{
    NSString *hudPrefixStr = @"保存宝宝信息";
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            
            
            
            [BDProgressHUD autoShowHUDAddedTo:self.view withText:@"保存成功"];
            
            
            _smallNameTextField.userInteractionEnabled = NO;
            _birthdayTextField.userInteractionEnabled  = NO;
            _motherAgeTextField.userInteractionEnabled = NO;
            _cityTextField.userInteractionEnabled      = NO;
            _saveBtn.hidden = YES;
            _boyBtn.userInteractionEnabled  = NO;
            _girlBtn.userInteractionEnabled = NO;
            
            
        }
        
    } else {
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
    }
}


#pragma mark -- 按钮点击事件

- (void)RightBtnPressed
{
    _smallNameTextField.userInteractionEnabled = YES;
    _birthdayTextField.userInteractionEnabled  = YES;
    _motherAgeTextField.userInteractionEnabled = YES;
    _cityTextField.userInteractionEnabled      = YES;
    _saveBtn.hidden = NO;
    _boyBtn.userInteractionEnabled  = YES;
    _girlBtn.userInteractionEnabled = YES;
    
    [_smallNameTextField becomeFirstResponder];
    
}
- (void)boyBtnClick
{
    _boyBtn.selected = YES;
    _girlBtn.selected = NO;
    
    [_boyBtn setImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateNormal];
    
    [_girlBtn setImage:[UIImage imageNamed:@"icon_noSelect"] forState:UIControlStateNormal];
    
    _sexStr = @"1";
}
- (void)girlBtnClick
{
    _girlBtn.selected = YES;
    _boyBtn.selected = NO;
    
    [_girlBtn setImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateNormal];
    
    [_boyBtn setImage:[UIImage imageNamed:@"icon_noSelect"] forState:UIControlStateNormal];
    
    _sexStr = @"2";
}
- (void)saveBtnClick
{
    if (_smallNameTextField.text.length == 0) {
        [BDProgressHUD autoShowHUDAddedTo:self.view withText:@"请填写宝宝小名"];
    }
    else if (_birthdayTextField.text.length == 0) {
        [BDProgressHUD autoShowHUDAddedTo:self.view withText:@"请填写宝宝生日"];
    }
    else if (_motherAgeTextField.text.length == 0) {
        [BDProgressHUD autoShowHUDAddedTo:self.view withText:@"请填写妈妈生日"];
    }
    else if (_cityTextField.text.length == 0) {
        [BDProgressHUD autoShowHUDAddedTo:self.view withText:@"请填写所在城市"];
    }
    else{
        [self saveMybabyInfoOperation];
    }
    
}
//

#pragma mark -- textField 键盘处理
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField != _birthdayTextField ) {
        
        datePicker_baby.hidden = YES;
    }
    if (textField != _motherAgeTextField ) {
        
        datePicker_mother.hidden = YES;
    }
    if (textField == _birthdayTextField) {
        
        //生日选择
        datePicker_baby.hidden = NO;
        
        [_smallNameTextField resignFirstResponder];
        
        [self timeSelect_baby];
        
        return NO;
    }
    if (textField == _motherAgeTextField) {
        
        //妈妈生日选择
        datePicker_mother.hidden = NO;
        
        [_smallNameTextField resignFirstResponder];
        
        [self timeSelect_mother];
        
        return NO;
    }
    
    if (textField == _cityTextField) {
        //选择城市
        datePicker_baby.hidden = YES;
        datePicker_mother.hidden = YES;
        [_smallNameTextField resignFirstResponder];
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [arr addObject:@"empty"];
        [arr addObject:@"empty"];
        [arr addObject:@"empty"];
        kata_AdressListTableViewController *addressControlVC = [[kata_AdressListTableViewController alloc] initWithStyle:UITableViewStylePlain andRegion:@"province" andRegionPid:[NSNumber numberWithInteger:0] andAddres:arr];
        addressControlVC.navigationController = self.navigationController;
        //addressControlVC.myDelete = self;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addressControlVC animated:YES];
        
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
//    [datePicker_baby removeFromSuperview];
//    [datePicker_mother removeFromSuperview];
    datePicker_baby.hidden = YES;
    datePicker_mother.hidden = YES;
    
    //[_birthdayTextField resignFirstResponder];
    [_smallNameTextField resignFirstResponder];
    [_cityTextField resignFirstResponder];
}

#pragma mark -- 宝宝生日选择器

- (void)timeSelect_baby
{
    if (!datePicker_baby) {
        
        datePicker_baby = [[UIDatePicker alloc]init];
        datePicker_baby.frame = CGRectMake(0, ScreenH - 216 - 64, ScreenW, 216);
        datePicker_baby.datePickerMode = UIDatePickerModeDate;
        datePicker_baby.backgroundColor = [UIColor whiteColor];
        datePicker_baby.hidden = NO;
        [datePicker_baby addTarget:self action:@selector(timeChange_baby:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:datePicker_baby];
    }
    
    
}
//获取日期选择器的时间
- (void)timeChange_baby:(UIDatePicker *)datePicker{

    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *text = [formatter stringFromDate:datePicker.date];

    _birthdayTextField.text = text;
}

#pragma mark -- 妈妈生日选择器

- (void)timeSelect_mother
{
    if (!datePicker_mother) {
        
        datePicker_mother = [[UIDatePicker alloc]init];
        datePicker_mother.frame = CGRectMake(0, ScreenH - 216 - 64, ScreenW, 216);
        datePicker_mother.datePickerMode = UIDatePickerModeDate;
        datePicker_mother.backgroundColor = [UIColor whiteColor];
        datePicker_mother.hidden = NO;
        [datePicker_mother addTarget:self action:@selector(timeChange_mother:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:datePicker_mother];
    }
    
    
}
//获取日期选择器的时间
- (void)timeChange_mother:(UIDatePicker *)datePicker{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *text = [formatter stringFromDate:datePicker.date];
    
    _motherAgeTextField.text = text;
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

@end

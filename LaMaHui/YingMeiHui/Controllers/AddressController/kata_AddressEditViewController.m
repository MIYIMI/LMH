//
//  kata_AddressEditViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-15.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_AddressEditViewController.h"
#import "BOKUNoActionTextField.h"
#import "KTAddressRegionInfoGetRequest.h"
#import "KTAddressAddRequest.h"
#import "KTProxy.h"
#import "kata_UserManager.h"
#import "UIWindow+KT51Additions.h"
#import "AddressVO.h"
#import "UIDevice+Resolutions.h"
#import "kata_AdressListTableViewController.h"
#define NUMBERS                             @"0123456789"

@interface kata_AddressEditViewController ()
{
    NSInteger _addressid;
    AddressVO *_addressInfo;
    NSString *_editType;
    UIBarButtonItem *_saveItem;
    UIButton *_saveBtn;
    BOOL _keyboardIsShowing;
    CGFloat _keyboard_yOffset;
    UIButton *_addressMask;
    UITextField *_edittingTF;
    NSString *_regionFlag;
    NSNumber *_regionPid;
    NSArray *_regionArr;
    UIPickerView *_regionPicker;
    UISegmentedControl *_cancelButton;
    UISegmentedControl *_confirmButton;
    UIActionSheet *_regionActionSheet;
    
    NSNumber *_provinceID;
    NSString *_provinceName;
    NSNumber *_cityID;
    NSString *_cityName;
    NSNumber *_countyID;
    NSString *_countyName;
    NSArray *_areaArr;
    NSMutableArray *_submitArr;
    
    BOKUNoActionTextField *_aUsernameField;
    BOKUNoActionTextField *_mobileField;
    BOKUNoActionTextField *_areaField;
    UITextView *_addressDetailTV;
    UIButton *defaultAddressBtn;
    
    NSString *nameStr;
    NSString *regionStr;
    bool is_default;
    AddressVO *addressData;
}

@property (readonly, nonatomic) UITableView *addressFormTableView;

@end

@implementation kata_AddressEditViewController

@synthesize addressFormTableView = _addressFormTableView;
@synthesize orderID;
- (id)initWithAddessInfo:(AddressVO *)addressinfo type:(NSString *)type
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        _addressInfo = addressinfo;
        if (_addressInfo.ProvinceCode) {
            _provinceID = _addressInfo.ProvinceCode;
        }
        if (_addressInfo.CityCode) {
            _cityID = _addressInfo.CityCode;
        }
        if (_addressInfo.RegionCode) {
            _countyID = _addressInfo.RegionCode;
        }
        if (_addressInfo.AddressID) {
            _addressid = [_addressInfo.AddressID intValue];
        }
        addressData = [[AddressVO alloc] init];
        nameStr = _addressInfo.Name;
        is_default = [_addressInfo.IsDefault boolValue];
        _cityName = _addressInfo.City;
        _provinceName = _addressInfo.Province;
        _countyName = _addressInfo.Region;
        regionStr = _addressInfo.Detail;
        _editType = type;
        if ([type isEqualToString:@"edit"]) {
            self.title = @"编辑地址";
            is_default = [addressinfo.IsDefault boolValue];
        } else if ([type isEqualToString:@"add"]) {
            _addressid = -1;
            is_default = false;
            self.title = @"新增地址";
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.addressFormTableView reloadData];
    [self createUI];
    
    _regionFlag = @"province";
    _regionPid = 0;
    [self regionOperation];
    [self addTapGesture];
    self.addressFormTableView.scrollEnabled=YES;
    CGFloat height = [[[DeviceModel shareModel] phoneType] hasSuffix:@"iPhone 4"] ? 548 : 465;
    [self.addressFormTableView setContentSize:CGSizeMake(320, height)];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(showIndex:) name:@"backEditView" object:nil];
}

- (void)showIndex:(NSNotification*)sender
{
    NSDictionary *dict = [sender userInfo];
    NSArray *arr = [dict objectForKey:@"para"];
    _countyID = [arr objectAtIndex:0];
    _provinceName = arr[1];
    _cityName = arr[2];
    _countyName = arr[3];
    NSString *addstr = [NSString stringWithFormat:@"%@/%@/%@",_provinceName,_cityName,_countyName];
    _areaField.text = addstr;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI
{
    if (!_saveItem) {
        UIButton * saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveBtn setFrame:CGRectMake(0, 0, 30, 30)];
        saveBtn.backgroundColor = [UIColor clearColor];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
        [saveBtn setImage:[UIImage imageNamed:@"nav_comfirm_btn"] forState:UIControlStateNormal];
//        [saveBtn setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 0, 0)];
        _saveBtn = saveBtn;
        
        [saveBtn addTarget:self action:@selector(savePressed) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * saveItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
        _saveItem = saveItem;
    }
    
    [self.navigationController addRightBarButtonItem:_saveItem animation:NO];
}

- (void)resignCurrentFirstResponder
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow endEditing:YES];
}

- (void)enableSaveButton
{
    [_saveBtn setEnabled:YES];
}

-(void)addTapGesture{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignSelfResponder)];
    tapGesture.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:tapGesture];
}

-(void)resignSelfResponder{
    [self resignCurrentFirstResponder];
}


#pragma mark - SaveAddressRequest
- (void)saveOperation
{
    [_saveBtn setEnabled:NO];
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
        stateHud.delegate = self;
        [self.contentView addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeIndeterminate;
    stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
    [stateHud show:YES];
    
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    NSString *userid = nil;
    NSString *usertoken = nil;
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    if (userid && usertoken){
        req = [[KTAddressAddRequest alloc] initWithAddressID:_addressid
                                                   andUserID:[userid intValue]
                                                andUserToken:usertoken
                                                     andName:nameStr
                                                   andMobile:_mobileField.text
                                                   andDetail:regionStr
                                               andRegionCode:[_countyID intValue]
                                                andDeafault:is_default
                                                  andOrderID:self.orderID];
    }
    
    addressData = [[AddressVO alloc] init];
    addressData.Name = nameStr;
    addressData.Mobile = _mobileField.text;
    addressData.CityCode = _cityID;
    addressData.IsDefault = [NSNumber numberWithBool:is_default];
    addressData.City = _cityName;
    addressData.Province = _provinceName;
    addressData.Region = _countyName;
    addressData.Detail = regionStr;
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(saveParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        [_saveBtn setEnabled:YES];
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)saveParseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            id dataObj = [respDict objectForKey:@"data"];
            
            if ([[dataObj objectForKey:@"code"] intValue] == 0) {
                [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"地址保存成功" waitUntilDone:YES];
                
                if (self.addressEditViewDelegate && [self.addressEditViewDelegate respondsToSelector:@selector(addressEdittedSuccessPop:)]) {
                    [self.addressEditViewDelegate addressEdittedSuccessPop:(([dataObj objectForKey:@"address_id"])?([[dataObj objectForKey:@"address_id"] intValue]):-1)];
                }
                addressData.AddressID = [NSNumber numberWithInteger:[[dataObj objectForKey:@"address_id"] integerValue]];
                [self performSelector:@selector(saveSuccess) withObject:nil afterDelay:0.1];
            } else {
                id messageObj = [dataObj objectForKey:@"msg"];
                if (messageObj && [messageObj isKindOfClass:[NSString class]]) {
                    if (![messageObj isEqualToString:@""]) {
                        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:messageObj waitUntilDone:YES];
                    } else {
                        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"地址保存失败" waitUntilDone:YES];
                    }
                } else {
                    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"地址保存失败" waitUntilDone:YES];
                }
                [self performSelectorOnMainThread:@selector(enableSaveButton) withObject:nil waitUntilDone:YES];
            }
        } else {
            id messageObj = [respDict objectForKey:@"msg"];
            if (messageObj && [messageObj isKindOfClass:[NSString class]]) {
                if (![messageObj isEqualToString:@""]) {
                    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:messageObj waitUntilDone:YES];
                } else {
                    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"地址保存失败" waitUntilDone:YES];
                }
            } else {
                [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"地址保存失败" waitUntilDone:YES];
            }
            [self performSelectorOnMainThread:@selector(enableSaveButton) withObject:nil waitUntilDone:YES];
        }
    } else {
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"地址保存失败" waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(enableSaveButton) withObject:nil waitUntilDone:YES];
    }
}

- (void)saveSuccess
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:addressData, @"address", [NSNumber numberWithInteger:0], @"addressno", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"payAddrSelect" object:nil userInfo:dict];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - RegionRequest
- (void)regionOperation
{
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
        stateHud.delegate = self;
        [self.contentView addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeIndeterminate;
    stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
    [stateHud show:YES];
    
    KTAddressRegionInfoGetRequest *req = [[KTAddressRegionInfoGetRequest alloc] initWithCode:[_regionPid intValue]];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(regionParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"获取地区信息失败" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)regionParseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            id dataObj = [respDict objectForKey:@"data"];

            if ([[dataObj objectForKey:@"code"] intValue] == 0) {
                if ([dataObj objectForKey:@"region_list"]) {
                    if ([[dataObj objectForKey:@"region_list"] isKindOfClass:[NSArray class]]) {
                        
                        _regionArr = (NSArray *)[dataObj objectForKey:@"region_list"];
                        [stateHud hide:YES afterDelay:0.5];
                        if (![_regionFlag isEqualToString:@"province"]) {
                            [self performSelector:@selector(showRegionActionSheet) withObject:nil afterDelay:0.6];
                        } else {
                            _areaArr = _regionArr;
                        }
                    } else {
                        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"地区信息载入失败" waitUntilDone:YES];
                    }
                } else {
                    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"地区信息为空" waitUntilDone:YES];
                }
            } else {
                id messageObj = [dataObj objectForKey:@"msg"];
                if (messageObj && [messageObj isKindOfClass:[NSString class]]) {
                    if (![messageObj isEqualToString:@""]) {
                        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:messageObj waitUntilDone:YES];
                    } else {
                        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"地区信息载入失败" waitUntilDone:YES];
                    }
                } else {
                    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"地区信息载入失败" waitUntilDone:YES];
                }
            }
        } else {
            id messageObj = [respDict objectForKey:@"msg"];
            if (messageObj && [messageObj isKindOfClass:[NSString class]]) {
                if (![messageObj isEqualToString:@""]) {
                    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:messageObj waitUntilDone:YES];
                } else {
                    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"地区信息载入失败" waitUntilDone:YES];
                }
            } else {
                [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"地区信息载入失败" waitUntilDone:YES];
            }
        }
    } else {
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"地区信息载入失败" waitUntilDone:YES];
    }
}

- (void)savePressed
{
    NSString *nameValue = [_aUsernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    nameValue = [nameValue stringByReplacingOccurrencesOfString:@" " withString:@""];
    nameStr = nameValue;

    NSString *mobileValue = _mobileField.text;
    NSString *areaValue = _areaField.text;
    
    NSString *addressValue = [_addressDetailTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    addressValue = [addressValue stringByReplacingOccurrencesOfString:@"\r\n" withString:@" "];
    addressValue = [addressValue stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
    addressValue = [addressValue stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    addressValue = [addressValue stringByReplacingOccurrencesOfString:@" " withString:@""];
    regionStr = addressValue;

    if (nameValue && nameValue.length > 0 && (mobileValue && mobileValue.length > 0) && addressValue && addressValue.length > 0 && areaValue && areaValue.length > 0) {
        
        //邮编正则
//        NSString *zipRegex = @"[1-9]\\d{5}(?!d)";
//        NSPredicate *zipPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", zipRegex];
        //邮编正则
        NSString *mobileRegex = @"^[1][34578][0-9]{9}";
        NSPredicate *mobilePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
        //电话号码正则
        //        NSString *phoneRegex = @"(^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)";
        //        NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
        
        
        if (![mobilePredicate evaluateWithObject:_mobileField.text] && (mobileValue && mobileValue.length > 0)) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"提示"
                                  message:@"手机格式不正确"
                                  delegate:self
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil];
            alert.tag = 202;
            [alert show];
            
            return;
        } else {
            [self resignCurrentFirstResponder];
            
            [self saveOperation];
            
            return;
        }
    } else if (!nameValue || nameValue.length == 0) {
        if (!stateHud) {
            stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
            stateHud.delegate = self;
            [self.contentView addSubview:stateHud];
        }
        stateHud.mode = MBProgressHUDModeText;
        stateHud.yOffset = 100 - CGRectGetHeight(self.contentView.frame) / 2;
        stateHud.labelText = @"收货人姓名为空";
        stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
        [stateHud show:YES];
        [stateHud hide:YES afterDelay:1.0];
        
        [self resignCurrentFirstResponder];
        [_aUsernameField becomeFirstResponder];
        return;
    } else if (!mobileValue || mobileValue.length == 0) {
        if (!stateHud) {
            stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
            stateHud.delegate = self;
            [self.contentView addSubview:stateHud];
        }
        stateHud.mode = MBProgressHUDModeText;
        stateHud.yOffset = 100 - CGRectGetHeight(self.contentView.frame) / 2;
        stateHud.labelText = @"手机号码为空";
        stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
        [stateHud show:YES];
        [stateHud hide:YES afterDelay:1.0];
        
        [self resignCurrentFirstResponder];
        [_mobileField becomeFirstResponder];
        return;
    } else if (!areaValue || areaValue.length == 0) {
        if (!stateHud) {
            stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
            stateHud.delegate = self;
            [self.contentView addSubview:stateHud];
        }
        stateHud.mode = MBProgressHUDModeText;
        stateHud.yOffset = 100 - CGRectGetHeight(self.contentView.frame) / 2;
        stateHud.labelText = @"请选择收货地区";
        stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
        [stateHud show:YES];
        [stateHud hide:YES afterDelay:1.0];
        
        [self resignCurrentFirstResponder];
        [_areaField becomeFirstResponder];
        return;
    } else if (!addressValue || addressValue.length == 0) {
        if (!stateHud) {
            stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
            stateHud.delegate = self;
            [self.contentView addSubview:stateHud];
        }
        stateHud.mode = MBProgressHUDModeText;
        stateHud.yOffset = 100 - CGRectGetHeight(self.contentView.frame) / 2;
        stateHud.labelText = @"详细地址为空";
        stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
        [stateHud show:YES];
        [stateHud hide:YES afterDelay:1.0];
        
        [self resignCurrentFirstResponder];
        [_addressDetailTV becomeFirstResponder];
        return;
    }
}

- (void)keyboardWillShow:(NSNotification *)note
{
    if (!_keyboardIsShowing) {
        _keyboardIsShowing = YES;
        NSDictionary *userInfo = [  note userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        UIView *firstResponder = [keyWindow findFirstResponder];
        if (IOS_7) {
            if ([[[[[firstResponder superview] superview] superview] superview] isKindOfClass:[UITableViewCell class]]) {
                UITableViewCell *cell = (UITableViewCell *)[[[[firstResponder superview] superview] superview] superview];
                NSIndexPath *indexPath = [self.addressFormTableView indexPathForCell:cell];
                CGFloat cellOffset = indexPath.row > 0 ? (indexPath.row) * 40 + 140 : 81;
                if (cellOffset < CGRectGetHeight(self.addressFormTableView.frame) - CGRectGetHeight(keyboardRect)) {
                    _keyboard_yOffset = 0;
                    return;
                }
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:0.25];
                _keyboard_yOffset = CGRectGetHeight(self.addressFormTableView.frame) - CGRectGetHeight(keyboardRect) - cellOffset;
                [self.addressFormTableView setContentOffset:CGPointMake(0, -_keyboard_yOffset)];
                [UIView commitAnimations];
            }
        } else {
            if ([[[firstResponder superview] superview] isKindOfClass:[UITableViewCell class]]) {
                UITableViewCell *cell = (UITableViewCell *)[[firstResponder superview] superview];
                NSIndexPath *indexPath = [self.addressFormTableView indexPathForCell:cell];
                CGFloat cellOffset = indexPath.row > 0 ? (indexPath.row) * 40 + 70 : 81;
                if (cellOffset < CGRectGetHeight(self.addressFormTableView.frame) - CGRectGetHeight(keyboardRect)) {
                    _keyboard_yOffset = 0;
                    return;
                }
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:0.25];
                _keyboard_yOffset = CGRectGetHeight(self.addressFormTableView.frame) - CGRectGetHeight(keyboardRect) - cellOffset;
                [self.addressFormTableView setContentOffset:CGPointMake(0, -_keyboard_yOffset)];
                [UIView commitAnimations];
            }
        }
    }
}

- (void)keyboardWillHide:(NSNotification*)note {
    if (_keyboardIsShowing) {
        _keyboardIsShowing = NO;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.25];
        if (CGRectGetHeight(self.addressFormTableView.frame) > self.addressFormTableView.contentSize.height) {
            [self.addressFormTableView setContentOffset:CGPointMake(0, 0)];
        } else if (CGRectGetHeight(self.addressFormTableView.frame) > self.addressFormTableView.contentSize.height - self.addressFormTableView.contentOffset.y) {
            [self.addressFormTableView setContentOffset:CGPointMake(0, self.addressFormTableView.contentSize.height - CGRectGetHeight(self.addressFormTableView.frame))];
        } else {
            [self.addressFormTableView setContentOffset:CGPointMake(0, self.addressFormTableView.contentOffset.y + _keyboard_yOffset)];
        }
        [UIView commitAnimations];
    }
}

#pragma mark - Getter
- (UITableView *)addressFormTableView
{
    if (!_addressFormTableView) {
        _addressFormTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height) style:UITableViewStylePlain];
        
        _addressFormTableView.delegate = self;
        _addressFormTableView.dataSource = self;
        [_addressFormTableView setBounces:NO];
        [_addressFormTableView setBackgroundView:nil];
        [_addressFormTableView setBackgroundColor:[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1]];
        [_addressFormTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 15)];
        [_addressFormTableView setTableHeaderView:header];
        [self.contentView addSubview:_addressFormTableView];
    }
    return _addressFormTableView;
}

#pragma mark - TableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    
    UITableViewCell *cell = nil;
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.opaque = YES;
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(10, 0, w - 20, 40.5)];
    [bg setBackgroundColor:[UIColor whiteColor]];
    [bg.layer setBorderWidth:0.5];
    [bg.layer setCornerRadius:1.0];
    [bg.layer setBorderColor:[UIColor colorWithRed:0.87 green:0.83 blue:0.84 alpha:1].CGColor];
    [cell.contentView addSubview:bg];
    
    switch (row) {
        case 0:
        {
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 80, 40)];
            [lbl setBackgroundColor:[UIColor clearColor]];
            [lbl setFont:[UIFont systemFontOfSize:13.0f]];
            [lbl setTextColor:[UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1]];
            [lbl setTextAlignment:NSTextAlignmentLeft];
            [lbl setText:@"收货人姓名:"];
            [bg addSubview:lbl];

            if (!_aUsernameField) {
                BOKUNoActionTextField *aUsernameField = [[BOKUNoActionTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lbl.frame), 1, w - 30 - CGRectGetMaxX(lbl.frame), 40)];
                aUsernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
                aUsernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                aUsernameField.autocorrectionType = UITextAutocorrectionTypeNo;
                aUsernameField.placeholder = @"请输入收货人";
                aUsernameField.tag = 101;
                aUsernameField.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
                aUsernameField.font = [UIFont systemFontOfSize:13.0f];
                aUsernameField.returnKeyType = UIReturnKeyNext;
                aUsernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                aUsernameField.delegate = self;
                
                _aUsernameField = aUsernameField;
            }
            [bg addSubview:_aUsernameField];
        
            if (_addressInfo && [_editType isEqualToString:@"edit"]) {
                _aUsernameField.text = _addressInfo.Name;
            }
        }
            break;
            
        case 1:
        {
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 80, 40)];
            [lbl setBackgroundColor:[UIColor clearColor]];
            [lbl setFont:[UIFont systemFontOfSize:13.0f]];
            [lbl setTextColor:[UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1]];
            [lbl setTextAlignment:NSTextAlignmentLeft];
            [lbl setText:@"手机号码:"];
            [bg addSubview:lbl];
            
            if (!_mobileField) {
                BOKUNoActionTextField *aMobileField = [[BOKUNoActionTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lbl.frame), 1, w - 30 - CGRectGetMaxX(lbl.frame), 40)];
                aMobileField.clearButtonMode = UITextFieldViewModeWhileEditing;
                aMobileField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                aMobileField.autocorrectionType = UITextAutocorrectionTypeNo;
                aMobileField.keyboardType = UIKeyboardTypeNumberPad;
                aMobileField.placeholder = @"请输入手机号码";
                aMobileField.tag = 102;
                aMobileField.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
                aMobileField.font = [UIFont systemFontOfSize:13.0f];
                aMobileField.returnKeyType = UIReturnKeyNext;
                aMobileField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                aMobileField.delegate = self;
                
                _mobileField = aMobileField;
            }
            [bg addSubview:_mobileField];
            
            if (_addressInfo && [_editType isEqualToString:@"edit"]) {
                _mobileField.text = _addressInfo.Mobile;
            }
        }
            break;
            
        case 2:
        {
            [bg setFrame:CGRectMake(10, 0, w - 20, 40)];
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 80, 40)];
            [lbl setBackgroundColor:[UIColor clearColor]];
            [lbl setFont:[UIFont systemFontOfSize:13.0f]];
            [lbl setTextColor:[UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1]];
            [lbl setTextAlignment:NSTextAlignmentLeft];
            [lbl setText:@"所在地区:"];
            [bg addSubview:lbl];
            
            if (!_areaField) {
                BOKUNoActionTextField *aAreaField = [[BOKUNoActionTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lbl.frame), 1, w - 30 - CGRectGetMaxX(lbl.frame), 40)];
                aAreaField.clearButtonMode = UITextFieldViewModeWhileEditing;
                aAreaField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                aAreaField.autocorrectionType = UITextAutocorrectionTypeNo;
                aAreaField.placeholder = @"点击选择";
                aAreaField.tag = 103;
                aAreaField.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
                aAreaField.font = [UIFont systemFontOfSize:13.0f];
                aAreaField.returnKeyType = UIReturnKeyNext;
                aAreaField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                aAreaField.delegate = self;
            
                _areaField = aAreaField;
            }
            [bg addSubview:_areaField];
            
            if (_addressInfo && [_editType isEqualToString:@"edit"]) {
                NSString *areaStr = @"";
                if (_addressInfo.Province) {
                    areaStr = [areaStr stringByAppendingString:[NSString stringWithFormat:@"%@/", _addressInfo.Province]];
                }
                
                if (_addressInfo.City) {
                    areaStr = [areaStr stringByAppendingString:[NSString stringWithFormat:@"%@/", _addressInfo.City]];
                }
                
                if (_addressInfo.Region) {
                    areaStr = [areaStr stringByAppendingString:_addressInfo.Region];
                }
                
                _areaField.text = areaStr;
            }
        }
            break;
            
        case 3:
        {
            [bg setFrame:CGRectMake(10, 12, w - 20, 78)];
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 65, 40)];
            [lbl setBackgroundColor:[UIColor clearColor]];
            [lbl setFont:[UIFont systemFontOfSize:13.0f]];
            [lbl setTextColor:[UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1]];
            [lbl setTextAlignment:NSTextAlignmentLeft];
            [lbl setText:@"详细地址:"];
            [bg addSubview:lbl];
            
            if (!_addressDetailTV) {
                UITextView *detailTV = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lbl.frame), 5, w - 30 - CGRectGetMaxX(lbl.frame), 68)];
                [detailTV setBackgroundColor:[UIColor clearColor]];
                detailTV.autocapitalizationType = UITextAutocapitalizationTypeNone;
                detailTV.autocorrectionType = UITextAutocorrectionTypeNo;
                detailTV.tag = 104;
                detailTV.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
                detailTV.font = [UIFont systemFontOfSize:13.0f];
                detailTV.delegate = self;
                
                [bg addSubview:detailTV];
                _addressDetailTV = detailTV;
                _addressDetailTV.delegate=self;
                _addressDetailTV.returnKeyType=UIReturnKeyDone;
            }
            
            if (_addressInfo && [_editType isEqualToString:@"edit"]) {
                _addressDetailTV.text = _addressInfo.Detail;
            }
        }
            break;
        case 4:
        {
            UILabel *defaultAddressLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 1, 80, 40)];
            [defaultAddressLbl setText:@"设为默认地址"];
            [defaultAddressLbl setBackgroundColor:[UIColor clearColor]];
            [defaultAddressLbl setFont:[UIFont systemFontOfSize:13.0f]];
            [defaultAddressLbl setTextColor:[UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f]];
            if (!defaultAddressBtn) {
                defaultAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [defaultAddressBtn setFrame:CGRectMake(w - 50, 6, 30 , 30)];
                [defaultAddressBtn setImage:[UIImage imageNamed:@"defaultUncheck"] forState:UIControlStateNormal];
                [defaultAddressBtn setImage:[UIImage imageNamed:@"defaultCheck"] forState:UIControlStateSelected];
                [defaultAddressBtn setImage:[UIImage imageNamed:@"defaultCheck"] forState:UIControlStateHighlighted];
                [defaultAddressBtn addTarget:self action:@selector(defaultBtnClick) forControlEvents:UIControlEventTouchUpInside];
                if (is_default) {
                    defaultAddressBtn.selected = YES;
                }else{
                    defaultAddressBtn.selected = NO;
                }
            }
            [cell addSubview:defaultAddressLbl];
            [cell addSubview:defaultAddressBtn];
        }
        default:
            break;
    }
    return cell;
}

-(void)defaultBtnClick
{
    if (defaultAddressBtn.selected) {
        defaultAddressBtn.selected = NO;
        is_default = false;
    }
    else
    {
        defaultAddressBtn.selected = YES;
        is_default = true;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        return 90;
    }
    return 40;
}

- (void)showRegionActionSheet
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:@"empty"];
    [arr addObject:@"empty"];
    [arr addObject:@"empty"];
    kata_AdressListTableViewController *addressControlVC = [[kata_AdressListTableViewController alloc] initWithStyle:UITableViewStylePlain andRegion:@"province" andRegionPid:[NSNumber numberWithInteger:0] andAddres:arr];
    addressControlVC.navigationController = self.navigationController;
    //addressControlVC.myDelete = self;
    [self.navigationController pushViewController:addressControlVC animated:YES];
//    if (!_regionActionSheet) {
//        _regionActionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择地区信息"
//                                                         delegate:self
//                                                cancelButtonTitle:nil
//                                           destructiveButtonTitle:nil
//                                                otherButtonTitles:nil];
//        
//        [_regionActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
//        
//        _cancelButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"取消"]];
//        _cancelButton.momentary = YES;
//        _cancelButton.frame = CGRectMake(10.0f, 7.0f, 65.0f, 28.0f);
//        _cancelButton.segmentedControlStyle = UISegmentedControlStyleBar;
//        [_cancelButton addTarget:self action:@selector(regionCancelClick) forControlEvents:UIControlEventValueChanged];
//        [_regionActionSheet addSubview:_cancelButton];
//        
//        _confirmButton =[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"确定"]];
//        _confirmButton.momentary = YES;
//        _confirmButton.frame = CGRectMake(245, 7.0f, 65.0f, 28.0f);
//        _confirmButton.segmentedControlStyle = UISegmentedControlStyleBar;
//        [_confirmButton addTarget:self action:@selector(regionConfirmClick) forControlEvents:UIControlEventValueChanged];
//        [_regionActionSheet addSubview:_confirmButton];
//    }
//    
//    if (!_regionPicker) {
//        // Add the picker
//        _regionPicker = [[UIPickerView alloc] init];
//        _regionPicker.showsSelectionIndicator = YES;
//        _regionPicker.dataSource = self;
//        _regionPicker.delegate = self;
//        _regionPicker.tag = 100003;
//        CGRect pickerRect = _regionPicker.bounds;
//        pickerRect.origin.y = 40;
//        _regionPicker.frame = pickerRect;
//        [_regionActionSheet addSubview:_regionPicker];
//    }
//    [_regionPicker reloadAllComponents];
//    
//    [_regionActionSheet showInView:self.view];
//    [_regionActionSheet setBounds:CGRectMake(0,0, 320, 470)];
//    
//    if ([_regionFlag isEqualToString:@"province"]) {
//        _provinceID = [NSNumber numberWithInteger:[[[_regionArr objectAtIndex:0] objectForKey:@"code"] integerValue]];
//        _provinceName = [[_regionArr objectAtIndex:0] objectForKey:@"name"];
//    } else if ([_regionFlag isEqualToString:@"city"]) {
//        _cityID = [NSNumber numberWithInteger:[[[_regionArr objectAtIndex:0] objectForKey:@"code"] integerValue]];
//        _cityName = [[_regionArr objectAtIndex:0] objectForKey:@"name"];
//    } else if ([_regionFlag isEqualToString:@"county"]) {
//        _countyID = [NSNumber numberWithInteger:[[[_regionArr objectAtIndex:0] objectForKey:@"code"] integerValue]];
//        _countyName = [[_regionArr objectAtIndex:0] objectForKey:@"name"];
//    }
}

- (void)regionCancelClick
{
    [_regionActionSheet dismissWithClickedButtonIndex:-1 animated:YES];
    
    if ([_editType isEqualToString:@"add"]) {
        if (!_countyID) {
            _provinceID = nil;
            _provinceName = nil;
            _cityID = nil;
            _cityName = nil;
            _countyID = nil;
            _countyName = nil;
        }
    } else if ([_editType isEqualToString:@"edit"]) {
        if (_addressInfo.ProvinceCode) {
            _provinceID = _addressInfo.ProvinceCode;
        }
        if (_addressInfo.CityCode) {
            _cityID = _addressInfo.CityCode;
        }
        if (_addressInfo.RegionCode) {
            _countyID = _addressInfo.RegionCode;
        }
    }
}

- (void)regionConfirmClick
{
    if ([_regionFlag isEqualToString:@"province"]) {
        [_regionActionSheet dismissWithClickedButtonIndex:-1 animated:YES];
        _regionFlag = @"city";
        _regionPid = _provinceID;
    } else if ([_regionFlag isEqualToString:@"city"]) {
        [_regionActionSheet dismissWithClickedButtonIndex:-1 animated:YES];
        _regionFlag = @"county";
        _regionPid = _cityID;
    } else if ([_regionFlag isEqualToString:@"county"]) {
        _submitArr = [NSMutableArray new];
        [_submitArr addObject:_provinceID];
        [_submitArr addObject:_cityID];
        [_submitArr addObject:_countyID];
        NSString *areaStr = _provinceName;
        areaStr = [areaStr stringByAppendingFormat:@"/%@", _cityName];
        areaStr = [areaStr stringByAppendingFormat:@"/%@", _countyName];
        _areaField.text = areaStr;
        [_regionActionSheet dismissWithClickedButtonIndex:-1 animated:YES];
        [_addressDetailTV becomeFirstResponder];
        return;
    }
    [_regionPicker performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];
    _regionPicker = nil;
    [self regionOperation];
}

#pragma mark - UITextField Input Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _aUsernameField) {
        [_mobileField becomeFirstResponder];
    } else if (textField == _mobileField) {
        [_areaField becomeFirstResponder];
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - TextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _areaField) {
        return NO;
    } else if (textField == _mobileField) {
        if(strlen([textField.text UTF8String]) >= 11 && range.length != 1) {
            return NO;
        } else {
            if (strlen([string UTF8String]) <= 11) {
                NSCharacterSet *cs;
                cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
                NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
                BOOL canChange = [string isEqualToString:filtered];
                
                return canChange;
            } else {
                return NO;
            }
        }
    }
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
//    if (!_addressMask) {
//		_addressMask = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
//		_addressMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
//		[_addressMask addTarget:self action:@selector(hideInputControl) forControlEvents:UIControlEventTouchUpInside];
//		_addressMask.alpha = 0;
//		[self.contentView addSubview:_addressMask];
		
//		[UIView beginAnimations:nil context:nil];
//		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
//		[UIView setAnimationDuration:0.3];
//		_addressMask.alpha = 1;
//		[UIView commitAnimations];
//	}
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _areaField) {
        if (_countyID) {
            [_regionPicker performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];
            _regionPicker = nil;
            _regionArr = _areaArr;
            _regionFlag = @"province";
        } else if (!_provinceID) {
            [_regionPicker performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];
            _regionPicker = nil;
            _regionArr = _areaArr;
            _regionFlag = @"province";
        }
        [_mobileField resignFirstResponder];
        [self showRegionActionSheet];
        return NO;
    }
    
//    if (!_addressMask) {
//        _edittingTF = textField;
//		_addressMask = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
//		_addressMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
//		[_addressMask addTarget:self action:@selector(hideInputControl) forControlEvents:UIControlEventTouchUpInside];
//		_addressMask.alpha = 0;
//		[self.contentView addSubview:_addressMask];
		
//		[UIView beginAnimations:nil context:nil];
//		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
//		[UIView setAnimationDuration:0.3];
//		_addressMask.alpha = 1;
//		[UIView commitAnimations];
//	}
    return YES;
}

- (void)hideInputControl
{
//	if (_edittingTF) {
//        [_edittingTF resignFirstResponder];
//    }
    [self resignCurrentFirstResponder];
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeMask)];
	_addressMask.alpha = 0;
	[UIView commitAnimations];
}

- (void)removeMask
{
	if (_addressMask) {
		[_addressMask removeFromSuperview];
		_addressMask = nil;
	}
}

#pragma mark - Picker View Delegate & DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _regionArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    row = row<_regionArr.count? row: 0;
    return [[_regionArr objectAtIndex:row] objectForKey:@"name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([_regionFlag isEqualToString:@"province"]) {
        _provinceID = [NSNumber numberWithInteger:[[[_regionArr objectAtIndex:row] objectForKey:@"code"] integerValue]];
        _provinceName = [[_regionArr objectAtIndex:row] objectForKey:@"name"];
    } else if ([_regionFlag isEqualToString:@"city"]) {
        _cityID = [NSNumber numberWithInteger:[[[_regionArr objectAtIndex:row] objectForKey:@"code"] integerValue]];
        _cityName = [[_regionArr objectAtIndex:row] objectForKey:@"name"];
    } else if ([_regionFlag isEqualToString:@"county"]) {
        _countyID = [NSNumber numberWithInteger:[[[_regionArr objectAtIndex:row] objectForKey:@"code"] integerValue]];
        _countyName = [[_regionArr objectAtIndex:row] objectForKey:@"name"];
    }
}

@end

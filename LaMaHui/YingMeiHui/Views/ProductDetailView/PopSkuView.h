//
//  PopSkuView.h
//  YingMeiHui
//
//  Created by work on 14-10-10.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductInfoVO.h"
#import "BOKUNoActionTextField.h"
#import "MBProgressHUD.h"

@protocol PopSkuViewDelegate <NSObject>

-(void)select_Color:(NSInteger)colorid select_Size:(NSInteger)sizeid total_Num:(NSInteger)qty andSku_id:(NSString *)sku_id;
//-(void)finish_Select;

@end

@interface PopSkuView : UIView<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MBProgressHUDDelegate,UIAlertViewDelegate>
{
    NSInteger cellRow;
    UILabel *__ourPriceLbl;
    UILabel *__marketPriceLbl;
    UIView *_colorPropView;
    UIView *_sizePropView;
    UIView *_selectView;
    NSInteger _colorid;
    NSInteger _sizeid;
    NSInteger _qty;
    
    UIView *headView;
    UIView *footView;
    BOKUNoActionTextField *_countTF;
    UIButton *downBtn;
    MBProgressHUD *stateHud;
    CGFloat headHight;
    NSMutableArray *colorBtnArray;
    NSMutableArray *sizeBtnArray;
    UIButton *_minusBtn;
    UIButton *_plusBtn;
    
    NSInteger _skuCartNum;
    NSInteger _skuOrderNum;
    NSInteger _skuNum;
}

@property(nonatomic, assign) id<PopSkuViewDelegate> popSkuViewDelegate;
@property(nonatomic, strong) UITableView *skuTabeView;
@property(nonatomic, strong) ProductInfoVO *_productVO;
@property(nonatomic, strong) NSNumber *_proid;
@property(nonatomic)         BOOL _isShoppingCart;

- (void)textStateHUD:(NSString *)text;

@end

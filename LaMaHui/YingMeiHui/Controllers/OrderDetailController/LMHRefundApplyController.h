//
//  LMHRefundApplyController.h
//  YingMeiHui
//
//  Created by Zhumingming on 15-1-30.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "FTBaseViewController.h"
#import "ZYQAssetPickerController.h"
#import "OrderDetailVO.h"

@interface LMHRefundApplyController : FTBaseViewController<UITextViewDelegate,UITextFieldDelegate,ZYQAssetPickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>

- (id)initWithGoodVO:(OrderGoodsVO *)goodVO andType:(NSInteger)type;

@end

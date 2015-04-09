//
//  EvaluationTableViewController.h
//  YingMeiHui
//
//  Created by 王凯 on 15-1-30.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListVO.h"
#import "FTStatefulTableViewController.h"

@interface EvaluationTableViewController : FTStatefulTableViewController<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (id)initWithOrderEventVO:(OrderEventVO *) eventVO;

@end

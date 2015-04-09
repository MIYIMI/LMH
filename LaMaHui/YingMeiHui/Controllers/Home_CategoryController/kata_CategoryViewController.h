//
//  kata_CategoryViewController.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-30.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "FTStatefulTableViewController.h"
#import "kata_IndexAdvFocusViewController.h"
#import "KTBrandProductListCell.h"
#import "AdvVO.h"
#import "LMH_Config.h"
#import "kata_LoginViewController.h"
#import "HomeSeckillCell.h"
#import "XLCycleScrollView.h"

@interface kata_CategoryViewController : FTStatefulTableViewController <KATAFocusViewControllerDelegate, KTBrandProductListCellDelegate,UIGestureRecognizerDelegate,LoginDelegate,XLCycleScrollViewDatasource,XLCycleScrollViewDelegate>

- (id)initWithMenuID:(NSInteger)menuid andParentID:(NSInteger)parentid andTitle:(NSString *)title;

-(void)nextView:(AdvVO *)nextVO;

@end

//
//  kata_RootViewController.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-29.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "FTBaseViewController.h"
#import "KTChannelViewController.h"

@interface kata_RootViewController : FTBaseViewController <UIGestureRecognizerDelegate>
{

}
- (id)initWithMenuInfo:(NSArray *)menuArr;
-(KTChannelViewController *)getCenterVC;
@end

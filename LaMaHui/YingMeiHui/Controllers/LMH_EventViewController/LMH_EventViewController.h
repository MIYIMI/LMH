//
//  LMH_EventViewController.h
//  YingMeiHui
//
//  Created by work on 15/5/27.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "FTStatefulTableViewController.h"

@class AdvVO;

@interface LMH_EventViewController : FTStatefulTableViewController

@property(nonatomic)NSInteger eventID;
@property(nonatomic)NSInteger scrollType;
@property(nonatomic,strong)NSString *vcTitle;

- (id)initWithDataVO:(AdvVO *)_advo;

@end

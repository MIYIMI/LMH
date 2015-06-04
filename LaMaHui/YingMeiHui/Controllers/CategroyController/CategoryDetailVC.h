//
//  CategoryDetailVC.h
//  YingMeiHui
//
//  Created by KevinKong on 14-9-23.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "FTStatefulTableViewController.h"
#import "kata_ProductDetailViewController.h"
#import "AloneProductCellTableViewCell.h"
#import "Category_selectView.h"

@interface CategoryDetailVC : FTStatefulTableViewController<AloneProductCellTableViewCellDelgate>

-(id)initWithAdvData:(AdvVO *)advo andFlag:(NSString *)_flag;
@property(nonatomic,strong)NSNumber *cateid;
@property(nonatomic,strong)NSNumber *pid;
@property(nonatomic)BOOL is_root;
@property(nonatomic)BOOL is_search;

@end

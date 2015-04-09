//
//  AloneProductCellTableViewCell.h
//  YingMeiHui
//
//  Created by work on 14-11-9.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeVO.h"

@protocol AloneProductCellTableViewCellDelgate <NSObject>

-(void)tapAtItem:(HomeProductVO*)pvo;

@end

@interface AloneProductCellTableViewCell : UITableViewCell
{
    UIView *cellView;
    NSMutableArray *viewArray;
    NSMutableArray *proImgArray;
    NSMutableArray *expertLblArray;
    NSMutableArray *titleLblArray;
    NSMutableArray *sellLblArray;
    NSMutableArray *orgLblArray;
    NSMutableArray *lineLblArray;
    NSMutableArray *checkLblArray;
    NSMutableArray *sellnumLblArray;
    NSMutableArray *tlabelArray;
    NSMutableArray *fitArray;
    NSArray        *_cellData;
    NSMutableArray *iconArray;
    NSMutableArray *salesArray;
    NSMutableArray *imgArray;
    NSMutableArray *logoArray;
    NSMutableArray *ttArray;
    
    BOOL _isFlag;
    BOOL _logoShow;
}
-(void)layoutUI:(NSArray *)cellData andColnum:(NSInteger)colnum  is_act:(BOOL)flag is_type:(BOOL)logoShow;
@property(nonatomic,strong)id<AloneProductCellTableViewCellDelgate> delegate;
@property(nonatomic)CGRect cellFrame;
@property(nonatomic)NSInteger row;

@end

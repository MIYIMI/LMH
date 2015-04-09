//
//  CategroyTableCell.h
//  YingMeiHui
//
//  Created by KevinKong on 14-9-22.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryDataModel.h"
/**
 此类用于 分类 的 显示.
 */
#pragma mark - 
#pragma mark CategoryDataModel 

typedef enum{
    CategoryChildType_text,// 文本.
    CategoryChildType_btn,// button 可点击。
}CategoryChildType;

@interface CategoryTableCellDataModel : NSObject
@property (nonatomic,strong) NSIndexPath *indexPath;
-(void)setCategoryDataModel:(CategoryDataModel *)dataModel;
-(NSString *)getCategoryImageURL;
-(NSString *)getCategoryTitle;
-(NSString *)getCategoryChildName;
-(CategoryChildType )getCategoryChildType;
-(NSString *)getCategoryChildNameWithIndex:(NSInteger)index;
-(NSInteger)getCategoryChildCount;
// show ui methods
-(UIFont *)getChlidBtnLabelFont;
@end

#pragma mark-
#pragma mark CategoryTableCell
@class CategroyTableCell;
@protocol CategroyTableCellDelegate <NSObject>

-(void)CategroyTableCell:(CategroyTableCell *)tableCell selectedRowIndexPath:(NSIndexPath *)indexPath didSelectBtnIndex:(NSInteger)index;

@end

@interface CategroyTableCell : UITableViewCell
@property(nonatomic,strong) id<CategroyTableCellDelegate> delegate;
-(void)setCategroyDataModel:(CategoryTableCellDataModel* )dataModel;
@end

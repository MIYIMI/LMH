//
//  CategroyTableCell.m
//  YingMeiHui
//
//  Created by KevinKong on 14-9-22.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "CategroyTableCell.h"
#import "EGOImageView.h"

@interface CategoryTableCellDataModel ()
{
    CategoryDataModel *dataModel;
}
@end

@implementation CategoryTableCellDataModel
@synthesize indexPath;
-(void)setCategoryDataModel:(CategoryDataModel *)__dataModel{
    dataModel = __dataModel;
}
-(NSString *)getCategoryImageURL{
    if (dataModel) {
        return dataModel.image;
    }
    return @"http://pica.nipic.com/2007-12-11/2007121116235726_2.jpg";
}

-(NSString *)getCategoryTitle{
    if (dataModel) {
        return dataModel.title;
    }
    return @"1232";
}
-(NSString *)getCategoryChildName{
    if (dataModel) {
        NSString *str = @"";
        for (CategoryDataModel *tempDataModel in dataModel.cate_son) {
            str=[[str stringByAppendingString:tempDataModel.title] stringByAppendingString:@"/"];
        }
        return str;
    }
    return @"/fsd/sdfds";
}
-(CategoryChildType )getCategoryChildType{
    if (dataModel) {
        if ([dataModel.flag isEqualToString:@"category"]) {
            return CategoryChildType_text;
        }

        return CategoryChildType_btn;


    }
    return CategoryChildType_text;
}
-(NSString *)getCategoryChildNameWithIndex:(NSInteger)index{
    
    if (dataModel) {

        if (index<dataModel.cate_son.count) {
            CategoryDataModel *tempDataModel = [dataModel.cate_son objectAtIndex:index];
            return tempDataModel.title;
        }
        
    }
    
    return @"";
}
-(NSInteger)getCategoryChildCount{
    if (dataModel) {
        return dataModel.cate_son.count;
    }
    return 0;
}

-(UIFont *)getChlidBtnLabelFont{
    return [UIFont systemFontOfSize:12];
}
@end

#pragma mark - 
#pragma mark CategroyTableCell class

@interface CategroyTableCell()
{
    UIView *customContentV;
    EGOImageView *logoImageV;
    UILabel *categoryTitleLabel;
    UILabel *categoryChildLabel;
    UIView *categoryBtnSuperV;
    UIImageView *lineImageV;
    // data
    CategoryTableCellDataModel *cellDataModel;
}
@end

@implementation CategroyTableCell
@synthesize delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self initParams];
    }
    return self;
}

#pragma mark -
#pragma mark super methods overwrite
-(void)layoutSubviews{
    [super layoutSubviews];
    if (customContentV)
        customContentV.frame = [self getCustomContentVFrame];
    if (logoImageV)
        logoImageV.frame = [self getLogoImageVFrame];
    if(categoryTitleLabel)
        categoryTitleLabel.frame = [self getTitleLabelFrame];
    if(categoryChildLabel)
        categoryChildLabel.frame = [self getChlidLabelFrame];
    if (categoryBtnSuperV) {
        categoryBtnSuperV.frame = [self getCategoryBtnSuperVFrame];
    }
    if (lineImageV) {
        lineImageV.frame = [self getLineImageVFrame];
    }
}
#pragma mark -
#pragma mark init methods
-(void)initParams{
    if (!customContentV) {
        customContentV = [[UIView alloc] init];
        customContentV.backgroundColor=[UIColor whiteColor];
        [self addSubview:customContentV];
    }
    if (!lineImageV) {
        lineImageV = [[UIImageView alloc] init];
        [lineImageV setBackgroundColor:[UIColor clearColor]];
        [lineImageV setImage:[UIImage imageNamed:@"CategoryTableCellLine.png"]];
        [customContentV addSubview:lineImageV];
    }
    if (!logoImageV) {
        logoImageV = [[EGOImageView alloc] init];
        logoImageV.backgroundColor=[UIColor clearColor];
        [customContentV addSubview:logoImageV];
    }
    
    if (!categoryTitleLabel) {
        categoryTitleLabel = [[UILabel alloc] init];
        categoryTitleLabel.backgroundColor=[UIColor clearColor];
        categoryTitleLabel.textColor=UIColorRGBA(45, 34, 33, 1);
        [customContentV addSubview:categoryTitleLabel];
    }
    
    if (!categoryChildLabel) {
        categoryChildLabel = [[UILabel alloc] init];
        categoryChildLabel.backgroundColor=[UIColor clearColor];
        categoryChildLabel.font=[UIFont systemFontOfSize:12.0];
        categoryChildLabel.textColor=UIColorRGBA(124, 124, 124, 1);
        categoryChildLabel.numberOfLines=3;
        [customContentV addSubview:categoryChildLabel];
    }
    
    if (!categoryBtnSuperV) {
        categoryBtnSuperV = [[UIView alloc] init];
        [categoryBtnSuperV setBackgroundColor:[UIColor clearColor]];
        [customContentV addSubview:categoryBtnSuperV];
    }
}
#pragma mark - 
#pragma mark layout item frames
-(CGRect)selfFrame{
    CGRect selfFrame = self.frame;
    selfFrame.origin.x=0;
    selfFrame.origin.y=0;
    return selfFrame;
}
-(CGRect)getCustomContentVFrame{
    return [self selfFrame];
}


-(CGRect)getLogoImageVFrame{
    CGFloat w = 65;
    CGFloat h = 65;
    CGFloat x = 5;
    CGFloat y = 10;
    return CGRectMake(x, y, w, h);
}
-(CGRect)getTitleLabelFrame{
    CGRect logoFrame = [self getLogoImageVFrame];
    CGFloat x = CGRectGetMaxX(logoFrame)+10;
    CGFloat y = CGRectGetMinY(logoFrame);
    CGFloat w = 220;
    CGFloat h = 40;
    return CGRectMake(x, y, w, h);
}
-(CGRect)getChlidLabelFrame{
    CGRect titleLabelFrame = [self getTitleLabelFrame];
    CGFloat x = CGRectGetMinX(titleLabelFrame);
    CGFloat y = CGRectGetMaxY(titleLabelFrame);
    CGFloat w = CGRectGetWidth(titleLabelFrame);
    CGFloat h = 50;
    return CGRectMake(x, y, w, h);
}
-(CGRect)getChlidBtnFrameWithIndex:(NSInteger )index{
    if (index<=0) {
        CGFloat x = 0;
        CGFloat y = 2;
//        CGSize itemSize = [self getChlidBtnTextSizeWithIndex:index];
        CGFloat w = 36;//itemSize.width+5;
        CGFloat h = 15;//itemSize.height+5;
        return CGRectMake(x, y, w, h);
    }else{
        
        CGRect priusBtnFrame = [self getChlidBtnFrameWithIndex:index-1];
//        CGSize priusItemSize = [self getChlidBtnTextSizeWithIndex:index];
        CGFloat x = CGRectGetMaxX(priusBtnFrame)+5;
        CGFloat y = CGRectGetMinY(priusBtnFrame);
        CGFloat w = 36;//priusItemSize.width+8;
        CGFloat h = 15;//priusItemSize.height+5;
        CGFloat maxX = x+w+2;
        CGRect superVFrame = [self getCategoryBtnSuperVFrame];
        if (maxX>CGRectGetWidth(superVFrame)) {
            x = 0;
            y = CGRectGetMaxY(priusBtnFrame)+8;
            
        }
        return CGRectMake(x, y, w, h);
        
    }
    return CGRectZero;
}

-(CGSize )getChlidBtnTextSizeWithIndex:(NSInteger)index{
    NSString *tempStr = @"";
   NSInteger tempIndex = 0;
    if (index<=0) {
        tempIndex = 0;
    }
    if (cellDataModel!=nil) {
        tempStr = [cellDataModel getCategoryChildNameWithIndex:tempIndex];
        return [tempStr sizeWithFont:[cellDataModel getChlidBtnLabelFont]];
    }
    return CGSizeMake(0, 0);
}

-(CGRect )getCategoryBtnSuperVFrame{
    CGRect titleLabelFrame = [self getTitleLabelFrame];
    CGFloat x = CGRectGetMinX(titleLabelFrame);
    CGFloat y = CGRectGetMaxY(titleLabelFrame);
    CGFloat w = CGRectGetWidth(titleLabelFrame);
    CGFloat h = 50;
    return CGRectMake(x, y, w, h);
}

-(CGRect)getLineImageVFrame{
    CGRect superVFrame = [self getCustomContentVFrame];
    CGFloat x =0;
    CGFloat h =2;
    CGFloat y = CGRectGetHeight(superVFrame)-h;
    CGFloat w = CGRectGetWidth(superVFrame);
    return CGRectMake(x, y, w, h);

}

#pragma mark -
#pragma mark public methods
-(void)setCategroyDataModel:(CategoryTableCellDataModel* )dataModel{
    if (dataModel!=nil) {
        cellDataModel = dataModel;
        if (logoImageV)
            [logoImageV setImageURL:[NSURL URLWithString:[cellDataModel getCategoryImageURL]]];
        if (categoryTitleLabel)
            [categoryTitleLabel setText:[cellDataModel getCategoryTitle]];
        
        CategoryChildType childType = [cellDataModel getCategoryChildType];
        if (categoryBtnSuperV){
            categoryBtnSuperV.hidden=childType==CategoryChildType_btn?NO:YES;
        }
        
        if (categoryChildLabel) {
            categoryChildLabel.hidden = childType==CategoryChildType_btn?YES:NO;
        }

        if (childType == CategoryChildType_text) {
             categoryChildLabel.text = [dataModel getCategoryChildName];
        }else{
            NSInteger itemCount = [categoryBtnSuperV subviews].count;
            NSInteger chlidCount = [cellDataModel getCategoryChildCount];
            NSInteger maxCount = MAX(itemCount, chlidCount);
            NSInteger tempTag = 1000;
            for (NSInteger i=0; i<maxCount; i++) {
                NSInteger currentTag = tempTag+i;
                UIButton *tempBtn = (UIButton *)[categoryBtnSuperV viewWithTag:currentTag];
                if (i<chlidCount) {
                    if (tempBtn==nil) {
                        tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        [tempBtn setBackgroundImage:[UIImage imageNamed:@"AgeBg.png"] forState:UIControlStateNormal];
                        tempBtn.tag=currentTag;
                        [tempBtn setTitleColor:UIColorRGBA(101, 101, 101, 1) forState:UIControlStateNormal];
                        [tempBtn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];

                        [categoryBtnSuperV addSubview:tempBtn];
                    }
                        tempBtn.titleLabel.font = [cellDataModel getChlidBtnLabelFont];
                    tempBtn.frame=[self getChlidBtnFrameWithIndex:i];
                    [tempBtn setTitle:[cellDataModel getCategoryChildNameWithIndex:i] forState:UIControlStateNormal];
                }else{
                    if (tempBtn) {
                        [tempBtn removeFromSuperview];
                    }
                }
            }
        }
    }
}

#pragma mark -
#pragma mark Action Methods
-(void)btnClickAction:(id)sender{
    UIButton *tempBtn = (UIButton *)sender;
    if (tempBtn) {
        NSInteger tag = tempBtn.tag-1000;
        //
        if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(CategroyTableCell:selectedRowIndexPath:didSelectBtnIndex:)]) {
            [self.delegate CategroyTableCell:self selectedRowIndexPath:cellDataModel.indexPath didSelectBtnIndex:tag];
        }
    }
}
//
@end

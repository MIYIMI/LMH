//
//  MyCommentCell.h
//  YingMeiHui
//
//  Created by Zhumingming on 15-5-27.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMHMyCommentVO.h"

@protocol MyCommentCellDelegate <NSObject>

- (void)pushWX;
- (void)pushNextVC:(LMHMyCommentVO *)commentVO;

@optional
- (void)delegateButtonMethod:(LMHMyCommentVO *)commentVO;
- (void)pushWebViewController:(LMHMyCommentVO *)commentVO;

@end

@interface MyCommentCell : UITableViewCell

@property(nonatomic,strong)UIView      *cellView;        //大背景
@property(nonatomic,strong)UIImageView *iconImageView;   //头像
@property(nonatomic,strong)UILabel     *nickNameLabel;   //昵称
@property(nonatomic,strong)UILabel     *timeLabel;       //时间
@property(nonatomic,strong)UILabel     *contentLabel;    //内容
@property(nonatomic,strong)UIView      *smallView;       //小背景
@property(nonatomic,strong)UIImageView *smallIconView;   //小头像
@property(nonatomic,strong)UILabel     *goodsTitleLbl;   //小标题
@property(nonatomic,strong)UILabel     *goodsSmallTitLbl;//小标题二级标题
@property(nonatomic,strong)UIButton    *weChatBtn;       //微信关注按钮
@property(nonatomic,strong)UIButton    *deleteBtn;       //删除按钮

@property(nonatomic       )BOOL        isReceiveComment; //是否是收到的评论

-(void)layoutUI:(LMHMyCommentVO*)commentVO;

@property(nonatomic,strong)id<MyCommentCellDelegate>delegate;

@end

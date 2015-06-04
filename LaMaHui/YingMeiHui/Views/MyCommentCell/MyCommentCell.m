//
//  MyCommentCell.m
//  YingMeiHui
//
//  Created by Zhumingming on 15-5-27.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "MyCommentCell.h"

@implementation MyCommentCell
{
    LMHMyCommentVO *_commentVO;
    
    UIPasteboard *pasteboard;
}

@synthesize cellView;        //大背景
@synthesize iconImageView;   //头像
@synthesize nickNameLabel;   //昵称
@synthesize timeLabel;       //时间
@synthesize contentLabel;    //内容
@synthesize smallView;       //小背景
@synthesize smallIconView;   //小头像
@synthesize goodsTitleLbl;   //小标题
@synthesize goodsSmallTitLbl;//小标题二级标题
@synthesize weChatBtn;       //微信关注按钮
@synthesize deleteBtn;       //删除按钮
@synthesize isReceiveComment;//是否是接收的评论

-(void)layoutUI:(LMHMyCommentVO*)commentVO{
    
    _commentVO = commentVO;
    
    //大背景
    if (!cellView) {
        cellView = [[UIView alloc] initWithFrame:CGRectZero];
        [cellView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:cellView];
    }
    //头像
    if (!iconImageView) {
        iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, RATIO(74), RATIO(74))];
        [cellView addSubview:iconImageView];
    }
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:_commentVO.avatar]];
    
    //昵称
    if (!nickNameLabel) {
        nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame)+10, 10, 200, 18)];
        nickNameLabel.backgroundColor = [UIColor clearColor];
        nickNameLabel.textColor = LMH_COLOR_BLACK;
        nickNameLabel.font = LMH_FONT_12;
        nickNameLabel.textAlignment = NSTextAlignmentLeft;
        [cellView addSubview:nickNameLabel];
    }
    nickNameLabel.text = _commentVO.nickname;
    
    //时间
    if (!timeLabel) {
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame)+10, CGRectGetMaxY(nickNameLabel.frame), 200, 15)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textColor = LMH_COLOR_GRAY;
        timeLabel.font = LMH_FONT_10;
        timeLabel.textAlignment = NSTextAlignmentLeft;
        [cellView addSubview:timeLabel];
    }
    timeLabel.text = _commentVO.create_at;
    
    //内容
    if (!contentLabel) {
        contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.textColor = LMH_COLOR_BLACK;
        contentLabel.font = LMH_FONT_11;
        contentLabel.numberOfLines = 0;
        [cellView addSubview:contentLabel];
    }

    contentLabel.text = _commentVO.content;
    CGSize hightSize = [_commentVO.content sizeWithFont:LMH_FONT_11 constrainedToSize:CGSizeMake(ScreenW -140, 70) lineBreakMode:NSLineBreakByCharWrapping];
    contentLabel.frame = CGRectMake(CGRectGetMaxX(iconImageView.frame)+10, CGRectGetMaxY(timeLabel.frame)+10, ScreenW - CGRectGetMaxX(iconImageView.frame) - 10 - 10, hightSize.height);
    
    //小背景
    if (!smallView) {
        smallView = [[UIImageView alloc]initWithFrame:CGRectZero];
        smallView.backgroundColor = [UIColor clearColor];
        smallView.layer.masksToBounds = YES;
        smallView.layer.cornerRadius =  2.0;
        smallView.layer.borderColor = LMH_COLOR_GRAY.CGColor;
        smallView.layer.borderWidth = 0.5;
        smallView.userInteractionEnabled = YES;
        [cellView addSubview:smallView];
        UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapClick:)];
        [smallView addGestureRecognizer:viewTap];
    }
    //这种View 的坐标一定要动态定义 不能放到里面 否则将只定义一次
    smallView.frame = CGRectMake(RATIO(120), CGRectGetMaxY(contentLabel.frame)+10,  ScreenW-RATIO(120) - 10, RATIO(102));
    
    //小头像
    if (!smallIconView) {
        smallIconView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [smallView addSubview:smallIconView];
    }
    //判断小模块是专题模块 还是单品模块： goods--单品  camoaign--专题
    if ([_commentVO.goods_infor.type isEqualToString:@"goods"]) {
        smallIconView.frame = CGRectMake(10, RATIO(19), RATIO(64), RATIO(64));
    }else if ([_commentVO.goods_infor.type isEqualToString:@"campaign"]){
        smallIconView.frame = CGRectMake(10, RATIO(19), RATIO(130), RATIO(64));
    }
    [smallIconView sd_setImageWithURL:[NSURL URLWithString:_commentVO.goods_infor.img]];
    
    //小标题
    if (!goodsTitleLbl) {
        goodsTitleLbl = [[UILabel alloc]initWithFrame:CGRectZero];
        goodsTitleLbl.backgroundColor = [UIColor clearColor];
        goodsTitleLbl.textColor = LMH_COLOR_BLACK;
        goodsTitleLbl.font = LMH_FONT_14;
        goodsTitleLbl.textAlignment = NSTextAlignmentLeft;
        [smallView addSubview:goodsTitleLbl];
    }
    goodsTitleLbl.text = _commentVO.goods_infor.title;
    goodsTitleLbl.frame = CGRectMake(CGRectGetMaxX(smallIconView.frame)+5, 10, CGRectGetWidth(smallView.frame) - CGRectGetMaxX(smallIconView.frame) - 10, 15);
    
    //小标题 二级标题
    if (!goodsSmallTitLbl) {
        goodsSmallTitLbl = [[UILabel alloc]initWithFrame:CGRectZero];
        goodsSmallTitLbl.backgroundColor = [UIColor clearColor];
        goodsSmallTitLbl.textColor = LMH_COLOR_GRAY;
        goodsSmallTitLbl.font = LMH_FONT_10;
        goodsSmallTitLbl.textAlignment = NSTextAlignmentLeft;
        [smallView addSubview:goodsSmallTitLbl];
        
        UITapGestureRecognizer *smallTitleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(smallTitleTapClick:)];
        [goodsSmallTitLbl addGestureRecognizer:smallTitleTap];
    }
    
    goodsSmallTitLbl.text = _commentVO.goods_infor.name;
    goodsSmallTitLbl.frame = CGRectMake(CGRectGetMaxX(smallIconView.frame)+5, CGRectGetMaxY(goodsTitleLbl.frame)+2, 100, 15);
    
    //删除按钮
    if (!deleteBtn) {
        if (isReceiveComment) {
            deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteBtn.frame = CGRectMake(ScreenW - 45, 10, 35, 18);
            deleteBtn.backgroundColor = [UIColor clearColor];
            [deleteBtn setTitle:@"删 除" forState:UIControlStateNormal];
            [deleteBtn setTitleColor:LMH_COLOR_GRAY forState:UIControlStateNormal];
            deleteBtn.titleLabel.font = LMH_FONT_10;
            deleteBtn.layer.masksToBounds = YES;
            deleteBtn.layer.cornerRadius = 2.0;
            deleteBtn.layer.borderColor = LMH_COLOR_GRAY.CGColor;
            deleteBtn.layer.borderWidth = 0.5;
            [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cellView addSubview:deleteBtn];
        }
        
    }
    
    //微信关注
    if (!weChatBtn) {
        weChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        weChatBtn.frame = CGRectMake(CGRectGetMaxX(goodsSmallTitLbl.frame), CGRectGetMaxY(goodsTitleLbl.frame)+2, 60, 15);
        weChatBtn.backgroundColor = [UIColor clearColor];
        [weChatBtn setTitle:@"+ 微信关注" forState:UIControlStateNormal];
        [weChatBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        weChatBtn.titleLabel.font = LMH_FONT_10;
        [weChatBtn addTarget:self action:@selector(weChatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [smallView addSubview:weChatBtn];
        [smallView addSubview:weChatBtn];
    }
    
    //判断小模块是专题模块 还是单品模块： goods--单品  camoaign--专题
    if ([_commentVO.goods_infor.type isEqualToString:@"goods"]) {
        weChatBtn.hidden = YES;
        goodsSmallTitLbl.userInteractionEnabled = NO;
    }else if ([_commentVO.goods_infor.type isEqualToString:@"campaign"]){
        weChatBtn.hidden = NO;
        goodsSmallTitLbl.userInteractionEnabled = YES;
    }
    
    cellView.frame = CGRectMake(0, 0, ScreenW, CGRectGetMaxY(smallView.frame)+15);

}
//二级小标题 点击
- (void)smallTitleTapClick:(UITapGestureRecognizer *)tap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushWebViewController:)]) {
        [self.delegate pushWebViewController:_commentVO];
    }
}
//删除按钮
- (void)deleteBtnClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(delegateButtonMethod:)]) {
        [self.delegate delegateButtonMethod:_commentVO];
    }
}
/**
 *  微信关注 按钮
 */
- (void)weChatBtnClick:(UIButton *)sender
{
    if (!pasteboard) {
        pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = _commentVO.goods_infor.weixin;
    }
    if ([self.delegate respondsToSelector:@selector(pushWX)] && _commentVO.goods_infor.weixin) {
        [self.delegate pushWX];
    }
}
//专题/单品 模块点击事件
- (void)viewTapClick:(UITapGestureRecognizer *)tap{
    
    if ([_commentVO.goods_infor.type isEqualToString:@"goods"]) {
        if ([self.delegate respondsToSelector:@selector(pushNextVC:)]) {
            [self.delegate pushNextVC:_commentVO];
        }
    }else if ([_commentVO.goods_infor.type isEqualToString:@"campaign"]){

        if ([self.delegate respondsToSelector:@selector(pushNextVC:)]) {
            [self.delegate pushNextVC:_commentVO];
        }
    }
    
}

@end

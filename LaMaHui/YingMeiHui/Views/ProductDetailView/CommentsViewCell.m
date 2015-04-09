//
//  CommentsViewCell.m
//  YingMeiHui
//
//  Created by work on 14-10-15.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "CommentsViewCell.h"

@implementation CommentsViewCell
{
    UIImageView *userImgView;
    UILabel *userNmaeLbl;
    UILabel *contentsLbl;
    UILabel *timeLbl;
    UILabel *specLbl;
    CGFloat cellHeight;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setComments:(CommentsVO *)dataVO
{
    if (dataVO) {
        cellHeight = 0;
        
        CGFloat w = self.frame.size.width;
        
        if (!userImgView) {
            userImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 5, 40, 40)];
            [self addSubview:userImgView];
        }
        [userImgView setImage:[UIImage imageNamed:@"userimage"]];
        
        if (!userNmaeLbl) {
            userNmaeLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImgView.frame) + 10, 5, w - CGRectGetMaxX(userImgView.frame) - 22, 20)];
            [userNmaeLbl setTextColor:[UIColor colorWithRed:0.62 green:0.62 blue:0.62 alpha:1]];
            [userNmaeLbl setFont:[UIFont systemFontOfSize:15.0]];
            [self addSubview:userNmaeLbl];
        }
        [userNmaeLbl setText:dataVO.user_name];
        
        if(!contentsLbl){
            contentsLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImgView.frame) + 10, CGRectGetMaxY(userNmaeLbl.frame)+5, w - CGRectGetMaxX(userImgView.frame) - 22, 40)];
            
            [contentsLbl setTextColor:[UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1]];
            [contentsLbl setFont:[UIFont systemFontOfSize:15.0]];
            contentsLbl.lineBreakMode = NSLineBreakByCharWrapping;
            contentsLbl.numberOfLines = 0;
            [self addSubview:contentsLbl];
        }
        CGSize contentSize = [dataVO.content sizeWithFont:contentsLbl.font constrainedToSize:CGSizeMake(CGRectGetWidth(contentsLbl.frame), 1000) lineBreakMode:NSLineBreakByCharWrapping];
        [contentsLbl setFrame:CGRectMake(CGRectGetMaxX(userImgView.frame)+10, CGRectGetMaxY(userNmaeLbl.frame)+5, w - CGRectGetMaxX(userImgView.frame) - 22, contentSize.height)];
        [contentsLbl setText:dataVO.content];
        
        if (!timeLbl) {
            timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImgView.frame) + 10, CGRectGetMaxY(contentsLbl.frame)+5, 100, 20)];
            
            [timeLbl setTextColor:[UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1]];
            [timeLbl setFont:[UIFont systemFontOfSize:12.0]];
            [self addSubview:timeLbl];
        }
        [timeLbl setFrame:CGRectMake(CGRectGetMaxX(userImgView.frame)+10, CGRectGetMaxY(contentsLbl.frame)+5, 80, 20)];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSDate *begin = [NSDate dateWithTimeIntervalSince1970:[dataVO.create_at longLongValue]];
        NSString *beginTimespStr = [formatter stringFromDate:begin];
        [timeLbl setText:beginTimespStr];
        
        if (!specLbl) {
            specLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timeLbl.frame) + 5, CGRectGetMaxY(contentsLbl.frame)+5, w - CGRectGetMaxX(timeLbl.frame) - 17, 20)];
            
            [specLbl setTextColor:[UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1]];
            [specLbl setFont:[UIFont systemFontOfSize:12.0]];
            [self addSubview:specLbl];
        }
        [specLbl setFrame:CGRectMake(CGRectGetMaxX(timeLbl.frame) + 5, CGRectGetMaxY(contentsLbl.frame)+5, w - CGRectGetMaxX(timeLbl.frame) - 17, 20)];
        NSMutableString *specStr = [[NSMutableString alloc] init];
        for (CommentsVO *vo in dataVO.spec) {
            if (vo.color) {
                [specStr appendString:vo.color];
            }
            [specStr appendString:@"    "];
            if (vo.size) {
                [specStr appendString:vo.size];
            }
        }
        
        [specLbl setText:specStr];
    }
}

@end

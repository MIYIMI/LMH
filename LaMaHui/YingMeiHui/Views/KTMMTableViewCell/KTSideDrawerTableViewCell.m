//
//  KTSideDrawerTableViewCell.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-28.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTSideDrawerTableViewCell.h"

@implementation KTSideDrawerTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setAccessoryCheckmarkColor:[UIColor whiteColor]];
        
        UIView * backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        [backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        
        [self.textLabel setBackgroundColor:[UIColor clearColor]];
        [self.textLabel setTextColor:[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1]];
        
        if(IOS_7== NO){
            [self.textLabel setShadowColor:[[UIColor blackColor] colorWithAlphaComponent:.5]];
            [self.textLabel setShadowOffset:CGSizeMake(0, 1)];
        } else {
            [self setBackgroundColor:[UIColor clearColor]];
        }
    }
    return self;
}

-(void)updateContentForNewContentSize{
    
    [self.textLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    
//    if([[UIFont class] respondsToSelector:@selector(preferredFontForTextStyle:)]){
//        [self.textLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
//    }
//    else {
//        [self.textLabel setFont:[UIFont systemFontOfSize:16.0]];
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    if (selected) {
        [self.textLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
        [self.textLabel setTextColor:[UIColor whiteColor]];
    } else {
        [self.textLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        [self.textLabel setTextColor:[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1]];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1].CGColor);
    if(IOS_7== NO){
        CGContextStrokeRect(context, CGRectMake(0, rect.size.height-1.5, rect.size.width, 1));
    } else {
        CGContextStrokeRect(context, CGRectMake(0, rect.size.height-1.0, rect.size.width, 1));
    }
}

@end

//
//  KTMainCfgCell.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-4.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTMainCfgCell.h"

@implementation KTMainCfgCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f]];
        [[self textLabel] setFont:[UIFont systemFontOfSize:14.0f]];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        [self.textLabel setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    [self setNeedsDisplay];
    // Configure the view for the selected state
    
}

- (void)drawRect:(CGRect)rect
{
    
    if (self.selected) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
        CGRect fpRect = CGRectMake(0, 0, 4, CGRectGetHeight(rect));
        CGRect bgRect = CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect));
//        CGRect bgRect = CGRectMake(4, 0, CGRectGetWidth(rect) - 4, CGRectGetHeight(rect));
        CGContextSetFillColorSpace(ctx, colorspace);
        
        CGColorSpaceRelease(colorspace);
        
        CGContextSaveGState(ctx);
        
        CGContextSetRGBFillColor(ctx, 0.96f, 0.36f, 0.15f, 1.00f);
        CGContextFillRect(ctx, fpRect);
        
        CGContextRestoreGState(ctx);
        CGContextSaveGState(ctx);
        
        CGContextSetRGBFillColor(ctx, 0.94f, 0.94f, 0.94f, 1.00f);
        CGContextFillRect(ctx, bgRect);
        
        CGContextRestoreGState(ctx);
        
        UIImageView *check = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filtercheck"]];
        self.accessoryView = check;
        self.textLabel.textColor = [UIColor colorWithRed:1 green:0.41 blue:0.01 alpha:1];
    } else {
        self.accessoryView = nil;
        self.textLabel.textColor = [UIColor blackColor];
    }
}

@end

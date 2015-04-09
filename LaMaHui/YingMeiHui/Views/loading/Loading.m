//
//  Loading.m
//  wllll
//
//  Created by 王凯 on 15-3-6.
//  Copyright (c) 2015年 王凯. All rights reserved.
//

#import "Loading.h"

@implementation Loading

- (id)initWithFrame:(CGRect)frame
            andName:(NSString*)GIFName
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString  *name = GIFName;
        NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:name ofType:nil];
        NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
        if (!loadingImageView) {
            loadingImageView = [[UIImageView alloc]init];
        }
        //    imgView.image = [UIImage animatedImageWithAnimatedGIFData:imageData];
        loadingImageView.backgroundColor = [UIColor clearColor];
        loadingImageView.image = [UIImage sd_animatedGIFWithData:imageData];
        loadingImageView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        [self addSubview:loadingImageView];
        [self bringSubviewToFront:loadingImageView];
        loadingImageView.hidden = YES;
        
        }
    return self;
}

- (void)stop{
    loadingImageView.hidden = YES;
}

- (void)start{
    loadingImageView.hidden = NO;
}
@end

//
//  Loading.h
//  wllll
//
//  Created by 王凯 on 15-3-6.
//  Copyright (c) 2015年 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIImageView+WebCache.h>
#import <UIImage+GIF.h>

@interface Loading : UIImageView
{
    UIImageView *loadingImageView;
}
- (id)initWithFrame:(CGRect)frame andName:(NSString*)GIFName;
-(void)start;
-(void)stop;
@end

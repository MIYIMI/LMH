//
//  LMHCellView.m
//  Test
//
//  Created by work on 14-8-31.
//  Copyright (c) 2014年 LYQ. All rights reserved.
//

#import "LMHCellView.h"

@implementation LMHCellView
{
    UIImageView *imageView;
    UIImage *defaultImage;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        defaultImage = [UIImage imageNamed:@"logoph.png"];
    }
    return self;
}

-(void)setImageURL:(NSURL *)imageUrl
{
    __block UIImageView *blockImageV = imageView;
    __block id<LMHCellViewDelegate> dtDelegate = self.detailDelegate;
    [imageView sd_setImageWithURL:imageUrl
               placeholderImage:defaultImage
                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                          if (image) {
                              NSMutableDictionary *higDict = [[NSMutableDictionary alloc] init];
                              CGFloat hight = image.size.height*ScreenW/image.size.width;
                              [blockImageV setFrame:CGRectMake(5, 0, ScreenW - 10, hight)];
                              [higDict setObject:[NSNumber numberWithFloat:hight] forKey:@"hight"];
                              [higDict setObject:imageURL.absoluteString forKey:@"url"];
                              [dtDelegate chaneCellHegith:higDict];
                          }
                        }];
    
//    [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:imageUrl] placeholderImage:defaultImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//        if (image) {
//            NSMutableDictionary *higDict = [[NSMutableDictionary alloc] init];
//            CGFloat hight = image.size.height*320/image.size.width;
//            [blockImageV setFrame:CGRectMake(10, 0, 300, hight)];
//            [higDict setObject:[NSNumber numberWithFloat:hight] forKey:@"hight"];
//            [higDict setObject:imageUrl.absoluteString forKey:@"url"];
//            [dtDelegate chaneCellHegith:higDict];
//        }
//        blockImageV.image = image;
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//        ;
//    }];
}

@end

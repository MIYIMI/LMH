//
//  KTProductView.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-3.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LikeProductVO;
@class ProductVO;

@interface KTProductView : UIView

@property (strong, nonatomic) LikeProductVO *LikeData;
@property (strong, nonatomic) ProductVO *ProductData;

@end

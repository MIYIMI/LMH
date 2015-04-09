//
//  KTPropButton.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-10.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ColorInfoVO;
@class SizeInfoVO;

typedef enum {
    KTPropButtonNoStock     =   0,
	KTPropButtonNormal      =   1,
	KTPropButtonSelected    =   2,
} KTPropButtonState;

@interface KTPropButton : UIButton

@property (strong, nonatomic) ColorInfoVO *colorData;
@property (strong, nonatomic) SizeInfoVO *sizeData;

@property (nonatomic) KTPropButtonState buttonState;

- (id)initWithFrame:(CGRect)frame
            andName:(NSString *)name
          withStock:(NSInteger)stock;

@end

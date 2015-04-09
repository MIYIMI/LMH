//
//  KTCounterTextField.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-12.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KTCounterTextFieldDelegate;

@interface KTCounterTextField : UIView <UITextFieldDelegate>

@property (assign, nonatomic) id<KTCounterTextFieldDelegate> counterTFDelegate;
@property (strong, nonatomic) NSNumber *counter;

- (id)init;

@end

@protocol KTCounterTextFieldDelegate <NSObject>

- (void)cntTFBeginEditting:(UITextField *)tf;
- (void)cntChanged:(NSInteger)count;

@end

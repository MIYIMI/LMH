//
//  NIDropDown.h
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIDropDown;
@protocol NIDropDownDelegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender;
@end 

@interface NIDropDown : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) id <NIDropDownDelegate> delegate;
@property (nonatomic, retain) NSString *emailStr;
@property (nonatomic, retain) NSMutableArray *emailArray;
@property(nonatomic, strong) UITableView *table;

@end

//
//  TrackInfoCell.h
//  YingMeiHui
//
//  Created by Zhumingming on 14-11-6.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackInfoModel.h"
@interface TrackInfoCell : UITableViewCell{
    UIImageView *imgview;
}

@property(nonatomic,strong)UILabel *trackAddressInfoLabel;
@property(nonatomic,strong)UILabel *trackTimeInfoLabel;
@property(nonatomic,strong)UIView  *lineView;


- (void)configContent:(TrackInfoModel *)model andRow:(NSInteger)row andCount:(NSInteger)cout;



@end

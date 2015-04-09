//
//  KTAddressListTableViewCell.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-11.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTAddressListTableViewCell.h"
#import "AddressVO.h"

#define BACKGROUND_COLOR            [UIColor clearColor]

@interface KTAddressListTableViewCell ()
{
    UIImageView *_addressBgView;
    UILabel *_addressInfoLbl;
    UIImageView *_dotline;
    UIButton *_defaultBtn;
    UIButton *_editBtn;
    UIButton *_deleteBtn;
    
    AddressVO *_AddressData;
}

@end

@implementation KTAddressListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:BACKGROUND_COLOR];
        [[self contentView] setBackgroundColor:BACKGROUND_COLOR];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)editBtnPressed
{
    if (self.addressCellDelegate && [self.addressCellDelegate respondsToSelector:@selector(addressEditAddress:)]) {
        [self.addressCellDelegate addressEditAddress:_AddressData];
    }
}

- (void)deleteBtnPressed
{
    if (self.addressCellDelegate && [self.addressCellDelegate respondsToSelector:@selector(addressDeleteAddress:)]) {
        [self.addressCellDelegate addressDeleteAddress:_AddressData];
    }
}

- (void)defaultBtnPressed
{
    if (self.addressCellDelegate && [self.addressCellDelegate respondsToSelector:@selector(setDefaultAddress:)]) {
        [self.addressCellDelegate setDefaultAddress:_AddressData];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark init view
////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setAddressData:(AddressVO *)AddressData andID:(NSInteger)addrID
{
    _AddressData = AddressData;
    
    if (_AddressData) {
        if (!_addressBgView) {
            _addressBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addresscellbg"]];
            
            [self.contentView addSubview:_addressBgView];
        }
        if ([_AddressData.AddressID integerValue] == addrID) {
            _addressBgView.layer.borderWidth = 0.5;
            _addressBgView.layer.borderColor = [[UIColor colorWithRed:0.98 green:0.3 blue:0.41 alpha:1] CGColor];
        }else{
            _addressBgView.layer.borderWidth = 0;
            _addressBgView.layer.borderColor = [[UIColor colorWithRed:0.98 green:0.3 blue:0.41 alpha:1] CGColor];
        }
        
        if (!_addressInfoLbl) {
            _addressInfoLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            _addressInfoLbl.backgroundColor = [UIColor clearColor];
            _addressInfoLbl.font = [UIFont systemFontOfSize:14.0];
            _addressInfoLbl.textColor = [UIColor colorWithRed:0.14 green:0.14 blue:0.14 alpha:1];
            _addressInfoLbl.textAlignment = NSTextAlignmentLeft;
            _addressInfoLbl.lineBreakMode = NSLineBreakByCharWrapping;
            _addressInfoLbl.numberOfLines = 0;
            [_addressBgView addSubview:_addressInfoLbl];
        }
        
        NSString *addressStr = @"";
        if (_AddressData.Name) {
            addressStr = [addressStr stringByAppendingFormat:@"%@\t", _AddressData.Name];
        }
        
        if (_AddressData.Mobile) {
            addressStr = [addressStr stringByAppendingFormat:@"%@", _AddressData.Mobile];
        }
        addressStr = [addressStr stringByAppendingString:@"\r\n"];
        
        if (_AddressData.Province) {
            addressStr = [addressStr stringByAppendingFormat:@"%@  ", _AddressData.Province];
        }
        
        if (_AddressData.City) {
            addressStr = [addressStr stringByAppendingFormat:@"%@  ", _AddressData.City];
        }
        
        if (_AddressData.Region) {
            addressStr = [addressStr stringByAppendingFormat:@"%@", _AddressData.Region];
        }
        addressStr = [addressStr stringByAppendingString:@"\r\n"];
        
        if (_AddressData.Detail) {
            addressStr = [addressStr stringByAppendingFormat:@"%@", _AddressData.Detail];
        }
        addressStr = [addressStr stringByAppendingString:@"\r\n"];
        
        [_addressInfoLbl setText:addressStr];
        
        if (!_dotline) {
            _dotline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logindotline"]];
            [_dotline setFrame:CGRectZero];
            [_addressBgView addSubview:_dotline];
        }
        
        if (!_defaultBtn) {
            _defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_defaultBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
            [_defaultBtn addTarget:self action:@selector(defaultBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_defaultBtn];
        }
        
        if ([_AddressData.IsDefault boolValue]) {
            NSString *defaultTitle = @"默认地址";
            CGSize defaultSize = [defaultTitle sizeWithFont:[UIFont systemFontOfSize:13.0]];
            [_defaultBtn setFrame:CGRectMake(0, 0, defaultSize.width, 25)];
            [_defaultBtn setTitle:defaultTitle forState:UIControlStateNormal];
            [_defaultBtn setTitleColor:[UIColor colorWithRed:0.96 green:0.31 blue:0.41 alpha:1] forState:UIControlStateNormal];
            [_defaultBtn setEnabled:NO];
        } else {
            NSString *defaultTitle = @"设为默认地址";
            CGSize defaultSize = [defaultTitle sizeWithFont:[UIFont systemFontOfSize:13.0]];
            [_defaultBtn setFrame:CGRectMake(0, 0, defaultSize.width, 25)];
            [_defaultBtn setTitle:defaultTitle forState:UIControlStateNormal];
            [_defaultBtn setTitleColor:[UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1] forState:UIControlStateNormal];
            [_defaultBtn setEnabled:YES];
        }
        
        if (!_editBtn) {
            _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_editBtn setFrame:CGRectMake(0, 0, 55, 25)];
            [_editBtn setImage:[UIImage imageNamed:@"addressedit"] forState:UIControlStateNormal];
            [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
            [_editBtn setTitleColor:[UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1] forState:UIControlStateNormal];
            [_editBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
            [_editBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            [_editBtn addTarget:self action:@selector(editBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_editBtn];
        }
        
        if (!_deleteBtn) {
            _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_deleteBtn setFrame:CGRectMake(0, 0, 55, 25)];
            [_deleteBtn setImage:[UIImage imageNamed:@"addressdelete"] forState:UIControlStateNormal];
            [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            [_deleteBtn setTitleColor:[UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1] forState:UIControlStateNormal];
            [_deleteBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
            [_deleteBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            [_deleteBtn addTarget:self action:@selector(deleteBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_deleteBtn];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize infosize = [_addressInfoLbl.text sizeWithFont:_addressInfoLbl.font constrainedToSize:CGSizeMake(ScreenW - 70, 100000) lineBreakMode:_addressInfoLbl.lineBreakMode];
    [_addressInfoLbl setFrame:CGRectMake(10, 17, ScreenW - 70, infosize.height)];
    [_dotline setFrame:CGRectMake(0, CGRectGetMaxY(_addressInfoLbl.frame) + 7, ScreenW - 20, 1)];
    [_addressBgView setFrame:CGRectMake(9, 5, ScreenW - 17, CGRectGetMaxY(_addressInfoLbl.frame) + 42)];
    
    [_defaultBtn setFrame:CGRectMake(20, CGRectGetMaxY(_dotline.frame) + 9, CGRectGetWidth(_defaultBtn.frame), CGRectGetHeight(_defaultBtn.frame))];
    [_editBtn setFrame:CGRectMake(ScreenW - 135, CGRectGetMaxY(_dotline.frame) + 9, CGRectGetWidth(_editBtn.frame), CGRectGetHeight(_editBtn.frame))];
    [_deleteBtn setFrame:CGRectMake(CGRectGetMaxX(_editBtn.frame) + 5, CGRectGetMaxY(_dotline.frame) + 9, CGRectGetWidth(_deleteBtn.frame), CGRectGetHeight(_deleteBtn.frame))];
}

@end

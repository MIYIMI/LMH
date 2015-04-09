//
//  KTOrderSubmitAddressTableViewCell.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-12.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTOrderSubmitAddressTableViewCell.h"
#import "AddressVO.h"

#define BACKGROUND_COLOR            [UIColor clearColor]

@interface KTOrderSubmitAddressTableViewCell ()
{
    UIView *_addressBgView;
    UILabel *_addressInfoLbl;
    UIButton *_editBtn;
    UIImageView *_arrowIcon;
}

@end

@implementation KTOrderSubmitAddressTableViewCell

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

////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark init view
////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setCellState:(KTOrderSubmitAddressState)cellState
{
    _cellState = cellState;
    
    switch (_cellState) {
        case KTOrderSubmitAddressNormal:
        {
            [_addressBgView.layer setBorderWidth:0.5];
            [_addressBgView.layer setBorderColor:[UIColor colorWithRed:0.87 green:0.83 blue:0.84 alpha:1].CGColor];
            [_arrowIcon setHidden:YES];
        }
            break;
            
        case KTOrderSubmitAddressDown:
        {
            [_addressBgView.layer setBorderWidth:0.5];
            [_addressBgView.layer setBorderColor:[UIColor colorWithRed:0.87 green:0.83 blue:0.84 alpha:1].CGColor];
            [_arrowIcon setImage:[UIImage imageNamed:@"downarrow"]];
            [_arrowIcon setHidden:NO];
        }
            break;
            
        case KTOrderSubmitAddressUp:
        {
            [_addressBgView.layer setBorderWidth:1.0];
            [_addressBgView.layer setBorderColor:[UIColor colorWithRed:0.96 green:0.31 blue:0.41 alpha:1].CGColor];
            [_arrowIcon setImage:[UIImage imageNamed:@"uparrow"]];
            [_arrowIcon setHidden:NO];
        }
            break;
            
        default:
            break;
    }
}

- (void)setAddressData:(AddressVO *)AddressData
{
    _AddressData = AddressData;
    
    if (_AddressData) {
        if (!_addressBgView) {
            _addressBgView = [[UIView alloc] initWithFrame:CGRectZero];
            [_addressBgView setBackgroundColor:[UIColor whiteColor]];
            [_addressBgView.layer setBorderWidth:0.5];
            [_addressBgView.layer setBorderColor:[UIColor colorWithRed:0.87 green:0.83 blue:0.84 alpha:1].CGColor];
            
            [self.contentView addSubview:_addressBgView];
        }
        
        if (!_addressInfoLbl) {
            _addressInfoLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            _addressInfoLbl.backgroundColor = [UIColor clearColor];
            _addressInfoLbl.font = [UIFont systemFontOfSize:12.0];
            _addressInfoLbl.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
            _addressInfoLbl.textAlignment = NSTextAlignmentLeft;
            _addressInfoLbl.lineBreakMode = NSLineBreakByCharWrapping;
            _addressInfoLbl.numberOfLines = 0;
            
            [_addressBgView addSubview:_addressInfoLbl];
        }
        
        NSString *addressStr = @"";
        if (_AddressData.Name) {
            addressStr = [addressStr stringByAppendingFormat:@"姓名：%@", _AddressData.Name];
        }
        addressStr = [addressStr stringByAppendingString:@"\r\n\r\n"];
        
        if (_AddressData.Province) {
            addressStr = [addressStr stringByAppendingFormat:@"%@ ", _AddressData.Province];
        }
        
        if (_AddressData.City) {
            addressStr = [addressStr stringByAppendingFormat:@"%@ ", _AddressData.City];
        }
        
        if (_AddressData.Region) {
            addressStr = [addressStr stringByAppendingFormat:@"%@ ", _AddressData.Region];
        }
        
        if (_AddressData.Detail) {
            addressStr = [addressStr stringByAppendingFormat:@"%@", _AddressData.Detail];
        }
        addressStr = [addressStr stringByAppendingString:@"\r\n\r\n"];
        
        if (_AddressData.Mobile) {
            addressStr = [addressStr stringByAppendingFormat:@"联系方式：%@", _AddressData.Mobile];
        }
        
        [_addressInfoLbl setText:addressStr];
        
        if (!_editBtn) {
            _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_editBtn setFrame:CGRectMake(0, 0, 40, 40)];
            [_editBtn setImage:[UIImage imageNamed:@"addedit_normal"] forState:UIControlStateNormal];
            [_editBtn setImage:[UIImage imageNamed:@"addedit_select"] forState:UIControlStateHighlighted];
            [_editBtn setImage:[UIImage imageNamed:@"addedit_select"] forState:UIControlStateSelected];
            [_editBtn addTarget:self action:@selector(editBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_editBtn];
        }
        
        if (!_arrowIcon) {
            _arrowIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"downarrow"]];
            [_arrowIcon setFrame:CGRectMake(284, 8, 11, 6)];
            [_arrowIcon setHidden:YES];
            
            [_addressBgView addSubview:_arrowIcon];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    
    CGSize infosize = [_addressInfoLbl.text sizeWithFont:_addressInfoLbl.font constrainedToSize:CGSizeMake(245, 100000) lineBreakMode:_addressInfoLbl.lineBreakMode];
    [_addressInfoLbl setFrame:CGRectMake(7, 7, 245, infosize.height)];
    
    switch (_cellState) {
        case KTOrderSubmitAddressNormal:
        {
            [_addressBgView setFrame:CGRectMake(10, -1, w - 20, infosize.height + 15)];
        }
            break;
            
        case KTOrderSubmitAddressDown:
        {
            [_addressBgView setFrame:CGRectMake(10, -1, w - 20, infosize.height + 15)];
        }
            break;
            
        case KTOrderSubmitAddressUp:
        {
            [_addressBgView setFrame:CGRectMake(10, 0, w - 20, infosize.height + 14)];
        }
            break;
            
        default:
            break;
    }
    
    [_editBtn setFrame:CGRectMake(w - CGRectGetWidth(_editBtn.frame) - 12, CGRectGetMaxY(_addressBgView.frame) - CGRectGetHeight(_editBtn.frame), CGRectGetWidth(_editBtn.frame), CGRectGetHeight(_editBtn.frame))];
}

@end

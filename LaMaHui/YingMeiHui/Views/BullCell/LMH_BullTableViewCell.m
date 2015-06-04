//
//  LMH_BullTableViewCell.m
//  YingMeiHui
//
//  Created by work on 15/5/26.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "LMH_BullTableViewCell.h"
#import <UIButton+WebCache.h>

#define SPACE_HEIGHT    10.0f

@interface LMH_BullTableViewCell()<UIWebViewDelegate>
{
    UIButton *imageBtn;
    UILabel *eventLabel;
    UIButton *perSonBtn;
    UIButton *wxBtn;
    UIImageView *eventImgView;
    UIWebView *decribleWeb;
    UIPasteboard *pasteboard;
    
    CampaignVO *_camVO;
    NSString *htmlContent;
}
@end

@implementation LMH_BullTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)layOutUI:(BOOL)is_show andVO:(id)cavo{
    if ([cavo isKindOfClass:[CampaignVO class]]) {
        _camVO = cavo;
        
        if (!imageBtn) {
            imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(SPACE_HEIGHT, SPACE_HEIGHT, ScreenW/8, ScreenW/8)];
            imageBtn.layer.cornerRadius = ScreenW/16;
            imageBtn.clipsToBounds = YES;
            [imageBtn addTarget:self action:@selector(userClick) forControlEvents:UIControlEventTouchUpInside];
            
            [self.contentView addSubview:imageBtn];
        }
        if (_camVO.buyer_img) {
            [imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_camVO.buyer_img] forState:UIControlStateNormal];
        }
        
        CGFloat labelH = (ScreenW/8-SPACE_HEIGHT)/2;
        if (!eventLabel) {
            eventLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageBtn.frame)+SPACE_HEIGHT/2, SPACE_HEIGHT, ScreenW-CGRectGetMaxX(imageBtn.frame)-2.5*SPACE_HEIGHT - ScreenW/4, labelH)];
            eventLabel.textColor = LMH_COLOR_BLACK;
            eventLabel.font = LMH_FONT_15;
            eventLabel.lineBreakMode = NSLineBreakByCharWrapping;
            
            [self.contentView addSubview:eventLabel];
        }
        eventLabel.text = _camVO.title;
        
        if (!perSonBtn) {
            perSonBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageBtn.frame)+SPACE_HEIGHT/2, CGRectGetMaxY(eventLabel.frame)+SPACE_HEIGHT, (CGRectGetWidth(eventLabel.frame)-SPACE_HEIGHT)/2, labelH)];
            [perSonBtn setTitleColor:LMH_COLOR_LIGHTGRAY forState:UIControlStateNormal];
            [perSonBtn.titleLabel setFont:LMH_FONT_12];
            perSonBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [perSonBtn addTarget:self action:@selector(userClick) forControlEvents:UIControlEventTouchUpInside];
            
            [self.contentView addSubview:perSonBtn];
        }
        [perSonBtn setTitle:_camVO.buyer forState:UIControlStateNormal];
        
        if (!wxBtn) {
            wxBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(perSonBtn.frame)+SPACE_HEIGHT, CGRectGetMaxY(eventLabel.frame)+SPACE_HEIGHT, (CGRectGetWidth(eventLabel.frame)-SPACE_HEIGHT)/2, labelH)];
            [wxBtn setTitleColor:LMH_COLOR_LIGHTbLUE forState:UIControlStateNormal];
            [wxBtn.titleLabel setFont:LMH_FONT_12];
            [wxBtn addTarget:self action:@selector(wxClick) forControlEvents:UIControlEventTouchUpInside];
            
            [self.contentView addSubview:wxBtn];
        }
        [wxBtn setTitle:_camVO.weixin_text forState:UIControlStateNormal];
        
        if (!eventImgView) {
            eventImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW-ScreenW/4-SPACE_HEIGHT, SPACE_HEIGHT, ScreenW/4, ScreenW/8)];
            
            [self.contentView addSubview:eventImgView];
        }
        if (_camVO.brand_logo) {
            [eventImgView sd_setImageWithURL:[NSURL URLWithString:_camVO.brand_logo]];
        }
    }else if ([cavo isKindOfClass:[NSString class]]){
        htmlContent = cavo;
    }
    
    if (!decribleWeb) {
        decribleWeb = [[UIWebView alloc] initWithFrame:CGRectNull];
        decribleWeb.delegate = self;
        decribleWeb.backgroundColor = [UIColor whiteColor];
        decribleWeb.scrollView.scrollEnabled = NO;
        
        [self.contentView addSubview:decribleWeb];
    }
    
    NSString *html = _camVO.topic_ios?_camVO.topic_ios:htmlContent;
    html = [html stringByReplacingOccurrencesOfString:@"font" withString:@""];
    
    NSString *content =[NSString stringWithFormat:@"<html> \n"
                    "<head> \n"
                    "<style type=\"text/css\"> \n"
                    "a{text-decoration: none;}\n"
                    "body{ font-size:15px;}\n"
                    "</style> \n"
                    "</head> \n"
                    "<body>%@</body> \n"
                    "</html>",html];
    
    NSString *textContent = [LMH_HtmlParase filterHTML:html];
    CGSize usize = [content sizeWithFont:LMH_FONT_15 constrainedToSize:CGSizeMake(10000000, 0)];
    CGSize csize = [textContent sizeWithFont:LMH_FONT_15 constrainedToSize:CGSizeMake(ScreenW - 10, 10000)];
    NSInteger h = csize.height+ ((csize.height/usize.height)+1)*(usize.height/4);
    
    decribleWeb.frame = CGRectMake(5, CGRectGetMaxY(eventImgView.frame)+1.2*SPACE_HEIGHT, ScreenW-SPACE_HEIGHT, h);
    [decribleWeb loadHTMLString:content baseURL:nil];
    
    if (!is_show) {
        imageBtn.hidden = YES;
        eventLabel.hidden = YES;
        perSonBtn.hidden = YES;
        wxBtn.hidden = YES;
        eventImgView.hidden = YES;
        decribleWeb.frame = CGRectMake(5, 10, ScreenW-SPACE_HEIGHT, h);;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // 禁用用户选择
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // 禁用长按弹出框
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[[request URL]  absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([requestString hasPrefix:@"http://"]) {
        NSLog(@"%@",requestString);
        NSRange range1 = [requestString rangeOfString:@"/" options:NSBackwardsSearch];
        NSRange range2 = [requestString rangeOfString:@".html" options:NSBackwardsSearch];
        NSString *proudctID = @"";
        if (range1.length > 0 && range2.length > 0) {
            proudctID = [requestString substringWithRange:NSMakeRange(range1.location+1, range2.location-range1.location-1)];
            NSLog(@"%@",proudctID);
            
            if ([self.bullDelegate respondsToSelector:@selector(pushProduct:)]) {
                [self.bullDelegate pushProduct:[proudctID integerValue]];
            }
        }
        return NO;
    }
    
    return YES;
}

- (void)userClick{
    if ([self.bullDelegate respondsToSelector:@selector(pushUser:)]) {
        [self.bullDelegate pushUser:_camVO.buyer_url];
    }
}

- (void)wxClick{
    if (!pasteboard) {
        pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = _camVO.weixin;
    }
    if ([self.bullDelegate respondsToSelector:@selector(pushWX)] && _camVO.weixin) {
        [self.bullDelegate pushWX];
    }
}

@end

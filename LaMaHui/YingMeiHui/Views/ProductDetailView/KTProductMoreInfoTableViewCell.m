//
//  KTProductMoreInfoTableViewCell.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-24.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTProductMoreInfoTableViewCell.h"

#define BACKGROUND_COLOR            [UIColor clearColor]

@implementation KTProductMoreInfoTableViewCell
{
    UIWebView *_contentWebView;
    CGFloat _contentHeight;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:BACKGROUND_COLOR];
        [self.contentView setBackgroundColor:BACKGROUND_COLOR];
        _contentHeight = 1;
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark init view
////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setContent:(NSString *)content
{
    //_content = content;
    
    if (content) {
        
        if (!_contentWebView) {
            _contentWebView = [[UIWebView alloc] init];
            _contentWebView.backgroundColor = [UIColor clearColor];
            _contentWebView.opaque = NO;
            _contentWebView.scrollView.bounces = NO;
            _contentWebView.delegate = self;
            _contentWebView.ScalesPageToFit = YES;//yes 根据webview自适应 no 根据内容自适应
            [_contentWebView setUserInteractionEnabled:NO];//用户不可操作
            [_contentWebView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
            
            [self.contentView addSubview:_contentWebView];
        }
        
        for (id subview in _contentWebView.subviews)
        {
            if ([[subview class] isSubclassOfClass: [UIScrollView class]])
            {
                ((UIScrollView *)subview).bounces = NO;
            }
        }
        
        _content = content;
        NSString *newContent = [self substrHtmlImage:content];
        NSString *headStr = @"<!DOCTYPE html><html><head> <meta content=\"text/html; charset=utf-8\" http-equiv=\"Content-Type\" /> <meta charset=\"utf-8\" /> <meta content=\"width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=2.0, user-scalable=no\" name=\"viewport\" /><meta content=\"yes\" name=\"apple-mobile-web-app-capable\" /> <meta content=\"black\" name=\"apple-mobile-web-app-status-bar-style\" /> <meta content=\"telephone=no\" name=\"format-detection\" />";
        
        NSString *styleStr = @"<style>#wrap{padding:10px}#titleWrap{padding:10px;background:#fccadc;border:1px solid #fd75a6;}#titleCon{font-size:16px;line-height:1.0;font-weight:bold;text-align:center}p{font-size:9px;line-height:1.5;text-indent:2em;margin:0;}#contentWrap{padding:5px 0;}img{display:block;margin:0;width:100%}</style></head><body><div id='wrap'>";
        
        NSString *footStr = @"</div></body></html>";
        
        NSMutableString *fullPageSource = [[NSMutableString alloc] init];
        [fullPageSource appendString:headStr];
        [fullPageSource appendString:styleStr];
        [fullPageSource appendString:newContent];
        [fullPageSource appendString:footStr];
        
       NSThread *currentThread =  [[NSThread  alloc] initWithTarget:self selector:@selector(loadHTMLString:) object:fullPageSource];
        [currentThread start];
//        [_contentWebView loadHTMLString:fullPageSource baseURL:nil];
    }
}

-(void)loadHTMLString:(NSString *)htmlStr{
    if (htmlStr && _contentWebView) {
    [_contentWebView loadHTMLString:htmlStr baseURL:nil];
    }

}

//截取html里的<img *****>
- (NSString *)substrHtmlImage:(NSString *)html
{
    NSScanner *oldScanner;
    NSScanner *newScanner;
    NSString *oldText = nil;
    NSString *newText = nil;
    NSRange pos;
    
    oldScanner = [NSScanner scannerWithString:html];
    while ([oldScanner isAtEnd] == NO)
    {
        [oldScanner scanUpToString:@"<img" intoString:nil];
        [oldScanner scanUpToString:@">" intoString:&oldText];
        
        newScanner = [NSScanner scannerWithString:oldText];
        [newScanner scanUpToString:@"src=\"" intoString:nil];
        NSInteger loction = newScanner.scanLocation + 5;
        if (loction > html.length) {
            break;
        }
        newScanner.scanLocation = loction;
        [newScanner scanUpToString:@"\"" intoString:&newText];
        pos = [newText rangeOfString:@".gif"];
        if (pos.length > 0)
        {
            continue;
        }
         html = [html stringByReplacingOccurrencesOfString:oldText withString:[NSString stringWithFormat:@"<img src=\"%@\"/",newText]];
    }
    return html;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_contentWebView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), _contentHeight)];
}

#pragma mark - UIWebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    NSInteger height = [height_str intValue];
    CGRect newFrame = webView.frame;
    newFrame.size.height = height;
    webView.frame = newFrame;
    
    _contentHeight = CGRectGetMaxY(webView.frame);
    if (self.infoCellDelegate && [self.infoCellDelegate respondsToSelector:@selector(heightForCell:)])
    {
        [self.infoCellDelegate heightForCell:_contentHeight];
    }

}

@end

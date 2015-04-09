#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridgeAbstract.h"
#import "MBProgressHUD.h"

@interface WebViewJavascriptBridge : WebViewJavascriptBridgeAbstract <UIWebViewDelegate,MBProgressHUDDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) MBProgressHUD *stateHud;
@property (nonatomic, strong) id <UIWebViewDelegate> webViewDelegate;

+ (id)bridgeForWebView:(UIWebView*)webView handler:(WVJBHandler)handler;
+ (id)bridgeForWebView:(UIWebView*)webView webViewDelegate:(id <UIWebViewDelegate>)webViewDelegate handler:(WVJBHandler)handler;

@end

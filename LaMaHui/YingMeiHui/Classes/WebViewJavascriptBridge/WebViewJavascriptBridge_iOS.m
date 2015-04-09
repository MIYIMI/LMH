#import "WebViewJavascriptBridge_iOS.h"
#import "kata_UserManager.h"
#import "KTProxy.h"
#import "LMHWebRequest.h"

@implementation WebViewJavascriptBridge
{
    BOOL ossss;
    NSString *RequstUrl;
}
#pragma mark UIWebViewDelegate

+ (id)bridgeForWebView:(UIWebView *)webView handler:(WVJBHandler)handler {
    return [self bridgeForWebView:webView webViewDelegate:nil handler:handler];
}

+ (id)bridgeForWebView:(UIWebView *)webView webViewDelegate:(id<UIWebViewDelegate>)webViewDelegate handler:(WVJBHandler)messageHandler {
    WebViewJavascriptBridge* bridge = [[WebViewJavascriptBridge alloc] init];
    bridge.messageHandler = messageHandler;
    bridge.webView = webView;
    bridge.webViewDelegate = webViewDelegate;
    bridge.messageHandlers = [NSMutableDictionary dictionary];
    [bridge reset];
    
    [webView setDelegate:bridge];
    
    return bridge;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView != self.webView) { return; }
    NSString *web_title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSString *web_url = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
//    NSLog(@">>>>>>>>>%@", web_url);
    if ([web_url rangeOfString:@"detail.m"].location == NSNotFound) {
    } else {
        if (ossss == NO) {
            RequstUrl = web_url;
            [self commiteInfoOperation];
            }
        ossss = YES;
    }
    if ([web_url rangeOfString:@"h5.m"].location == NSNotFound) {
    } else {
        if (ossss == NO) {
            RequstUrl = web_url;
            [self commiteInfoOperation];
        }
        ossss = YES;
    }

    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:web_title, @"web_title", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WEB_HTML" object:nil userInfo:dict];
    
    if (![[self.webView stringByEvaluatingJavaScriptFromString:@"typeof WebViewJavascriptBridge == 'object'"] isEqualToString:@"true"]) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"WebViewJavascriptBridge.js" ofType:@"txt"];
        NSString *js = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        [self.webView stringByEvaluatingJavaScriptFromString:js];
    }
    
    if (self.startupMessageQueue) {
        for (id queuedMessage in self.startupMessageQueue) {
            [self _dispatchMessage:queuedMessage];
        }
        self.startupMessageQueue = nil;
    }
    
    if (self.webViewDelegate && [self.webViewDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.webViewDelegate webViewDidFinishLoad:webView];
    }
    
}

#pragma mark - 网络请求 传 URL
- (void)commiteInfoOperation
{
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    NSString *userid = nil;
    NSString *usertoken = nil;
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    if (userid && usertoken) {
        req = [[LMHWebRequest alloc] initWithUserID:[userid integerValue] andUserToken:usertoken andUrl:RequstUrl andAname:nil];
    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
    } failed:^(NSError *error) {

    }];
    
    [proxy start];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (webView != self.webView) { return; }
    if (self.webViewDelegate && [self.webViewDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.webViewDelegate webView:self.webView didFailLoadWithError:error];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (webView != self.webView) { return YES; }
    
    NSURL *url = [request URL];
    if ([[url scheme] isEqualToString:kCustomProtocolScheme]) {
        if ([[url host] isEqualToString:kQueueHasMessage]) {
            [self _flushMessageQueue];
        } else {
            NSLog(@"WebViewJavascriptBridge: WARNING: Received unknown WebViewJavascriptBridge command %@://%@", kCustomProtocolScheme, [url path]);
        }
        return NO;
    } else if (self.webViewDelegate && [self.webViewDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [self.webViewDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    } else {
        return YES;
    }
    ossss = NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (webView != self.webView) { return; }
    if (self.webViewDelegate && [self.webViewDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.webViewDelegate webViewDidStartLoad:webView];
    }
}

@end

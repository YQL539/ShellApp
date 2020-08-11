//
//  WeakWebViewScriptMessageDelegate.h
//  RuiZhiH5
//
//  Created by 陈志伟 on 2020/1/7.
//  Copyright © 2020年 殇璃. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
// WKWebView 内存不释放的问题解决
@interface WeakWebViewScriptMessageDelegate : NSObject<WKScriptMessageHandler>
//WKScriptMessageHandler 这个协议类专门用来处理JavaScript调用原生OC的方法
@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;
@end

@interface XDCookieDefault : NSObject
//解决第一次进入的cookie丢失问题
+ (NSString *)readCurrentCookieWithDomain:(NSString *)domainStr;
//解决 页面内跳转（a标签等）还是取不到cookie的问题
+ (void)getCookieWithWebView:(WKWebView *)webView;
//每次请求的时候自动带上 cookie
+ (void)setTheCookieOfWebview:(WKWebView *)webView;
@end

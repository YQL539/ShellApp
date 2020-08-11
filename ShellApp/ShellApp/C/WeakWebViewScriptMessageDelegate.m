//
//  WeakWebViewScriptMessageDelegate.m
//  RuiZhiH5
//
//  Created by 陈志伟 on 2020/1/7.
//  Copyright © 2020年 殇璃. All rights reserved.
//

#import "WeakWebViewScriptMessageDelegate.h"
@implementation WeakWebViewScriptMessageDelegate
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

#pragma mark - WKScriptMessageHandler
//遵循WKScriptMessageHandler协议，必须实现如下方法，然后把方法向外传递
//通过接收JS传出消息的name进行捕捉的回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([self.scriptDelegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}
@end

@implementation XDCookieDefault
//解决第一次进入的cookie丢失问题
+ (NSString *)readCurrentCookieWithDomain:(NSString *)domainStr {
    NSHTTPCookieStorage*cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSMutableString * cookieString = [[NSMutableString alloc]init];
    for (NSHTTPCookie*cookie in [cookieJar cookies]) {
        [cookieString appendFormat:@"%@=%@;",cookie.name,cookie.value];
    }
    //删除最后一个“;”
    if ([cookieString hasSuffix:@";"]) {
        [cookieString deleteCharactersInRange:NSMakeRange(cookieString.length - 1, 1)];
    }
    return cookieString;
}

//解决 页面内跳转（a标签等）还是取不到cookie的问题
+ (void)getCookieWithWebView:(WKWebView *)webView {
    //取出cookie
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //js函数
    NSString *JSFuncString =
    @"function setCookie(name,value,expires)\
    {\
    var oDate=new Date();\
    oDate.setDate(oDate.getDate()+expires);\
    document.cookie=name+'='+value+';expires='+oDate+';path=/'\
    }\
    function getCookie(name)\
    {\
    var arr = document.cookie.match(new RegExp('(^| )'+name+'=([^;]*)(;|$)'));\
    if(arr != null) return unescape(arr[2]); return null;\
    }\
    function delCookie(name)\
    {\
    var exp = new Date();\
    exp.setTime(exp.getTime() - 1);\
    var cval=getCookie(name);\
    if(cval!=null) document.cookie= name + '='+cval+';expires='+exp.toGMTString();\
    }";
    //拼凑js字符串
    NSMutableString *JSCookieString = JSFuncString.mutableCopy;
    for (NSHTTPCookie *cookie in cookieStorage.cookies) {
        NSString *excuteJSString = [NSString stringWithFormat:@"setCookie('%@', '%@', 1);", cookie.name, cookie.value];
        [JSCookieString appendString:excuteJSString];
    }
    //执行js
    [webView evaluateJavaScript:JSCookieString completionHandler:nil];
}

//每次请求的时候自动带上 cookie
+ (void)setTheCookieOfWebview:(WKWebView *)webView {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //先删除Userid的cookie（你自己那边表示登录状态的name）
    [webView evaluateJavaScript:@"document.cookie='Userid =;expires=Thu, 01 Jan 1970 00:00:00 GMT; Domain=.baidu.com; path=/'" completionHandler:nil];
    for (NSHTTPCookie *cookie in [cookieStorage cookies]) {
        NSString *nameStr = [NSString stringWithFormat:@"document.cookie='%@=%@;expires=Wed, 25 Sep 2075 17:05:15 GMT;domain=%@;path=%@;verson=%lu;'",cookie.name,cookie.value, cookie.domain, cookie.path, (unsigned long) cookie.version];
        [webView evaluateJavaScript:nameStr completionHandler:nil];
    }
}
@end

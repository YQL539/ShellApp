//
//  PolicyViewController.m
//  WaiHuiProduct
//
//  Created by qinglong yang on 2020/7/9.
//  Copyright © 2020 com. All rights reserved.
//

#import "PolicyViewController.h"
#import <WebKit/WebKit.h>
#import "WeakWebViewScriptMessageDelegate.h"

@interface PolicyViewController ()<WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate>
@property(nonatomic , strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *myProgressView;
@end

@implementation PolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    NSString *requestUrlString = [NSString stringWithFormat:@"%@/iwa-admin/app/login/home.htm?uac=%@&upd=%@",SERVER_HTTP,self.userName,self.userPsw];
    NSURL *url = [NSURL URLWithString:requestUrlString];
    NSLog(@"当前网络:%@",url);
    [self.view addSubview:self.webView];
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];

}
- (WKWebView *)webView{
    if(_webView == nil){
        //创建网页配置对象
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.selectionGranularity = WKSelectionGranularityDynamic;
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
        preference.minimumFontSize = 0;
        //设置是否支持javaScript 默认是支持的
        preference.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preference;
        //自定义的WKScriptMessageHandler 是为了解决内存不释放的问题
        WeakWebViewScriptMessageDelegate *weakScriptMessageDelegate = [[WeakWebViewScriptMessageDelegate alloc] initWithDelegate:self];
        //这个类主要用来做native与JavaScript的交互管理
        WKUserContentController * wkUController = [[WKUserContentController alloc] init];
        //设置处理接收JS方法的对象
        [self registJavaScript:wkUController and:weakScriptMessageDelegate];
        config.userContentController = wkUController;
        //以下代码适配文本大小
        NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [config.userContentController addUserScript:wkUScript];

        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) configuration:config];
        // UI代理
        _webView.UIDelegate = self;
        // 导航代理
        _webView.navigationDelegate = self;
        _webView.scrollView.scrollEnabled = NO;
        // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
        _webView.allowsBackForwardNavigationGestures = YES;
        //可返回的页面列表, 存储已打开过的网页
        if ([_webView goBack]) {
            [_webView backForwardList];
        }
    }
    return _webView;
}
//JS调用OC方法 被自定义的WKScriptMessageHandler在回调方法里通过代理回调回来，绕了一圈就是为了解决内存不释放的问题
//通过接收JS传出消息的name进行捕捉的回调方法
//java执行代码  ：  window.webkit.messageHandlers.scanQRCode.postMessage('111');
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
       NSLog(@"didReceiveScriptMessage:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n",message.name,message.body,message.frameInfo);
    //用message.body获得JS传出的参数体
//    NSDictionary * parameter = message.body;
    //JS调用OC
    if([message.name isEqualToString:@"popToLoginVC"]){
        [self popToLoginVC];
    }
}

-(void)popToLoginVC {
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:KACCOUNT];
     [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:KPASSWORD];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)registJavaScript:(WKUserContentController  *)wkUController
                     and:(WeakWebViewScriptMessageDelegate  *)weakScriptMessageDelegate {
    [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"switchServer"];
}

#pragma mark - event response
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        self.myProgressView.alpha = 1.0f;
        [self.myProgressView setProgress:newprogress animated:YES];
        if (newprogress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                self.myProgressView.alpha = 0.0f;
            }
                             completion:^(BOOL finished) {
                [self.myProgressView setProgress:0 animated:NO];
            }];
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - getter and setter
- (UIProgressView *)myProgressView
{
    if (_myProgressView == nil) {
        _myProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width, 3)];
        _myProgressView.tintColor = [UIColor blueColor];
        _myProgressView.trackTintColor = [UIColor whiteColor];
        [self.view addSubview:_myProgressView];
        [self.view bringSubviewToFront:_myProgressView];
    }
    
    return _myProgressView;
}

- (void)dealloc
{
    NSLog(@"======deallocaboutView");
    //移除注册的js方法
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"popToLoginVC"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

-(void)showAlertWithTitle:(NSString *)Title
               Infomation:(NSString *)information
     shoeInViewController:(UIViewController *)viewController
          completedAction:(void(^_Nullable)(UIAlertAction *action))showAction {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:Title message:information preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:showAction];
    [alertController addAction:alertAction];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

@end

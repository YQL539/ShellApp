//
//  PolicyViewController.m
//  WaiHuiProduct
//
//  Created by qinglong yang on 2020/7/9.
//  Copyright © 2020 com. All rights reserved.
//

#import "PolicyViewController.h"
#import <WebKit/WebKit.h>
@interface PolicyViewController ()<WKNavigationDelegate>
@property(nonatomic , strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *myProgressView;
@end

@implementation PolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    NSURL *url = [NSURL URLWithString:@"http://yfstrug.wicp.net/iwa-admin//app/login/login.htm"];
//    if (![self.urlStr containsString:@"http"]) {
//        self.urlStr = [NSString stringWithFormat:@"http://%@",self.urlStr];
//    }
//
//    NSURL *url = [NSURL URLWithString:self.urlStr];
    self.webView =[[WKWebView alloc]init];
    self.webView.navigationDelegate =self;
    self.webView.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.webView];
    
    self.webView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREENWIDTH, SCREENHEIGHT - NAVIGATION_BAR_HEIGHT);
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"exit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(popToRoot)];
}
-(void)popToRoot {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
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
        _myProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width, 3)];
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
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
@end

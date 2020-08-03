//
//  ViewController.m
//  ShellApp
//
//  Created by qinglong yang on 2020/7/14.
//  Copyright © 2020 yql. All rights reserved.
//

#import "ViewController.h"
#import "PolicyViewController.h"
#import "MBProgressHUD.h"
#import <WebKit/WebKit.h>

@interface ViewController ()
@property (nonatomic,strong) UITextField *urlField;
@property (nonatomic,strong) UIButton  *goBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubviews];
}

-(void)setSubviews{
    NSURL *url = [NSURL URLWithString:@"http://yfstrug.wicp.net/iwa-admin//app/login/login.htm"];
    [[[WKWebView alloc]init] loadRequest:[NSURLRequest requestWithURL:url]];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 180, self.view.frame.size.width, 40)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = @"请输入网址:";
    [self.view addSubview:titleLabel];
    
    CGFloat iMarginX = 40;
    self.urlField = [[UITextField alloc]initWithFrame:CGRectMake(iMarginX, CGRectGetMaxY(titleLabel.frame) + 20, self.view.frame.size.width - iMarginX*2, 40)];
    [self.view addSubview:_urlField];
    self.urlField.text = @"http://yfstrug.wicp.net/iwa-admin//app/login/login.htm";
    self.urlField.placeholder = @"";
    self.urlField.layer.borderWidth = 1.0f;
    self.urlField.layer.borderColor = [UIColor blackColor].CGColor;
    
    
    self.goBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goBtn.frame = CGRectMake(iMarginX, CGRectGetMaxY(self.urlField.frame) + 30, CGRectGetWidth(self.urlField.frame), 40);
    self.goBtn.clipsToBounds = YES;
    self.goBtn.layer.cornerRadius = 10;
    self.goBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.goBtn.layer.borderWidth = 1.f;
    [self.view addSubview:self.goBtn];
    [self.goBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.goBtn setTitle:@"前往" forState:UIControlStateNormal];
    [self.goBtn addTarget:self action:@selector(goBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.goBtn.frame) +20, self.view.frame.size.width, 40)];
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.textColor = [UIColor blackColor];
    alertLabel.font = [UIFont systemFontOfSize:14];
    alertLabel.text = @"提示：https网址请输入前缀:https://";
    [self.view addSubview:alertLabel];
}

-(void)goBtnDidClicked:(UIButton *)button{
    NSLog(@"%@",self.urlField.text);
    if (self.urlField.text &&self.urlField.text.length > 0) {
         PolicyViewController *webView = [[PolicyViewController alloc]init];
           webView.urlStr = self.urlField.text;
           [self.navigationController pushViewController:webView animated:YES];
    }else{
        [self showHubMessage:@"请输入有效网址" delay:2];
    }
   
}

-(void)showHubMessage:(NSString *)message delay:(NSTimeInterval)time{
        MBProgressHUD *HUB = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUB.mode = MBProgressHUDModeText;
        HUB.detailsLabel.text = message;
        [HUB hideAnimated:YES afterDelay:time];
        HUB.removeFromSuperViewOnHide = YES;
}
@end

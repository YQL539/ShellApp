//
//  LK_LoginViewController.m
//  YiShiJieProduct
//
//  Created by 陈志伟 on 2020/3/11.
//  Copyright © 2020年 Linkcare. All rights reserved.
//

#import "LK_LoginViewController.h"
#import "MBProgressHUD.h"
#import "PolicyViewController.h"
#import "SettingView.h"
#import <AFNetworking.h>
#define iLoginTime 30

@interface LK_LoginViewController ()
@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic,strong) UIImageView *bgView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic, strong) UITextField *emailFiled;
@property (nonatomic, strong) UITextField *pwdFiled;
@property (nonatomic,strong) UIButton *remeberButton;
@property (nonatomic,strong) UIButton *autoLoginBtn;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *fogetPwdButton;
@property (nonatomic,copy) NSString *emailStr;
@property (nonatomic,copy) NSString *pswStr;
@property (nonatomic,strong) MBProgressHUD *loginHub;
@property (nonatomic,strong) NSTimer *registTimer;//注册计时器
@property (nonatomic, assign) NSInteger iRegistCount;//注册j计时
@property (nonatomic,assign) CGFloat iMargin;

@end

@implementation LK_LoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.emailFiled != nil && ![self.emailFiled isKindOfClass:[NSNull class]]) {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:KACCOUNT] length] > 0) {
            _emailFiled.text = [[NSUserDefaults standardUserDefaults] valueForKey:KACCOUNT];
        }else {
            _emailFiled.text = @"";
        }
    }
    if (self.pwdFiled != nil && ![self.pwdFiled isKindOfClass:[NSNull class]]) {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:KPASSWORD] length] > 0) {
            self.pwdFiled.text = [[NSUserDefaults standardUserDefaults] valueForKey:KACCOUNT];
        }else {
            self.pwdFiled.text = @"";
        }
    }
    if (self.emailFiled.text.length > 0 && self.pwdFiled.text.length > 0) {
            [self loginClicked];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.iMargin = 60.f;
    [self drawUIWithComplete];
}


#pragma mark ----- UI
- (void)drawUIWithComplete{
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.detailLabel];
    [self.view addSubview:self.settingButton];
    [self.view addSubview:self.emailFiled];
    [self.view addSubview:self.pwdFiled];
    [self.view addSubview:self.loginBtn];
}
-(UIImageView *)bgView{
    if (!_bgView) {
        _bgView = [[UIImageView alloc]initWithFrame:self.view.frame];
        _bgView.backgroundColor = RGB(242.0, 242.0, 242.0);
    }
    return _bgView;
}
- (UIButton *)settingButton {
    if (!_settingButton) {
        _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _settingButton.frame = CGRectMake(GetWidthNum(5), STATUS_BAR_HEIGHT, GetWidthNum(50), GetWidthNum(50));
        [_settingButton setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
        [_settingButton addTarget:self action:@selector(showServer) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingButton;
}

- (void)showServer {
    [self.view endEditing:YES];
    SettingView *settingView = [[SettingView alloc] initWithTitle:@"请设置服务器" cancelBtn:@"取消" sureBtn:@"确定" btnClickBlock:^(NSInteger index,NSString *ipStr,NSString *firstText) {
        if (index == 0) {
            NSLog(@"取消");
        }else if (index == 1){
            [[NSUserDefaults standardUserDefaults] setObject:ipStr forKey:KSERVERIP];
            [[NSUserDefaults standardUserDefaults] setObject:firstText forKey:KSERVERPORT];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSString *port = [[NSUserDefaults standardUserDefaults] objectForKey:KSERVERPORT];
            NSString *ip = [[NSUserDefaults standardUserDefaults] objectForKey:KSERVERIP];
            NSLog(@"ip=%@,终端端口=%@",ip,port);
        }
    }];
    [settingView show];
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT + GetWidthNum(80.f), SCREENWIDTH, GetWidthNum(60.f))];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:30];
        _titleLabel.text = @"海绵城市";
    }
    return _titleLabel;
}

-(UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), SCREENWIDTH, GetWidthNum(30.f))];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.textColor = [UIColor grayColor];
        _detailLabel.font = [UIFont systemFontOfSize:16];
        _detailLabel.text = @"徐州海绵城市信息管理系统";
    }
    return _detailLabel;
}

- (UITextField *)emailFiled {
    if (!_emailFiled) {
        _emailFiled = [self getTextFieldWithplaceText:@"账号" withImageName:@"Account-number"];
        _emailFiled.frame = CGRectMake(_iMargin, self.detailLabel.bottom + GetHeightNum(60.f), SCREENWIDTH - _iMargin * 2, GetWidthNum(46));
    }
    return _emailFiled;
}

- (UITextField *)pwdFiled {
    if (!_pwdFiled) {
        _pwdFiled = [self getTextFieldWithplaceText:@"密码" withImageName:@"Password"];
        _pwdFiled.frame = CGRectMake(_iMargin, CGRectGetMaxY(_emailFiled.frame) + GetWidthNum(10), CGRectGetWidth(_emailFiled.frame), CGRectGetHeight(_emailFiled.frame));
        _pwdFiled.secureTextEntry = YES;
    }
    return _pwdFiled;
}


-(UITextField *)getTextFieldWithplaceText:(NSString *)placeText withImageName:(NSString *)imageName{
    UITextField *textField = [[UITextField alloc] init];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.layer.borderColor = [UIColor whiteColor].CGColor;
    textField.layer.borderWidth = .5f;
    textField.layer.cornerRadius = 5.0f;
    textField.textColor = [UIColor blackColor];
    textField.font = [UIFont systemFontOfSize:16];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeText attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GetWidthNum(34), GetWidthNum(20))];
    UIImageView *headView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, GetWidthNum(18), GetWidthNum(18))];
    headView.image = [UIImage imageNamed:imageName];
    [leftView addSubview:headView];
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.backgroundColor = [UIColor whiteColor];
    return textField;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.frame = CGRectMake(_iMargin, CGRectGetMaxY(_pwdFiled.frame) + GetWidthNum(60), SCREENWIDTH - _iMargin * 2, CGRectGetHeight(_emailFiled.frame));
        _loginBtn.layer.cornerRadius = 5.0f;
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn setBackgroundColor:RGB(58.0, 102.0, 150.0)];
        [_loginBtn addTarget:self action:@selector(loginClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

#pragma mark=========== 网络请求====================
//确定
- (void)loginClicked{
    self.emailStr = _emailFiled.text;
    self.pswStr = _pwdFiled.text;
    if (_emailStr.length == 0 || _pswStr.length == 0) {
        [self showAlertWithTitle:@"提示" Infomation:@"账号或密码不可为空" shoeInViewController:self completedAction:nil];
        return;
    }
    __block typeof(self)weakSelf = self;
    MBProgressHUD *requestHub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    requestHub.mode = MBProgressHUDModeIndeterminate;
    requestHub.label.text = @"数据加载中。。。";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *serverIp = [[NSUserDefaults standardUserDefaults] objectForKey:KSERVERIP];
        if (!serverIp) {
            serverIp = @"yfstrug.wicp.net";
        }
        
        NSString *requestUrlString = [NSString stringWithFormat:@"http://%@/iwa-admin/app/login/loginSub.htm",serverIp];
        NSDictionary *paramDic = @{@"uac":self.emailStr,
                                   @"upd":self.pswStr
        };
        [manager GET:requestUrlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [requestHub removeFromSuperview];
            NSString *result = [[NSString alloc] initWithData:responseObject
                                                     encoding:NSUTF8StringEncoding];
            NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:&err];
            NSLog(@"%@",resultDic);
            if ([resultDic[@"status"] integerValue] == 200) {
                [[NSUserDefaults standardUserDefaults] setValue:self.emailStr forKey:KACCOUNT];
                [[NSUserDefaults standardUserDefaults] setValue:self.pswStr forKey:KPASSWORD];
                [weakSelf presentTabarVC];
            }else{
                [weakSelf showAlertWithTitle:@"提示" Infomation:resultDic[@"msg"] shoeInViewController:self completedAction:nil];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            [weakSelf showAlertWithTitle:@"提示" Infomation:@"网络请求错误" shoeInViewController:self completedAction:nil];
        }];
    });
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

//跳转网页
-(void)presentTabarVC{
    dispatch_async(dispatch_get_main_queue(), ^{
        PolicyViewController *webviewVC = [[PolicyViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:webviewVC];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:^{
            self.emailFiled.text = @"";
            self.pwdFiled.text = @"";
        }];
    });
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end

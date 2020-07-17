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

#define iLoginTime 30

@interface LK_LoginViewController ()
@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) UIImageView *bgIconView;
@property (nonatomic, strong) UIImageView *logoIconView;
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
        
    }
    if (self.pwdFiled != nil && ![self.pwdFiled isKindOfClass:[NSNull class]]) {
        
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
    [self.view addSubview:self.bgIconView];
    [self.view addSubview:self.logoIconView];
    [self.view addSubview:self.emailFiled];
    [self.view addSubview:self.pwdFiled];
    [self.view addSubview:self.loginBtn];
}

- (UIImageView *)bgIconView {
    if (!_bgIconView) {
        _bgIconView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _bgIconView.backgroundColor = [UIColor whiteColor];
    }
    return _bgIconView;
}

- (UIImageView *)logoIconView {
    if (!_logoIconView) {
        _logoIconView = [[UIImageView alloc] init];
        _logoIconView.width = GetWidthNum(150.f);
        _logoIconView.height = GetWidthNum(150.f);
        _logoIconView.centerX = self.view.width/2.f;
        _logoIconView.y = STATUS_BAR_HEIGHT + GetWidthNum(60.f);
        if (IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs || IS_IPHONE_Xs_Max) {
            _logoIconView.y = STATUS_BAR_HEIGHT + GetWidthNum(120.f);
        }
        _logoIconView.image = [UIImage imageNamed:@"logo"];
    }
    return _logoIconView;
}


- (UITextField *)emailFiled {
    if (!_emailFiled) {
        _emailFiled = [self getTextFieldWithplaceText:@"账号" withImageName:@"Account-number"];
        _emailFiled.frame = CGRectMake(_iMargin, self.logoIconView.bottom + GetHeightNum(80.f), SCREENWIDTH - _iMargin * 2, GetWidthNum(46));
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
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.layer.borderWidth = .5f;
    textField.layer.cornerRadius = 5.0f;
    textField.textColor = [UIColor lightGrayColor];
    textField.font = [UIFont systemFontOfSize:16];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeText attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GetWidthNum(34), GetWidthNum(20))];
    UIImageView *headView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, GetWidthNum(18), GetWidthNum(18))];
    headView.image = [UIImage imageNamed:imageName];
    [leftView addSubview:headView];
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    return textField;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.frame = CGRectMake(_iMargin, CGRectGetMaxY(_pwdFiled.frame) + GetWidthNum(30), SCREENWIDTH - _iMargin * 2, CGRectGetHeight(_emailFiled.frame));
        _loginBtn.layer.cornerRadius = 5.0f;
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn setBackgroundColor:[UIColor blueColor]];
        [_loginBtn addTarget:self action:@selector(loginClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

#pragma mark=========== 网络请求====================
//确定
- (void)loginClicked{
    _emailStr = _emailFiled.text;
    _pswStr = _pwdFiled.text;
    if (_emailStr.length == 0 || _pswStr.length == 0) {
        [self showAlertWithTitle:@"提示" Infomation:@"账号或密码不可为空" shoeInViewController:self completedAction:nil];
        return;
    }
    [self presentTabarVC];


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

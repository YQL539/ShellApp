//
//  AppDelegate.m
//  ShellApp
//
//  Created by qinglong yang on 2020/7/14.
//  Copyright © 2020 yql. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LK_LoginViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    LK_LoginViewController *viewController = [[LK_LoginViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    return YES;
}





@end

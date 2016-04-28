//
//  LTYLoginViewController.m
//  LTY1chat
//
//  Created by ayuan on 15/9/24.
//  Copyright (c) 2015年 AYuan. All rights reserved.
//

#import "LTYLoginViewController.h"
#import "EaseMob.h"

@interface LTYLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@end

@implementation LTYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)registerAction:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    if (username.length == 0 || password.length == 0) {
        NSLog(@"请输入账号和密码");
        return;
    }

    
    // 注册
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:username password:password withCompletion:^(NSString *username, NSString *password, EMError *error) {
        NSLog(@"%@",[NSThread currentThread]);
        if (!error) {
            NSLog(@"注册成功");
        }else{
            NSLog(@"注册失败 %@",error);
        }
        
    } onQueue:nil];
    
}

- (IBAction)loginAction:(id)sender {
    // 让环信SDK在"第一次"登录完成之后，自动从服务器获取好友列表，添加到本地数据库(Buddy表)
    [[EaseMob sharedInstance].chatManager setIsAutoFetchBuddyList:YES];
    
    
    
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    if (username.length == 0 || password.length == 0) {
        NSLog(@"请输入账号和密码");
        return;
    }
    
    
    // 登录
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username password:password completion:^(NSDictionary *loginInfo, EMError *error) {
        // 登录请求完成后的block回调
        if (!error) {
            /*
             {
             LastLoginTime = 1443083631296;
             jid = "vgios#LTY1chat_LTYtest1@easemob.com";
             password = 123456;
             resource = mobile;
             token = "YWMt-2kmTmKWEeWhivny1t_c6gAAAVEzekiFP9xOO0dqxYGGu4uI5CZNNCoaV0Y";
             username = LTYtest1;
             }
             */
            NSLog(@"登录成功 %@",loginInfo);
            
            // 设置自动登录
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            
            // 来主界面
            self.view.window.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            
        }else{
            NSLog(@"登录失败 %@",error);
            //User do not exist.
            /** 每一个应用都有自己的注册用户*/
        }
        
        
        
    } onQueue:dispatch_get_main_queue()];
}
@end

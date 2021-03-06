//
//  LTYSettingViewController.m
//  LTY1chat
//
//  Created by ayuan on 16/4/27.
//  Copyright © 2016年 AYuan. All rights reserved.
//

#import "LTYSettingViewController.h"
#import "EaseMob.h"

@interface LTYSettingViewController ()
- (IBAction)logoutAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@end

@implementation LTYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    // 当前登录的用户名
    NSString *loginUsername = [[EaseMob sharedInstance].chatManager loginInfo][@"username"];
    
    NSString *title = [NSString stringWithFormat:@"log out(%@)",loginUsername];
    
    //1.设置退出按钮的文字
    [self.logoutBtn setTitle:title forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logoutAction:(id)sender {
    //UnbindDeviceToken 不绑定DeviceToken
    // DeviceToken 推送用
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        if (error) {
            NSLog(@"退出失败 %@",error);
            
        }else{
            NSLog(@"退出成功");
            // 回到登录界面
            self.view.window.rootViewController = [UIStoryboard storyboardWithName:@"Login" bundle:nil].instantiateInitialViewController;
        
        }
    } onQueue:nil];
}
@end

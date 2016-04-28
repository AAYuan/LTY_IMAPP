//
//  LTYAddFriendViewController.m
//  LTY1chat
//
//  Created by ayuan on 16/4/27.
//  Copyright © 2016年 AYuan. All rights reserved.
//

#import "LTYAddFriendViewController.h"
#import "EaseMob.h"

@interface LTYAddFriendViewController ()<EMChatManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation LTYAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#warning 代理放在Conversaton控制器比较好
    // 添加（聊天管理器）代理
//    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}


- (IBAction)addFriendAction:(id)sender {
    
    // 添加好友
    
    // 1.获取要添加好友的名字
    NSString *username = self.textField.text;
    
    
    // 2.向服务器发送一个添加好友的请求
    // buddy 哥儿们
    // message ： 请求添加好友的 额外信息
    NSString *loginUsername = [[EaseMob sharedInstance].chatManager loginInfo][@"username"];
    NSString *message = [@"我是" stringByAppendingString:loginUsername];
    
    EMError *error =  nil;
    [[EaseMob sharedInstance].chatManager addBuddy:username message:message error:&error];
    if (error) {
        NSLog(@"添加好友有问题 %@",error);
        
    }else{
        NSLog(@"添加好友没有问题");
    }
    
}

//
//
//-(void)dealloc{
//    //移除聊天管理器的代理
//    [[EaseMob sharedInstance].chatManager removeDelegate:self];
//}
@end

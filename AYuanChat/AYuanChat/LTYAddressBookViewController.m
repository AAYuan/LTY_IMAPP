//
//  LTYAddressBookViewController.m
//  LTY1chat
//
//  Created by ayuan on 15/9/25.
//  Copyright © 2015年 AYuan. All rights reserved.
//

#import "LTYAddressBookViewController.h"
#import "LTYChatViewController.h"
#import "EaseMob.h"

@interface LTYAddressBookViewController ()<EMChatManagerDelegate>

/** 好友列表数据源 */
@property (nonatomic, strong) NSArray *buddyList;

@end

@implementation LTYAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加聊天管理器的代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
  
    // 获取好友列表数据
    /* 注意
     * 1.好友列表buddyList需要在自动登录成功后才有值
     * 2.buddyList的数据是从 本地数据库获取
     * 3.如果要从服务器获取好友列表 调用chatManger下面的方法
        【-(void *)asyncFetchBuddyListWithCompletion:onQueue:】;
     * 4.如果当前有添加好友请求，环信的SDK内部会往数据库的buddy表添加好友记录
     * 5.如果程序删除或者用户第一次登录，buddyList表是没记录，
         解决方案
         1》要从服务器获取好友列表记录
         2》用户第一次登录后，自动从服务器获取好友列表
     */
    
    self.buddyList =  [[EaseMob sharedInstance].chatManager buddyList];
    NSLog(@"=== %@",self.buddyList);
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.buddyList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"BuddyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    // 1。获取“好友”模型
    EMBuddy *buddy = self.buddyList[indexPath.row];
    
    // 2.显示头像
    cell.imageView.image = [UIImage imageNamed:@"chatListCellHead"];
    
    // 3.显示名称
    cell.textLabel.text = buddy.username;
    
    return cell;
}


#pragma mark - chatmanger的代理
#pragma mark - 监听自动登录成功
-(void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error{
    if (!error) {//自动登录成功，此时buddyList就有值
        self.buddyList = [[EaseMob sharedInstance].chatManager buddyList];
        NSLog(@"=== %@",self.buddyList);
        [self.tableView reloadData];
    }
}


#pragma mark 好友添加请求同意
-(void)didAcceptedByBuddy:(NSString *)username{
    // 把新的好友显示到表格
    NSArray *buddyList = [[EaseMob sharedInstance].chatManager buddyList];
    NSLog(@"好友添加请求同意 %@",buddyList);
#warning buddyList的个数，仍然是没有添加好友之前的个数，从新服务器获取
    [self loadBuddyListFromServer];
    
    
}

#pragma mark 从新服务器获取好友列表
-(void)loadBuddyListFromServer{
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        NSLog(@"从服务器获取的好友列表 %@",buddyList);
        
        // 赋值数据源
        self.buddyList = buddyList;
        
        // 刷新
        [self.tableView reloadData];
        
    } onQueue:nil];
}

#pragma mark 好友列表数据被更新
-(void)didUpdateBuddyList:(NSArray *)buddyList changedBuddies:(NSArray *)changedBuddies isAdd:(BOOL)isAdd{

    NSLog(@"好友列表数据被更新 %@",buddyList);
    // 重新赋值数据源
    self.buddyList = buddyList;
    // 刷新
    [self.tableView reloadData];
}

#pragma mark 被好友删除
-(void)didRemovedByBuddy:(NSString *)username{
    
    // 刷新表格
    [self loadBuddyListFromServer];

}

#pragma mark  实现下面的方法就会出现表格的Delete按钮
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // 获取移除好友的名字
        EMBuddy *buddy = self.buddyList[indexPath.row];
        NSString *deleteUsername = buddy.username;
        
        // 删除好友
        [[EaseMob sharedInstance].chatManager removeBuddy:deleteUsername removeFromRemote:YES error:nil];
    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    //往聊天控制器 传递一个 buddy的值
    id destVC = segue.destinationViewController;
    if ([destVC isKindOfClass:[LTYChatViewController class]]) {
        //获取点击的行
        NSInteger selectedRow = [self.tableView indexPathForSelectedRow].row;
        
        LTYChatViewController *chatVc = destVC;
        chatVc.buddy = self.buddyList[selectedRow];
    }
    
}

@end

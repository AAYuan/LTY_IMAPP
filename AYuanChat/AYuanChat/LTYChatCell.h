//
//  LTYChatCell.h
//  LTY1chat
//
//  Created by ayuan on 15/9/25.
//  Copyright © 2015年 AYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *ReceiverCell = @"ReceiverCell";
static NSString *SenderCell = @"SenderCell";
@interface LTYChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

/** 消息模型，内部set方法 显示文字 */
@property (nonatomic, strong) EMMessage *message;

-(CGFloat)cellHeghit;

@end

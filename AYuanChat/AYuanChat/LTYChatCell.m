//
//  LTYChatCell.m
//  LTY1chat
//
//  Created by ayuan on 16/4/27.
//  Copyright © 2016年 AYuan. All rights reserved.
//

#import "LTYChatCell.h"

@implementation LTYChatCell


-(void)setMessage:(EMMessage *)message{

    _message = message;
    
    // 1.获取消息体
    id body = message.messageBodies[0];
    if ([body isKindOfClass:[EMTextMessageBody class]]) {//文本消息
        EMTextMessageBody *textBody = body;
        self.messageLabel.text = textBody.text;
    }else if([body isKindOfClass:[EMVoiceMessageBody class]]){//语音消息
        self.messageLabel.text = @"【语音】";
    }
    else{
        self.messageLabel.text = @"未知类型";
    }
    

}


/** 返回cell的高度*/
-(CGFloat)cellHeghit{
    //1.重新布局子控件
    [self layoutIfNeeded];
    
    return 5 + 10 + self.messageLabel.bounds.size.height + 10 + 5;

}


@end

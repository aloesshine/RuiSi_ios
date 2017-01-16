//
//  Message.h
//  RuiSi
//
//  Created by 汪泽伟 on 2017/1/16.
//  Copyright © 2017年 aloes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
@property (nonatomic,copy) NSString *friendAvatarURL;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *messageURL;
@property (nonatomic,copy) NSString *messageTime;
@property (nonatomic,copy) NSString *messageContent;
@end

@interface MessageList : NSObject
@property (nonatomic,strong) NSArray *list;
+ (MessageList *) getMessageListFromResponseObject:(id) responseObject;
- (NSInteger) countOfList;
@end

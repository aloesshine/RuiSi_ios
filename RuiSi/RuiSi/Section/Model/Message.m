//
//  Message.m
//  RuiSi
//
//  Created by 汪泽伟 on 2017/1/16.
//  Copyright © 2017年 aloes. All rights reserved.
//

#import "Message.h"
#import "OCGumbo.h"
#import "OCGumbo+Query.h"
@implementation Message

@end

@implementation MessageList

+ (MessageList *)getMessageListFromResponseObject:(id)responseObject {
    NSMutableArray *messagesArray = [[NSMutableArray alloc] init];
    @autoreleasepool {
        NSString *htmlString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlString];
        OCGumboNode *element = document.Query(@"body.bg").find(@"div.pmbox").first();
        OCQueryObject *elementsArray = element.Query(@"li");
        for(OCGumboNode *ele in elementsArray) {
            Message *message = [[Message alloc] init];
            message.friendAvatarURL = (NSString *)ele.Query(@".avatar_img").find(@"img").first().attr(@"src");
            message.title = (NSString *)ele.Query(@"span.name").first().text();
            message.messageURL = (NSString *)ele.Query(@"a").first().attr(@"href");
            message.messageContent = (NSString *)ele.Query(@".grey").find(@"span").last().text();
            message.messageTime = (NSString*) ele.Query(@".grey").find(@"span.time").text();
            message.messageTime = [message.messageTime stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
            [messagesArray addObject:message];
        }
    }
    MessageList *list;
    if (messagesArray.count) {
        list = [[MessageList alloc] init];
        list.list = messagesArray;
    }
    return list;
}

- (NSInteger)countOfList {
    return self.list.count;
}

@end

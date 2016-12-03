//
//  Member.m
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/1.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "Member.h"

@implementation Member
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.memberUid  = [dict objectForKey:@"id"];
        self.memberSex = [dict objectForKey:@"sex"];
        self.memberAvatarSmall = [dict objectForKey:@"avatar_small"];
        self.memberAvatarMiddle = [dict objectForKey:@"avatar_middle"];
        self.memberAvatarBig = [dict objectForKey:@"avatar_big"];
        self.memberCoins = [dict objectForKey:@"coins"];
        self.memberCredicts = [dict objectForKey:@"credicts"];
        self.memberUploads = [dict objectForKey:@"uploads"];
        self.memberDownloads = [dict objectForKey:@"downloads"];
        self.memberTorrents = [dict objectForKey:@"torrents"];
        self.memberName = [dict objectForKey:@"name"];
        self.memberBirthday = [dict objectForKey:@"birthday"];
        self.memberBirthplace = [dict objectForKey:@"birthplace"];
        self.memberHomepage = [dict objectForKey:@"homepage"];
    }
    return self;
}
@end

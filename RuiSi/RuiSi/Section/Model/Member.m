//
//  Member.m
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/1.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "Member.h"
#import "OCGumbo.h"
#import "OCGumbo+Query.h"
#import "Constants.h"
@implementation Member
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

+ (Member *)getMemberWithHomepage:(NSString *)homepage {
    Member *member = [[Member alloc] init];
    NSString *urlString = [kPublicNetURL stringByAppendingString:homepage];
    NSURL *url = [NSURL URLWithString:urlString];
    NSError *error = nil;
    NSString *htmlString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlString];
    OCGumboNode *avatarNode = document.Query(@"body").find(@".user_avatar").first();
    member.memberAvatarSmall = (NSString *)avatarNode.Query(@".avatar_m").find(@"img").first().attr(@"src");
    member.memberHomepage = homepage;
    NSRange range1 = [homepage rangeOfString:@"uid="];
    NSRange range2 = [homepage rangeOfString:@"&mobile=2"];
    NSRange range = NSMakeRange(range1.location+range1.length, range2.location-range1.location-range1.length);
    member.memberUid = [homepage substringWithRange:range];
    member.memberName = (NSString *)avatarNode.Query(@".name").text();
    OCQueryObject *spanNodes = document.Query(@"body").find(@".user_box").find(@"ul").find(@"span");
    for (OCGumboNode *node in spanNodes) {
        NSInteger index = [spanNodes indexOfObject:node];
        switch (index) {
            case 0:
                member.memberCredicts = node.text();
                break;
            case 1:
                member.memberCoins = node.text();
                break;
            case 2:
                member.memberUploads = node.text();
                break;
            case 3:
                member.memberDownloads = node.text();
                break;
            case 4:
                member.memberTorrents = node.text();
                break;
            case 5:
                member.memberChip = node.text();
                break;
            case 6:
                member.memberRatio = node.text();
                break;
            case 7:
                member.memberPin = node.text();
                break;
            default:
                break;
        }
    }
    
    return member;
}

@end

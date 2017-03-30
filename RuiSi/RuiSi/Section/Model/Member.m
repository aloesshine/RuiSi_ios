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
    NSError *error = nil;
    NSString *urlString;
    
    if ([DataManager isSchoolNet]) {
        if ([homepage containsString:kSchoolNetURL]) {
            urlString = homepage;
        } else {
            urlString = [kSchoolNetURL stringByAppendingString:homepage];
        }
    } else {
        if ([homepage containsString:kPublicNetURL]) {
            urlString = homepage;
        } else {
            urlString = [kPublicNetURL stringByAppendingString:homepage];
        }
    }
    NSString *htmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:&error];
    OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlString];
    OCGumboNode *avatarNode = document.Query(@"body").find(@".user_avatar").first();
    member.memberAvatarSmall = (NSString *)avatarNode.Query(@".avatar_m").find(@"img").first().attr(@"src");
    member.memberAvatarMiddle = [member.memberAvatarSmall stringByReplacingOccurrencesOfString:@"size=small" withString:@"size=middle"];
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

+ (Member *) getMemberFromResponseObject:(id) responseObject {
    Member *member = [[Member alloc] init];
    @autoreleasepool {
        NSString *htmlString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlString];
        OCGumboNode *avatarNode = document.Query(@"body").find(@".user_avatar").first();
        member.memberAvatarSmall = (NSString *)avatarNode.Query(@".avatar_m").find(@"img").first().attr(@"src");
        member.memberAvatarMiddle = [member.memberAvatarSmall stringByReplacingOccurrencesOfString:@"size=small" withString:@"size=middle"];
        
        
        NSRange range1 = [member.memberAvatarSmall rangeOfString:@"uid="];
        NSRange range2 = [member.memberAvatarSmall rangeOfString:@"&size="];
        NSRange range = NSMakeRange(range1.length+range1.location, range2.location-range1.location-range1.length);
        NSString *uid = [member.memberAvatarSmall substringWithRange:range];
        member.memberUid = uid;
        member.memberHomepage = [NSString stringWithFormat:@"home.php?mod=space&uid=%@&do=profile&mobile=2",uid];
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
    }
    return member;
}
@end

//
//  Collections.m
//  RuiSi
//
//  Created by 汪泽伟 on 2017/1/14.
//  Copyright © 2017年 aloes. All rights reserved.
//

#import "Collections.h"
#import "OCGumbo.h"
#import "OCGumbo+Query.h"
#import "Constants.h"
#import "Collection.h"
@implementation Collections
+ (NSArray *)getCollectionsFromResponseObject:(id)responseObject {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    @autoreleasepool {
        NSString *htmlString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlString];
        OCQueryObject *elementArray = document.Query(@"body").find(@".threadlist").find(@"li");
        for (OCGumboNode *node in elementArray) {
            Collection *collection = [[Collection alloc] init];
            NSString *string = (NSString *)node.Query(@"a").first().attr(@"href");
            NSString *title = (NSString *)node.Query(@"a").first().text();
            NSString *num = (NSString *)node.Query(@"span").first().text();
            if ([string rangeOfString:@"tid="].location != NSNotFound) {
                
                NSRange range1 = [string rangeOfString:@"&mobile=2"];
                NSRange range2 = [string rangeOfString:@"tid="];
                NSRange range = NSMakeRange(range1.location-range2.location-range2.length, range1.location-range2.location);
                NSString *tid = [string substringWithRange:range];
                collection.tid = tid;
                collection.title = title;
                collection.spanNum = num;
                [array addObject:collection];
            }
        }
    }
    
    NSArray *thisArray = [NSArray arrayWithArray:array];
    return thisArray;
}
@end

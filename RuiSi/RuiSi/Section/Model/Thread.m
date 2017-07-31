
//
//  Post.m
//  RuiSi
//
//  Created by aloes on 2016/11/23.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "Thread.h"
#import "OCGumbo.h"
#import "OCGumbo+Query.h"
@implementation Thread

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

@end
@implementation ThreadList

- (instancetype)initWithArray:(NSArray *)array {
    if (self = [super init]) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for( NSDictionary *dict in list) {
            Thread *thread = [[Thread alloc] initWithDictionary:dict];
            [list addObject:thread];
        }
        self.list = list;
    }
    return self;
}

- (NSInteger)countOfList {
    return self.list.count;
}


+ (ThreadList *) getThreadListFromResponseObject:(id)responseObject {
    NSMutableArray *elements = [[NSMutableArray alloc] init];
    @autoreleasepool {
        NSString *htmlString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlString];
        if(document.Query(@"body.bg").find(@"div.threadlist").first()) {
            OCQueryObject *elementArrry = document.Query(@"body.bg").find(@"div.threadlist").first().Query(@"li");
            for (OCGumboNode *ele in elementArrry)
            {
                
                Thread *thread = [[Thread alloc] init];
                if(ele.Query(@"span")) {
                    thread.reviewCount = ele.Query(@"span").last().text();
                }
                thread.titleURL = (NSString *)ele.Query(@"a").first().attr(@"href");
                
                NSRange range1 = [thread.titleURL rangeOfString:@"tid="];
                NSRange range2;
                if ([thread.titleURL rangeOfString:@"&extra="].location != NSNotFound) {
                    range2 = [thread.titleURL rangeOfString:@"&extra="];
                } else {
                    range2 = [thread.titleURL rangeOfString:@"&mobile="];
                }
                NSRange range = NSMakeRange(range1.location+range1.length,range2.location-range1.location-range1.length);
                thread.tid = [thread.titleURL substringWithRange:range];
                
                
                if (ele.Query(@"a").find(@".by")) {
                    thread.author = (NSString *)ele.Query(@"a").find(@".by").text();
                    NSString *title = (NSString *)ele.Query(@"a").textArray().firstObject;
                    title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
                    thread.title = title;
                } else {
                    NSString *title = (NSString *)ele.Query(@"a").first().text();
                    title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    thread.title = title;
                }
                thread.hasPic = ele.Query(@"span.icon_tu").count == 0 ? NO : YES;
                [elements addObject:thread];
            }
        }
        }
    
    if (elements.count) {
        ThreadList *list = [[ThreadList alloc] init];
        list.list = elements;
        return list;
    }
    return nil;
}


+ (ThreadList *)getThreadListForFavoritesFromResponseObject:(id)responseObject {
    NSMutableArray *elements = [[NSMutableArray alloc] init];
    @autoreleasepool {
        NSString *htmlString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlString];
        OCQueryObject *elementArray = document.Query(@"body.bg").find(@"div.threadlist").first().Query(@"li");
        for(OCGumboNode *element in elementArray) {
            Thread *thread = [[Thread alloc] init];
            thread.titleURL = (NSString *)element.Query(@"a").first().attr(@"href");
            
            NSRange range1 = [thread.titleURL rangeOfString:@"tid="];
            NSRange range2;
            if ([thread.titleURL rangeOfString:@"&extra="].location != NSNotFound) {
                range2 = [thread.titleURL rangeOfString:@"&extra="];
            } else {
                range2 = [thread.titleURL rangeOfString:@"&mobile="];
            }
            NSRange range = NSMakeRange(range1.location+range1.length,range2.location-range1.location-range1.length);
            thread.tid = [thread.titleURL substringWithRange:range];
            NSString *title = (NSString *)element.Query(@"a").first().text();
            title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            thread.title = title;
            
            [elements addObject:thread];
        }
    }
    if (elements.count) {
        ThreadList *list = [[ThreadList alloc] init];
        list.list = elements;
        return list;
    }
    return nil;
}
@end

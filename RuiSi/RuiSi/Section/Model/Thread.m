
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
        OCGumboNode *element = document.Query(@"body.bg").find(@"div.threadlist").first();
        OCQueryObject *elementArrry = element.Query(@"li");
        
        for (OCGumboNode *ele in elementArrry)
        {

            Thread *thread = [[Thread alloc] init];
            thread.reviewCount = (NSString *)ele.Query(@"span.num").text();
            thread.titleURL = (NSString *)ele.Query(@"a").first().attr(@"href");
            
            NSString *s1 = @"tid=",*s2 = @"&extra=";
            NSRange range1 = [thread.titleURL rangeOfString:s1];
            NSRange range2 = [thread.titleURL rangeOfString:s2];
            NSRange range = NSMakeRange(range1.location+range1.length, range2.location-range1.location-range1.length);
            
            thread.tid = [thread.titleURL substringWithRange:range];
            if (ele.Query(@"a").hasClass(@"span.by")) {
                thread.author = (NSString *)ele.Query(@"a").first().Query(@"span.by").text();
            }
            NSString *title = (NSString *)ele.Query(@"a").text();
            title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
            thread.title = [title substringToIndex: title.length - thread.author.length];
            thread.hasPic = ele.Query(@"span.icon_tu").count == 0 ? NO : YES;
            [elements addObject:thread];
        }
    }
    
    ThreadList *list ;
    if (elements.count) {
        list = [[ThreadList alloc] init];
        list.list = elements;
    }
    return list;
}

@end

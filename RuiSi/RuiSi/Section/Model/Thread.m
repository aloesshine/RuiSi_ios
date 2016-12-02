
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
        self.title = [dict objectForKey:@"title"];
        self.titleURL = [dict objectForKey:@"title_url"];
        self.author = [dict objectForKey:@"author"];
        self.hasPic = [dict objectForKey:@"has_pic"];
        self.reviewCount = [dict objectForKey:@"review_count"];
        self.tid = [dict objectForKey:@"tid"];
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


+ (ThreadList *)getThreadListWithURL:(NSString *)urlString {
    NSMutableArray *elements = [[NSMutableArray alloc] init];
    @autoreleasepool {
        NSError *error = nil;
        NSURL *url = [NSURL URLWithString:urlString];
        NSString *htmlString = [NSString stringWithContentsOfURL: url encoding:NSUTF8StringEncoding error:&error];
        OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlString];
        OCGumboNode *element = document.Query(@"body.bg").find(@"div.threadlist").first();
        OCQueryObject *elementArrry = element.Query(@"li");
        
        for (OCGumboNode *ele in elementArrry)
        {
            // 坑爹的初始化
            Thread *thread = [[Thread alloc] init];
            thread.reviewCount = (NSString *)ele.Query(@"span.num").text();
            thread.titleURL = (NSString *)ele.Query(@"a").first().attr(@"href");
            thread.author = (NSString *)ele.Query(@"a").first().Query(@"span.by").text();
            NSString *title = (NSString *)ele.Query(@"a").text();
            title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
            thread.title = [title substringToIndex: title.length - thread.author.length];
            thread.hasPic = ele.Query(@"span.icon_tu").count == 0 ? NO : YES;
            
            [elements addObject:thread];
        }

        
    }
    ThreadList *list;
    if (elements.count) {
        list = [[ThreadList alloc] init];
        list.list = elements;
    }
    return list;
}

@end

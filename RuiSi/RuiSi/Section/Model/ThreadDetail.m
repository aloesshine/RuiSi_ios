//
//  ThreadDetail.m
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/1.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "ThreadDetail.h"
#import "NSString+SCMention.h"
#import "OCGumbo.h"
#import "OCGumbo+Query.h"
#import "DataManager.h"
#import "Constants.h"


@implementation ThreadDetail
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
    }
    return self;
}


- (void)configureMember {
    
}

- (NSString *) spaceWithLength:(NSUInteger) length {
    NSString *spaceString = @"";
    while (spaceString.length < length) {
        spaceString = [spaceString stringByAppendingString:@" "];
    }
    return spaceString;
}

@end


@interface ThreadDetailList()

@end

@implementation ThreadDetailList

- (instancetype)initWithArray:(NSArray *)array {
    if (self = [super init]) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for( NSDictionary *dict in list) {
            ThreadDetail *detail = [[ThreadDetail alloc] initWithDictionary:dict];
            [list addObject:detail];
        }
        self.list = list;
    }
    return self;
}

- (NSInteger)countOfList {
    return self.list.count;
}

+ (NSString *) formatHMTLString:(NSString *) htmlString {
    NSString *string = htmlString;
    string = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    return string;
}

+ (ThreadDetailList *)getThreadDetailListFromResponseObject:(id)responseObject {
    NSMutableArray *threadDetailArray = [[NSMutableArray alloc] init];
    @autoreleasepool {
        NSString *htmlString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlString];
        OCQueryObject *elementArray = document.Query(@"body").find(@".postlist").find(@".cl");

        NSInteger countOfArray = [elementArray count];
        // 暂时移除最后一个元素
        //for(OCGumboNode *node in elementArray)
        for (int i = 0; i < countOfArray-1;i++)
        {
            OCGumboNode *node = [elementArray objectAtIndex:i];

            ThreadDetail *detail = [[ThreadDetail alloc] init];
            NSString *idString = (NSString *)node.attr(@"id");
            detail.threadID = [idString substringFromIndex:3];
            detail.creatorName = (NSString *)node.Query(@".blue").first().text();
            detail.homepage = (NSString *)node.Query(@".blue").first().attr(@"href");
            detail.createTime = (NSString *)node.Query(@".rela").textArray().lastObject;
            if ([detail.createTime rangeOfString:@"\n"].location != NSNotFound) {
                detail.createTime = [detail.createTime stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            }
            if (node.Query(@".message").find(@".pstatus").first() != nil) {
                detail.pstatus  = node.Query(@".message").find(@".pstatus").first().text();
            }
            detail.content = (NSString *)node.Query(@".message").text();
            detail.content = [self formatHMTLString:detail.content];
            NSString *contentHTML = (NSString *)node.Query(@".message").first().html();
            
            detail.quoteArray = [contentHTML quoteArray];
            detail.threadCreator = [Member getMemberWithHomepage:detail.homepage];
            
            NSString *mentionString = detail.content;
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:mentionString];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, attributedString.length)];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, attributedString.length)];
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineSpacing = 0.8;
            [attributedString addAttributes:@{
                                              NSParagraphStyleAttributeName:style
                                              }range:NSMakeRange(0, attributedString.length)];
            
            NSMutableArray *imageURLs = [[NSMutableArray alloc] init];
            for (SCQuote *quote in detail.quoteArray) {

                NSRange range = [contentHTML rangeOfString:quote.string];
                if (range.location != NSNotFound) {
                    quote.range = range;
                } else {
                    quote.range = NSMakeRange(0, 0);
                }
                if (quote.type == SCQuoteTypeUser) {
                    range = [mentionString rangeOfString:quote.string];
                    if (range.location != NSNotFound) {
                        quote.range = range;
                        [attributedString addAttribute:NSForegroundColorAttributeName value:(id)RGB(0x778087, 0.8) range:range];
                    }
                }
                if (quote.type == SCQuoteTypeImage) {
                    [imageURLs addObject:quote.identifier];
                }
                if (quote.type == SCQuoteTypeEmotion) {
                    [imageURLs addObject:quote.identifier];
                }
            }
            
            if (node.Query(@".img_list").first() != nil) {
                OCQueryObject *liArray = node.Query(@".img_list").find(@"li");
                for(OCGumboNode *liNode in liArray) {
                    
                    SCQuote *quote = [[SCQuote alloc] init];
                    NSString *identifier = liNode.Query(@"a").first().attr(@"href");
                    NSRange range = [contentHTML rangeOfString:identifier];
                    quote.range = range;
                    
                    if ([DataManager isSchoolNet]) {
                        identifier = [kSchoolNetURL stringByAppendingString:identifier];
                    } else {
                        identifier = [kPublicNetURL stringByAppendingString:identifier];
                    }
                    quote.identifier = identifier;
                    quote.string = identifier;
                    quote.type = SCQuoteTypeImage;
                    
                    [imageURLs addObject:identifier];
                    [detail.quoteArray addObject:quote];
                }
            }
            
            if (node.Query(@"img_one").first() != nil ) {
                SCQuote *quote = [[SCQuote alloc] init];
                NSString *identifier = node.Query(@".img_one").find(@"li").first().attr(@"href");
                quote.range = [contentHTML rangeOfString:identifier];
                if ([DataManager isSchoolNet]) {
                    identifier = [kSchoolNetURL stringByAppendingString:identifier];
                } else {
                    identifier = [kPublicNetURL stringByAppendingString:identifier];
                }
                
                quote.identifier = identifier;
                quote.string = identifier;
                quote.type = SCQuoteTypeImage;
                [detail.quoteArray addObject:quote];
                [imageURLs addObject:identifier];
            }
            
            
            
            detail.imageURLs = imageURLs;
            detail.attributedString = attributedString;
            
            NSMutableArray *contentArray = [[NSMutableArray alloc] init];

            
            RSContentStringModel *stringModel = [[RSContentStringModel alloc] init];
            stringModel.attributedString = attributedString;
            NSMutableArray *quotes = [[NSMutableArray alloc] init];
            
            [detail.quoteArray enumerateObjectsUsingBlock:^(SCQuote *quote, NSUInteger idx, BOOL *stop){
                if (quote.type == SCQuoteTypeUser) {
                    [quotes addObject:quote];
                }

                if (quote.type == SCQuoteTypeImage || quote.type == SCQuoteTypeEmotion) {
                    RSContentImageModel *imageModel = [[RSContentImageModel alloc] init];
                    imageModel.imageQuote = quote;
                    [contentArray addObject:imageModel];
                }
            }];
            
            stringModel.quoteArray = quotes;
            [contentArray addObject:stringModel];
            
            detail.contentsArray = contentArray;
            [threadDetailArray addObject:detail];
        }
    }
    ThreadDetailList *list;
    if (threadDetailArray.count) {
        list = [[ThreadDetailList alloc] init];
        list.list = threadDetailArray;
    }
    return list;
}


@end


@implementation RSContentBaseModel

- (instancetype) init {
    if (self = [super init]) {
        
    }
    return self;
}

@end

@implementation RSContentStringModel

- (instancetype) init {
    if (self = [super init]) {
        self.contentType = RSContentTypeString;
    }
    return self;
}

@end


@implementation RSContentImageModel

- (instancetype) init {
    if (self = [super init]) {
        self.contentType = RSContentTypeImage;
    }
    return self;
}

@end

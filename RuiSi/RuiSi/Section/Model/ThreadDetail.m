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
    
//    NSRange r ;
//    while ((r = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
//        string = [string stringByReplacingCharactersInRange:r withString:@""];
//    }
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
            NSInteger index = [elementArray indexOfObject:node];
            if (index <= countOfArray-1 ) {
                
            }
            ThreadDetail *detail = [[ThreadDetail alloc] init];
            NSString *idString = (NSString *)node.attr(@"id");
            detail.threadID = [idString substringFromIndex:3];
            detail.creatorName = (NSString *)node.Query(@".blue").first().text();
            detail.homepage = (NSString *)node.Query(@".blue").first().attr(@"href");
            detail.createTime = (NSString *)node.Query(@".rela").textArray().lastObject;
            detail.content = (NSString *)node.Query(@".message").first().html();
            detail.content = [[self class] formatHMTLString:detail.content];
            NSLog(@"%@",detail.content);
            
            detail.quoteArray = [detail.content quoteArray];
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
                NSRange range = [mentionString rangeOfString:quote.string];
                if (range.location != NSNotFound) {
                    mentionString = [mentionString stringByReplacingOccurrencesOfString:quote.string withString:[detail spaceWithLength:range.length]];
                    quote.range = range;
                    if (quote.type == SCQuoteTypeUser) {
                        [attributedString addAttribute:NSForegroundColorAttributeName value:(id)RGB(0x778087,0.8) range:NSMakeRange(range.location-1,1)];
                    }
                } else {
                    NSString *string = [quote.string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                    NSRange range = [mentionString rangeOfString:string];
                    if (range.location != NSNotFound) {
                        mentionString = [mentionString stringByReplacingOccurrencesOfString:quote.string withString:[detail spaceWithLength:range.length]];
                        quote.range = range;
                    } else {
                        quote.range = NSMakeRange(0, 0);
                    }
                }
                if (quote.type == SCQuoteTypeImage) {
                    [imageURLs addObject:quote.identifier];
                }
                if (quote.type == SCQuoteTypeEmotion) {
                    [imageURLs addObject:quote.identifier];
                }
            }
            
            detail.imageURLs = imageURLs;
            detail.attributedString = attributedString;
            
            
            NSMutableArray *contentArray = [[NSMutableArray alloc] init];
            __block NSUInteger lastStringIndex = 0;
            __block NSUInteger lastImageQuoteIndex = 0;
            [detail.quoteArray enumerateObjectsUsingBlock:^(SCQuote *quote, NSUInteger idx, BOOL *stop){
                if (quote.type == SCQuoteTypeImage) {
                    if (quote.range.location > lastStringIndex) {
                        RSContentStringModel *stringModel = [[RSContentStringModel alloc] init];
                        NSAttributedString *subString = [detail.attributedString attributedSubstringFromRange:NSMakeRange(lastStringIndex, quote.range.location-lastStringIndex)];
                        NSAttributedString *firstString = [subString attributedSubstringFromRange:NSMakeRange(0, 1)];
                        NSInteger stringOffset = 0;
                        if ([firstString.string isEqualToString:@"\n"]) {
                            stringOffset = 1;
                            subString = [attributedString attributedSubstringFromRange:NSMakeRange(lastStringIndex+stringOffset, quote.range.location-lastStringIndex)];
                        }
                        stringModel.attributedString = subString;
                        
                        NSMutableArray *quotes = [[NSMutableArray alloc] init];
                        for (NSInteger i = lastImageQuoteIndex;i < idx;i++) {
                            SCQuote *quote = detail.quoteArray[i];
                            quote.range = NSMakeRange(quote.range.location-lastStringIndex, quote.range.length);
                            [quotes addObject:quote];
                        }
                        if(quotes.count > 0) {
                            stringModel.quoteArray = quotes;
                        }
                        [contentArray addObject:stringModel];
                    }
                    RSContentImageModel *imageModel = [[RSContentImageModel alloc] init];
                    imageModel.imageQuote = quote;
                    [contentArray addObject:imageModel];
                    lastImageQuoteIndex = idx+1;
                    lastStringIndex = quote.range.location+quote.range.length;
                }
            }];
            
            if(lastStringIndex < attributedString.length) {
                RSContentStringModel *stringModel = [[RSContentStringModel alloc] init];
                NSAttributedString *subString = [attributedString attributedSubstringFromRange:NSMakeRange(lastStringIndex, attributedString.length-lastStringIndex)];
                NSAttributedString *firstString = [subString attributedSubstringFromRange:NSMakeRange(0, 1)];
                NSInteger stringOffset = 0;
                if ([firstString.string isEqualToString:@"\n"]) {
                    stringOffset = 1;
                    subString = [attributedString attributedSubstringFromRange:NSMakeRange(lastStringIndex+stringOffset, attributedString.length-lastStringIndex-stringOffset)];
                }
                stringModel.attributedString = subString;
                
                NSMutableArray *quotes = [[NSMutableArray alloc] init];
                for(NSInteger i = lastImageQuoteIndex;i < detail.quoteArray.count;i++) {
                    SCQuote *otherQuote = detail.quoteArray[i];
                    NSInteger location = otherQuote.range.location - lastStringIndex - stringOffset;
                    if (location >= 0) {
                        otherQuote.range = NSMakeRange(location, otherQuote.range.length);
                    } else {
                        otherQuote.range = NSMakeRange(0, 0);
                    }
                    [quotes addObject:detail.quoteArray[i]];
                }
                if (quotes.count > 0) {
                    stringModel.quoteArray = quotes;
                }
                [contentArray addObject:stringModel];
            }
            
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

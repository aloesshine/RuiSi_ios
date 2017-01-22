//
//  NSString+SCMention.m
//  newSponia
//
//  Created by Singro on 3/26/14.
//  Copyright (c) 2014 Sponia. All rights reserved.
//

#import "NSString+SCMention.h"

#import "SCQuote.h"
#import <RegexKitLite.h>
#import <HTMLParser.h>
#import "Constants.h"
#import "DataManager.h"
@implementation NSString (SCMention)

- (NSString *)enumerateMetionObjectsUsingBlock:(void (^)(id object, NSRange range))block {
    
    NSString *regex1 = @"\\[(.*?)\\]";
    
    NSMutableArray *ranges = [[NSMutableArray alloc] init];
    
    [self enumerateStringsMatchedByRegex:regex1 usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        [ranges addObject:[NSValue valueWithRange:*capturedRanges]];
        
    }];
    
    NSString *plainString = @"";
    
    if (ranges.count) {
        NSUInteger rangeIndex = 0;
        for (NSValue *value in ranges) {
            
            NSRange range = [value rangeValue];
            
            if (rangeIndex < range.location) {
                NSRange stringRange = (NSRange){rangeIndex, range.location - rangeIndex};
                NSString *normalString = [self substringWithRange:stringRange];
                stringRange.location = plainString.length;
                plainString = [plainString stringByAppendingString:normalString];
                block(normalString, stringRange);
                
            }
            
            NSString *quoteString = [self substringWithRange:range];
            
            NSArray *quoteArray = [quoteString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[()]"]];
            
            if (quoteArray.count == 5) {

                SCQuote *quote = [[SCQuote alloc] init];
                quote.string = @"";

                if ([quoteArray[1] isEqualToString:@"user"]) {
                    quote.type = SCQuoteTypeUser;
                    quote.identifier = quoteArray[2];
                    quote.string = quoteArray[3];
                } else if ([quoteArray[1] isEqualToString:@"url"]) {
                    quote.type = SCQuoteTypeLink;
                    quote.identifier = quoteArray[2];
                    quote.string = quoteArray[3];
                } else if ([quoteArray[1] isEqualToString:@"image"]) {
                    quote.type = SCQuoteTypeImage;
                    quote.identifier = quoteArray[2];
                    quote.string = quoteArray[3];
                }
                
                else {
                    quote.type = SCQuoteTypeNone;
                    quote.string = quoteString;
                }

                NSRange quoteRange = NSMakeRange(plainString.length, quote.string.length);
                quote.range = quoteRange;
                plainString = [plainString stringByAppendingString:quote.string];
                block(quote, quoteRange);
            } else {
                NSRange stringRange = NSMakeRange(plainString.length, plainString.length);
                plainString = [plainString stringByAppendingString:quoteString];
                block(quoteString, stringRange);
            }
            
            rangeIndex = range.location + range.length;
            
        }
        
        NSRange lastRange = [ranges.lastObject rangeValue];
        
        if (lastRange.location + lastRange.length < self.length && ranges.count) {
            
            NSRange lastStringRange = (NSRange){lastRange.location + lastRange.length, self.length - lastRange.location - lastRange.length};
            NSString *lastString = [self substringWithRange:lastStringRange];
            plainString = [plainString stringByAppendingString:lastString];
            block(lastString, NSMakeRange(plainString.length - lastString.length, lastString.length));
            
        }
        
    } else {
        block(self, NSMakeRange(0, plainString.length));
    }

    return plainString;
}

- (NSString *)metionPlainString {
    
    NSString *regex1 = @"\\[(.*?)\\]";
    
    NSMutableArray *ranges = [[NSMutableArray alloc] init];
    
    [self enumerateStringsMatchedByRegex:regex1 usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        [ranges addObject:[NSValue valueWithRange:*capturedRanges]];
        
    }];
    
    NSString *plainString = @"";
    
    if (ranges) {
        NSUInteger rangeIndex = 0;
        for (NSValue *value in ranges) {
            
            NSRange range = [value rangeValue];
            
            if (rangeIndex < range.location) {
                NSRange rangeString = (NSRange){rangeIndex, range.location - rangeIndex};
                NSString *normalString = [self substringWithRange:rangeString];
                plainString = [plainString stringByAppendingString:normalString];
                
            }
            
            NSString *quoteString = [self substringWithRange:range];
            
            NSArray *quoteArray = [quoteString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[()]"]];
            
            if (quoteArray.count == 5) {
                
                NSString *quoteString = @"";
                
                if ([quoteArray[1] isEqualToString:@"user"]) {
                    quoteString = quoteArray[3];
                } else {
                    quoteString = @"";
                }
                
                plainString = [plainString stringByAppendingString:quoteString];
            }
            
            rangeIndex = range.location + range.length;
            
        }
        
        NSRange lastRange = [ranges.lastObject rangeValue];
        
        if (lastRange.location + lastRange.length < self.length) {
            
            NSRange lastStringRange = (NSRange){lastRange.location + lastRange.length, self.length - lastRange.location - lastRange.length};
            NSString *lastString = [self substringWithRange:lastStringRange];
            plainString = [plainString stringByAppendingString:lastString];
            
        }
        
    } else {
        plainString = self;
    }
    
    return plainString;
}

- (NSString *)mentionStringFromHtmlString:(NSString *)htmlString {
    
    NSString *mentionString;
    
    @autoreleasepool {
        
        mentionString = [htmlString stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
        while ([mentionString rangeOfString:@"\n\n"].location != NSNotFound) {
            mentionString = [mentionString stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
        }
        
        NSError *error = nil;
        HTMLParser *parser = [[HTMLParser alloc] initWithString:[NSString stringWithFormat:@"<body>%@</body>", htmlString] error:&error];
        
        if (error) {
            NSLog(@"Error: %@", error);
        }
        
        HTMLNode *bodyNode = [parser body];
        mentionString = bodyNode.allContents;

        NSArray *aNodes = [bodyNode findChildTags:@"a"];
        
        for (HTMLNode *aNode in aNodes) {
            
            NSString *hrefString = [aNode getAttributeNamed:@"href"];
            NSLog(@"href:  %@", hrefString);
            
            if ([hrefString hasPrefix:@"/member/"]) {
                NSString *identifier = [hrefString stringByReplacingOccurrencesOfString:@"/member/" withString:@""];
                mentionString = [mentionString stringByReplacingOccurrencesOfString:aNode.allContents withString:[NSString stringWithFormat:@"[user(%@)%@]", identifier, identifier]];
            }
            
            if ([hrefString hasSuffix:@"jpeg"] ||
                [hrefString hasSuffix:@"png"] ||
                [hrefString hasSuffix:@"jpg"] ||
                [hrefString hasSuffix:@"gif"]) {
                
                NSString *identifier = hrefString;
                
                HTMLNode *imageNode = [aNode findChildTag:@"img"];
                identifier = [imageNode getAttributeNamed:@"src"];
                
                NSLog(@"raw:%@", aNode.rawContents);

                mentionString = [mentionString stringByReplacingOccurrencesOfString:aNode.allContents withString:[NSString stringWithFormat:@"[image(%@)%@]", identifier, hrefString]];
            }
            
            if ([hrefString hasPrefix:@"/t/"]) {
                NSString *identifier = [hrefString stringByReplacingOccurrencesOfString:@"/t/" withString:@""];
                mentionString = [mentionString stringByReplacingOccurrencesOfString:aNode.allContents withString:[NSString stringWithFormat:@"[topic(%@)%@]", identifier, hrefString]];
            }

        }

    }
    
    
    return mentionString;
}

- (NSMutableArray *)quoteArray {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    @autoreleasepool {
        
        NSString *mentionString = self;

        NSError *error = nil;
        HTMLParser *parser = [[HTMLParser alloc] initWithString:[NSString stringWithFormat:@"<body>%@</body>", self] error:&error];
        
        if (error) {
            NSLog(@"Error: %@", error);
        }
        
        HTMLNode *bodyNode = [parser body];
        mentionString = bodyNode.allContents;
        NSArray *aNodes = [bodyNode findChildTags:@"a"];
        for (HTMLNode *aNode in aNodes) {
            
            NSString *hrefString = [aNode getAttributeNamed:@"href"];
            SCQuote *quote = [[SCQuote alloc] init];
            NSRange range = [hrefString rangeOfString:@"mod=space&uid="];
            if (range.location != NSNotFound) {
                NSString *identifier = hrefString;
                NSString *atUserName = [aNode rawContents];
                if ([DataManager isSchoolNet]) {
                    identifier = [kSchoolNetURL stringByAppendingString:identifier];
                } else {
                    identifier = [kPublicNetURL stringByAppendingString:identifier];
                }
                quote.identifier = identifier;
                quote.string = atUserName;
                quote.type = SCQuoteTypeUser;
            }
            
            range = [hrefString rangeOfString:@"from=album"];
            if (range.location != NSNotFound) {
                
                NSString *identifier = hrefString;
                quote.string = identifier;
                if ([DataManager isSchoolNet]) {
                    identifier = [kSchoolNetURL stringByAppendingString:identifier];
                } else {
                    identifier = [kPublicNetURL stringByAppendingString:identifier];
                }
                quote.identifier = identifier;
                quote.type = SCQuoteTypeImage;
            }
            
            
            range = [hrefString rangeOfString:@"mod=redirect"];
            if (range.location != NSNotFound) {
                HTMLNode *node = [[aNode parent] parent];
                NSString *string = [node allContents];
                quote.identifier = string;
                quote.string = string;
                quote.type = SCQuoteTypeQuote;
            }
            
            if (quote.type == SCQuoteTypeNone) {
                quote.identifier = hrefString;
                quote.string = hrefString;
                quote.type = SCQuoteTypeLink;
            }
            
            [array addObject:quote];
            
        }

        NSArray *emotionNodes = [bodyNode findChildTags:@"img"];
        for(HTMLNode *emotionNode in emotionNodes) {
            NSString *srcString = [emotionNode getAttributeNamed:@"src"];
            NSRange range = [srcString rangeOfString:@"static/image/smiley"];
            if (range.location != NSNotFound) {
                SCQuote *quote = [[SCQuote alloc] init];
                NSString *imageSource;
                if ([DataManager isSchoolNet]) {
                    imageSource = [kSchoolNetURL stringByAppendingString:srcString];
                } else {
                    imageSource = [kPublicNetURL stringByAppendingString:srcString];
                }
                quote.identifier = imageSource;
                quote.string = srcString;
                quote.type = SCQuoteTypeEmotion;
                [array addObject:quote];
            }
        }
    }
    return array;
}



@end

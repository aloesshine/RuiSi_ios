//
//  ThreadDetailBodyCell.m
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/7.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "ThreadDetailBodyCell.h"
#import "SCQuote.h"
#import "TTTAttributedLabel.h"
#import "Constants.h"
#import "EXTScope.h"
#import "SDWebImageManager.h"
#import "BlocksKit.h"
#import "UIView+BlocksKit.h"
static CGFloat const kBodyFontSize = 16.0f;
#define KBodyLabelWidth (kScreen_Width-20)


@interface ThreadDetailBodyCell() <TTTAttributedLabelDelegate>
@property (nonatomic,strong) TTTAttributedLabel *bodyLabel;
@property (nonatomic,assign) NSInteger bodyHeight;
@property (nonatomic,strong) NSMutableArray *attributedLabelArray;
@property (nonatomic,strong) NSMutableArray *imageArray;
@property (nonatomic,strong) NSMutableArray *imageButtonArray;
@property (nonatomic,strong) NSMutableArray *imageUrls;
@property (nonatomic,strong) UIView *borderLineView;
@end



@implementation ThreadDetailBodyCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.attributedLabelArray = [[NSMutableArray alloc] init];
        self.imageArray = [[NSMutableArray alloc] init];
        self.imageButtonArray = [[NSMutableArray alloc] init];
        self.bodyLabel = [self createAttributedLabel];
    }
    return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];
    self.borderLineView.frame = CGRectMake(10, self.frame.size.height-10, kScreen_Width-20, 0.5);
    [self layoutContent];
    
}

- (TTTAttributedLabel *) createAttributedLabel {
    TTTAttributedLabel *attributedLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    attributedLabel.textColor = [UIColor blackColor];
    attributedLabel.font = [UIFont systemFontOfSize:kBodyFontSize];
    attributedLabel.numberOfLines = 1;
    attributedLabel.lineBreakMode = NSLineBreakByWordWrapping;
    attributedLabel.delegate = self;
    [self addSubview:attributedLabel];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 0.8;
    attributedLabel.linkAttributes = @{
                                       NSForegroundColorAttributeName:[UIColor blueColor],                                       NSFontAttributeName: [UIFont systemFontOfSize:kBodyFontSize],
                                       NSParagraphStyleAttributeName: style
                                       };
    attributedLabel.activeLinkAttributes = @{
                                             (NSString *)kCTUnderlineStyleAttributeName: [NSNumber numberWithBool:NO],
                                             NSForegroundColorAttributeName: [UIColor whiteColor],
                                             (NSString *)kTTTBackgroundFillColorAttributeName: (__bridge id)[[UIColor blueColor] CGColor],
                                             (NSString *)kTTTBackgroundCornerRadiusAttributeName:[NSNumber numberWithFloat:4.0f]
                                             };
    [self.attributedLabelArray addObject:attributedLabel];
    return attributedLabel;
}

- (UIImageView *) createImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.clipsToBounds = YES;
    [self addSubview:imageView];
    UIButton *button = [[UIButton alloc] init];
    [self addSubview:button];
    [self.imageButtonArray addObject:button];
    [self.imageArray addObject:imageView];
    return imageView;
}
- (void) layoutContent {
    if (! self.threadDetail.contentsArray) {
        self.bodyLabel.attributedText = self.threadDetail.attributedString;
        self.bodyHeight = [TTTAttributedLabel sizeThatFitsAttributedString:self.threadDetail.attributedString withConstraints:CGSizeMake(KBodyLabelWidth, 0) limitedToNumberOfLines:0].height;
        if (! self.bodyLabel.attributedText.length) {
            self.bodyHeight = 0;
        }
        self.bodyLabel.frame = CGRectMake(10, 5, KBodyLabelWidth, self.bodyHeight);
        for(SCQuote *quote in self.threadDetail.quoteArray) {
            [self.bodyLabel addLinkToURL:[NSURL URLWithString:quote.identifier] withRange:quote.range];
        }
    } else {
        __block NSUInteger labelIndex = 0;
        __block NSUInteger imageIndex = 0;
        __block CGFloat offsetY = 10;
        
#warning init content array
        @weakify(self);
        [self.threadDetail.contentsArray enumerateObjectsUsingBlock:^(RSContentBaseModel  *baseModel, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            if (baseModel.contentType == RSContentTypeString) {
                RSContentStringModel *stringModel = (RSContentStringModel *)baseModel;
                TTTAttributedLabel *label;
                if (self.attributedLabelArray.count <= labelIndex) {
                    label = [self createAttributedLabel];
                } else {
                    label = self.attributedLabelArray[labelIndex];
                }
                label.attributedText = stringModel.attributedString;
                CGFloat labelHeight = [TTTAttributedLabel sizeThatFitsAttributedString:stringModel.attributedString withConstraints:CGSizeMake(KBodyLabelWidth, 0) limitedToNumberOfLines:0].height;
                if (stringModel.attributedString.length == 0) {
                    labelHeight = 0;
                }
                label.frame = CGRectMake(10, offsetY, KBodyLabelWidth, labelHeight);
                for(SCQuote *quote in stringModel.quoteArray) {
                    if (stringModel.attributedString.length >= quote.range.location+quote.range.length) {
                        [label addLinkToURL:[NSURL URLWithString:quote.identifier] withRange:quote.range];
                    }
                }
                labelIndex++;
                offsetY += (label.frame.size.height+7);
            }
            if (baseModel.contentType == RSContentTypeImage) {
                RSContentImageModel *imageModel = (RSContentImageModel *)baseModel;
                UIImageView *imageView;
                if (self.imageArray.count <= imageIndex) {
                    imageView = [self createImageView];
                } else {
                    imageView = self.imageArray[imageIndex];
                }
                
                CGSize imageSize = [[self class] imageSizeForKey:imageModel.imageQuote.identifier];
                imageView.frame = CGRectMake(10, offsetY, imageSize.width, imageSize.height);
                UIImage *cachedImage = [[self class] imageForKey:imageModel.imageQuote.identifier];
                if (cachedImage) {
                    imageView.contentMode = UIViewContentModeScaleAspectFill;
                    imageView.image = cachedImage;
                    imageView.backgroundColor = [UIColor clearColor];
                } else {
                    imageView.backgroundColor = [UIColor whiteColor];
                    imageView.contentMode = UIViewContentModeCenter;
#warning Placeholder image
                    //imageView.image = [UIImage imageNamed:@"threadDetail_placeHolder"];
#warning Replace identifier as image's url
                    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imageModel.imageQuote.identifier] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        @strongify(self);
                        if (cacheType == SDImageCacheTypeNone && self.reloadCellBlock && finished) {
                            imageView.image = nil;
                            self.reloadCellBlock();
                        }
                    }];
                }
                offsetY += (imageView.frame.size.height + 7);
                UIButton *button = self.imageButtonArray[imageIndex];
                button.frame = imageView.frame;
                NSUInteger imageIndexNoneBlock = imageIndex;
                [button bk_removeAllBlockObservers];
                [button bk_whenTapped:^{
                    @strongify(self);
                    NSLog(@"Need to add an image browser.");
                    
                }];
                imageIndex++;
            }
            
        }];
    }
}

+ (CGSize) imageSizeForKey:(NSString *)key {
    UIImage *cachedImage = [self imageForKey:key];
    if (cachedImage) {
        CGFloat height = cachedImage.size.height;
        CGFloat width = cachedImage.size.width;
        if (width > KBodyLabelWidth) {
            height *= KBodyLabelWidth / width;
            width = KBodyLabelWidth;
        }
        return CGSizeMake(width, height);
    } else {
        return CGSizeMake(KBodyLabelWidth, 60);
    }
}
+ (UIImage *)imageForKey:(NSString *)key {
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    if (!cachedImage) {
        cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    }
    return cachedImage;
}


+ (CGFloat)getCellHeightWithThreadDetail:(ThreadDetail *)threadDetail {
    return 0;
}


- (SCQuote *)quoteForIdentifier:(NSString *)identifier {
    for (SCQuote *quote in self.threadDetail.quoteArray) {
        if ([quote.identifier isEqualToString:identifier]) {
            return quote;
        }
    }
    return nil;
}

- (void) attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    SCQuote *quote = [self quoteForIdentifier:url.absoluteString];
    if (quote) {
        if (quote.type == SCQuoteTypeUser) {
#warning ProfileVC
        }
        if (quote.type == SCQuoteTypeImage) {
#warning ImageBrowser
        }
        if (quote.type == SCQuoteTypeLink) {
#warning WebViewVC
        }
    }
    
    
}



@end

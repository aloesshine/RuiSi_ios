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
        
    }
}

@end

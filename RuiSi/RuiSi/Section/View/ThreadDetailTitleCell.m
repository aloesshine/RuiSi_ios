//
//  ThreadDetailTitleCell.m
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/6.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "ThreadDetailTitleCell.h"
#import "Constants.h"
#import "Helper.h"
#define kTitleLabelFont 18
#define kTitleLabelWidth (kScreen_Width-20)

@interface ThreadDetailTitleCell()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,assign) NSInteger titleHeight;
@end


@implementation ThreadDetailTitleCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:kTitleLabelFont];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:self.titleLabel];
    }
    
    return self;
}



- (void)setThread:(Thread *)thread {
    _thread = thread;
    self.titleLabel.text = thread.title;
    //[self.titleLabel sizeToFit];
    self.titleHeight = [Helper getTextHeightWithText:thread.title Font:[UIFont systemFontOfSize:kTitleLabelFont] Width:kTitleLabelWidth] + 1;
    [self.titleLabel sizeToFit];
    [self setNeedsLayout];
}

- (void) layoutSubviews {
    self.titleLabel.frame = CGRectMake(10, 15, kTitleLabelWidth, self.titleHeight);
}

+ (CGFloat)getCellHeightWithThread:(Thread *)thread {
    NSInteger titleHeight = [Helper getTextHeightWithText:thread.title Font:[UIFont systemFontOfSize:kTitleLabelFont] Width:kTitleLabelWidth] + 1;
    if (thread.title.length > 0) {
        return titleHeight+25;
    } else {
        return 0;
    }
}
@end

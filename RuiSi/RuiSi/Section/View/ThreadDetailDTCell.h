//
//  ThreadDetailDTCell.h
//  RuiSi
//
//  Created by 汪泽伟 on 2017/1/21.
//  Copyright © 2017年 aloes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThreadDetail.h"
#import "DTAttributedTextContentView.h"
#import "DTLazyImageView.h"
#import <DTFoundation/DTWeakSupport.h>
@interface ThreadDetailDTCell : UITableViewCell <DTAttributedTextContentViewDelegate,DTLazyImageViewDelegate>
@property (nonatomic,strong) ThreadDetail *detail;
@property (nonatomic,strong) UINavigationController *navi;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIImageView *avatarImageView;

@property (nonatomic,strong) NSAttributedString *attributedString;
@property (nonatomic,assign) BOOL hasFixedRowHeight;
@property (nonatomic,DT_WEAK_PROPERTY) id<DTAttributedTextContentViewDelegate> textDelegate;
@property (nonatomic,readonly) DTAttributedTextContentView *attributedTextContentView;



- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier accessoryType:(UITableViewCellAccessoryType)accessoryType;
- (void) setHTMLString:(NSString *)html;
- (CGFloat) requiredRowHeightInTableView:(UITableView *)tableView;
- (void) configureDetail:(ThreadDetail *)threadDetail;
@end

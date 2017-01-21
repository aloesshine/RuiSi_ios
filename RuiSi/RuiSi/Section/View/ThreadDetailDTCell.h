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
#import <DTFoundation/DTWeakSupport.h>
@interface ThreadDetailDTCell : UITableViewCell
@property (nonatomic,strong) ThreadDetail *detail;
@property (nonatomic,strong) UINavigationController *navi;
@property (nonatomic,strong) NSAttributedString *attributedString;
@property (nonatomic,assign) BOOL hasFixedRowHeight;
@property (nonatomic,DT_WEAK_PROPERTY) IBOutlet id<DTAttributedTextContentViewDelegate> textDelegate;
@property (nonatomic,readonly) DTAttributedTextContentView *attributedTextContextView;
- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier accessoryType:(UITableViewCellAccessoryType)accessoryType;
- (void) setHTMLString:(NSString *)html;
- (CGFloat) requiredRowHeightInTableView:(UITableView *)tableView;
@end

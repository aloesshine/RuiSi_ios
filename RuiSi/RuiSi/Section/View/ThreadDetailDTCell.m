//
//  ThreadDetailDTCell.m
//  RuiSi
//
//  Created by 汪泽伟 on 2017/1/21.
//  Copyright © 2017年 aloes. All rights reserved.
//

#import "ThreadDetailDTCell.h"
#import "DTAttributedTextCell.h"
#import "DTCSSStylesheet.h"
#import "DTCoreText.h"
#import <DTFoundation/DTLog.h>
#import "BlocksKit+UIKit.h"
#import "EXTScope.h"
#import "UIView+BlocksKit.h"
#import "ProfileViewController.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"
#import "DTLazyImageView.h"
#import "ProfileViewController.h"


static CGFloat const kAvatarHeight = 32.0f;

@implementation ThreadDetailDTCell
{
    //DTAttributedTextContentView * _attributedTextContextView;
    DT_WEAK_VARIABLE id <DTAttributedTextContentViewDelegate> _textDelegate;
    NSUInteger _htmlHash;
    BOOL _hasFixedRowHeight;
    DT_WEAK_VARIABLE UITableView *_containingTableView;
}
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier accessoryType:(UITableViewCellAccessoryType)accessoryType {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.textDelegate = self;
        
        self.hasFixedRowHeight = NO;
        self.attributedTextContextView.edgeInsets = UIEdgeInsetsMake(5, 50, 5, 10);
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.avatarImageView = [[UIImageView alloc] init];
        self.avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.avatarImageView.layer.cornerRadius = 2;
        self.avatarImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.avatarImageView];
        
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.font = [UIFont systemFontOfSize:14.0];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.clipsToBounds = YES;
        [self.contentView addSubview:self.nameLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.textColor = [UIColor blackColor];
        self.timeLabel.font = [UIFont systemFontOfSize:12.0];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.timeLabel.clipsToBounds = YES;
        [self.contentView addSubview:self.timeLabel];
        
    }
    return self;
}

- (void)dealloc
{
    _textDelegate = nil;
    _containingTableView = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.superview)
    {
        return;
    }
    self.avatarImageView.frame = CGRectMake(10, 10, kAvatarHeight, kAvatarHeight);
    self.nameLabel.frame = CGRectMake(50, 8, kScreen_Width-50, 16);
    self.timeLabel.frame = CGRectMake(50, 32, kScreen_Width-50, 10);
    
    if (_hasFixedRowHeight)
    {
        self.attributedTextContextView.frame = self.contentView.bounds;
    }
    else
    {
        CGFloat neededContentHeight = [self requiredRowHeightInTableView:_containingTableView];
        
        // after the first call here the content view size is correct
        //CGRect frame = CGRectMake(0, 0, self.contentView.bounds.size.width, neededContentHeight);
        CGRect frame = CGRectMake(0, 45, self.contentView.bounds.size.width, neededContentHeight);
        self.attributedTextContextView.frame = frame;
    }
}

- (UITableView *)_findContainingTableView
{
    UIView *tableView = self.superview;
    
    while (tableView)
    {
        if ([tableView isKindOfClass:[UITableView class]])
        {
            return (UITableView *)tableView;
        }
        
        tableView = tableView.superview;
    }
    
    return nil;
}

- (NSMutableArray *)photoURLs {
    _photoURLs = [[NSMutableArray alloc] init];
    return _photoURLs;
}


- (void) setDetail:(ThreadDetail *)threadDetail {
    _detail = threadDetail;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.detail.threadCreator.memberAvatarSmall] placeholderImage:[UIImage imageNamed:@"default_avatar_small"]];
    [self.nameLabel setText:threadDetail.threadCreator.memberName];
    [self.timeLabel setText:threadDetail.createTime];
    [self.nameLabel sizeToFit];
    [self.timeLabel sizeToFit];
    
    
    [self setHTMLString:threadDetail.content];
    [self setNeedsLayout];
}


- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    _containingTableView = [self _findContainingTableView];
    
    // on < iOS 7 we need to make the background translucent to avoid artifacts at rounded edges
    if (_containingTableView.style == UITableViewStyleGrouped)
    {
        if (NSFoundationVersionNumber < DTNSFoundationVersionNumber_iOS_7_0)
        {
            _attributedTextContentView.backgroundColor = [UIColor clearColor];
        }
    }
}

// http://stackoverflow.com/questions/4708085/how-to-determine-margin-of-a-grouped-uitableview-or-better-how-to-set-it/4872199#4872199
- (CGFloat)_groupedCellMarginWithTableWidth:(CGFloat)tableViewWidth
{
    CGFloat marginWidth;
    if(tableViewWidth > 20)
    {
        if(tableViewWidth < 400 || [UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
        {
            marginWidth = 10;
        }
        else
        {
            marginWidth = MAX(31.f, MIN(45.f, tableViewWidth*0.06f));
        }
    }
    else
    {
        marginWidth = tableViewWidth - 10;
    }
    return marginWidth;
}

- (CGFloat)requiredRowHeightInTableView:(UITableView *)tableView
{
    if (_hasFixedRowHeight)
    {
        DTLogWarning(@"You are calling %s even though the cell is configured with fixed row height", (const char *)__PRETTY_FUNCTION__);
    }
    
    BOOL ios6Style = (NSFoundationVersionNumber < DTNSFoundationVersionNumber_iOS_7_0);
    CGFloat contentWidth = tableView.frame.size.width;
    
    // reduce width for grouped table views
    if (ios6Style && tableView.style == UITableViewStyleGrouped)
    {
        contentWidth -= [self _groupedCellMarginWithTableWidth:contentWidth] * 2;
    }
    
    // reduce width for accessories
    
    switch (self.accessoryType)
    {
        case UITableViewCellAccessoryDisclosureIndicator:
        {
            contentWidth -= ios6Style ? 20.0f : 10.0f + 8.0f + 15.0f;
            break;
        }
            
        case UITableViewCellAccessoryCheckmark:
        {
            contentWidth -= ios6Style ? 20.0f : 10.0f + 14.0f + 15.0f;
            break;
        }
#if TARGET_OS_IOS
        case UITableViewCellAccessoryDetailDisclosureButton:
        {
            contentWidth -= ios6Style ? 33.0f : 10.0f + 42.0f + 15.0f;
            break;
        }
            
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
        case UITableViewCellAccessoryDetailButton:
        {
            contentWidth -= 10.0f + 22.0f + 15.0f;
            break;
        }
#endif
#endif
        case UITableViewCellAccessoryNone:
        {
            break;
        }
            
        default:
        {
            DTLogWarning(@"AccessoryType %d not implemented on %@", self.accessoryType, NSStringFromClass([self class]));
            break;
        }
    }
    
    CGSize neededSize = [self.attributedTextContextView suggestedFrameSizeToFitEntireStringConstraintedToWidth:contentWidth];
    
    // note: non-integer row heights caused trouble < iOS 5.0
    return neededSize.height + 45;
}

#pragma mark Setters

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setHTMLString:(NSString *)html
{
    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    [options setObject:[NSNumber numberWithFloat:16.0] forKey:DTDefaultFontSize];
    [options setObject:[NSURL URLWithString:kPublicNetURL] forKey:NSBaseURLDocumentOption];
    [self setHTMLString:html options:options];
}

- (void) setHTMLString:(NSString *)html options:(NSDictionary*) options {
    
    NSUInteger newHash = [html hash];
    
    if (newHash == _htmlHash)
    {
        return;
    }
    
    _htmlHash = newHash;
    
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:NULL];
    self.attributedString = string;
    
    [self setNeedsLayout];
    
}

- (void)setAttributedString:(NSAttributedString *)attributedString
{
    // passthrough
    self.attributedTextContextView.attributedString = attributedString;
}

- (NSAttributedString *)attributedString
{
    // passthrough
    return _attributedTextContentView.attributedString;
}

- (DTAttributedTextContentView *)attributedTextContextView
{
    if (!_attributedTextContentView)
    {
        // don't know size because there's no string in it
        
        _attributedTextContentView = [[DTAttributedTextContentView alloc] initWithFrame:self.contentView.bounds];
        _attributedTextContentView.edgeInsets = UIEdgeInsetsMake(5, 5, 5, 2);
        _attributedTextContentView.layoutFrameHeightIsConstrainedByBounds = _hasFixedRowHeight;
        _attributedTextContentView.delegate = _textDelegate;
        _attributedTextContentView.shouldDrawLinks = YES;
        _attributedTextContentView.shouldDrawImages = YES;
        [self.contentView addSubview:_attributedTextContentView];
    }
    
    return _attributedTextContentView;
}

- (void)setHasFixedRowHeight:(BOOL)hasFixedRowHeight
{
    if (_hasFixedRowHeight != hasFixedRowHeight)
    {
        _hasFixedRowHeight = hasFixedRowHeight;
        
        [self setNeedsLayout];
    }
}

- (void)setTextDelegate:(id)textDelegate
{
    _textDelegate = textDelegate;
    _attributedTextContentView.delegate = _textDelegate;
}

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame {
    if ([attachment isKindOfClass:[DTImageTextAttachment class]]) {
        DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
        imageView.delegate = self;
        imageView.image = [(DTImageTextAttachment *)attachment image];
        imageView.url = attachment.contentURL;
        NSURL *url = attachment.contentURL;
        [self.photoURLs addObject:url];
        if(attachment.hyperLinkURL) {
            imageView.userInteractionEnabled = YES;
            DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:imageView.bounds];
            button.URL = attachment.hyperLinkURL;
            button.minimumHitSize = CGSizeMake(25, 25);
            //button.GUID = attachment.hyperLinkGUID;
            [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
        }
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        return imageView;
    }
    return nil;
}


- (void) linkPushed: (UIButton *)sender {
    self.photoBrowser = [[IDMPhotoBrowser alloc] initWithPhotos:self.photoURLs animatedFromView:sender];
    UITableViewController *tableViewController = (UITableViewController *)_containingTableView.dataSource;
    [tableViewController presentViewController:self.photoBrowser animated:YES completion:nil];
}

- (UIView *) attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForLink:(NSURL *)url identifier:(NSString *)identifier frame:(CGRect)frame {
    NSString *urlString = url.absoluteString;
    NSString *fixedUrlString = [urlString stringByAppendingString:@"&mobile=2"];
    NSURL *fixedUrl = [NSURL URLWithString:fixedUrlString];
    if ([urlString containsString:@"mod=space&uid="]) {
        DTLinkButton *showUserInfoButton = [[DTLinkButton alloc] initWithFrame:frame];
        [showUserInfoButton addTarget:self action:@selector(showUserInfo:) forControlEvents:UIControlEventTouchUpInside];
        showUserInfoButton.URL = fixedUrl;
        return showUserInfoButton;
    } else {
        DTLinkButton *openUrlInSafariButton = [[DTLinkButton alloc] initWithFrame:frame];
        openUrlInSafariButton.URL = fixedUrl;
        [openUrlInSafariButton addTarget:self action:@selector(openUrlInSafari:) forControlEvents:UIControlEventTouchUpInside];
        return openUrlInSafariButton;
    }
}

- (void) showUserInfo:(DTLinkButton *)sender {
    ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
    profileViewController.homepage = sender.URL.absoluteString;
    UITableViewController *controller = (UITableViewController *)_containingTableView.dataSource;
    [controller.navigationController pushViewController:profileViewController animated:YES];
}

- (void) openUrlInSafari:(DTLinkButton *)sender {
    if(sender.URL) {
        [self.delegate WillOpenInSafariViewControllerWithURL:sender.URL];
    }
}

#pragma mark - DTLazyImageViewDelegate

- (void)lazyImageView:(DTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size {
    NSURL *url = lazyImageView.url;
    CGSize imageSize = size;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@",url];
    BOOL didUpdate = NO;
    
    for (DTTextAttachment *oneAttachment in [self.attributedTextContentView.layoutFrame textAttachmentsWithPredicate:pred]) {
        //oneAttachment.originalSize = imageSize;
        if ( CGSizeEqualToSize(oneAttachment.originalSize , CGSizeZero)) {
            oneAttachment.originalSize = imageSize;
            oneAttachment.displaySize = imageSize;
            didUpdate = YES;
        }
    }
    if(didUpdate) {
        self.attributedTextContentView.layouter = nil;
        [self.attributedTextContentView relayoutText];
    }
    
}


@synthesize attributedTextContentView = _attributedTextContentView;
@synthesize hasFixedRowHeight = _hasFixedRowHeight;
@synthesize textDelegate = _textDelegate;
@synthesize nameLabel;
@synthesize timeLabel;
@synthesize avatarImageView;
@end

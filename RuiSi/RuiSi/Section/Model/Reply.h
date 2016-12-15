//
//  Reply.h
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/4.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "BaseModel.h"
#import "Member.h"
@interface Reply : BaseModel

@property (nonatomic,copy) NSString *replyID;
@property (nonatomic,copy) NSString *replierName;
@property (nonatomic,copy) NSString *replyTime;
@property (nonatomic,copy) NSString *homePage;
@property (nonatomic,strong) NSArray *quoteArray;
@property (nonatomic,copy) NSAttributedString *attributeString;
@property (nonatomic,strong) NSArray *contentArray;
@property (nonatomic,strong) NSArray *imageURLs;

@property (nonatomic,strong) Member *replyCreator;
@end



@interface ReplyList : NSObject
@property (nonatomic,strong) NSArray *list;

- (instancetype) initWithArray:(NSArray *)array;
+ (ReplyList *)getReplyListFromResponseObject:(id) responseObject;
- (NSInteger) countOfList;
@end

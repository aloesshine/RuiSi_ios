//
//  ThreadDetail.h
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/1.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "BaseModel.h"
#import "Member.h"
#import "SCQuote.h"

typedef NS_ENUM(NSInteger,RSContentType) {
    RSContentTypeString,
    RSContentTypeImage,
};


@interface ThreadDetail : BaseModel
@property (nonatomic,strong) NSString *threadID;
@property (nonatomic,strong) NSString *creatorName;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *homepage;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,strong) NSArray *quoteArray;
@property (nonatomic,copy) NSAttributedString *attributedString;
@property (nonatomic,strong) NSArray* contentsArray;
@property (nonatomic,strong) NSArray *imageURLs;
@property (nonatomic,strong) Member *threadCreator;

- (void) configureMember;
@end


@interface ThreadDetailList : BaseModel
@property (nonatomic,strong) NSArray *list;
- (instancetype) initWithArray:(NSArray *)array;
- (NSInteger) countOfList;
+ (ThreadDetailList *)getThreadDetailListFromResponseObject:(id) responseObject;
@end


@interface RSContentBaseModel : NSObject
@property (nonatomic,assign) RSContentType contentType;
@end

@interface RSContentStringModel : RSContentBaseModel
@property (nonatomic,copy) NSAttributedString *attributedString;
@property (nonatomic,strong) NSArray *quoteArray;
@end


@interface RSContentImageModel : RSContentBaseModel
@property (nonatomic,strong) SCQuote *imageQuote;
@end

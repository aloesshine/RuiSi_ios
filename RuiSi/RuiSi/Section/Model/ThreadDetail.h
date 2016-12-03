//
//  ThreadDetail.h
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/1.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "BaseModel.h"
#import "Member.h"
@interface ThreadDetail : BaseModel
@property (nonatomic,strong) Member *threadCreator;
@property (nonatomic,copy) NSString *threadCreateTime;
@property (nonatomic,copy) NSString *threadContents;
@property (nonatomic,strong) NSArray *threadImageURLs;
@property (nonatomic,strong) NSString *threadID;




@end


@interface ThreadDetailList : BaseModel
@property (nonatomic,strong) NSArray *list;
- (instancetype) initWithArray:(NSArray *)array;
- (NSInteger) countOfList;
+ (ThreadDetailList *)getThreadDetailListWithURL:(NSString *)urlString;
@end

//
//  Post.h
//  RuiSi
//
//  Created by aloes on 2016/11/23.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "Member.h"
@interface Thread : BaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *titleURL;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *reviewCount;
@property (nonatomic, assign) BOOL hasPic;
@property (nonatomic,copy) NSString *tid;
@property (nonatomic,copy) NSString *createTime;
@end


@interface ThreadList : NSObject

@property (nonatomic,strong) NSArray *list;

- (instancetype) initWithArray:(NSArray *)array;

+ (ThreadList *)getThreadListFromResponseObject:(id) responseObject;
- (NSInteger) countOfList;
@end

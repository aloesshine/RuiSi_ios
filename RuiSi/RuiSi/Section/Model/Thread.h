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

// 普通的获取帖子列表
+ (ThreadList *)getThreadListFromResponseObject:(id) responseObject;

// 用于我的收藏中的获取列表
+ (ThreadList *)getThreadListForFavoritesFromResponseObject:(id) responseObject;

- (NSInteger) countOfList;
@end

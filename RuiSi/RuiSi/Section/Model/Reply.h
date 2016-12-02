//
//  Reply.h
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/1.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "BaseModel.h"
#import "Member.h"
@interface Reply : BaseModel
@property (nonatomic,strong) Member *replyCreator;
@property (nonatomic,copy) NSString *replyContents;
@property (nonatomic,copy) NSString *replyCreateTime;
@property (nonatomic,strong) NSArray *replyImageURLs;
@property (nonatomic,copy) NSString *replyID;
@end


@interface ReplyList : NSObject
@property (nonatomic,strong) NSArray *list;
- (instancetype) initWithArray:(NSArray *)array;

@end

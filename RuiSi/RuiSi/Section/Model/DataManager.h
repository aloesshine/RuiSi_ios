//
//  DataManager.h
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/2.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import <AFNetworking.h>
#import "Thread.h"
#import "ThreadDetail.h"
static NSString *const kUserIsLogin = @"UserIsLogin";
static NSString *const kUserName = @"UserName";
static NSString *const kUserID = @"UserID";
static NSString *const kUserAvatarURL = @"UserAvatarURL";


typedef NS_ENUM(NSInteger,RequestMethod) {
    RequestMethodHTTPPost = 1,
    RequestMethodHTTPGet = 2,
};


@interface DataManager : NSObject

@property (nonatomic,strong) User *user;

+ (instancetype) manager;
+ (BOOL) isSchoolNet;



- (NSURLSessionDataTask *) getThreadListWithFid:(NSString *)fid
                                           page:(NSNumber *)page
                                        success:(void (^)(ThreadList *threadList))success
                                        failure:(void (^)(NSError *error))failure;


- (NSURLSessionDataTask *) getThreadDetailListWithTid:(NSString *)tid
                                              success:(void (^)(ThreadDetailList *threadDetailList))success
                                              failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *) getMoreThreadDetailListWithTid:(NSString *)tid
                                                     page:(NSNumber *)page
                                                  success:(void (^)(ThreadDetailList *list))success
                                                  failure:(void (^)(NSError *error))failure;


- (NSURLSessionDataTask *) getMemberWithUid:(NSString *)uid
                                    success:(void (^)(Member *member))success
                                    failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *) replyCreateWithFid:(NSString *)fid
                                     ThreadID:(NSString *)tid
                               ThreadDetailID:(NSString *)pid
                                         page:(NSNumber *)page
                                           content:(NSString *)content
                                           success:(void (^)(ThreadDetail *detail))success
                                           failure:(void (^)(NSError *error)) failure;

- (NSURLSessionDataTask *) userLoginWithUserName:(NSString *)username
                                        password:(NSString *)password
                                         success:(void (^)(NSString *message))success
                                         failure:(void (^)(NSError *error)) error;
- (void) UserLogout;

@end

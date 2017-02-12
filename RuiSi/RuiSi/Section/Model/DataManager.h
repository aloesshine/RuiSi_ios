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
#import "Reply.h"
#import "Message.h"
static NSString *const kUserIsLogin = @"UserIsLogin";
static NSString *const kUserName = @"UserName";
static NSString *const kUserID = @"UserID";
static NSString *const kUserAvatarURL = @"UserAvatarURL";
static NSString *const kUserHomepage = @"UserHomepage";

typedef NS_ENUM(NSInteger,RequestMethod) {
    RequestMethodHTTPPost = 1,
    RequestMethodHTTPGet = 2,
};


typedef NS_ENUM(NSInteger, RSErrorType) {
    
    RSErrorTypeNoOnceAndNext          = 700,
    RSErrorTypeLoginFailure           = 701,
    RSErrorTypeRequestFailure         = 702,
    RSErrorTypeGetFeedURLFailure      = 703,
    RSErrorTypeGetTopicListFailure    = 704,
    RSErrorTypeGetNotificationFailure = 705,
    RSErrorTypeGetFavUrlFailure       = 706,
    RSErrorTypeGetMemberReplyFailure  = 707,
    RSErrorTypeGetTopicTokenFailure   = 708,
    RSErrorTypeGetCheckInURLFailure   = 709,
    
};

@interface DataManager : NSObject

@property (nonatomic,strong) User *user;

+ (instancetype) manager;
+ (BOOL) isSchoolNet;
+ (BOOL) isUserLogined;



- (NSURLSessionDataTask *) getMessageListSuccess:(void (^)(MessageList *messageList))success
failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *) getThreadListWithFid:(NSString *)fid
                                           page:(NSInteger )page
                                        success:(void (^)(ThreadList *threadList))success
                                        failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *) getThreadListWithUid:(NSString *)uid
                                        success:(void (^)(ThreadList *threadList))success
                                        failure:(void (^)(NSError *error)) failure;

- (NSURLSessionDataTask *) getFavoriteThreadListWithUid:(NSString *)uid
                                                success:(void (^)(ThreadList *threadList))success
                                                         failure:(void (^)(NSError *error)) failure;

- (NSURLSessionDataTask *) getThreadDetailListWithTid:(NSString *)tid
                                                 page:(NSInteger )page
                                              success:(void (^)(ThreadDetailList *threadDetailList))success
                                              failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *) getCreatorOnlyThreadDetailListWithTid:(NSString *)tid
                                                            page:(NSInteger )page
                                                        authorid:(NSString *)authorid
                                                         success:(void (^)(ThreadDetailList *threadDetailList))success
                                                         failure:(void (^)(NSError *error)) failure;

- (NSURLSessionDataTask *) favorThreadWithTid:(NSString *)tid
                                     formhash:(NSString *)formhash
                                      success:(void (^)(NSString *message)) success
                                      failure:(void (^)(NSError *error)) failure;

- (NSURLSessionDataTask *) getLinkDictionaryWithTid:(NSString *)tid
                                      page:(NSInteger )page
                                   success:(void (^)(NSDictionary *links))success
                                   failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *) getMemberWithUid:(NSString *)uid
                                    success:(void (^)(Member *member))success
                                    failure:(void (^)(NSError *error))failure;


- (NSURLSessionDataTask *) createReplyWithfid:(NSString *)fid
                                     tid:(NSString *)tid
                                    pid:(NSString *)pid
                                         page:(NSInteger )page
                                           content:(NSString *)content
                                           success:(void (^)(ThreadDetail *detail))success
                                           failure:(void (^)(NSError *error)) failure;

- (NSURLSessionDataTask *) userLoginWithUserName:(NSString *)username
                                        password:(NSString *)password
                                         success:(void (^)(NSString *message))success
                                         failure:(void (^)(NSError *error)) failure;


- (void) UserLogout;

@end

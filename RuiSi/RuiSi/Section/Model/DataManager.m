//
//  DataManager.m
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/2.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "DataManager.h"
#import "User.h"
#import "Member.h"
#import "Constants.h"
#import "ThreadDetail.h"
@interface DataManager()
@property (nonatomic,strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic,copy) NSString *userAgentMobile;
@property (nonatomic,copy) NSString *userAgentPC;
@end

@implementation DataManager

- (instancetype) init {
    if (self = [super init]) {
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        self.userAgentMobile = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        self.userAgentPC = @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/537.75.14";
        
        //BOOL isLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserIsLogin] boolValue];
        BOOL isLogin = false;
        if (isLogin) {
            User *user = [[User alloc] init];
            user.login = YES;
            Member *member = [[Member alloc] init];
            user.member = member;
            user.member.memberName = [[NSUserDefaults standardUserDefaults] valueForKey:kUserName];
            user.member.memberUid = [[NSUserDefaults standardUserDefaults] valueForKey:kUserID];
            user.member.memberAvatarMiddle = [[NSUserDefaults standardUserDefaults] valueForKey:kUserAvatarURL];
            _user = user;
        }
        [self setBaseURL];
    }
    
    return self;
}

- (void) setBaseURL {
    NSURL *baseURL;
    if ([DataManager isSchoolNet]) {
        baseURL = [NSURL URLWithString:kSchoolNetURL];
    } else {
        baseURL = [NSURL URLWithString:kPublicNetURL];
    }
    self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    self.sessionManager.requestSerializer = serializer;
}

- (void) setUser:(User *)user {
    _user = user;
    if (user) {
        self.user.login = YES;
        [userDefaults setObject:user.member.memberName forKey:kUserName];
        [userDefaults setObject:user.member.memberUid forKey:kUserID];
        [userDefaults setObject:user.member.memberAvatarMiddle forKey:kUserAvatarURL];
        [userDefaults setObject:@"YES" forKey:kUserIsLogin];
        [userDefaults synchronize];
    } else {
        [userDefaults removeObjectForKey:kUserName];
        [userDefaults removeObjectForKey:kUserID];
        [userDefaults removeObjectForKey:kUserAvatarURL];
        [userDefaults removeObjectForKey:kUserIsLogin];
        [userDefaults synchronize];
    }
}

+ (instancetype) manager {
    static DataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DataManager alloc] init];
    });
    return manager;
}

+ (BOOL)isSchoolNet {
    return false;
}

- (NSURLSessionDataTask *)requestWithMethod:(RequestMethod) method
                                  urlString:(NSString *)urlString
                                 parameters:(NSDictionary *)parameters
                                    success:(void (^)(NSURLSessionDataTask *task,id responseObject))success
                                    failure:(void (^)(NSError *error)) failure {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    void (^responseHandleBlock) (NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        success(task,responseObject);
    };
    
    
    NSURLSessionDataTask *task = nil;
    [self.sessionManager.requestSerializer setValue:self.userAgentMobile forHTTPHeaderField:@"User-Agent"];
    if (method == RequestMethodHTTPGet) {
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        self.sessionManager.responseSerializer = responseSerializer;
        task = [self.sessionManager GET:urlString parameters:parameters progress:^(NSProgress *  downloadProgress) {
            ;
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            responseHandleBlock(task,responseObject);
        }failure:^(NSURLSessionDataTask *task,NSError *error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            failure(error);
        }];
    }
    
    if (method == RequestMethodHTTPPost) {
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        self.sessionManager.responseSerializer = responseSerializer;
        task = [self.sessionManager POST:urlString parameters:parameters progress:^(NSProgress *  uploadProgress) {
            ;
        }  success:^(NSURLSessionDataTask *  task, id  responseObject) {
            responseHandleBlock(task,responseObject);
        } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            failure(error);
        }];
    }
    
    return task;
}

- (NSURLSessionDataTask *)getThreadListWithFid:(NSString *)fid page:(NSInteger )page success:(void (^)(ThreadList *))success failure:(void (^)(NSError *))failure {
    NSDictionary *parameters;
    if (page) {
        parameters = @{
                       @"mod":@"forumdisplay",
                       @"fid":fid,
                       @"page":@(page),
                       @"mobile":@"2"
                       };
    } else {
        parameters = @{
                       @"mod":@"forumdisplay",
                       @"fid":fid,
                       @"mobile":@"2"
                       };
    }
    return [self requestWithMethod:RequestMethodHTTPGet urlString:@"forum.php" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        ThreadList *list = [ThreadList getThreadListFromResponseObject:responseObject];
        if (list) {
            success(list);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:self.sessionManager.baseURL.absoluteString code:404 userInfo:nil ];
            failure(error);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}


- (NSURLSessionDataTask *)getThreadDetailListWithTid:(NSString *)tid page:(NSInteger)page success:(void (^)(ThreadDetailList *))success failure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{
                       @"mode":@"viewthread",
                       @"tid":tid,
                       @"page":@(page),
                       @"mobile":@"2"
                       };
    return [self requestWithMethod:RequestMethodHTTPGet urlString:@"forum.php" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        ThreadDetailList *detailList = [ThreadDetailList getThreadDetailListFromResponseObject:responseObject];
        success(detailList);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


- (NSURLSessionDataTask *)getMemberWithUid:(NSString *)uid success:(void (^)(Member *))success failure:(void (^)(NSError *))failure {
    NSDictionary *parameters;
    parameters = @{
                   @"mod":@"space",
                   @"uid":uid,
                   @"do":@"profile",
                   @"mobile":@"2"
                   };
    return [self requestWithMethod:RequestMethodHTTPGet urlString:@"forum.php" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
#warning init member with url
        Member *member = [[Member alloc] init];
        success(member);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (NSURLSessionDataTask *)replyCreateWithFid:(NSString *)fid ThreadID:(NSString *)tid ThreadDetailID:(NSString *)pid page:(NSInteger )page content:(NSString *)content success:(void (^)(ThreadDetail *))success failure:(void (^)(NSError *))failure {
    NSDictionary *parameters;
    parameters = @{
                   @"mod":@"post",
                   @"action":@"reply",
                   @"fid":fid,
                   @"tid":tid,
                   @"reppost":pid,
                   @"page":@(page),
                   @"mobile":@"2"
                   };
    return [self requestWithMethod:RequestMethodHTTPPost urlString:@"forum.php" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (NSURLSessionDataTask *)userLoginWithUserName:(NSString *)username password:(NSString *)password success:(void (^)(NSString *))success failure:(void (^)(NSError *))error {
    return nil;
}



- (void)UserLogout {
    
}

@end

//
//  AppDelegate.m
//  RuiSi
//
//  Created by aloes on 2016/11/17.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "AppDelegate.h"
#import "SectionViewController.h"
#import "AboutMeViewController.h"
#import "ThreadListViewController.h"
@interface AppDelegate ()
@property (nonatomic,strong) UITabBarController *tabBarController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    self.tabBarController = [[UITabBarController alloc] init];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    SectionViewController *sectionViewController = [[SectionViewController alloc] initWithCollectionViewLayout:layout];
    AboutMeViewController *aboutMeViewController = [[AboutMeViewController alloc] init];
    ThreadListViewController *hotThreadListViewController = [[ThreadListViewController alloc] init];
    
    hotThreadListViewController.needToGetMore = YES;
    hotThreadListViewController.name = @"精彩热帖";
    __weak typeof(hotThreadListViewController) whotThreadListViewController = hotThreadListViewController;
    hotThreadListViewController.getThreadListBlock = ^(NSInteger page){
      return [[DataManager manager] getHotThreadListWithPage:page success:^(ThreadList *threadList) {
          whotThreadListViewController.threadList = threadList;
          [whotThreadListViewController.tableView reloadData];
      } failure:^(NSError *error) {
          ;
      }];
    };
    
    hotThreadListViewController.getMoreListBlock = ^(NSInteger page) {
        return [[DataManager manager] getHotThreadListWithPage:page success:^(ThreadList *threadList) {
            NSMutableArray *threadLists = [[NSMutableArray alloc] initWithArray:whotThreadListViewController.threadList.list];
            [threadLists addObjectsFromArray:threadList.list];
            whotThreadListViewController.threadList.list = [threadLists copy];
            [whotThreadListViewController.tableView reloadData];
        } failure:^(NSError *error) {
            ;
        }];
    };
    
    
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:sectionViewController];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:hotThreadListViewController];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:aboutMeViewController];
    nav1.tabBarItem.title = @"板块";
    nav2.tabBarItem.title = @"热帖";
    nav3.tabBarItem.title = @"我";
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:nav1,nav2,nav3, nil];
    
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    [[UITabBar appearance] setTranslucent:NO];
    [[UITabBar appearance] setTintColor:[UIColor blackColor]];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end

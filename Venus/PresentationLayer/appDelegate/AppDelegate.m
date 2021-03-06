//
//  AppDelegate.m
//  Venus
//
//  Created by zhaoqin on 4/14/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "AppDelegate.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "NetworkFetcher+User.h"
#import "RootTabViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <AlipaySDK/AlipaySDK.h>
#import "UMMobClick/MobClick.h"
#import "AppCacheManager.h"
#import "DatabaseManager.h"
#import "AccountDao.h"

@interface AppDelegate ()<WXApiDelegate>{
    BMKMapManager* _mapManager;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"gN6RkXIxUBVPTO7UAx7IkNlw3FZap5qS" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    //友盟统计
    UMConfigInstance.appKey = @"5760e385e0f55a27b2000cf6";
    UMConfigInstance.channelId = @"App Store";
    
    [MobClick startWithConfigure:UMConfigInstance];
    
    self.window = [[UIWindow alloc] init];
    self.window.rootViewController = [[RootTabViewController alloc] init];
    [self.window makeKeyAndVisible];

    // Override point for customization after application launch.
    [WXApi registerApp:@"wxbafcc387a8a8fe31"];
    [self configureNavigationBar];
    return YES;
}

- (void)configureNavigationBar {
    [[UINavigationBar appearance] setBarTintColor:GMRedColor];
    [[UINavigationBar appearance] setTintColor:GMBrownColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: GMBrownColor}];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSString *cookie = [[manager requestSerializer] valueForHTTPHeaderField:@"Cookie"];
    [AppCacheManager cacheCookie:cookie];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSString *cookie = [[manager requestSerializer] valueForHTTPHeaderField:@"Cookie"];
    if (!cookie) {
        cookie = [AppCacheManager fetchCookie];
        [manager.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.neotel.Venus" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Venus" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Venus.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySuccess" object:nil];
            }
            else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PayFailure" object:nil];
            }
        }];
        return YES;
    }
    
    if (self.state == QQ) {
        return [TencentOAuth HandleOpenURL:url];
    }else if (self.state == WECHAT){
        return [WXApi handleOpenURL:url delegate:self];
    }else{
        return NO;
    }
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    if (self.state == QQ) {
        return [TencentOAuth HandleOpenURL:url];
    }else if (self.state == WECHAT){
        return [WXApi handleOpenURL:url delegate:self];
    }else{
        return NO;
    }
}

- (void)onResp:(SendAuthResp*)resp{
    if([resp errCode] == 0){
        [NetworkFetcher userFetchAccessTokenWithCode:[resp code] success:^{
            
        } failure:^(NSString *error) {
            
        }];
    }else{
        NSLog(@"login error");
    }
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySuccess" object:nil];
            }
            else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PayFailure" object:nil];
            }
        }];
    }
    else if ([url.host isEqualToString:@"oauth"]) {
        [WXApi handleOpenURL:url delegate:self];
    }
    else if ([url.host isEqualToString:@"qzapp"]) {
        [TencentOAuth HandleOpenURL:url];
    }
    return YES;
}

@end

//
//  AppDelegate.h
//  Venus
//
//  Created by zhaoqin on 4/14/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
//#import <BaiduMapAPI_Base/BMKBaseComponent.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

typedef enum _ACCOUNT_STATE{
    ORDINARY,
    WECHAT,
    QQ,
    WEIBO
}ACCOUNT_STATE;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property ACCOUNT_STATE state;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end


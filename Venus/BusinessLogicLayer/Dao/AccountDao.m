//
//  AccountDao.m
//  Venus
//
//  Created by zhaoqin on 4/20/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "AccountDao.h"
#import "Account.h"
#import "AppDelegate.h"
#import "AppCacheManager.h"

@interface AccountDao ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSManagedObjectContext *appContext;

@end

@implementation AccountDao


- (instancetype)init{
    self = [super init];
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.appContext = [self.appDelegate managedObjectContext];
    return self;
}

- (Account *)fetchAccount{
    NSArray *array = [self fetchAccountArray];
    if (array.count == 0) {
        return [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:self.appContext];;
    }else{
        return [array objectAtIndex:0];
    }
}

- (BOOL)isLogin{
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSString *cookie = [[manager requestSerializer] valueForHTTPHeaderField:@"Cookie"];
    if ([cookie hasPrefix:@"PLAY_SESSION"]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)deleteAccount{
    NSArray *array = [self fetchAccountArray];
    if ([array count] != 0) {
        [self.appContext deleteObject:[array objectAtIndex:0]];
        AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
        [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"Cookie"];
        [AppCacheManager deleteCookie];
    }
}

- (NSArray *)fetchAccountArray{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:self.appContext];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [self.appContext executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}

- (void)save{
    [self.appDelegate saveContext];
}

@end

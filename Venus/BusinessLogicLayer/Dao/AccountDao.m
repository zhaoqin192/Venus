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

@implementation AccountDao{
    AppDelegate *appDelegate;
    NSManagedObjectContext *appContext;
}

- (instancetype)init{
    self = [super init];
    appDelegate = [[UIApplication sharedApplication] delegate];
    appContext = [appDelegate managedObjectContext];
    return self;
}

- (Account *)fetchAccount{
    NSArray *array = [self fetchAccountArray];
    if (array.count == 0) {
        return [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:appContext];;
    }else{
        return [array objectAtIndex:0];
    }
}

- (BOOL)isLogin{
    Account *account = [self fetchAccount];
    if (account.token != nil) {
        return YES;
    }else{
        return NO;
    }
}

- (void)deleteAccount{
    NSArray *array = [self fetchAccountArray];
    if ([array count] != 0) {
        [appContext deleteObject:[array objectAtIndex:0]];
    }
}

- (NSArray *)fetchAccountArray{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:appContext];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [appContext executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}

- (void)save{
    [appDelegate saveContext];
}

@end

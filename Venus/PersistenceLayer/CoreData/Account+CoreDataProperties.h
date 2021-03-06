//
//  Account+CoreDataProperties.h
//  Venus
//
//  Created by zhaoqin on 6/12/16.
//  Copyright © 2016 Neotel. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Account.h"

NS_ASSUME_NONNULL_BEGIN

@interface Account (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *avatar;
@property (nullable, nonatomic, retain) NSString *birthday;
@property (nullable, nonatomic, retain) NSString *nickName;
@property (nullable, nonatomic, retain) NSString *openID;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSString *phone;
@property (nullable, nonatomic, retain) NSString *realName;
@property (nullable, nonatomic, retain) NSNumber *sex;
@property (nullable, nonatomic, retain) NSString *token;
@property (nullable, nonatomic, retain) NSString *unionID;

@end

NS_ASSUME_NONNULL_END

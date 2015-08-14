//
//  MOGContacts.h
//  MOGContacts
//
//  Created by Guilherme Mogames on 1/10/15.
//  Copyright (c) 2015 Mogames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOGContact.h"

typedef NS_ENUM(NSUInteger, MOGContactDataSource) {
    MOGContactDataSourceKinvey,
    MOGContactDataSourceDatabase,
    MOGContactDataSourceLocal
};

@interface MOGContacts : NSObject

@property (nonatomic, assign) MOGContactDataSource dataSource;

+ (instancetype)sharedManager;

- (NSMutableArray *)getUsers;
- (MOGContact *)getUserWithId:(int)userId;
- (BOOL)creatUserWithObject:(MOGContact *)contact;
- (BOOL)updateUserWithObject:(MOGContact *)contact;
- (BOOL)deleteUserWithID:(int)userId;

@end

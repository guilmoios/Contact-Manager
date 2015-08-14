//
//  MOGContacts.m
//  MOGContacts
//
//  Created by Guilherme Mogames on 1/10/15.
//  Copyright (c) 2015 Mogames. All rights reserved.
//

#import "MOGContacts.h"
#import <FMDB/FMDB.h>

@interface MOGContacts(){
    NSString *_databaseName;
    NSString *_databasePath;
}
@end

@implementation MOGContacts

-(id)init{
    self = [super init];
    if(self){
        self.dataSource = MOGContactDataSourceDatabase;
        _databaseName = @"contactsDB.sqlite";
        
        // Database Manager
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDir = [documentPaths objectAtIndex:0];
        _databasePath = [documentDir stringByAppendingPathComponent:_databaseName];
        
        [self createAndCheckDatabase];
        
    }
    return self;
}

+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static id shared = nil;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (void)createAndCheckDatabase{
    
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:_databasePath];
    
    if(success) return;
    
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:_databaseName];
    [fileManager copyItemAtPath:databasePathFromApp toPath:_databasePath error:nil];
}


#pragma mark - CRUD

- (NSMutableArray *)getUsers{
    
    NSMutableArray *results = [NSMutableArray array];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_databasePath];
    
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS contacts (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, firstName TEXT, lastName TEXT, company TEXT, title TEXT, phoneNumber TEXT, email TEXT, userDefined TEXT );"];
        
        FMResultSet *s = [db executeQuery:@"SELECT * FROM contacts ORDER BY id"];
        
        while ([s next]) {
            [results addObject:[s resultDictionary]];
        }
    }
     ];
    
    return results;
    
}

- (MOGContact *)getUserWithId:(int)userId{
    
    NSMutableArray *results = [NSMutableArray array];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_databasePath];
    __block BOOL dbError;
    
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS contacts (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, firstName TEXT, lastName TEXT, company TEXT, title TEXT, phoneNumber TEXT, email TEXT, userDefined TEXT );"];
        
        FMResultSet *s = [db executeQuery:@"SELECT * FROM contacts WHERE id = ?",[NSNumber numberWithInt:userId]];
        
        dbError = [db hadError];
        
        while ([s next]) {
            [results addObject:[s resultDictionary]];
        }
    }
     ];
    
    if(!dbError){
        MOGContact *contact = [[MOGContact alloc] init];
        contact.firstName = [results objectAtIndex:0][@"firstName"];
        contact.lastName = [results objectAtIndex:0][@"lastName"];
        contact.company = [results objectAtIndex:0][@"company"];
        contact.title = [results objectAtIndex:0][@"title"];
        contact.phoneNumber = [results objectAtIndex:0][@"phoneNumber"];
        contact.email = [results objectAtIndex:0][@"email"];
        
        // Convert JSON string into NSDictionary
        if(![[results objectAtIndex:0][@"userDefined"] isEqualToString:@""]){
            NSData *objectData = [[results objectAtIndex:0][@"userDefined"] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:objectData options:0 error:nil];
            contact.userDefined = jsonDict;
            contact.userDefinedJSON = [results objectAtIndex:0][@"userDefined"];
        } else{
            contact.userDefined = nil;
            contact.userDefinedJSON = @"";
        }
        
        return contact;
        
    } else{
        return nil;
    }
    
}

- (BOOL)creatUserWithObject:(MOGContact *)contact{
    
    // Avoid issues with empty userDefined parameter
    if(!contact.userDefined)
        contact.userDefinedJSON = @"";
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_databasePath];
    __block BOOL dbError;
    
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS contacts (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, firstName TEXT, lastName TEXT, company TEXT, title TEXT, phoneNumber TEXT, email TEXT, userDefined TEXT );"];
        
        [db executeUpdate:@"INSERT INTO contacts(firstName, lastName, company, title, phoneNumber, email, userDefined) VALUES (?,?,?,?,?,?,?)", contact.firstName, contact.lastName, contact.company, contact.title, contact.phoneNumber, contact.email, contact.userDefinedJSON];
        
        dbError = [db hadError];
    }
     ];
    
    return !dbError;
}

- (BOOL)updateUserWithObject:(MOGContact *)contact{
    
    if(!contact.userId || contact.userId == 0)
        return NO;
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_databasePath];
    __block BOOL dbError;
    
    [queue inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:@"UPDATE contacts SET firstName = ?, lastName = ?, company = ?, title = ?, phoneNumber = ?, email = ?, userDefined = ? WHERE id = ?", contact.firstName, contact.lastName, contact.company, contact.title, contact.phoneNumber, contact.email, contact.userDefinedJSON, [NSNumber numberWithInt:contact.userId], nil];
        
        dbError = [db hadError];
        
    }
     ];
    
    return !dbError;
}

- (BOOL)deleteUserWithID:(int)userId{
    
    if(!userId || userId == 0)
        return NO;
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_databasePath];
    __block BOOL dbError;
    
    [queue inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:@"DELETE FROM contacts WHERE id = ?", [NSNumber numberWithInt:userId], nil];
        dbError = [db hadError];
        
    }
     ];
    
    return !dbError;
}


@end

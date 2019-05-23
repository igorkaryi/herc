//
//  RLMRealm+Setup.m
//  Tachcard
//
//  Created by Yaroslav Bulda on 28/10/15.
//  Copyright © 2015 Tachcard. All rights reserved.
//

#import "RLMRealm+Setup.h"
#import "RLMRealm+Migration.h"

@implementation RLMRealm (Setup)

#pragma mark -
#pragma mark Constant defination

NSInteger const RLMRealmSchemaVersion = 1;

#pragma mark -
#pragma mark Setup

+ (void)tcc_setupDefaultRealm {
    NSString *filePath = [[[RLMRealm tcc_applicationStorageDirectory] stringByAppendingPathComponent:@"Default"]
                          stringByAppendingPathExtension:@"realm"];
    [RLMRealm tcc_createPathToStoreFileIfNeccessary:filePath];
    
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.fileURL = [NSURL fileURLWithPath:filePath];
    config.schemaVersion = RLMRealmSchemaVersion;
    config.migrationBlock = [RLMRealm tcc_migrationBlock];

    
    [RLMRealmConfiguration setDefaultConfiguration:config];
    [RLMRealm defaultRealm];
}

#pragma mark -
#pragma mark Private

+ (NSString *)tcc_applicationStorageDirectory {
    NSString *appSupDir = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
    return [appSupDir stringByAppendingPathComponent:@"Realm"];
}

+ (void)tcc_createPathToStoreFileIfNeccessary:(NSString *)fileLoc {
    NSURL *pathToStore = [[NSURL fileURLWithPath:fileLoc] URLByDeletingLastPathComponent];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    [fileManager createDirectoryAtPath:[pathToStore path] withIntermediateDirectories:YES attributes:nil error:&error];
}

@end

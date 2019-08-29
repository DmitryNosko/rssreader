//
//  FileManager.m
//  rssreader
//
//  Created by USER on 8/29/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "FileManager.h"

@interface FileManager()
@property (strong, nonatomic) NSFileManager* fileManager;
@end

@implementation FileManager

static FileManager* shared;

+(instancetype) shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [FileManager new];
    });
    return shared;
}

- (void) saveFeed:(NSMutableArray*) feedData resourceName:(NSString*) resourceName {
    self.fileManager = [NSFileManager defaultManager];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    NSString* filePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", resourceName]];
    //NSData* data = [NSKeyedArchiver archivedDataWithRootObject:feedData requiringSecureCoding:YES error:nil];
    
    if ([self.fileManager fileExistsAtPath:filePath]) {
        //load file
        NSLog(@"reading file = %@", [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil]);
    } else {
        //file does not exist
        //[data writeToFile:filePath atomically:YES];
        
    }
}

@end


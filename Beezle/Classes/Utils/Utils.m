//
//  Utils.m
//  Beezle
//
//  Created by Me on 04/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(void) printBundleContents:(NSString *)rootPath
{
    NSString *bundlePathName = [[NSBundle mainBundle] bundlePath];
    NSString *dataPathName = [bundlePathName stringByAppendingPathComponent:rootPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:dataPathName])
    {
        BOOL isDir = NO;
        [fileManager fileExistsAtPath:dataPathName isDirectory:(&isDir)];
        if (isDir == YES)
        {
            NSArray *contents;
            contents = [fileManager contentsOfDirectoryAtPath:dataPathName error:nil];
            for (NSString *entity in contents)
            {
                NSLog(@"%@/%@", dataPathName, entity);
            }
        }
        else
        {
            NSLog(@"%@ is not a directory", dataPathName);
        }
    }
    else
    {
        NSLog(@"%@ does not exist", dataPathName);
    }
}

@end

//
//  LevelLayoutEntry.h
//  Beezle
//
//  Created by Me on 03/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@interface LevelLayoutEntry : NSObject
{
    NSString *_type;
    NSDictionary *_instanceComponentsDict;
}

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSDictionary *instanceComponentsDict;

+(LevelLayoutEntry *) entry;

@end

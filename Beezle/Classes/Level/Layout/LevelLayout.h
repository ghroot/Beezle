//
//  LevelLayout.h
//  Beezle
//
//  Created by Me on 03/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class LevelLayoutEntry;

@interface LevelLayout : NSObject
{
	NSString *_levelName;
	int _format;
	int _version;
	int _pollenForTwoFlowers;
	int _pollenForThreeFlowers;
	BOOL _hasWater;
    NSMutableArray *_entries;
	BOOL _isEdited;
}

@property (nonatomic, retain) NSString *levelName;
@property (nonatomic) int format;
@property (nonatomic) int version;
@property (nonatomic) int pollenForTwoFlowers;
@property (nonatomic) int pollenForThreeFlowers;
@property (nonatomic) BOOL hasWater;
@property (nonatomic, readonly) NSArray *entries;
@property (nonatomic) BOOL isEdited;

+(LevelLayout *) layout;
+(LevelLayout *) layoutWithContentsOfDictionary:(NSDictionary *)dict;
+(LevelLayout *) layoutWithContentsOfFile:(NSString *)filePath;
+(LevelLayout *) layoutWithContentsOfWorld:(World *)world levelName:(NSString *)levelName version:(int)version;

-(id) initWithLevelName:(NSString *)levelName;

-(void) addLevelLayoutEntry:(LevelLayoutEntry *)entry;
-(NSDictionary *) layoutAsDictionary;
-(BOOL) hasEntityWithType:(NSString *)entityType;

@end

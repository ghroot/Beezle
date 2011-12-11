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
    CGPoint _position;
    BOOL _mirrored;
    int _rotation;
    NSString *_beeTypeAsString;
    NSMutableArray *_beeTypesAsStrings;
}

@property (nonatomic, retain) NSString *type;
@property (nonatomic) CGPoint position;
@property (nonatomic) BOOL mirrored;
@property (nonatomic) int rotation;
@property (nonatomic, retain) NSString *beeTypeAsString;
@property (nonatomic, retain) NSArray *beeTypesAsStrings;

-(void) addBeeTypeAsString:(NSString *)beeTypeAsString;

@end

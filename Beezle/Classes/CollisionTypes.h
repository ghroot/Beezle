//
//  CollisionTypes.h
//  Beezle
//
//  Created by Me on 28/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@interface CollisionTypes : NSObject
{
	NSString *_string;
}

@property (nonatomic, readonly) NSString *string;

+(CollisionTypes *) sharedTypeBackground;
+(CollisionTypes *) sharedTypeEdge;
+(CollisionTypes *) sharedTypeBee;
+(CollisionTypes *) sharedTypeBeeater;
+(CollisionTypes *) sharedTypeRamp;
+(CollisionTypes *) sharedTypePollen;
+(CollisionTypes *) sharedTypeMushroom;
+(CollisionTypes *) sharedTypeWood;
+(CollisionTypes *) sharedTypeNut;
+(CollisionTypes *) sharedTypeAimPollen;

-(id) initWithString:(NSString *)string;

@end

//
//  EditComponent.h
//  Beezle
//
//  Created by Me on 17/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface EditComponent : Component
{
	NSString *_levelLayoutType;
	Entity *_nextMovementIndicatorEntity;
	Entity *_mainMoveEntity;
}

@property (nonatomic, retain) NSString *levelLayoutType;
@property (nonatomic, assign) Entity *nextMovementIndicatorEntity;
@property (nonatomic, assign) Entity *mainMoveEntity;

+(EditComponent *) componentWithLevelLayoutType:(NSString *)levelLayoutType;

-(id) initWithLevelLayoutType:(NSString *)levelLayoutType;

@end

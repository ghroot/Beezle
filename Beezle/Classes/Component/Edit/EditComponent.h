//
//  EditComponent.h
//  Beezle
//
//  Created by Me on 17/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

/**
  Keeps track of edit related properties.
 */
@interface EditComponent : Component
{
    // Transient
	NSString *_levelLayoutType;
	Entity *_nextMovementIndicatorEntity;
	Entity *_mainMoveEntity;
	Entity *_teleportOutPositionEntity;
	Entity *_mainTeleportEntity;
}

@property (nonatomic, copy) NSString *levelLayoutType;
@property (nonatomic, assign) Entity *nextMovementIndicatorEntity;
@property (nonatomic, assign) Entity *mainMoveEntity;
@property (nonatomic, assign) Entity *teleportOutPositionEntity;
@property (nonatomic, assign) Entity *mainTeleportEntity;

+(EditComponent *) componentWithLevelLayoutType:(NSString *)levelLayoutType;

-(id) initWithLevelLayoutType:(NSString *)levelLayoutType;

@end

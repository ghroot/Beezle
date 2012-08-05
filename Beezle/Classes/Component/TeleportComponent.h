//
//  TeleportComponent.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/05/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface TeleportComponent : Component
{
	// Instance
	CGPoint _outPosition;
	float _outRotation;

	// Transient
	NSMutableArray *_teleportInfos;
}

@property (nonatomic) CGPoint outPosition;
@property (nonatomic) float outRotation;
@property (nonatomic, readonly) NSMutableArray *teleportInfos;

-(void) addTeleportingEntity:(Entity *)entity;

@end

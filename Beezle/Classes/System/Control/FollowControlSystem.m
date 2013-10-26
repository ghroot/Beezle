//
//  FollowControlSystem
//  Beezle
//
//  Created by marcus on 01/06/2012.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FollowControlSystem.h"
#import "FollowComponent.h"
#import "InputSystem.h"
#import "TouchTypes.h"
#import "InputAction.h"
#import "PhysicsComponent.h"
#import "TransformComponent.h"
#import "Utils.h"
#import "EntityUtil.h"
#import "EntityFactory.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "FadeComponent.h"
#import "SonarSprite.h"
#import "SoundManager.h"

static float FORCE_SCALE = 0.5f;

@implementation FollowControlSystem

-(id) init
{
	self = [super initWithUsedComponentClass:[FollowComponent class]];
	return self;
}

-(void) initialise
{
	_inputSystem = (InputSystem *)[[_world systemManager] getSystem:[InputSystem class]];
}

-(void) entityAdded:(Entity *)entity
{
	[[FollowComponent getFrom:entity] setState:FOLLOW_CONTROL_STATE_INACTIVE];
}

-(void) processEntity:(Entity *)entity
{
	FollowComponent *followComponent = [FollowComponent getFrom:entity];

	if ([followComponent state] == FOLLOW_CONTROL_STATE_ACTIVE)
	{
		TransformComponent *transformComponent = [TransformComponent getFrom:entity];
		CGPoint force = ccpSub([followComponent location], [transformComponent position]);
		CGPoint scaledForce = CGPointMake(force.x * FORCE_SCALE, force.y * FORCE_SCALE);

		PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:entity];
		[[physicsComponent body] setForce:scaledForce];

		float forceAngle = ccpToAngle(scaledForce);
		float compatibleForceAngle = [Utils unwindAngleDegrees:360 - CC_RADIANS_TO_DEGREES(forceAngle) + 270];
		if (compatibleForceAngle < 180)
		{
			[EntityUtil setEntityMirrored:entity mirrored:TRUE];
			compatibleForceAngle += 180;
		}
		else
		{
			[EntityUtil setEntityMirrored:entity mirrored:FALSE];
		}
		[EntityUtil setEntityRotation:entity rotation:compatibleForceAngle + 90];
	}

	while ([_inputSystem hasInputActions])
	{
		InputAction *inputAction = [_inputSystem popInputAction];
		switch ([inputAction touchType])
		{
			case TOUCH_BEGAN:
			{
				if ([followComponent alwaysActive] ||
						[followComponent state] == FOLLOW_CONTROL_STATE_INACTIVE)
				{
					[followComponent setLocation:[inputAction touchLocation]];
					[followComponent setState:FOLLOW_CONTROL_STATE_ACTIVE];
				}
				break;
			}
			case TOUCH_MOVED:
			{
				if ([followComponent state] == FOLLOW_CONTROL_STATE_ACTIVE)
				{
					[followComponent setLocation:[inputAction touchLocation]];
				}
				break;
			}
			case TOUCH_ENDED:
			case TOUCH_CANCELLED:
			{
				if (![followComponent alwaysActive] &&
						[followComponent state] == FOLLOW_CONTROL_STATE_ACTIVE)
				{
					[followComponent setState:FOLLOW_CONTROL_STATE_INACTIVE];
				}
				break;
			}
		}
	}

	if ([followComponent locationEntity] == nil &&
			([followComponent location].x != 0.0f || [followComponent location].y != 0.0f) &&
			[followComponent locationAnimationFile] != nil)
	{
		Entity *locationEntity = [EntityFactory createSimpleAnimatedEntity:_world animationFile:[followComponent locationAnimationFile]];

		FadeComponent *fadeComponent = [[[FadeComponent alloc] initWithDuration:0.1f introAnimationName:@"Ironbee-Target" fadeAnimationNames:[NSArray arrayWithObject:@"Ironbee-Target"]] autorelease];
		[locationEntity addComponent:fadeComponent];
		[locationEntity refresh];

		RenderComponent *renderComponent = [RenderComponent getFrom:locationEntity];
		[[renderComponent defaultRenderSprite] playAnimationLoop:[followComponent locationAnimationName]];

		CCSprite *sonarParentSprite = [CCSprite node];
		CCSprite *sonarSprite = [SonarSprite node];
		[sonarParentSprite addChild:sonarSprite];
		RenderSprite *sonarRenderSprite = [RenderSprite renderSpriteWithSprite:sonarParentSprite];
		[sonarRenderSprite setName:@"sonar"];
		[renderComponent addRenderSprite:sonarRenderSprite];

		[[SoundManager sharedManager] playSound:@"IronBeeSonar"];
		id scaleAndFadeSequence = [CCSpawn actionOne:[CCFadeOut actionWithDuration:2.0f] two:[CCScaleTo actionWithDuration:2.0f scale:4.0f]];
		id resetScaleAndAlphaAction = [CCCallBlock actionWithBlock:^{
			[sonarSprite setOpacity:255];
			[sonarSprite setScale:1.0f];
			[[SoundManager sharedManager] playSound:@"IronBeeSonar"];
		}];
		id sequence = [CCSequence actionOne:scaleAndFadeSequence two:resetScaleAndAlphaAction];
		[sonarSprite runAction:[CCRepeat actionWithAction:sequence times:9999]];

		[followComponent setLocationEntity:locationEntity];
	}
	if ([followComponent locationEntity] != nil)
	{
		[EntityUtil setEntityPosition:[followComponent locationEntity] position:[followComponent location]];

		FadeComponent *fadeComponent = [FadeComponent getFrom:[followComponent locationEntity]];
		[fadeComponent resetCountdown];
	}
}

@end
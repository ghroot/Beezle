//
// Created by Marcus on 2013-10-03.
//

#import "StingerControlSystem.h"
#import "InputSystem.h"
#import "StingerComponent.h"
#import "InputAction.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "EntityFactory.h"
#import "PhysicsComponent.h"
#import "EntityUtil.h"
#import "TransformComponent.h"

@interface StingerControlSystem ()

-(BOOL) didTouchBegin;
-(void) createTag:(CGPoint)position velocity:(CGPoint)velocity rotation:(float)rotation;

@end

@implementation StingerControlSystem

-(id) init
{
	self = [super initWithUsedComponentClass:[StingerComponent class]];
	return self;
}

-(void) initialise
{
	_inputSystem = (InputSystem *)[[_world systemManager] getSystem:[InputSystem class]];
}

-(void) processEntity:(Entity *)entity
{
	StingerComponent *stingComponent = [StingerComponent getFrom:entity];
	if ([stingComponent countdownUntilNextPossibleSting] > 0)
	{
		[stingComponent setCountdownUntilNextPossibleSting:[stingComponent countdownUntilNextPossibleSting] - 1];
	}

	BOOL didTouchBegin = [self didTouchBegin];
	if (didTouchBegin &&
			[stingComponent countdownUntilNextPossibleSting] == 0)
	{
		TransformComponent *transformComponent = [TransformComponent getFrom:entity];

		RenderComponent *renderComponent = [RenderComponent getFrom:entity];
		RenderSprite *defaultRenderSprite = [renderComponent defaultRenderSprite];
		[defaultRenderSprite playAnimationsLoopLast:[NSArray arrayWithObjects:[stingComponent inflateStartAnimation], [stingComponent inflateEndAnimation], [defaultRenderSprite randomDefaultIdleAnimationName], nil]];

		for (float rotation = 0.0f; rotation < 360.0f; rotation += 36.0f)
		{
			float velocityX = 150.0f * cosf(CC_DEGREES_TO_RADIANS(rotation));
			float velocityY = 150.0f * sinf(CC_DEGREES_TO_RADIANS(rotation));
			[self createTag:[transformComponent position] velocity:CGPointMake(velocityX, velocityY) rotation:360.0f - rotation + 225.0f];
		}

		[stingComponent setCountdownUntilNextPossibleSting:20];
	}
}

-(BOOL) didTouchBegin
{
	BOOL didTouchBegin = FALSE;
	while ([_inputSystem hasInputActions])
	{
		InputAction *nextInputAction = [_inputSystem popInputAction];
		if ([nextInputAction touchType] == TOUCH_BEGAN)
		{
			didTouchBegin = TRUE;
		}
	}
	return didTouchBegin;
}

-(void) createTag:(CGPoint)position velocity:(CGPoint)velocity rotation:(float)rotation
{
	Entity *tagEntity = [EntityFactory createEntity:@"STINGEE-TAG" world:_world];
	[EntityUtil setEntityPosition:tagEntity position:position];
	[EntityUtil setEntityRotation:tagEntity rotation:rotation];
	PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:tagEntity];
	[[physicsComponent body] setVel:velocity];
}

@end
//
//  BeeQueueRenderingSystem.m
//  Beezle
//
//  Created by Me on 14/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeeQueueRenderingSystem.h"
#import "BeeTypes.h"
#import "GameNotificationTypes.h"
#import "RenderSprite.h"
#import "SlingerComponent.h"
#import "TransformComponent.h"

#define QUEUE_START_OFFSET_X -30
#define QUEUE_START_OFFSET_Y 0
#define QUEUE_SPACING_X 5
#define QUEUE_SWAY_Y 4

@interface BeeQueueRenderingSystem()

-(void) handleNotification:(NSNotification *)notification;
-(void) updateSprites:(SlingerEntity *)slingerEntity;

@end

@implementation BeeQueueRenderingSystem

-(id) initWithLayer:(CCLayer *)layer
{
	if (self = [super initWithTag:@"SLINGER"])
	{
		_layer = layer;
		_beeQueueSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"Sprites.png"];
		[_layer addChild:_beeQueueSpriteSheet];
		
		_notifications = [[NSMutableArray alloc] init];
		_beeQueueRenderSprites = [[NSMutableArray alloc] init];
		
		[[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:GAME_NOTIFICATION_BEE_LOADED object:nil];
		[[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:GAME_NOTIFICATION_BEE_FIRED object:nil];
		[[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:GAME_NOTIFICATION_BEE_SAVED object:nil];
	}
	return self;
}

-(void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];

	[_notifications release];
	[_beeQueueRenderSprites release];
	
	[super dealloc];
}

-(void) entityAdded:(Entity *)entity
{
    [self updateSprites:entity];
}

-(void) processTaggedEntity:(Entity *)entity
{
	if ([_notifications count] > 0)
	{
		[self updateSprites:entity];
		[_notifications removeAllObjects];
	}
}

-(void) handleNotification:(NSNotification *)notification
{
	[_notifications addObject:notification];
}

-(void) updateSprites:(SlingerEntity *)slingerEntity
{
    SlingerComponent *slingerSlingerComponent = (SlingerComponent *)[slingerEntity getComponent:[SlingerComponent class]];
	TransformComponent *slingerTransformComponent = (TransformComponent *)[slingerEntity getComponent:[TransformComponent class]];

	// Remove all sprites
	[_beeQueueRenderSprites makeObjectsPerformSelector:@selector(removeSpriteFromSpriteSheet)];
	[_beeQueueRenderSprites removeAllObjects];
	
	// Create sprites
    int startX = [slingerTransformComponent position].x + QUEUE_START_OFFSET_X;
	int startY = [slingerTransformComponent position].y + QUEUE_START_OFFSET_Y;
    int currentX = startX;
    int currentY = startY;
    for (BeeTypes *beeType in [slingerSlingerComponent queuedBeeTypes])
    {
		// Create sprite
		RenderSprite *beeQueueRenderSprite = [RenderSprite renderSpriteWithSpriteSheet:_beeQueueSpriteSheet];
		[[beeQueueRenderSprite sprite] setPosition:CGPointMake(currentX, currentY)];
		[beeQueueRenderSprite addSpriteToSpriteSheet];
		[_beeQueueRenderSprites addObject:beeQueueRenderSprite];
		
		// Make sure animation is loaded
		NSString *animationsFileName = [NSString stringWithFormat:@"%@-Animations.plist", [beeType capitalizedString]];
		[[CCAnimationCache sharedAnimationCache] addAnimationsWithFile:animationsFileName];
		
		// Idle animation
		NSString *animationName = [NSString stringWithFormat:@"%@-Idle", [beeType capitalizedString]];
		[beeQueueRenderSprite playAnimation:animationName];
		
		// Move up and down
		CCMoveTo *moveUpAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:0.5f position:CGPointMake(currentX, currentY + (QUEUE_SWAY_Y / 2))]];
		CCMoveTo *moveDownAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:0.5f position:CGPointMake(currentX, currentY - (QUEUE_SWAY_Y / 2))]];
		[[beeQueueRenderSprite sprite] runAction:[CCRepeatForever actionWithAction:[CCSequence actions:moveUpAction, moveDownAction, nil]]];
        
		currentX -= [[beeQueueRenderSprite sprite] contentSize].width + QUEUE_SPACING_X;
    }
}

@end

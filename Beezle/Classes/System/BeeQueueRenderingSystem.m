//
//  BeeQueueRenderingSystem.m
//  Beezle
//
//  Created by Me on 14/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeeQueueRenderingSystem.h"
#import "ActionTags.h"
#import "BeeType.h"
#import "NotificationTypes.h"
#import "RenderSprite.h"
#import "RenderSystem.h"
#import "SlingerComponent.h"
#import "TransformComponent.h"

#define QUEUE_START_OFFSET_X -30
#define QUEUE_START_OFFSET_Y 0
#define QUEUE_SPACING_X 30
#define QUEUE_SWAY_Y 4

@interface BeeQueueRenderingSystem()

-(void) addNotificationObservers;
-(void) queueNotification:(NSNotification *)notification;
-(BOOL) canHandleNotifications;
-(void) handleNotification:(NSNotification *)notification slingerEntity:(Entity *)slingerEntity;
-(void) handleBeeLoadedNotification:(NSNotification *)notification slingerEntity:(Entity *)slingerEntity;
-(void) handleBeeFiredNotification:(NSNotification *)notification slingerEntity:(Entity *)slingerEntity;
-(void) handleBeeSavedNotification:(NSNotification *)notification slingerEntity:(Entity *)slingerEntity;
-(void) decreaseMovingBeesCount;
-(void) updateLoadedBeeRotation:(Entity *)slingerEntity;
-(RenderSprite *) createBeeQueueRenderSpriteWithBeeType:(BeeType *)beeType position:(CGPoint)position;
-(CGPoint) calculatePositionForBeeQueueRenderSpriteAtIndex:(int)index slingerEntity:(Entity *)slingerEntity;
-(CGPoint) calculatePositionForNextBeeQueueRenderSprite:(Entity *)slingerEntity;
-(CCAction *) createSwayAction:(CGPoint)position;

@end

@implementation BeeQueueRenderingSystem

-(id) initWithZ:(int)z
{
	if (self = [super initWithUsedComponentClasses:[NSArray arrayWithObject:[SlingerComponent class]]])
	{
		_z = z;
		
		_notifications = [[NSMutableArray alloc] init];
		_beeQueueRenderSprites = [[NSMutableArray alloc] init];
		
		_movingBeesCount = 0;
		
		[self addNotificationObservers];
	}
	return self;
}

-(void) addNotificationObservers
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queueNotification:) name:GAME_NOTIFICATION_BEE_LOADED object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queueNotification:) name:GAME_NOTIFICATION_BEE_FIRED object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queueNotification:) name:GAME_NOTIFICATION_BEE_SAVED object:nil];
}

-(void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];

	[_notifications release];
	[_beeQueueRenderSprites release];
	
	if (_beeLoadedRenderSprite != nil)
	{
		[_beeLoadedRenderSprite release];
		_beeLoadedRenderSprite = nil;
	}
	
	[super dealloc];
}

-(void) initialise
{
	_renderSystem = (RenderSystem *)[[_world systemManager] getSystem:[RenderSystem class]];
}

-(void) entityAdded:(Entity *)entity
{
    [self refreshSprites:entity];
}

-(void) processEntity:(Entity *)entity
{
	while ([_notifications count] > 0 &&
		   [self canHandleNotifications])
	{
		NSNotification *nextNotification = [[_notifications objectAtIndex:0] retain];
		[_notifications removeObjectAtIndex:0];
		[self handleNotification:nextNotification slingerEntity:entity];
		[nextNotification release];
	}
	
	[self updateLoadedBeeRotation:entity];
}

-(void) queueNotification:(NSNotification *)notification
{
	[_notifications addObject:notification];
}

-(BOOL) canHandleNotifications
{
	return _movingBeesCount == 0;
}

-(void) decreaseMovingBeesCount
{
	_movingBeesCount--;
}

-(void) handleNotification:(NSNotification *)notification slingerEntity:(Entity *)entity
{
	if ([[notification name] isEqualToString:GAME_NOTIFICATION_BEE_LOADED])
	{
		[self handleBeeLoadedNotification:notification slingerEntity:entity];
	}
	else if ([[notification name] isEqualToString:GAME_NOTIFICATION_BEE_FIRED])
	{
		[self handleBeeFiredNotification:notification slingerEntity:entity];
	}
	else if ([[notification name] isEqualToString:GAME_NOTIFICATION_BEE_SAVED])
	{
		[self handleBeeSavedNotification:notification slingerEntity:entity];
	}
}

-(void) handleBeeLoadedNotification:(NSNotification *)notification slingerEntity:(Entity *)slingerEntity
{
	// Load next bee sprite
	_beeLoadedRenderSprite = [[_beeQueueRenderSprites objectAtIndex:0] retain];
	[_beeQueueRenderSprites removeObjectAtIndex:0];
	TransformComponent *slingerTransformComponent = (TransformComponent *)[slingerEntity getComponent:[TransformComponent class]];
	[[_beeLoadedRenderSprite sprite] stopActionByTag:ACTION_TAG_BEE_QUEUE];
	CCAction *moveAction = [CCMoveTo actionWithDuration:0.5f position:[slingerTransformComponent position]];
	[moveAction setTag:ACTION_TAG_BEE_QUEUE];
	[[_beeLoadedRenderSprite sprite] runAction:moveAction];
	
	// Move queued sprites right
	for (int i = 0; i < [_beeQueueRenderSprites count]; i++)
	{
		CGPoint nextPosition = [self calculatePositionForBeeQueueRenderSpriteAtIndex:i slingerEntity:slingerEntity];
		
		RenderSprite *beeQueueRenderSprite = [_beeQueueRenderSprites objectAtIndex:i];
		_movingBeesCount++;
		CCMoveTo *moveRightAction = [CCMoveTo actionWithDuration:0.5f position:nextPosition];
		CCCallFunc *decreaseMovingBeesCountAction = [CCCallFunc actionWithTarget:self selector:@selector(decreaseMovingBeesCount)];
		[[beeQueueRenderSprite sprite] stopActionByTag:ACTION_TAG_BEE_QUEUE];
		CCAction *action = [CCSequence actions:moveRightAction, decreaseMovingBeesCountAction, [self createSwayAction:nextPosition], nil];
		[action setTag:ACTION_TAG_BEE_QUEUE];
		[[beeQueueRenderSprite sprite] runAction:action];
	}
}

-(void) updateLoadedBeeRotation:(Entity *)slingerEntity
{
	if (_beeLoadedRenderSprite != nil)
	{
		TransformComponent *slingerTransformComponent = [TransformComponent getFrom:slingerEntity];
		[[_beeLoadedRenderSprite sprite] setRotation:[slingerTransformComponent rotation] + 90];
	}
}

-(void) handleBeeFiredNotification:(NSNotification *)notification slingerEntity:(Entity *)slingerEntity
{
	// Remove loaded bee sprite
	[_beeLoadedRenderSprite removeSpriteFromSpriteSheet];
	[_beeLoadedRenderSprite release];
	_beeLoadedRenderSprite = nil;
}

-(void) handleBeeSavedNotification:(NSNotification *)notification slingerEntity:(Entity *)slingerEntity
{
	NSValue *beeterPositionValue = (NSValue *)[[notification userInfo] objectForKey:@"beeaterEntityPosition"];
	CGPoint beeaterPosition = [beeterPositionValue CGPointValue];
	BeeType *savedBeeType = (BeeType *)[[notification userInfo] objectForKey:@"beeType"];
	
	CGPoint nextPosition = [self calculatePositionForNextBeeQueueRenderSprite:slingerEntity];
	
	// Create sprite
	CGPoint beePosition = CGPointMake(beeaterPosition.x, beeaterPosition.y + 20);
	RenderSprite *beeQueueRenderSprite = [self createBeeQueueRenderSpriteWithBeeType:savedBeeType position:beePosition];
	
	// Saved animation
	NSString *animationName = [NSString stringWithFormat:@"%@-Saved", [savedBeeType capitalizedString]];
	[beeQueueRenderSprite playAnimation:animationName];
	
	// Face the slinger
	if ([[TransformComponent getFrom:slingerEntity] position].x < beePosition.x)
	{
		[[beeQueueRenderSprite sprite] setScaleX:-1];
	}
	
	// Move from beeater to slinger queue
	_movingBeesCount++;
	CCEaseSineInOut *moveUpAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:1.0f position:CGPointMake(beePosition.x, beePosition.y + 30)]];
	CCCallBlock *animateHappyAction = [CCCallBlock actionWithBlock:^()
	{
		NSString *animationName = [NSString stringWithFormat:@"%@-Happy", [savedBeeType capitalizedString]];
		[beeQueueRenderSprite playAnimation:animationName];
	}];
	CCEaseSineOut *moveToQueueAction = [CCEaseSineOut actionWithAction:[CCMoveTo actionWithDuration:0.7f position:nextPosition]];
	CCCallBlock *faceRightAction = [CCCallBlock actionWithBlock:^()
	{
		[[beeQueueRenderSprite sprite] setScaleX:1];
	}];
	CCCallBlock *animateIdleAction = [CCCallBlock actionWithBlock:^()
	{
		NSString *animationName = [NSString stringWithFormat:@"%@-Idle", [savedBeeType capitalizedString]];
		[beeQueueRenderSprite playAnimation:animationName];
	}];
	CCCallFunc *decreaseMovingBeesCountAction = [CCCallFunc actionWithTarget:self selector:@selector(decreaseMovingBeesCount)];
	[[beeQueueRenderSprite sprite] stopActionByTag:ACTION_TAG_BEE_QUEUE];
	CCAction *action = [CCSequence actions:
						moveUpAction,
						animateHappyAction,
						moveToQueueAction,
						faceRightAction,
						animateIdleAction,
						decreaseMovingBeesCountAction,
						[self createSwayAction:nextPosition],
						nil];
	[action setTag:ACTION_TAG_BEE_QUEUE];
	[[beeQueueRenderSprite sprite] runAction:action];
}

-(void) refreshSprites:(Entity *)slingerEntity
{
    SlingerComponent *slingerSlingerComponent = (SlingerComponent *)[slingerEntity getComponent:[SlingerComponent class]];
	
	// Remove all sprites
	[_beeQueueRenderSprites makeObjectsPerformSelector:@selector(removeSpriteFromSpriteSheet)];
	[_beeQueueRenderSprites removeAllObjects];
	
	// Create sprites
    for (BeeType *beeType in [slingerSlingerComponent queuedBeeTypes])
    {
		// Create sprite
		RenderSprite *beeQueueRenderSprite = [self createBeeQueueRenderSpriteWithBeeType:beeType position:[self calculatePositionForNextBeeQueueRenderSprite:slingerEntity]];
		
		// Sway
		CCAction *swayAction = [self createSwayAction:[[beeQueueRenderSprite sprite] position]];
		[swayAction setTag:ACTION_TAG_BEE_QUEUE];
		[[beeQueueRenderSprite sprite] runAction:swayAction];
    }
}

-(RenderSprite *) createBeeQueueRenderSpriteWithBeeType:(BeeType *)beeType position:(CGPoint)position
{
	// Create sprite
	RenderSprite *beeQueueRenderSprite = [_renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" z:_z];
	[[beeQueueRenderSprite sprite] setPosition:position];
	[beeQueueRenderSprite addSpriteToSpriteSheet];
	[_beeQueueRenderSprites addObject:beeQueueRenderSprite];
	
	// Make sure animation is loaded
	NSString *animationsFileName = [NSString stringWithFormat:@"%@-Animations.plist", [beeType capitalizedString]];
	[[CCAnimationCache sharedAnimationCache] addAnimationsWithFile:animationsFileName];
	
	// Idle animation
	NSString *animationName = [NSString stringWithFormat:@"%@-Idle", [beeType capitalizedString]];
	[beeQueueRenderSprite playAnimation:animationName];
	
	return beeQueueRenderSprite;
}

-(CGPoint) calculatePositionForBeeQueueRenderSpriteAtIndex:(int)index slingerEntity:(Entity *)slingerEntity
{
	TransformComponent *slingerTransformComponent = (TransformComponent *)[slingerEntity getComponent:[TransformComponent class]];
	
	// Method 1: Straight line
//	int x = [slingerTransformComponent position].x + QUEUE_START_OFFSET_X - index * QUEUE_SPACING_X;
//	int y = [slingerTransformComponent position].y + QUEUE_START_OFFSET_Y;
//	return CGPointMake(x, y);
	
	// Method 2: Slightly curved
	float angle = CC_DEGREES_TO_RADIANS(92 + index * 10);
	return CGPointMake([slingerTransformComponent position].x - 20 + 150 * cosf(angle),
					   [slingerTransformComponent position].y - 150 + 150 * sinf(angle));
}

-(CGPoint) calculatePositionForNextBeeQueueRenderSprite:(Entity *)slingerEntity
{
	return [self calculatePositionForBeeQueueRenderSpriteAtIndex:[_beeQueueRenderSprites count] slingerEntity:slingerEntity];
}

-(CCAction *) createSwayAction:(CGPoint)position
{
	CCMoveTo *moveUpAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:0.5f position:CGPointMake(position.x, position.y + (QUEUE_SWAY_Y / 2))]];
	CCMoveTo *moveDownAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:0.5f position:CGPointMake(position.x, position.y - (QUEUE_SWAY_Y / 2))]];
	CCAction *swayAction = [CCRepeat actionWithAction:[CCSequence actions:moveUpAction, moveDownAction, nil] times:INT_MAX];
	return swayAction;
}

@end

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
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "NotificationTypes.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "RenderSystem.h"
#import "SlingerComponent.h"
#import "TransformComponent.h"

#define QUEUE_START_OFFSET_X -30
#define QUEUE_START_OFFSET_Y 0
#define QUEUE_SPACING_X 30
#define QUEUE_SWAY_Y 4
#define LOADED_BEE_MIN_ANIMATION_DURATION 0.4f
#define LOADED_BEE_MAX_ANIMATION_DURATION 1.0f

@interface BeeQueueRenderingSystem()

-(void) addNotificationObservers;
-(void) queueNotification:(NSNotification *)notification;
-(BOOL) canHandleNotifications;
-(void) handleNotification:(NSNotification *)notification slingerEntity:(Entity *)slingerEntity;
-(void) handleBeeLoadedNotification:(NSNotification *)notification slingerEntity:(Entity *)slingerEntity;
-(void) handleBeeRevertedNotification:(NSNotification *)notification slingerEntity:(Entity *)slingerEntity;
-(void) handleBeeFiredNotification:(NSNotification *)notification slingerEntity:(Entity *)slingerEntity;
-(void) handleBeeSavedNotification:(NSNotification *)notification slingerEntity:(Entity *)slingerEntity;
-(void) decreaseMovingBeesCount;
-(void) updateLoadedBee:(Entity *)slingerEntity;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queueNotification:) name:GAME_NOTIFICATION_BEE_REVERTED object:nil];
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
	
	[self updateLoadedBee:entity];
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

-(BOOL) isBusy
{
	return _movingBeesCount > 0;
}

-(void) handleNotification:(NSNotification *)notification slingerEntity:(Entity *)entity
{
	if ([[notification name] isEqualToString:GAME_NOTIFICATION_BEE_LOADED])
	{
		[self handleBeeLoadedNotification:notification slingerEntity:entity];
	}
    else if ([[notification name] isEqualToString:GAME_NOTIFICATION_BEE_REVERTED])
	{
		[self handleBeeRevertedNotification:notification slingerEntity:entity];
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
//	_beeLoadedRenderSprite = [[_beeQueueRenderSprites objectAtIndex:0] retain];
//	[_beeQueueRenderSprites removeObjectAtIndex:0];
//	TransformComponent *slingerTransformComponent = (TransformComponent *)[slingerEntity getComponent:[TransformComponent class]];
//	[[_beeLoadedRenderSprite sprite] stopActionByTag:ACTION_TAG_BEE_QUEUE];
//	CCAction *moveAction = [CCMoveTo actionWithDuration:0.5f position:[slingerTransformComponent position]];
//	[moveAction setTag:ACTION_TAG_BEE_QUEUE];
//	[[_beeLoadedRenderSprite sprite] runAction:moveAction];
    
    // Load next bee sprite (instant version)
    _beeLoadedRenderSprite = [[_beeQueueRenderSprites objectAtIndex:0] retain];
	[_beeQueueRenderSprites removeObjectAtIndex:0];
	
	// Remove and add so it ends up on top
	[_beeLoadedRenderSprite removeSpriteFromSpriteSheet];
	[_beeLoadedRenderSprite addSpriteToSpriteSheet];
	
	// Idle animation
	SlingerComponent *slingerComponent = [SlingerComponent getFrom:slingerEntity];
	BeeType *beeType = [slingerComponent loadedBeeType];
	NSString *animationName = [NSString stringWithFormat:@"%@-Idle", [beeType capitalizedString]];
	[_beeLoadedRenderSprite playAnimationLoop:animationName];
	
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

-(void) handleBeeRevertedNotification:(NSNotification *)notification slingerEntity:(Entity *)slingerEntity
{
    [self refreshSprites:slingerEntity];
}

-(void) updateLoadedBee:(Entity *)slingerEntity
{
	if (_beeLoadedRenderSprite != nil)
	{
		// Rotation
		TransformComponent *slingerTransformComponent = [TransformComponent getFrom:slingerEntity];
		[[_beeLoadedRenderSprite sprite] setRotation:[slingerTransformComponent rotation] + 90];
        
		// Position
        RenderComponent *slingerRenderComponent = [RenderComponent getFrom:slingerEntity];
        RenderSprite *slingerAddonRenderSprite = [slingerRenderComponent renderSpriteWithName:@"addon"];
        CCSprite *slingerAddonSprite = [slingerAddonRenderSprite sprite];
        float angle = CC_DEGREES_TO_RADIANS(360 - [slingerTransformComponent rotation] + 270);
        CGPoint newPosition = CGPointMake([slingerTransformComponent position].x - 15.0f * [slingerAddonSprite scaleY] * cosf(angle),
                                          [slingerTransformComponent position].y - 15.0f * [slingerAddonSprite scaleY] * sinf(angle));
        [[_beeLoadedRenderSprite sprite] setPosition:newPosition];
		
		// Animation speed
		float animationSpeed = LOADED_BEE_MIN_ANIMATION_DURATION + (1.0f - [slingerAddonSprite scaleY]) * (LOADED_BEE_MAX_ANIMATION_DURATION - LOADED_BEE_MIN_ANIMATION_DURATION);
		[_beeLoadedRenderSprite setAnimationSpeed:animationSpeed];
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
	
	BOOL needsToTurn = [[TransformComponent getFrom:slingerEntity] position].x < beePosition.x;
	
	// Face the slinger
	if (needsToTurn)
	{
		[[beeQueueRenderSprite sprite] setScaleX:-1];
	}
	
	CGPoint positionAboveBeeater = CGPointMake(beePosition.x, beePosition.y + 30);
	
	// Move from beeater to slinger queue
	_movingBeesCount++;
	NSMutableArray *actions = [NSMutableArray array];
	CCCallBlock *animateLookDownAction = [CCCallBlock actionWithBlock:^(){
		NSString *animationName = [NSString stringWithFormat:@"%@-Saved-Look-Down", [savedBeeType capitalizedString]];
		[beeQueueRenderSprite playAnimationOnce:animationName];
	}];
	[actions addObject:animateLookDownAction];
	CCEaseSineInOut *moveUpAction = [CCEaseSineOut actionWithAction:[CCMoveTo actionWithDuration:0.4f position:positionAboveBeeater]];
	[actions addObject:moveUpAction];
	CCCallBlock *animateLookScreenAction = [CCCallBlock actionWithBlock:^(){
		NSString *animationName = [NSString stringWithFormat:@"%@-Saved-Look-Screen", [savedBeeType capitalizedString]];
		[beeQueueRenderSprite playAnimationOnce:animationName];
	}];
	[actions addObject:animateLookScreenAction];
	CCDelayTime *waitAction1 = [CCDelayTime actionWithDuration:0.1f];
	[actions addObject:waitAction1];
	CCCallBlock *animateLookSideAction = [CCCallBlock actionWithBlock:^(){
		NSString *animationName1 = [NSString stringWithFormat:@"%@-Saved-Leap", [savedBeeType capitalizedString]];
		NSString *animationName2 = [NSString stringWithFormat:@"%@-Saved-Look-Side", [savedBeeType capitalizedString]];
		[beeQueueRenderSprite playAnimationsLoopLast:[NSArray arrayWithObjects:animationName1, animationName2, nil]];
	}];
	[actions addObject:animateLookSideAction];
	CCDelayTime *waitAction2 = [CCDelayTime actionWithDuration:0.1f];
	[actions addObject:waitAction2];
	CCCallBlock *spawnLeapAnimationAction = [CCCallBlock actionWithBlock:^(){
		Entity *leapEntity = [EntityFactory createSimpleAnimatedEntity:_world];
		[EntityUtil setEntityPosition:leapEntity position:positionAboveBeeater];
		NSString *animationName = [NSString stringWithFormat:@"%@-Saved-Leap-Dust", [savedBeeType capitalizedString]];
		[EntityUtil animateAndDeleteEntity:leapEntity animationName:animationName];
	}];
	[actions addObject:spawnLeapAnimationAction];
	CCEaseSineOut *moveToQueueAction = [CCEaseSineOut actionWithAction:[CCMoveTo actionWithDuration:0.6f position:nextPosition]];
	[actions addObject:moveToQueueAction];
	if (needsToTurn)
	{
		CCCallBlock *animateLookAwayAction = [CCCallBlock actionWithBlock:^(){
			NSString *animationName = [NSString stringWithFormat:@"%@-Saved-Look-Away", [savedBeeType capitalizedString]];
			[beeQueueRenderSprite playAnimationOnce:animationName];
		}];
		[actions addObject:animateLookAwayAction];
		CCDelayTime *waitAction3 = [CCDelayTime actionWithDuration:0.1f];
		[actions addObject:waitAction3];
		CCCallBlock *faceRightAction = [CCCallBlock actionWithBlock:^()
		{
			[[beeQueueRenderSprite sprite] setScaleX:1];
		}];
		[actions addObject:faceRightAction];
	}
	CCCallBlock *animateIdleAction = [CCCallBlock actionWithBlock:^(){
		NSString *animationName = [NSString stringWithFormat:@"%@-Idle", [savedBeeType capitalizedString]];
		[beeQueueRenderSprite playAnimationLoop:animationName];
	}];
	[actions addObject:animateIdleAction];
	CCCallFunc *decreaseMovingBeesCountAction = [CCCallFunc actionWithTarget:self selector:@selector(decreaseMovingBeesCount)];
	[actions addObject:decreaseMovingBeesCountAction];
	[actions addObject:[self createSwayAction:nextPosition]];
	[[beeQueueRenderSprite sprite] stopActionByTag:ACTION_TAG_BEE_QUEUE];
	CCAction *sequence = [CCSequence actionsWithArray:actions];
	[sequence setTag:ACTION_TAG_BEE_QUEUE];
	[[beeQueueRenderSprite sprite] runAction:sequence];
}

-(void) refreshSprites:(Entity *)slingerEntity
{
    SlingerComponent *slingerSlingerComponent = (SlingerComponent *)[slingerEntity getComponent:[SlingerComponent class]];
	
	// Remove all sprites
	[_beeQueueRenderSprites makeObjectsPerformSelector:@selector(removeSpriteFromSpriteSheet)];
	[_beeQueueRenderSprites removeAllObjects];
    
    if (_beeLoadedRenderSprite != nil)
    {
        // Remove loaded bee sprite
        [_beeLoadedRenderSprite removeSpriteFromSpriteSheet];
        [_beeLoadedRenderSprite release];
        _beeLoadedRenderSprite = nil;
    }
	
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
	RenderSprite *beeQueueRenderSprite = [_renderSystem createRenderSpriteWithSpriteSheetName:@"Shared" z:_z];
	[[beeQueueRenderSprite sprite] setPosition:position];
	[beeQueueRenderSprite addSpriteToSpriteSheet];
	[_beeQueueRenderSprites addObject:beeQueueRenderSprite];
	
	// Make sure animation is loaded
	NSString *animationsFileName = [NSString stringWithFormat:@"%@-Animations.plist", [beeType capitalizedString]];
	[[CCAnimationCache sharedAnimationCache] addAnimationsWithFile:animationsFileName];
	
	// Idle animation
	NSString *animationName = [NSString stringWithFormat:@"%@-Idle", [beeType capitalizedString]];
	[beeQueueRenderSprite playAnimationLoop:animationName];
	
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
//	float angle = CC_DEGREES_TO_RADIANS(92 + index * 10);
//	return CGPointMake([slingerTransformComponent position].x - 20 + 150 * cosf(angle),
//					   [slingerTransformComponent position].y - 150 + 150 * sinf(angle));
	
	// Method 3: Vertical
	int x = [slingerTransformComponent position].x - 20;
	int y = [slingerTransformComponent position].y - 5 - 20 * index;
	return CGPointMake(x, y);
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

-(void) turnRemainingBeesIntoPollen
{
	for (int i = 0; i < [_beeQueueRenderSprites count]; i++)
	{
		RenderSprite *beeQueueRenderSprite = [_beeQueueRenderSprites objectAtIndex:i];
		_movingBeesCount++;
        CCDelayTime *waitAction = [CCDelayTime actionWithDuration:(i * 0.8f)];
        CCCallBlock *animateAction = [CCCallBlock actionWithBlock:^(){
            [[CCAnimationCache sharedAnimationCache] addAnimationsWithFile:@"Bees-Animations.plist"];
			[beeQueueRenderSprite playAnimationOnce:@"Bee-Turn-Into-Pollen" andCallBlockAtEnd:^{
				[self decreaseMovingBeesCount];
			}];
        }];
		[[beeQueueRenderSprite sprite] stopActionByTag:ACTION_TAG_BEE_QUEUE];
        CCAction *action = [CCSequence actions:waitAction, animateAction, nil];
		[action setTag:ACTION_TAG_BEE_QUEUE];
		[[beeQueueRenderSprite sprite] runAction:action];
	}
}

@end
//
//  BeeQueueRenderingSystem.m
//  Beezle
//
//  Created by Me on 14/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeeQueueRenderingSystem.h"
#import "ActionTags.h"
#import "BeeComponent.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "NotificationProcessor.h"
#import "NotificationTypes.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "RenderSystem.h"
#import "SlingerComponent.h"
#import "TransformComponent.h"
#import "ZOrder.h"

static const float QUEUE_START_OFFSET_X = -30.0f;
static const float QUEUE_START_OFFSET_Y = 0.0f;
static const float QUEUE_SPACING_X = 30.0f;
static const float QUEUE_SWAY_Y = 4.0f;
static const float LOADED_BEE_MIN_ANIMATION_DURATION = 0.4f;
static const float LOADED_BEE_MAX_ANIMATION_DURATION = 1.0f;

@interface BeeQueueRenderingSystem()

-(void) handleBeeLoaded:(NSNotification *)notification;
-(void) handleBeeReverted:(NSNotification *)notification;
-(void) handleBeeFired:(NSNotification *)notification;
-(void) handleBeeSaved:(NSNotification *)notification;
-(Entity *) getSlingerEntity;
-(void) increaseMovingBeesCount;
-(void) decreaseMovingBeesCount;
-(void) updateLoadedBee;
-(RenderSprite *) createBeeQueueRenderSpriteWithBeeType:(BeeType *)beeType position:(CGPoint)position;
-(CGPoint) calculatePositionForBeeQueueRenderSpriteAtIndex:(int)index slingerEntity:(Entity *)slingerEntity;
-(CGPoint) calculatePositionForNextBeeQueueRenderSprite:(Entity *)slingerEntity;
-(CCAction *) createSwayAction:(CGPoint)position;

@end

@implementation BeeQueueRenderingSystem

-(id) init
{
	if (self = [super initWithUsedComponentClass:[SlingerComponent class]])
	{
		_notificationProcessor = [[NotificationProcessor alloc] initWithTarget:self];
		[_notificationProcessor registerNotification:GAME_NOTIFICATION_BEE_LOADED withSelector:@selector(handleBeeLoaded:)];
		[_notificationProcessor registerNotification:GAME_NOTIFICATION_BEE_REVERTED withSelector:@selector(handleBeeReverted:)];
		[_notificationProcessor registerNotification:GAME_NOTIFICATION_BEE_FIRED withSelector:@selector(handleBeeFired:)];
		[_notificationProcessor registerNotification:GAME_NOTIFICATION_BEE_SAVED withSelector:@selector(handleBeeSaved:)];
		
		_beeQueueRenderSprites = [[NSMutableArray alloc] init];
		
		_movingBeesCount = 0;
	}
	return self;
}

-(void) dealloc
{
	[_renderComponentMapper release];
	[_transformComponentMapper release];
	[_slingerComponentMapper release];

	[_notificationProcessor release];
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
	_renderComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[RenderComponent class]];
	_transformComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[TransformComponent class]];
	_slingerComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[SlingerComponent class]];
	_renderSystem = (RenderSystem *)[[_world systemManager] getSystem:[RenderSystem class]];
}

-(void) activate
{
	[super activate];
	
	[_notificationProcessor activate];
}

-(void) deactivate
{
	[super deactivate];
	
	[_notificationProcessor deactivate];
}

-(void) entityAdded:(Entity *)entity
{
    [self refreshSprites];
}

-(void) begin
{
	[_notificationProcessor processNotifications];
	[self updateLoadedBee];
}

-(Entity *) getSlingerEntity
{
	TagManager *tagManager = (TagManager *)[_world getManager:[TagManager class]];
	return [tagManager getEntity:@"SLINGER"];
}

-(void) increaseMovingBeesCount
{
	_movingBeesCount++;
}

-(void) decreaseMovingBeesCount
{
	_movingBeesCount--;
}

-(BOOL) isBusy
{
	return _movingBeesCount > 0;
}

-(void) handleBeeLoaded:(NSNotification *)notification
{
	Entity *slingerEntity = [self getSlingerEntity];
	
	// Move first bee towards slinger and fade out
	TransformComponent *slingerTransformComponent = [_transformComponentMapper getComponentFor:slingerEntity];
	RenderSprite *beeLoadingRenderSprite = [[_beeQueueRenderSprites objectAtIndex:0] retain];
	[_beeQueueRenderSprites removeObjectAtIndex:0];
	[[beeLoadingRenderSprite sprite] stopActionByTag:ACTION_TAG_BEE_QUEUE];
	CCMoveTo *moveAction = [CCMoveTo actionWithDuration:0.3f position:[slingerTransformComponent position]];
	CCFadeOut *fadeOutAction = [CCFadeOut actionWithDuration:0.3f];
	CCSpawn *spawnAction = [CCSpawn actions:moveAction, fadeOutAction, nil];
	CCCallBlock *removeAction = [CCCallBlock actionWithBlock:^{
		[beeLoadingRenderSprite removeSpriteFromSpriteSheet];
	}];
	CCSequence *sequence = [CCSequence actions:spawnAction, removeAction, nil];
	[sequence setTag:ACTION_TAG_BEE_QUEUE];
	[[beeLoadingRenderSprite sprite] runAction:sequence];
	[beeLoadingRenderSprite release];
	
	// Create new sprite and place in slinger
	SlingerComponent *slingerComponent = [_slingerComponentMapper getComponentFor:slingerEntity];
	BeeType *beeType = [slingerComponent loadedBeeType];
	_beeLoadedRenderSprite = [self createBeeQueueRenderSpriteWithBeeType:beeType position:[slingerTransformComponent position]];
	[_beeLoadedRenderSprite retain];
	NSString *animationName = [NSString stringWithFormat:@"%@-Idle", [beeType capitalizedString]];
	[_beeLoadedRenderSprite playAnimationLoop:animationName];
	[[_beeLoadedRenderSprite sprite] setOpacity:0];
	CCFadeIn *fadeInAction = [CCFadeIn actionWithDuration:0.3f];
	[fadeInAction setTag:ACTION_TAG_BEE_QUEUE];
	[[_beeLoadedRenderSprite sprite] runAction:fadeInAction];
}

-(void) handleBeeReverted:(NSNotification *)notification
{
    [self refreshSprites];
}

-(void) updateLoadedBee
{
	Entity *slingerEntity = [self getSlingerEntity];
	if (_beeLoadedRenderSprite != nil)
	{
		// Rotation
		TransformComponent *slingerTransformComponent = [_transformComponentMapper getComponentFor:slingerEntity];
		[[_beeLoadedRenderSprite sprite] setRotation:[slingerTransformComponent rotation] + 90];
        
		// Position
        RenderComponent *slingerRenderComponent = [_renderComponentMapper getComponentFor:slingerEntity];
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

-(void) handleBeeFired:(NSNotification *)notification
{
	// Remove loaded bee sprite
	[_beeLoadedRenderSprite removeSpriteFromSpriteSheet];
	[_beeLoadedRenderSprite release];
	_beeLoadedRenderSprite = nil;
	
	// Move queued sprites up
	Entity *slingerEntity = [self getSlingerEntity];
	for (int i = 0; i < [_beeQueueRenderSprites count]; i++)
	{
		CGPoint nextPosition = [self calculatePositionForBeeQueueRenderSpriteAtIndex:i slingerEntity:slingerEntity];
		
		RenderSprite *beeQueueRenderSprite = [_beeQueueRenderSprites objectAtIndex:i];
		CCMoveTo *moveUpAction = [CCMoveTo actionWithDuration:0.5f position:nextPosition];
		[[beeQueueRenderSprite sprite] stopActionByTag:ACTION_TAG_BEE_QUEUE];
		CCAction *action = [CCSequence actions:moveUpAction, [self createSwayAction:nextPosition], nil];
		[action setTag:ACTION_TAG_BEE_QUEUE];
		[[beeQueueRenderSprite sprite] runAction:action];
	}
}

-(void) handleBeeSaved:(NSNotification *)notification
{
	Entity *slingerEntity = [self getSlingerEntity];
	TransformComponent *transformComponent = [_transformComponentMapper getComponentFor:slingerEntity];

	// Notification data
	CGPoint position = [[[notification userInfo] objectForKey:@"entityPosition"] CGPointValue];
	BeeType *savedBeeType = (BeeType *)[[notification userInfo] objectForKey:@"savedBeeType"];
	BeeType *savingBeeType = (BeeType *)[[notification userInfo] objectForKey:@"savingBeeType"];
	
	CGPoint targetPosition = [self calculatePositionForNextBeeQueueRenderSprite:slingerEntity];
	CGPoint beePosition = CGPointMake(position.x, position.y + 20);
	CGPoint positionAboveBeeater = CGPointMake(beePosition.x, beePosition.y + 30);
	BOOL needsToTurn = [transformComponent position].x < beePosition.x;
	
	// Create sprite
	RenderSprite *beeQueueRenderSprite = [self createBeeQueueRenderSpriteWithBeeType:savedBeeType position:beePosition];
	[_beeQueueRenderSprites addObject:beeQueueRenderSprite];
	
	// Face the slinger
	if (needsToTurn)
	{
		[[beeQueueRenderSprite sprite] setScaleX:-1];
	}
	
	// Move from beeater to slinger queue
	[self increaseMovingBeesCount];
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
	CCEaseSineOut *moveToQueueAction = [CCEaseSineOut actionWithAction:[CCMoveTo actionWithDuration:0.6f position:targetPosition]];
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
	[actions addObject:[self createSwayAction:targetPosition]];
	[[beeQueueRenderSprite sprite] stopActionByTag:ACTION_TAG_BEE_QUEUE];
	CCAction *sequence = [CCSequence actionWithArray:actions];
	[sequence setTag:ACTION_TAG_BEE_QUEUE];
	[[beeQueueRenderSprite sprite] runAction:sequence];
	
	// Add reused bee
	if (savingBeeType != nil &&
		[savingBeeType canBeReused])
	{
		CGPoint endOfQueuePosition = [self calculatePositionForNextBeeQueueRenderSprite:slingerEntity];
		RenderSprite *reusedBeeQueueRenderSprite = [self createBeeQueueRenderSpriteWithBeeType:savingBeeType position:position];
		[_beeQueueRenderSprites addObject:reusedBeeQueueRenderSprite];
		
		[self increaseMovingBeesCount];
		NSMutableArray *reusedBeeActions = [NSMutableArray array];
		BOOL reusedBeeNeedsToTurn = [transformComponent position].x < position.x;
		if (reusedBeeNeedsToTurn)
		{
			[[reusedBeeQueueRenderSprite sprite] setScaleX:-1];
		}
		CCEaseSineOut *moveAction = [CCEaseSineOut actionWithAction:[CCMoveTo actionWithDuration:0.6f position:endOfQueuePosition]];
		[reusedBeeActions addObject:moveAction];
		if (reusedBeeNeedsToTurn)
		{
			CCCallBlock *faceRightAction = [CCCallBlock actionWithBlock:^()
			{
				[[reusedBeeQueueRenderSprite sprite] setScaleX:1];
			}];
			[reusedBeeActions addObject:faceRightAction];
		}
		CCCallFunc *decreaseMovingBeesCountAction2 = [CCCallFunc actionWithTarget:self selector:@selector(decreaseMovingBeesCount)];
		[reusedBeeActions addObject:decreaseMovingBeesCountAction2];
		[reusedBeeActions addObject:[self createSwayAction:endOfQueuePosition]];
		CCSequence *sequence2 = [CCSequence actionWithArray:reusedBeeActions];
		[sequence2 setTag:ACTION_TAG_BEE_QUEUE];
		[[reusedBeeQueueRenderSprite sprite] runAction:sequence2];
	}
}

-(void) refreshSprites
{
	Entity *slingerEntity = [self getSlingerEntity];
    SlingerComponent *slingerSlingerComponent = [_slingerComponentMapper getComponentFor:slingerEntity];

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
		[_beeQueueRenderSprites addObject:beeQueueRenderSprite];
		
		// Sway
		CCAction *swayAction = [self createSwayAction:[[beeQueueRenderSprite sprite] position]];
		[swayAction setTag:ACTION_TAG_BEE_QUEUE];
		[[beeQueueRenderSprite sprite] runAction:swayAction];
    }
}

-(RenderSprite *) createBeeQueueRenderSpriteWithBeeType:(BeeType *)beeType position:(CGPoint)position
{
	// Create sprite
	RenderSprite *beeQueueRenderSprite = [_renderSystem createRenderSpriteWithSpriteSheetName:@"Shared" zOrder:[ZOrder Z_DEFAULT]];
	[[beeQueueRenderSprite sprite] setPosition:position];
	[beeQueueRenderSprite addSpriteToSpriteSheet];
	
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
	TransformComponent *slingerTransformComponent = [_transformComponentMapper getComponentFor:slingerEntity];

	// Method 1: Straight line
//	int x = [slingerTransformComponent position].x + QUEUE_START_OFFSET_X - index * QUEUE_SPACING_X;
//	int y = [slingerTransformComponent position].y + QUEUE_START_OFFSET_Y;
//	return CGPointMake(x, y);
	
	// Method 2: Slightly curved
//	float angle = CC_DEGREES_TO_RADIANS(92 + index * 10);
//	return CGPointMake([slingerTransformComponent position].x - 20 + 150 * cosf(angle),
//					   [slingerTransformComponent position].y - 150 + 150 * sinf(angle));
	
	// Method 3: Vertical
//	int x = [slingerTransformComponent position].x - 32;
//	int y = [slingerTransformComponent position].y - 5 - 20 * index;
//	return CGPointMake(x, y);

	// Method 3: Vertical with first bee closer
	if (index == 0)
	{
		return CGPointMake([slingerTransformComponent position].x - 14.0f, [slingerTransformComponent position].y + 14.0f);
	}
	else
	{
		return CGPointMake([slingerTransformComponent position].x - 30.0f, [slingerTransformComponent position].y - 8.0f - 20.0f * (index - 1));
	}
}

-(CGPoint) calculatePositionForNextBeeQueueRenderSprite:(Entity *)slingerEntity
{
	return [self calculatePositionForBeeQueueRenderSpriteAtIndex:[_beeQueueRenderSprites count] slingerEntity:slingerEntity];
}

-(CCAction *) createSwayAction:(CGPoint)position
{
	float randomSwayDuration = 0.4f + ((rand() % 200) / 1000.0f);
	CCMoveTo *moveUpAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:randomSwayDuration position:CGPointMake(position.x, position.y + (QUEUE_SWAY_Y / 2))]];
	CCMoveTo *moveDownAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:randomSwayDuration position:CGPointMake(position.x, position.y - (QUEUE_SWAY_Y / 2))]];
	CCAction *swayAction = [CCRepeat actionWithAction:[CCSequence actions:moveUpAction, moveDownAction, nil] times:INT_MAX];
	return swayAction;
}

-(void) turnRemainingBeesIntoPollen
{
	for (int i = 0; i < [_beeQueueRenderSprites count]; i++)
	{
		RenderSprite *beeQueueRenderSprite = [_beeQueueRenderSprites objectAtIndex:i];
		[self increaseMovingBeesCount];
        CCDelayTime *waitAction = [CCDelayTime actionWithDuration:(i * 0.8f)];
        CCCallBlock *animateAction = [CCCallBlock actionWithBlock:^(){
            [[CCAnimationCache sharedAnimationCache] addAnimationsWithFile:@"Bees-Animations.plist"];
			[beeQueueRenderSprite playAnimationOnce:@"Bee-Turn-Into-Pollen" andCallBlockAtEnd:^{
				[self decreaseMovingBeesCount];
			}];

	        NSString *pollenString = [NSString stringWithFormat:@"%d", 20];
	        CCLabelAtlas *label = [[CCLabelAtlas alloc] initWithString:@"0" charMapFile:@"numberImages.png" itemWidth:25 itemHeight:30 startCharMap:'/'];
	        [label setString:pollenString];
	        [label setAnchorPoint:CGPointMake(0.5f, 0.5f)];
	        [label setPosition:[[beeQueueRenderSprite sprite] position]];
	        CCScaleTo *scaleAction = [CCScaleTo actionWithDuration:0.8f scale:1.2f];
	        CCFadeOut *fadeAction = [CCFadeOut actionWithDuration:0.8f];
	        CCCallBlock *removeAction = [CCCallBlock actionWithBlock:^{
		        [[_renderSystem layer] removeChild:label cleanup:TRUE];
	        }];
	        CCSequence *sequence = [CCSequence actionOne:fadeAction two:removeAction];
	        [label runAction:scaleAction];
	        [label runAction:sequence];
	        [[_renderSystem layer] addChild:label z:[[ZOrder Z_DEFAULT] z]];
        }];
		[[beeQueueRenderSprite sprite] stopActionByTag:ACTION_TAG_BEE_QUEUE];
        CCAction *action = [CCSequence actions:waitAction, animateAction, nil];
		[action setTag:ACTION_TAG_BEE_QUEUE];
		[[beeQueueRenderSprite sprite] runAction:action];
	}
}

@end

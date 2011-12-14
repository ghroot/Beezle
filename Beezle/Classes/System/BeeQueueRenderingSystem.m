//
//  BeeQueueRenderingSystem.m
//  Beezle
//
//  Created by Me on 14/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeeQueueRenderingSystem.h"
#import "BeeTypes.h"
#import "RenderSprite.h"
#import "SlingerComponent.h"
#import "TransformComponent.h"

#define QUEUE_START_OFFSET_X -30
#define QUEUE_START_OFFSET_Y 0
#define QUEUE_SPACING_X 5
#define QUEUE_SWAY_Y 4

@interface BeeQueueRenderingSystem()

-(void) updateSprites:(CGPoint)slingerPosition;

@end

@implementation BeeQueueRenderingSystem

-(id) initWithLayer:(CCLayer *)layer
{
	if (self = [super initWithTag:@"SLINGER"])
	{
		_layer = layer;
		_beeQueueSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"Sprites.png"];
		[_layer addChild:_beeQueueSpriteSheet];
		
		_shownBeeTypes = [[NSMutableArray alloc] init];
		_beeQueueRenderSprites = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void) dealloc
{
	[_shownBeeTypes release];
	[_beeQueueRenderSprites release];
	
	[super dealloc];
}

-(void) processTaggedEntity:(Entity *)entity
{
    SlingerComponent *slingerComponent = (SlingerComponent *)[entity getComponent:[SlingerComponent class]];
	
	if (![_shownBeeTypes isEqualToArray:[slingerComponent queuedBeeTypes]])
	{
		[_shownBeeTypes removeAllObjects];
		[_shownBeeTypes addObjectsFromArray:[slingerComponent queuedBeeTypes]];
		
		TransformComponent *transformComponent = (TransformComponent *)[entity getComponent:[TransformComponent class]];
		[self updateSprites:[transformComponent position]];
	}
}

-(void) updateSprites:(CGPoint)slingerPosition
{
	// Remove all sprites
	for (RenderSprite *beeQueueRenderSprite in _beeQueueRenderSprites)
	{
		[beeQueueRenderSprite removeSpriteFromSpriteSheet];
	}
	[_beeQueueRenderSprites removeAllObjects];
	
	// Create sprites
    int startX = slingerPosition.x + QUEUE_START_OFFSET_X;
	int startY = slingerPosition.y + QUEUE_START_OFFSET_Y;
    int currentX = startX;
    int currentY = startY;
    for (BeeTypes *beeType in _shownBeeTypes)
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

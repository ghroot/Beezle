//
//  BeeQueueRendering.m
//  Beezle
//
//  Created by Me on 14/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeeQueueRendering.h"
#import "BeeTypes.h"
#import "GameRulesSystem.h"
#import "RenderSprite.h"

@implementation BeeQueueRendering

-(id) initWithLayer:(CCLayer *)layer position:(CGPoint)position gameRulesSystem:(GameRulesSystem *)gameRulesSystem
{
	if (self = [super init])
	{
		_layer = layer;
		_position = position;
		_gameRulesSystem = gameRulesSystem;
		
		_beeQueueRenderSprites = [[NSMutableArray alloc] init];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:@"BeeQueueUpdated" object:_gameRulesSystem];
	}
	return self;
}

-(void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"BeeQueueUpdated" object:_gameRulesSystem];
	
	[_beeQueueRenderSprites release];
	
	[super dealloc];
}

-(void) update
{
	if (_beeQueueSpriteSheet == nil)
	{
		_beeQueueSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"Sprites.png"];
		[_layer addChild:_beeQueueSpriteSheet];
	}
	
	for (RenderSprite *beeQueueRenderSprite in _beeQueueRenderSprites)
	{
		[beeQueueRenderSprite removeSpriteFromSpriteSheet];
	}
	[_beeQueueRenderSprites removeAllObjects];
	
    int startX = _position.x - 30;
	int startY = _position.y;
	
    int currentX = startX;
    int currentY = startY;
    int spacing = 5;
    for (BeeTypes *beeType in [_gameRulesSystem beeQueue])
    {
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
		CCMoveTo *moveUpAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:0.5f position:CGPointMake(currentX, currentY + 2)]];
		CCMoveTo *moveDownAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:0.5f position:CGPointMake(currentX, currentY - 2)]];
		[[beeQueueRenderSprite sprite] runAction:[CCRepeatForever actionWithAction:[CCSequence actions:moveUpAction, moveDownAction, nil]]];
        
		currentX -= [[beeQueueRenderSprite sprite] contentSize].width + spacing;
    }
}

@end

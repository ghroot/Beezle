//
//  HUDSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 29/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HUDRenderingSystem.h"
#import "PlayerInformation.h"

@interface HUDRenderingSystem()

-(void) refreshKeySprites;

@end

@implementation HUDRenderingSystem

-(id) initWithLayer:(CCLayer *)layer
{
	if (self = [super init])
	{
		_layer = layer;
		_keyImageSprites = [NSMutableArray new];
	}
	return self;
}

-(void) dealloc
{
	[_keyImageSprites release];
	
	[super dealloc];
}

-(void) initialise
{
	[self refreshKeySprites];
}

-(void) begin
{
	[self refreshKeySprites];
}

-(void) refreshKeySprites
{
	int numberOfKeys = [[PlayerInformation sharedInformation] totalNumberOfKeys];
	if ([_keyImageSprites count] != numberOfKeys)
	{
		for (CCSprite *keyImageSprite in _keyImageSprites)
		{
			[_layer removeChild:keyImageSprite cleanup:TRUE];
		}
		[_keyImageSprites removeAllObjects];
		
		for (int i = 0; i < numberOfKeys; i++)
		{
			CCSprite *keyImageSprite = [CCSprite spriteWithFile:@"Key-01.png"];
			[keyImageSprite setAnchorPoint:CGPointMake(0.0f, 1.0f)];
			CGSize winSize = [[CCDirector sharedDirector] winSize];
			[keyImageSprite setPosition:CGPointMake(5.0f + (i * (5.0f + [keyImageSprite contentSize].width)), winSize.height - 5.0f)];
			[_keyImageSprites addObject:keyImageSprite];
			[_layer addChild:keyImageSprite];
		}
	}
}

@end

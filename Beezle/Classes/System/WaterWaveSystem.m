//
//  WaterWaveSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 25/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WaterWaveSystem.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "WaterComponent.h"
#import "Waves1DNode.h"

static const float SPLASH_AMOUNT = 0.2f;

@implementation WaterWaveSystem

-(id) init
{
	self = [super initWithUsedComponentClasses:[NSArray arrayWithObject:[WaterComponent class]]];
	return self;
}

-(void) processEntity:(Entity *)entity
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	RenderComponent *renderComponent = [RenderComponent getFrom:entity];
	RenderSprite *renderSprite = [[renderComponent renderSprites] objectAtIndex:0];
	CCSprite *sprite = [renderSprite sprite];
	for (Waves1DNode *wave in [sprite children])
	{
		int randomX = rand() % ((int)winSize.width);
		[wave makeSplashAt:randomX amount:SPLASH_AMOUNT];
	}
}

@end

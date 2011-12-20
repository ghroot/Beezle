//
//  EditRenderingSystem.m
//  Beezle
//
//  Created by Me on 19/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EditOptionsSystem.h"
#import "EditComponent.h"
#import "EditControlSystem.h"
#import "EntityUtil.h"
#import "TransformComponent.h"

@interface EditOptionsSystem()

-(void) createOptionsMenu;

@end

@implementation EditOptionsSystem

-(id) initWithLayer:(CCLayer *)layer
{
	if (self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[EditComponent class], nil]])
	{
		_layer = layer;
		
		[self createOptionsMenu];
	}
	return self;
}

-(void) dealloc
{
	[_optionsMenu release];
	
	[super dealloc];
}

-(void) createOptionsMenu
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	_optionsMenu = [[CCMenu menuWithItems:nil] retain];
	[_optionsMenu setPosition:CGPointMake(winSize.width / 2, 14)];
	CCMenuItemFont *menuItemMirror = [CCMenuItemFont itemFromString:@"Mirror" target:self selector:@selector(doOptionMirror:)];
	[menuItemMirror setFontSize:14];
	[_optionsMenu addChild:menuItemMirror];
	CCMenuItemFont *menuItemRotateLeft = [CCMenuItemFont itemFromString:@"Rotate Left" target:self selector:@selector(doOptionRotateLeft:)];
	[menuItemRotateLeft setFontSize:14];
	[_optionsMenu addChild:menuItemRotateLeft];
	CCMenuItemFont *menuItemRotateRight = [CCMenuItemFont itemFromString:@"Rotate Right" target:self selector:@selector(doOptionRotateRight:)];
	[menuItemRotateRight setFontSize:14];
	[_optionsMenu addChild:menuItemRotateRight];
	[_optionsMenu alignItemsHorizontallyWithPadding:20.0f];
}

-(void) begin
{
	EditControlSystem *editControlSystem = (EditControlSystem *)[[_world systemManager] getSystem:[EditControlSystem class]];
	if (_entityWithOptionsDisplayed != [editControlSystem selectedEntity])
	{
		_entityWithOptionsDisplayed = [editControlSystem selectedEntity];
		if (_entityWithOptionsDisplayed != nil)
		{
			[_layer addChild:_optionsMenu];
		}
		else
		{
			[_layer removeChild:_optionsMenu cleanup:TRUE];
		}
	}
}

-(void) doOptionMirror:(id)sender
{
	TransformComponent *transformComponent = (TransformComponent *)[_entityWithOptionsDisplayed getComponent:[TransformComponent class]];
	[transformComponent setScale:CGPointMake(-[transformComponent scale].x, [transformComponent scale].y)];
}

-(void) doOptionRotateLeft:(id)sender
{
	TransformComponent *transformComponent = (TransformComponent *)[_entityWithOptionsDisplayed getComponent:[TransformComponent class]];
	
	float newAngle = [transformComponent rotation] - 2.0f;
	
	[EntityUtil setEntityRotation:_entityWithOptionsDisplayed rotation:newAngle];
}

-(void) doOptionRotateRight:(id)sender
{
	TransformComponent *transformComponent = (TransformComponent *)[_entityWithOptionsDisplayed getComponent:[TransformComponent class]];
	
	float newAngle = [transformComponent rotation] + 2.0f;
	
	[EntityUtil setEntityRotation:_entityWithOptionsDisplayed rotation:newAngle];
}

@end

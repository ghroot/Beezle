//
//  EditSystem.m
//  Beezle
//
//  Created by Me on 17/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EditControlSystem.h"
#import "ActionTags.h"
#import "BeeQueueRenderingSystem.h"
#import "EditComponent.h"
#import "EntityUtil.h"
#import "InputAction.h"
#import "InputSystem.h"
#import "PhysicsComponent.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "SlingerComponent.h"
#import "TransformComponent.h"

@interface EditControlSystem()

-(Entity *) findClosestEntityToPosition:(CGPoint)position;

@end

@implementation EditControlSystem

@synthesize selectedEntity = _selectedEntity;

-(id) init
{
	self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[EditComponent class], nil]];
	return self;
}

-(void) initialise
{
	_inputSystem = (InputSystem *)[[_world systemManager] getSystem:[InputSystem class]];
	_beeQueueRenderingSystem = (BeeQueueRenderingSystem *)[[_world systemManager] getSystem:[BeeQueueRenderingSystem class]];
}

-(void) begin
{
    while ([_inputSystem hasInputActions])
    {
        InputAction *nextInputAction = [_inputSystem popInputAction];
        
        switch ([nextInputAction touchType])
        {
            case TOUCH_BEGAN:
            {
				_touchBeganLocation = [nextInputAction touchLocation];
				_hasTouchMoved = FALSE;
                break;
            }
            case TOUCH_MOVED:
            {
				if (_selectedEntity != nil)
				{
					CGPoint delta = ccpSub([nextInputAction touchLocation], _touchBeganLocation);
					CGPoint newLocation = ccpAdd(_selectedStartLocation, delta);
					
					[EntityUtil setEntityPosition:_selectedEntity position:newLocation];
					
					if ([_selectedEntity hasComponent:[SlingerComponent class]])
					{
						[_beeQueueRenderingSystem refreshSprites];
					}
				}
				_hasTouchMoved = TRUE;
                break;
            }
            case TOUCH_ENDED:
            case TOUCH_CANCELLED:
            {
				if (_hasTouchMoved)
				{
					if (_selectedEntity != nil)
					{
						TransformComponent *selectedTransformComponent = [TransformComponent getFrom:_selectedEntity];
						_selectedStartLocation = [selectedTransformComponent position];
					}
				}
				else
				{
					if (_selectedEntity != nil)
					{
						[self deselectSelectedEntity];
					}
					else
					{
						Entity *closestEntity = [self findClosestEntityToPosition:[nextInputAction touchLocation]];
                        if (closestEntity != nil)
                        {
							[self selectEntity:closestEntity];
                        }
					}
				}
                break;
            }
        }
    }
}

-(void) selectEntity:(Entity *)entity
{
	if (_selectedEntity != nil)
	{
		[self deselectSelectedEntity];
	}
	
	_selectedEntity = entity;
	TransformComponent *transformComponent = [TransformComponent getFrom:entity];
	_selectedStartLocation = [transformComponent position];
	RenderComponent *renderComponent = [RenderComponent getFrom:entity];
	for (RenderSprite *renderSprite in [renderComponent renderSprites])
	{
		CCTintTo *tintAction1 = [CCTintTo actionWithDuration:0.2f red:200 green:200 blue:200];
		CCTintTo *tintAction2 = [CCTintTo actionWithDuration:0.2f red:255 green:255 blue:255];
		CCSequence *sequenceAction = [CCSequence actions:tintAction1, tintAction2, nil];
		CCRepeatForever *repeatAction = [CCRepeatForever actionWithAction:sequenceAction];
		[repeatAction setTag:ACTION_TAG_EDIT_TINT];
		[[renderSprite sprite] stopActionByTag:ACTION_TAG_EDIT_TINT];
		[[renderSprite sprite] runAction:repeatAction];
	}
}

-(void) deselectSelectedEntity
{
	RenderComponent *renderComponent = [RenderComponent getFrom:_selectedEntity];
	for (RenderSprite *renderSprite in [renderComponent renderSprites])
	{
		CCTintTo *tintAction = [CCTintTo actionWithDuration:0.2f red:255 green:255 blue:255];
		[tintAction setTag:ACTION_TAG_EDIT_TINT];
		[[renderSprite sprite] stopActionByTag:ACTION_TAG_EDIT_TINT];
		[[renderSprite sprite] runAction:tintAction];
	}
	_selectedEntity = nil;
}

-(Entity *) findClosestEntityToPosition:(CGPoint)position
{
	Entity *closestEntity = nil;
	float closestDistance = MAXFLOAT;
	for (Entity *entity in _entities)
	{
		TransformComponent *transformComponent = [TransformComponent getFrom:entity];
		float distance = ccpDistance(position, [transformComponent position]);
		if (distance < closestDistance)
		{
			closestDistance = distance;
			closestEntity = entity;
		}
	}
	return closestEntity;
}

@end

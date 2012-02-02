//
//  EditSystem.m
//  Beezle
//
//  Created by Me on 17/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EditControlSystem.h"
#import "ActionTags.h"
#import "EditComponent.h"
#import "EntityUtil.h"
#import "InputAction.h"
#import "InputSystem.h"
#import "NotificationTypes.h"
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

-(void) begin
{
	if (_selectedEntity && [_selectedEntity deleted])
	{
		_selectedEntity = nil;
		return;
	}
	
    InputSystem *inputSystem = (InputSystem *)[[_world systemManager] getSystem:[InputSystem class]];
    if ([inputSystem hasInputActions])
    {
        InputAction *nextInputAction = [inputSystem popInputAction];
        
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
					
					// Game notification
					[[NSNotificationCenter defaultCenter] postNotificationName:EDIT_NOTIFICATION_ENTITY_MOVED object:self];
				}
				_hasTouchMoved = TRUE;
                break;
            }
            case TOUCH_ENDED:
            {
				if (_hasTouchMoved)
				{
					if (_selectedEntity != nil)
					{
						TransformComponent *selectedTransformComponent = (TransformComponent *)[_selectedEntity getComponent:[TransformComponent class]];
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
	TransformComponent *transformComponent = (TransformComponent *)[entity getComponent:[TransformComponent class]];
	_selectedStartLocation = [transformComponent position];
	RenderComponent *renderComponent = (RenderComponent *)[entity getComponent:[RenderComponent class]];
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
	RenderComponent *renderComponent = (RenderComponent *)[_selectedEntity getComponent:[RenderComponent class]];
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
		TransformComponent *transformComponent = (TransformComponent *)[entity getComponent:[TransformComponent class]];
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

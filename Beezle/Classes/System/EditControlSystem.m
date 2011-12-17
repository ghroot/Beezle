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
#import "InputAction.h"
#import "InputSystem.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "TransformComponent.h"

@implementation EditControlSystem

-(id) init
{
	self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[EditComponent class], nil]];
	return self;
}

-(void) processEntity:(Entity *)entity
{
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
					TransformComponent *selectedTransformComponent = (TransformComponent *)[_selectedEntity getComponent:[TransformComponent class]];
					CGPoint delta = ccpSub([nextInputAction touchLocation], _touchBeganLocation);
					CGPoint newLocation = ccpAdd(_selectedStartLocation, delta);
					[selectedTransformComponent setPosition:newLocation];
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
						NSLog(@"Deselecting %@", _selectedEntity);
						
						EditComponent *selectedEditComponent = (EditComponent *)[_selectedEntity getComponent:[EditComponent class]];
						[selectedEditComponent setIsSelected:FALSE];
						RenderComponent *selectedRenderComponent = (RenderComponent *)[_selectedEntity getComponent:[RenderComponent class]];
						RenderSprite *selectedRenderSprite = (RenderSprite *)[[selectedRenderComponent renderSprites] objectAtIndex:0];
						CCTintTo *tintAction = [CCTintTo actionWithDuration:0.2f red:255 green:255 blue:255];
						[tintAction setTag:ACTION_TAG_EDIT_TINT];
						[[selectedRenderSprite sprite] stopActionByTag:ACTION_TAG_EDIT_TINT];
						[[selectedRenderSprite sprite] runAction:tintAction];
						_selectedEntity = nil;
					}
					else
					{
						Entity *closestEntity = nil;
						float closestDistance = MAXFLOAT;
						for (Entity *entity in [[_world entityManager] entities])
						{
							TransformComponent *transformComponent = (TransformComponent *)[entity getComponent:[TransformComponent class]];
							float distance = ccpDistance([nextInputAction touchLocation], [transformComponent position]);
							if (distance < closestDistance)
							{
								closestDistance = distance;
								closestEntity = entity;
							}
						}
						
						NSLog(@"Selecting %@", closestEntity);
						
						EditComponent *closestEditComponent = (EditComponent *)[closestEntity getComponent:[EditComponent class]];
						[closestEditComponent setIsSelected:TRUE];
						_selectedEntity = closestEntity;
						TransformComponent *closestTransformComponent = (TransformComponent *)[closestEntity getComponent:[TransformComponent class]];
						_selectedStartLocation = [closestTransformComponent position];
						RenderComponent *closestRenderComponent = (RenderComponent *)[closestEntity getComponent:[RenderComponent class]];
						RenderSprite *closestRenderSprite = (RenderSprite *)[[closestRenderComponent renderSprites] objectAtIndex:0];
						CCTintTo *tintAction1 = [CCTintTo actionWithDuration:0.2f red:200 green:200 blue:200];
						CCTintTo *tintAction2 = [CCTintTo actionWithDuration:0.2f red:255 green:255 blue:255];
						CCSequence *sequenceAction = [CCSequence actions:tintAction1, tintAction2, nil];
						CCRepeatForever *repeatAction = [CCRepeatForever actionWithAction:sequenceAction];
						[repeatAction setTag:ACTION_TAG_EDIT_TINT];
						[[closestRenderSprite sprite] stopActionByTag:ACTION_TAG_EDIT_TINT];
						[[closestRenderSprite sprite] runAction:repeatAction];
					}
				}
                break;
            }
        }
    }
}

@end

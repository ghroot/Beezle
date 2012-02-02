//
//  EditSystem.h
//  Beezle
//
//  Created by Me on 17/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "ObjectiveChipmunk.h"

@class InputSystem;

@interface EditControlSystem : EntityComponentSystem
{
	InputSystem *_inputSystem;
	
	CGPoint _touchBeganLocation;
	BOOL _hasTouchMoved;
	Entity *_selectedEntity;
	CGPoint _selectedStartLocation;
}

@property (nonatomic, readonly) Entity *selectedEntity;

-(void) selectEntity:(Entity *)entity;
-(void) deselectSelectedEntity;

@end

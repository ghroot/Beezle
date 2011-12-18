//
//  EditSystem.h
//  Beezle
//
//  Created by Me on 17/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "chipmunk.h"

@interface EditControlSystem : EntityComponentSystem
{
	CGPoint _touchBeganLocation;
	BOOL _hasTouchMoved;
	Entity *_selectedEntity;
	CGPoint _selectedStartLocation;
}

@end

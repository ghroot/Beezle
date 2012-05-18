//
//  EditRenderingSystem.h
//  Beezle
//
//  Created by Me on 19/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "cocos2d.h"

@class BeeaterSystem;
@class BeeQueueRenderingSystem;
@class EditControlSystem;
@class EditState;

@interface EditOptionsSystem : EntityComponentSystem
{
	EditControlSystem *_editControlSystem;
	BeeQueueRenderingSystem *_beeQueueRenderingSystem;
	BeeaterSystem *_beeaterSystem;
	
	EditState *_editState;
	CCLayer *_layer;
	
	CCMenu *_generalOptionsMenu;
	CCMenu *_generalEntityOptionsMenu;
	Entity *_entityWithOptionsDisplayed;
	CCMenu *_beeaterOptionsMenu;
	CCMenu *_slingerOptionsMenu;
	CCMenu *_movementOptionsMenu;
	CCMenu *_reflectionOptionsMenu;
}

-(id) initWithLayer:(CCLayer *)layer andEditState:(EditState *)editState;

@end

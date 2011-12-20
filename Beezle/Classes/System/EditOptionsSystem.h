//
//  EditRenderingSystem.h
//  Beezle
//
//  Created by Me on 19/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "chipmunk.h"
#import "cocos2d.h"

@interface EditOptionsSystem : EntityComponentSystem
{
	CCLayer *_layer;
	
	CCMenu *_optionsMenu;
	Entity *_entityWithOptionsDisplayed;
}

-(id) initWithLayer:(CCLayer *)layer;

-(void) doOptionMirror:(id)sender;
-(void) doOptionRotateLeft:(id)sender;
-(void) doOptionRotateRight:(id)sender;

@end

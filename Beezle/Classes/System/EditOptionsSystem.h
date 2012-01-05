//
//  EditRenderingSystem.h
//  Beezle
//
//  Created by Me on 19/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "cocos2d.h"

@interface EditOptionsSystem : EntityComponentSystem
{
	CCLayer *_layer;
	
	CCMenu *_generalOptionsMenu;
	CCMenu *_generalEntityOptionsMenu;
	Entity *_entityWithOptionsDisplayed;
	CCMenu *_beeaterOptionsMenu;
	CCMenu *_slingerOptionsMenu;
}

-(id) initWithLayer:(CCLayer *)layer;

-(void) doOptionAddEntity:(id)sender;

-(void) doOptionMirror:(id)sender;
-(void) doOptionRotateLeft:(id)sender;
-(void) doOptionRotateRight:(id)sender;
-(void) doOptionDelete:(id)sender;

-(void) doOptionSetBeeaterBeeType:(id)sender;

-(void) doOptionAddSlingerBeeType:(id)sender;
-(void) doOptionClearSlingerBees:(id)sender;

@end

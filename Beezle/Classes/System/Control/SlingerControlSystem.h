//
//  SlingerControlSystem
//  Beezle
//
//  Created by marcus on 08/10/2012.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "cocos2d.h"

@class InputSystem;
@class RenderSystem;
@class CDSoundSource;

@interface SlingerControlSystem : EntityComponentSystem
{
	InputSystem *_inputSystem;
	RenderSystem *_renderSystem;

	ComponentMapper *_transformComponentMapper;
	ComponentMapper *_trajectoryComponentMapper;
	ComponentMapper *_slingerComponentMapper;
	ComponentMapper *_renderComponentMapper;

	BOOL _stretchSoundPlayed;
	CDSoundSource *_soundSource;
}

@end

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

	CGPoint _startLocation;
	float _startAngle;
	float _currentAngle;
	float _startPower;
	float _currentPower;
	NSTimeInterval _touchBeganTime;

	BOOL _stretchSoundPlayed;
	CDSoundSource *_soundSource;

	CCSprite *_controlChangeTextSprite;
}

-(void) reset:(Entity *)slingerEntity;

@end

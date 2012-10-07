//
//  SlingerControlSystem.h
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "cocos2d.h"

@class InputSystem;

@interface SlingerControlSystem : EntityComponentSystem
{
	InputSystem *_inputSystem;
	
    CGPoint _startLocation;
    float _startAngle;
	float _currentAngle;
	float _currentPower;
    
	BOOL _stretchSoundPlayed;
}

@end

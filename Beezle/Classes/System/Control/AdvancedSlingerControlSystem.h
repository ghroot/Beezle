//
//  AdvancedSlingerControlSystem
//  Beezle
//
//  Created by marcus on 08/10/2012.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "cocos2d.h"

@class InputSystem;

@interface AdvancedSlingerControlSystem : EntityComponentSystem
{
	InputSystem *_inputSystem;

	CGPoint _startLocation;
	float _startAngle;
	float _currentAngle;

	BOOL _stretchSoundPlayed;
}

@end

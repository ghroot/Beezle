//
//  AdvancedSlingerControlSystem
//  Beezle
//
//  Created by marcus on 08/10/2012.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "cocos2d.h"
#import "SlingerControlSystem.h"

@class InputSystem;

@interface AdvancedSlingerControlSystem : SlingerControlSystem
{
	InputSystem *_inputSystem;

	CGPoint _startLocation;
	float _startAngle;
	float _currentAngle;

	BOOL _stretchSoundPlayed;
}

@end

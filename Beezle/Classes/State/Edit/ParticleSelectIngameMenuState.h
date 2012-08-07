//
//  ParticleSelectIngameMenuState.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/07/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "cocos2d.h"

@interface ParticleSelectIngameMenuState : GameState
{
	CCMenu *_menu;
}

-(id) initWithParticleNames:(NSArray *)particleNames;

@end

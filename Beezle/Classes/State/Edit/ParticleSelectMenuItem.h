//
//  ParticleSelectMenuItem.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/07/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface ParticleSelectMenuItem : CCMenuItemFont
{
	NSString *_particleName;
}

-(id) initWithParticleName:(NSString *)particleName target:(id)target selector:(SEL)selector;

@end

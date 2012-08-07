//
//  ParticleGroupSelectMenuItem.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/07/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface ParticleGroupSelectMenuItem : CCMenuItemFont
{
	NSArray *_particleNames;
}

@property (nonatomic, readonly) NSArray *particleNames;

-(id) initWithParticleNames:(NSArray *)particleNames target:(id)target selector:(SEL)selector;

@end

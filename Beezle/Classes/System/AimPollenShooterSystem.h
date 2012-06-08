//
//  AimPollenShooterSystem.h
//  Beezle
//
//  Created by KM Lagerstrom on 26/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface AimPollenShooterSystem : EntityComponentSystem
{
	ComponentMapper *_slingerComponentMapper;
	ComponentMapper *_trajectoryComponentMapper;
}

@end

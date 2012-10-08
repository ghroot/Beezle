//
//  SlingerControlSystem
//  Beezle
//
//  Created by marcus on 08/10/2012.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SlingerControlSystem.h"
#import "SlingerComponent.h"

@implementation SlingerControlSystem

-(id) init
{
	self = [super initWithUsedComponentClasses:[NSArray arrayWithObject:[SlingerComponent class]]];
	return self;
}

@end

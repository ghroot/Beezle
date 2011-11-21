//
//  BoundryComponent.h
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class Boundry;

@interface BoundryComponent : Component
{
    Boundry *_boundry;
}

@property (nonatomic, retain) Boundry *boundry;

-(id) initWithBoundry:(Boundry *)boundry;

@end

//
//  PhysicalBehaviour.h
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AbstractBehaviour.h"

#import "chipmunk.h"

@interface PhysicalBehaviour : AbstractBehaviour
{
    cpBody *_body;
    cpShape *_shape;
}

-(id) initWithBody:(cpBody *)body andShape:(cpShape *)shape;

@end

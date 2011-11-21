//
//  BoundrySystem.m
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BoundrySystem.h"
#import "Boundry.h"
#import "BoundryComponent.h"
#import "TransformComponent.h"

@implementation BoundrySystem

-(id) init
{
    if (self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[TransformComponent class], [BoundryComponent class], nil]])
    {   
        
    }
    return self;
}

-(void) processEntity:(Entity *)entity
{
    TransformComponent *transformComponent = (TransformComponent *)[entity getComponent:[TransformComponent class]];
    BoundryComponent *boundryComponent = (BoundryComponent *)[entity getComponent:[BoundryComponent class]];
    
    CGPoint enforcedLocation = [[boundryComponent boundry] getEnforcedLocation:[transformComponent position]];
    [transformComponent setPosition:enforcedLocation];
}

@end

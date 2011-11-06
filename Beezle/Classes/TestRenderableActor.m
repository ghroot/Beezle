//
//  TestRenderableActor.m
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TestRenderableActor.h"

@implementation TestRenderableActor

- (id)init
{
    if (self = [super init])
    {
        RenderableBehaviour *renderableBehaviour = [[RenderableBehaviour alloc] initWithFile:@"Beeater-01.png"];
        renderableBehaviour.name = @"renderable";
        [self addBehaviour:renderableBehaviour];
    }
    return self;
}

@end

//
//  DragComponent.h
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Component.h"

@interface DragComponent : Component
{
    CGPoint _dragStartLocation;
    float _scale;
}

@property (nonatomic) CGPoint dragStartLocation;
@property (nonatomic) float scale;

-(id) initWithScale:(float)scale;

@end

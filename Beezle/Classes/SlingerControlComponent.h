//
//  DragComponent.h
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Component.h"

@interface SlingerControlComponent : Component
{
    CGPoint _dragStartLocation;
}

@property (nonatomic) CGPoint dragStartLocation;

@end

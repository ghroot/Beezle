//
//  DragSystem.h
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntityProcessingSystem.h"

@interface SlingerControlSystem : EntityProcessingSystem
{
    CGPoint _startLocation;
}

@property (nonatomic) CGPoint startLocation;

@end
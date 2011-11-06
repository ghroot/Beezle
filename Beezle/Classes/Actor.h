//
//  Actor.h
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RenderableBehaviour.h"
#import "PhysicalBehaviour.h"

@class GameLayer;

@interface Actor : NSObject
{
    NSMutableArray *_behaviours;
}

-(void) addBehaviour:(AbstractBehaviour *)behaviour;
-(AbstractBehaviour *) getBehaviour:(NSString *)name;
-(BOOL) hasBehaviour:(NSString *)name;
-(void) addedToLayer:(GameLayer *)layer;
-(void) removedFromLayer:(GameLayer *)layer;
-(void) setPosition:(CGPoint) position;
-(void) update:(ccTime) delta;

@end

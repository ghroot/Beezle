//
//  AbstractBehaviour.h
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"

@class Actor;

@interface AbstractBehaviour : NSObject
{
    NSString *_name;
    Actor *_parentActor;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) Actor *parentActor;

-(void) addedToLayer:(GameLayer *)layer;
-(void) removedFromLayer:(GameLayer *)layer;
-(void) setPosition:(CGPoint)position;
-(void) update:(ccTime) delta;

@end

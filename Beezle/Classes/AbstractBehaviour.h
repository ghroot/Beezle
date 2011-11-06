//
//  AbstractBehaviour.h
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"

@interface AbstractBehaviour : NSObject
{
    NSString *name;
}

@property (nonatomic, retain) NSString *name;

-(void) addedToLayer:(GameLayer *)layer;
-(void) removedFromLayer:(GameLayer *)layer;
-(void) setPosition:(CGPoint)position;

@end

//
//  BodyInfo.h
//  Beezle
//
//  Created by Me on 03/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ObjectiveChipmunk.h"

@interface BodyInfo : NSObject
{
    ChipmunkBody *_body;
    NSMutableArray *_shapes;
}

@property (nonatomic, retain) ChipmunkBody *body;
@property (nonatomic, readonly) NSArray *shapes;

-(void) setBody:(ChipmunkBody *)body;
-(void) addShape:(ChipmunkShape *)shape;

@end

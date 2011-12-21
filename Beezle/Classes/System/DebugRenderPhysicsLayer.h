//
//  DebugRenderPhysicsLayer.h
//  Beezle
//
//  Created by Me on 07/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "ObjectiveChipmunk.h"

@interface DebugRenderPhysicsLayer : CCLayer
{
    NSMutableArray *_shapesToDraw;
}

@property (nonatomic, retain) NSMutableArray *shapesToDraw;

-(void) drawShape:(ChipmunkShape *)shape;

@end

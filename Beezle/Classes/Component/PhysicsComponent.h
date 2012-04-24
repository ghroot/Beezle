//
//  PhysicalBehaviour.h
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Component.h"
#import "artemis.h"
#import "cocos2d.h"
#import "ObjectiveChipmunk.h"

@class PhysicsBody;
@class PhysicsShape;

@interface PhysicsComponent : Component
{
    ChipmunkBody *_body;
    NSMutableArray *_shapes;
	BOOL _positionOrRotationUpdatedManually;
}

@property (nonatomic, retain) ChipmunkBody *body;
@property (nonatomic, readonly) NSArray *shapes;
@property (nonatomic) BOOL positionOrRotationUpdatedManually;

+(id) componentWithBody:(ChipmunkBody *)body andShapes:(NSArray *)shapes;
+(id) componentWithBody:(ChipmunkBody *)body andShape:(ChipmunkShape *)shape;

-(id) initWithBody:(ChipmunkBody *)body andShapes:(NSArray *)shapes;
-(id) initWithBody:(ChipmunkBody *)body andShape:(ChipmunkShape *)shape;
-(BOOL) isRougeBody;
-(void) addShape:(ChipmunkShape *)shape;
-(void) setLayers:(cpLayers)layers;
-(void) setPositionManually:(CGPoint)position;
-(void) setRotationManually:(float)rotation;
-(cpBB) boundingBox;

@end

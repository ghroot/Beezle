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
	BOOL _positionUpdatedManually;
}

@property (nonatomic, retain) ChipmunkBody *body;
@property (nonatomic, readonly) NSArray *shapes;
@property (nonatomic) BOOL positionUpdatedManually;

+(id) componentWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world;
+(id) componentWithBody:(ChipmunkBody *)body andShapes:(NSArray *)shapes;
+(id) componentWithBody:(ChipmunkBody *)body andShape:(ChipmunkShape *)shape;

-(id) initWithBody:(ChipmunkBody *)body andShapes:(NSArray *)shapes;
-(id) initWithBody:(ChipmunkBody *)body andShape:(ChipmunkShape *)shape;
-(BOOL) isRougeBody;
-(void) addShape:(ChipmunkShape *)shape;
-(ChipmunkShape *) firstPhysicsShape;
-(void) setPositionManually:(CGPoint)position;
-(void) setRotationManually:(float)rotation;

@end

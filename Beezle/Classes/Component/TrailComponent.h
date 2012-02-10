//
//  TrailComponent.h
//  Beezle
//
//  Created by KM Lagerstrom on 10/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Component.h"

@interface TrailComponent : Component
{
	NSString *_entityType;
	NSString *_animationName;
	float _interval;
	float _countdown;
}

@property (nonatomic, readonly) NSString *entityType;
@property (nonatomic, readonly) NSString *animationName;
@property (nonatomic, readonly) float interval;
@property (nonatomic) float countdown;

+(id) componentWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world;

-(id) initWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world;

-(void) resetCountdown;

@end

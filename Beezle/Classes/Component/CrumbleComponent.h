//
//  CrumbleComponent.h
//  Beezle
//
//  Created by KM Lagerstrom on 15/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Component.h"

@interface CrumbleComponent : Component
{
	NSString *_crumbleAnimationName;
}

@property (nonatomic, retain) NSString *crumbleAnimationName;

+(CrumbleComponent *) componentWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world;

@end

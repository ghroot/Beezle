//
//  TransformBehaviour.h
//  Beezle
//
//  Created by Me on 07/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface TransformComponent : Component
{
    CGPoint _position;
    float _rotation;
    CGPoint _scale;
}

@property (nonatomic) CGPoint position;
@property (nonatomic) float rotation;
@property (nonatomic) CGPoint scale;

+(id) componentWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world;
+(id) componentWithPosition:(CGPoint)position;

-(id) initWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world;
-(id) initWithPosition:(CGPoint)position;

@end

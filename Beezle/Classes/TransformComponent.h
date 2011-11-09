//
//  TransformBehaviour.h
//  Beezle
//
//  Created by Me on 07/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AbstractComponent.h"

@interface TransformComponent : AbstractComponent
{
    CGPoint _position;
    float _rotation;
    float _scale;
}

@property (nonatomic) CGPoint position;
@property (nonatomic) float rotation;
@property (nonatomic) float scale;

-(id) initWithPosition:(CGPoint)position;

@end

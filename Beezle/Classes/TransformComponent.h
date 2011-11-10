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
}

@property (nonatomic) CGPoint position;
@property (nonatomic) float rotation;

-(id) initWithPosition:(CGPoint)position;

@end

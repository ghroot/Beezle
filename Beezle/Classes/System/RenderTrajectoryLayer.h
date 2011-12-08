//
//  RenderTrajectoryLayer.h
//  Beezle
//
//  Created by Me on 08/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface RenderTrajectoryLayer : CCLayer
{
	CGPoint _startPoint;
	CGPoint _startVelocity;
	CGPoint _gravity;
}

@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint startVelocity;
@property (nonatomic) CGPoint gravity;

@end

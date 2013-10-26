//
// Created by Marcus on 2013-10-16.
//

#import "SonarSprite.h"

@implementation SonarSprite

-(void) draw
{
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	ccDrawColor4B(0, 0, 255, [(id<CCRGBAProtocol>) self opacity]);
	ccDrawCircle(CGPointZero, 16.0f * _scaleX, 0, 20, FALSE);
}

@end

//
// Created by Marcus on 2013-09-24.
//

#import "cocos2d.h"

@interface CCAnchorPointTo : CCActionInterval <NSCopying>
{
	float _anchorPointX;
	float _anchorPointY;
	float _startAnchorPointX;
	float _startAnchorPointY;
	float _endAnchorPointX;
	float _endAnchorPointY;
	float _deltaX;
	float _deltaY;
}

+(id) actionWithDuration:(ccTime)duration anchorPoint:(CGPoint)anchorPoint;
-(id) initWithDuration:(ccTime)duration anchorPoint:(CGPoint)anchorPoint;

@end
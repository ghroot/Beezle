//
// Created by Marcus on 2013-09-24.
//

#import "CCAnchorPointTo.h"

@implementation CCAnchorPointTo

+(id) actionWithDuration:(ccTime)duration anchorPoint:(CGPoint)anchorPoint
{
	return [[[self alloc] initWithDuration:duration anchorPoint:anchorPoint] autorelease];
}

-(id) initWithDuration: (ccTime)duration anchorPoint:(CGPoint)anchorPoint
{
	if (self = [super initWithDuration:duration])
	{
		_endAnchorPointX = anchorPoint.x;
		_endAnchorPointY = anchorPoint.y;
	}
	return self;
}

-(id) copyWithZone:(NSZone*)zone
{
	CCAction *copy = [[[self class] allocWithZone: zone] initWithDuration:[self duration] anchorPoint:CGPointMake(_endAnchorPointX, _endAnchorPointY)];
	return copy;
}

-(void) startWithTarget:(CCNode *)aTarget
{
	[super startWithTarget:aTarget];
	_startAnchorPointX = [_target anchorPoint].x;
	_startAnchorPointY = [_target anchorPoint].y;
	_deltaX = _endAnchorPointX - _startAnchorPointX;
	_deltaY = _endAnchorPointY - _startAnchorPointY;
}

-(void) update:(ccTime)t
{
	[_target setAnchorPoint:CGPointMake(_startAnchorPointX + _deltaX * t, _startAnchorPointY + _deltaY * t)];
}
@end
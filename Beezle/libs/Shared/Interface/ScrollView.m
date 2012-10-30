//
//  ScrollView.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/20/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScrollView.h"
#import "ActionTags.h"

static const float SIGNIFICANT_DRAG_DISTANCE = 10.0f;

@interface ScrollView()

-(BOOL) isTouching;
-(CGPoint) touchLocation;
-(void) startDragging;
-(void) stopDragging;
-(void) updateDragging;
-(void) updateSliding;
-(void) applyVelocity;

@end

@implementation ScrollView

@synthesize didDragSignificantDistance = _didDragSignificantDistance;

+(id) viewWithContent:(CCNode *)node
{
	return [[[self alloc] initWithContent:node] autorelease];
}

-(id) initWithContent:(CCNode *)node
{
	if (self = [super init])
	{
		_draggableNode = [node retain];
		_touches = [NSMutableArray new];
		_previousDragTouchX = [NSMutableArray new];

		[self addChild:_draggableNode];

		[self setIsTouchEnabled:TRUE];
	}
	return self;
}

-(void) dealloc
{
	[_draggableNode release];
	[_touches release];
	[_previousDragTouchX release];

	[super dealloc];
}

-(void) registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:FALSE];
}

-(void) onEnter
{
	[super onEnter];

	[self scheduleUpdate];
}

-(void) onExit
{
	[super onExit];

	[self unscheduleUpdate];
}

-(void) update:(ccTime)delta
{
	if (_isDragging)
	{
		if ([self isTouching])
		{
			[self updateDragging];
		}
		else
		{
			[self stopDragging];
		}
	}
	else
	{
		if ([self isTouching])
		{
			[self startDragging];
		}
		else
		{
			[self updateSliding];
		}
	}
}

-(BOOL) isTouching
{
	return [_touches count] > 0;
}

-(CGPoint) touchLocation
{
	if ([_touches count] > 0)
	{
		UITouch *touch = [_touches lastObject];
		CGPoint location = [touch locationInView:[touch view]];
		CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
		return convertedLocation;
	}
	else
	{
		return CGPointZero;
	}
}

-(void) startDragging
{
	_isDragging = TRUE;
	_startDragTouchX = [self touchLocation].x;
	_startDragNodeX = [_draggableNode position].x;
	_velocityX = 0.0f;
	[_draggableNode stopActionByTag:ACTION_TAG_ELASTIC_SWIPE];
	_didDragSignificantDistance = FALSE;
}

-(void) stopDragging
{
	_isDragging = FALSE;
	if ([_previousDragTouchX count] >= 3)
	{
		float previousDragTouchX1 = [[_previousDragTouchX objectAtIndex:0] floatValue];
		float previousDragTouchX2 = [[_previousDragTouchX objectAtIndex:1] floatValue];
		float previousDragTouchX3 = [[_previousDragTouchX objectAtIndex:2] floatValue];
		float firstDistance = previousDragTouchX3 - previousDragTouchX2;
		float secondDistance = previousDragTouchX2 - previousDragTouchX1;
		float averageDistance = (firstDistance + secondDistance) / 2;
		_velocityX = averageDistance / 2.0f;
	}
	_didDragSignificantDistance = FALSE;
}

-(void) updateDragging
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	float newX = _startDragNodeX + ([self touchLocation].x - _startDragTouchX);
	float minX = winSize.width - [_draggableNode contentSize].width;
	float maxX = 0.0f;
	if (newX > maxX)
	{
		newX = maxX + 0.2f * newX;
	}
	else if (newX < minX)
	{
		newX = minX + 0.2f * (newX - minX);
	}
	[_draggableNode setPosition:CGPointMake(newX, 0)];

	[_previousDragTouchX addObject:[NSNumber numberWithFloat:[self touchLocation].x]];
	while ([_previousDragTouchX count] > 3)
	{
		[_previousDragTouchX removeObjectAtIndex:0];
	}

	if (!_didDragSignificantDistance &&
		fabsf(_startDragTouchX - [self touchLocation].x) >= SIGNIFICANT_DRAG_DISTANCE)
	{
		_didDragSignificantDistance = TRUE;
	}
}

-(void) updateSliding
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	float minX = winSize.width - [_draggableNode contentSize].width;
	float maxX = 0.0f;

	if ([_draggableNode position].x > maxX)
	{
		BOOL bounce = FALSE;

		if (_velocityX == 0.0f)
		{
			bounce = [_draggableNode getActionByTag:ACTION_TAG_ELASTIC_SWIPE] == nil;
		}
		else
		{
			float velocityXBefore = _velocityX;
			_velocityX *= 0.6f;
			bounce = velocityXBefore > 0.0f && fabsf(_velocityX) <= 1.0f;
		}

		if (bounce)
		{
			_velocityX = 0.0f;
			CCMoveTo *moveAction = [CCEaseSineOut actionWithAction:[CCMoveTo actionWithDuration:0.3f position:CGPointMake(maxX, 0.0f)]];
			[moveAction setTag:ACTION_TAG_ELASTIC_SWIPE];
			[_draggableNode runAction:moveAction];
		}
	}
	else if ([_draggableNode position].x < minX)
	{
		BOOL bounce = FALSE;

		if (_velocityX == 0.0f)
		{
			bounce = [_draggableNode getActionByTag:ACTION_TAG_ELASTIC_SWIPE] == nil;
		}
		else
		{
			float velocityXBefore = _velocityX;
			_velocityX *= 0.6f;
			bounce = velocityXBefore < 0.0f && fabsf(_velocityX) <= 1.0f;
		}

		if (bounce)
		{
			_velocityX = 0.0f;
			CCMoveTo *moveAction = [CCEaseSineOut actionWithAction:[CCMoveTo actionWithDuration:0.3f position:CGPointMake(minX, 0.0f)]];
			[moveAction setTag:ACTION_TAG_ELASTIC_SWIPE];
			[_draggableNode runAction:moveAction];
		}
	}
	else
	{
		_velocityX *= 0.94f;
	}

	[self applyVelocity];
}

-(void) applyVelocity
{
	float newX = [_draggableNode position].x + _velocityX;
	float newY = [_draggableNode position].y;
	[_draggableNode setPosition:CGPointMake(newX, newY)];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if (![_touches containsObject:touch])
	{
		[_touches addObject:touch];
	}
	return TRUE;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	if ([_touches containsObject:touch])
	{
		[_touches removeObject:touch];
	}
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self ccTouchEnded:touch withEvent:event];
}

-(float) distanceLeftToScrollRight
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	float minX = winSize.width - [_draggableNode contentSize].width;
	return [_draggableNode position].x - minX;
}

@end

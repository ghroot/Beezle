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
-(void) updateSliding:(float)delta;
-(void) applyVelocity;

@end

@implementation ScrollView

@synthesize scrollHorizontally = _scrollHorizontally;
@synthesize scrollVertically = _scrollVertically;
@synthesize constantVelocity = _constantVelocity;
@synthesize constantVelocityDelay = _constantVelocityDelay;
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
		_previousDragTouchPositions = [NSMutableArray new];

		[self addChild:_draggableNode];

		[self setTouchEnabled:TRUE];
	}
	return self;
}

-(void) dealloc
{
	[_draggableNode release];
	[_touches release];
	[_previousDragTouchPositions release];

	[super dealloc];
}

-(void) setScrollHorizontally:(BOOL)scrollHorizontally
{
	_scrollHorizontally = scrollHorizontally;
	if (_scrollHorizontally)
	{
		_scrollVertically = FALSE;
	}
}

-(void) setScrollVertically:(BOOL)scrollVertically
{
	_scrollVertically = scrollVertically;
	if (_scrollVertically)
	{
		_scrollHorizontally = FALSE;
	}
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
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	if ([_draggableNode contentSize].width > winSize.width ||
			[_draggableNode contentSize].height > winSize.height)
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
				[self updateSliding:delta];
			}
		}
	}
	else
	{
		[_draggableNode setPosition:CGPointMake((winSize.width - [_draggableNode contentSize].width) / 2, (winSize.height - [_draggableNode contentSize].height) / 2)];
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
	_startDragTouchPosition = [self touchLocation];
	_startDragNodePosition = [_draggableNode position];
	[_previousDragTouchPositions removeAllObjects];
	_velocity = CGPointZero;
	[_draggableNode stopActionByTag:ACTION_TAG_ELASTIC_SWIPE_X];
	[_draggableNode stopActionByTag:ACTION_TAG_ELASTIC_SWIPE_Y];
	_didDragSignificantDistance = FALSE;
}

-(void) stopDragging
{
	_isDragging = FALSE;
	if ([_previousDragTouchPositions count] >= 3)
	{
		CGPoint previousDragTouchPosition1 = [[_previousDragTouchPositions objectAtIndex:0] CGPointValue];
		CGPoint previousDragTouchPosition2 = [[_previousDragTouchPositions objectAtIndex:1] CGPointValue];
		CGPoint previousDragTouchPosition3 = [[_previousDragTouchPositions objectAtIndex:2] CGPointValue];

		if (_scrollHorizontally)
		{
			float firstDistanceX = previousDragTouchPosition3.x - previousDragTouchPosition2.x;
			float secondDistanceX = previousDragTouchPosition2.x - previousDragTouchPosition1.x;
			float averageDistanceX = (firstDistanceX + secondDistanceX) / 2;
			_velocity.x = averageDistanceX / 2.0f;
		}
		if (_scrollVertically)
		{
			float firstDistanceY = previousDragTouchPosition3.y - previousDragTouchPosition2.y;
			float secondDistanceY = previousDragTouchPosition2.y - previousDragTouchPosition1.y;
			float averageDistanceY = (firstDistanceY + secondDistanceY) / 2;
			_velocity.y = averageDistanceY / 2.0f;
		}
	}
	_didDragSignificantDistance = FALSE;
}

-(void) updateDragging
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];

	if (_scrollHorizontally)
	{
		float newX = _startDragNodePosition.x + ([self touchLocation].x - _startDragTouchPosition.x);
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
		[_draggableNode setPosition:CGPointMake(newX, [_draggableNode position].y)];
	}
	if (_scrollVertically)
	{
		float newY = _startDragNodePosition.y + ([self touchLocation].y - _startDragTouchPosition.y);
		float minY = winSize.height - [_draggableNode contentSize].height;
		float maxY = 0.0f;
		if (newY > maxY)
		{
			newY = maxY + 0.2f * newY;
		}
		else if (newY < minY)
		{
			newY = minY + 0.2f * (newY - minY);
		}
		[_draggableNode setPosition:CGPointMake([_draggableNode position].x, newY)];
	}

	[_previousDragTouchPositions addObject:[NSValue valueWithCGPoint:[self touchLocation]]];
	while ([_previousDragTouchPositions count] > 3)
	{
		[_previousDragTouchPositions removeObjectAtIndex:0];
	}

	if (!_didDragSignificantDistance &&
		(fabsf(_startDragTouchPosition.x - [self touchLocation].x) >= SIGNIFICANT_DRAG_DISTANCE ||
				fabsf(_startDragTouchPosition.y - [self touchLocation].y) >= SIGNIFICANT_DRAG_DISTANCE))
	{
		_didDragSignificantDistance = TRUE;
	}
}

-(void) updateSliding:(float)delta
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];

	if (_constantVelocityDelay > 0.0f)
	{
		_constantVelocityDelay -= delta;
	}

	if (_scrollHorizontally)
	{
		float minX = winSize.width - [_draggableNode contentSize].width;
		float maxX = 0.0f;

		if ([_draggableNode position].x > maxX)
		{
			BOOL bounce = FALSE;

			if (_velocity.x == 0.0f)
			{
				bounce = [_draggableNode getActionByTag:ACTION_TAG_ELASTIC_SWIPE_X] == nil;
			}
			else
			{
				float velocityXBefore = _velocity.x;
				_velocity.x *= 0.6f;
				bounce = velocityXBefore > 0.0f && fabsf(_velocity.x) <= 1.0f;
			}

			if (bounce)
			{
				_velocity.x = 0.0f;
				CCMoveTo *moveAction = [CCEaseSineOut actionWithAction:[CCMoveTo actionWithDuration:0.3f position:CGPointMake(maxX, [_draggableNode position].y)]];
				[moveAction setTag:ACTION_TAG_ELASTIC_SWIPE_X];
				[_draggableNode runAction:moveAction];
			}
		}
		else if ([_draggableNode position].x < minX)
		{
			BOOL bounce = FALSE;

			if (_velocity.x == 0.0f)
			{
				bounce = [_draggableNode getActionByTag:ACTION_TAG_ELASTIC_SWIPE_X] == nil;
			}
			else
			{
				float velocityXBefore = _velocity.x;
				_velocity.x *= 0.6f;
				bounce = velocityXBefore < 0.0f && fabsf(_velocity.x) <= 1.0f;
			}

			if (bounce)
			{
				_velocity.x = 0.0f;
				CCMoveTo *moveAction = [CCEaseSineOut actionWithAction:[CCMoveTo actionWithDuration:0.3f position:CGPointMake(minX, [_draggableNode position].y)]];
				[moveAction setTag:ACTION_TAG_ELASTIC_SWIPE_X];
				[_draggableNode runAction:moveAction];
			}
		}
		else
		{
			_velocity.x *= 0.94f;

			if (_constantVelocityDelay <= 0.0f &&
					fabsf(_velocity.x) < fabsf(_constantVelocity.x))
			{
				if (_constantVelocity.x > 0.0f &&
						[_draggableNode position].x < maxX)
				{
					_velocity.x = min(_constantVelocity.x, maxX - [_draggableNode position].x);
				}
				else if (_constantVelocity.x < 0.0f &&
						[_draggableNode position].x > minX)
				{
					_velocity.x = max(_constantVelocity.x, minX - [_draggableNode position].x);
				}
				else
				{
					_velocity.x = 0.0f;
				}
			}
		}
	}
	if (_scrollVertically)
	{
		float minY = winSize.height - [_draggableNode contentSize].height;
		float maxY = 0.0f;

		if ([_draggableNode position].y > maxY)
		{
			BOOL bounce = FALSE;

			if (_velocity.y == 0.0f)
			{
				bounce = [_draggableNode getActionByTag:ACTION_TAG_ELASTIC_SWIPE_Y] == nil;
			}
			else
			{
				float velocityYBefore = _velocity.y;
				_velocity.y *= 0.6f;
				bounce = velocityYBefore > 0.0f && fabsf(_velocity.y) <= 1.0f;
			}

			if (bounce)
			{
				_velocity.y = 0.0f;
				CCMoveTo *moveAction = [CCEaseSineOut actionWithAction:[CCMoveTo actionWithDuration:0.3f position:CGPointMake([_draggableNode position].x, maxY)]];
				[moveAction setTag:ACTION_TAG_ELASTIC_SWIPE_Y];
				[_draggableNode runAction:moveAction];
			}
		}
		else if ([_draggableNode position].y < minY)
		{
			BOOL bounce = FALSE;

			if (_velocity.y == 0.0f)
			{
				bounce = [_draggableNode getActionByTag:ACTION_TAG_ELASTIC_SWIPE_Y] == nil;
			}
			else
			{
				float velocityYBefore = _velocity.y;
				_velocity.y *= 0.6f;
				bounce = velocityYBefore < 0.0f && fabsf(_velocity.y) <= 1.0f;
			}

			if (bounce)
			{
				_velocity.y = 0.0f;
				CCMoveTo *moveAction = [CCEaseSineOut actionWithAction:[CCMoveTo actionWithDuration:0.3f position:CGPointMake([_draggableNode position].x, minY)]];
				[moveAction setTag:ACTION_TAG_ELASTIC_SWIPE_Y];
				[_draggableNode runAction:moveAction];
			}
		}
		else
		{
			_velocity.y *= 0.94f;

			if (_constantVelocityDelay <= 0.0f &&
					fabsf(_velocity.y) < fabsf(_constantVelocity.y))
			{
				if (_constantVelocity.y > 0.0f &&
						[_draggableNode position].y < maxY)
				{
					_velocity.y = min(_constantVelocity.y, maxY - [_draggableNode position].y);
				}
				else if (_constantVelocity.y < 0.0f &&
						[_draggableNode position].y > minY)
				{
					_velocity.y = max(_constantVelocity.y, minY - [_draggableNode position].y);
				}
				else
				{
					_velocity.y = 0.0f;
				}
			}
		}
	}

	[self applyVelocity];
}

-(void) applyVelocity
{
	float newX = [_draggableNode position].x + _velocity.x;
	float newY = [_draggableNode position].y + _velocity.y;
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

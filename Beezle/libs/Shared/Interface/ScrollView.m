//
//  ScrollView.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/20/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScrollView.h"
#import "ActionTags.h"

static const float DRAG_DISTANCE = 10.0f;

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
		if ([_touches count] == 0)
		{
			_isDragging = FALSE;

			if ([_previousDragTouchX count] >= 3)
			{
				float previousDragTouchX1 = [[_previousDragTouchX objectAtIndex:0] floatValue];
				float previousDragTouchX2 = [[_previousDragTouchX objectAtIndex:1] floatValue];
				float previousDragTouchX3 = [[_previousDragTouchX objectAtIndex:2] floatValue];
				float firstDistance = previousDragTouchX3 - previousDragTouchX2;
				float secondDistance = previousDragTouchX2 - previousDragTouchX1;
				float averageDistance = (firstDistance + secondDistance) / 2.0f;
				_velocityX = averageDistance / 3.0f;
			}
		}
		else
		{
			UITouch *touch = [_touches lastObject];
			CGPoint location = [touch locationInView:[touch view]];
			CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];

			CGSize winSize = [[CCDirector sharedDirector] winSize];
			float newX = _startDragNodeX + (convertedLocation.x - _startDragTouchX);
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

			[_previousDragTouchX addObject:[NSNumber numberWithFloat:convertedLocation.x]];
			while ([_previousDragTouchX count] > 3)
			{
				[_previousDragTouchX removeObjectAtIndex:0];
			}

			if (!_didDragSignificantDistance &&
				fabsf(_startDragTouchX - convertedLocation.x) >= DRAG_DISTANCE)
			{
				_didDragSignificantDistance = TRUE;
			}
		}
	}
	else
	{
		if ([_touches count] > 0)
		{
			UITouch *touch = [_touches lastObject];
			CGPoint location = [touch locationInView:[touch view]];
			CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];

			_isDragging = TRUE;
			_startDragTouchX = convertedLocation.x;
			_startDragNodeX = [_draggableNode position].x;
			_velocityX = 0.0f;
			[_draggableNode stopActionByTag:ACTION_TAG_ELASTIC_SWIPE];
			_didDragSignificantDistance = FALSE;
		}
		else
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
		}
	}

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

@end

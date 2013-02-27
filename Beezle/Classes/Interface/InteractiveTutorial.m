//
// Created by Marcus on 26/02/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "InteractiveTutorial.h"
#import "CCBAnimationManager.h"
#import "CCBReader.h"
#import "SlingerControlSystem.h"
#import "SlingerComponent.h"

@interface InteractiveTutorial()

-(void) changeToState:(int)state;

@end

@implementation InteractiveTutorial

-(id) initWithLayer:(CCLayer *)layer world:(World *)world
{
	if (self = [super init])
	{
		_layer = layer;
		_world = world;

		_slingerControlSystem = (SlingerControlSystem *)[[_world systemManager] getSystem:[SlingerControlSystem class]];

		[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:FALSE];

		_tutorialNode = [CCBReader nodeGraphFromFile:@"Tutorial.ccbi" owner:self];
		_tutorialAnimationManager = [_tutorialNode userObject];
		[_layer addChild:_tutorialNode];

		[self changeToState:1];
	}
	return self;
}

-(void) dealloc
{
	[[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];

	[super dealloc];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if (_tutorialState == 1)
	{
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		CGPoint location = [touch locationInView: [touch view]];
		CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
		float distance = ccpDistance(convertedLocation, CGPointMake(winSize.width - 140.0f, 74.0f));
		if (distance <= 30.0f)
		{
			TagManager *tagManager = (TagManager *)[_world getManager:[TagManager class]];
			Entity *slingerEntity = [tagManager getEntity:@"SLINGER"];
			[_slingerControlSystem reset:slingerEntity];

			[self changeToState:2];
		}
	}

	return TRUE;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	if (_tutorialState == 2 || _tutorialState == 3)
	{
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		CGPoint location = [touch locationInView: [touch view]];
		CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
		float distance = ccpDistance(convertedLocation, CGPointMake(winSize.width - 153.0f, 134.0f));
		if (_tutorialState == 2 && distance <= 20.0f)
		{
			[self changeToState:3];
		}
		else if (_tutorialState == 3 && distance > 25.0f)
		{
			[self changeToState:2];
		}
	}
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	if (_tutorialState == 2)
	{
		TagManager *tagManager = (TagManager *)[_world getManager:[TagManager class]];
		Entity *slingerEntity = [tagManager getEntity:@"SLINGER"];
		[_slingerControlSystem reset:slingerEntity];

		[self changeToState:1];
	}
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self ccTouchEnded:touch withEvent:event];
}

-(void) update
{
	if (_tutorialState > 0)
	{
		TagManager *tagManager = (TagManager *)[_world getManager:[TagManager class]];
		Entity *slingerEntity = [tagManager getEntity:@"SLINGER"];
		SlingerComponent *slingerComponent = [SlingerComponent getFrom:slingerEntity];

		if (![slingerComponent hasMoreBees] &&
				![slingerComponent hasLoadedBee])
		{
			[_layer removeChild:_tutorialNode];
			_tutorialState = 0;
		}
	}
}

-(void) changeToState:(int)state
{
	int previousTutorialState = _tutorialState;

	[_tutorialAnimationManager runAnimationsForSequenceNamed:[NSString stringWithFormat:@"%i", state]];
	_tutorialState = state;

	if (_tutorialState == 1 ||
			(previousTutorialState == 1 && _tutorialState == 2))
	{
		[_tutorialTargetSprite runAction:[CCFadeIn actionWithDuration:0.5f]];
	}
}

@end

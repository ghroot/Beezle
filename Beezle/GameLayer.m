//
//  GameLayer.m
//  Beezle
//
//  Created by Me on 31/10/2011.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "GameLayer.h"

#import "PhysicsSystem.h"
#import "RenderSystem.h"
#import "InputSystem.h"
#import "SlingerControlSystem.h"
#import "BoundrySystem.h"
#import "EntityFactory.h"

@implementation GameLayer

-(id) init
{
	if (self=[super init])
    {
		// Enable events
		self.isTouchEnabled = YES;
        
        _world = [[World alloc] init];
        SystemManager *systemManager = [_world systemManager];
        
        PhysicsSystem *physicsSystem = [[PhysicsSystem alloc] init];
        [systemManager setSystem:physicsSystem];
        RenderSystem *renderSystem = [[RenderSystem alloc] initWithLayer:self];
        [systemManager setSystem:renderSystem];
        _inputSystem = [[InputSystem alloc] init];
        [systemManager setSystem:_inputSystem];
        SlingerControlSystem *dragSystem = [[SlingerControlSystem alloc] init];
        [systemManager setSystem:dragSystem];
        BoundrySystem *boundrySystem = [[BoundrySystem alloc] init];
        [systemManager setSystem:boundrySystem];
        
        [systemManager initialiseAll];

        [EntityFactory createSlinger:_world withPosition:CGPointMake(150, 300)];
        [EntityFactory createRamp:_world withPosition:CGPointMake(150, 100)];
		
		[self scheduleUpdate];
	}
	
	return self;
}

- (void)dealloc
{
    [_world release];
    
	[super dealloc];
}

-(void) update:(ccTime)delta
{
    [_world loopStart];
    [_world setDelta:delta];
    [[_world systemManager] processAll];
}

- (void)draw
{
    if (isTouching)
    {
//        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CGPoint actualStartPoint = touchStartLocation;
        CGPoint actualEndPoint = ccpAdd(actualStartPoint, touchVector);
        glLineWidth(2.0);
        ccDrawLine(actualStartPoint, actualEndPoint);
        
//        CGPoint projectedStartPoint = ccp(winSize.width / 2, winSize.height / 2);
//        CGPoint projectedEndPoint = ccpAdd(projectedStartPoint, touchVector);
//        glLineWidth(5.0);
//        ccDrawLine(projectedStartPoint, projectedEndPoint);
    }
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
    CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL: location];
    
    touchStartLocation = convertedLocation;
    touchVector = ccp(0, 0);
    
    isTouching = TRUE;
    
    [_inputSystem setTouchType:TOUCH_START];
    [_inputSystem setTouchLocation:convertedLocation];
    
//    NSLog(@"ccTouchesBegan %f,%f -> %f,%f", location.x, location.y, convertedLocation.x, convertedLocation.y);
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
    CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL: location];
    
    touchVector = ccpSub(convertedLocation, touchStartLocation);
    
    [_inputSystem setTouchType:TOUCH_MOVE];
    [_inputSystem setTouchLocation:convertedLocation];
    
//    NSLog(@"ccTouchesMoved %f,%f -> %f,%f", location.x, location.y, convertedLocation.x, convertedLocation.y);
}

-(void) ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
    CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL: location];
    
    isTouching = FALSE;
    
    [_inputSystem setTouchType:TOUCH_END];
    [_inputSystem setTouchLocation:convertedLocation];
    
//    NSLog(@"ccTouchesEnded %f,%f -> %f,%f", location.x, location.y, convertedLocation.x, convertedLocation.y);
}

@end

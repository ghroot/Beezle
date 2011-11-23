//
//  GameLayer.m
//  Beezle
//
//  Created by Me on 31/10/2011.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "GameLayer.h"
#import "BoundrySystem.h"
#import "CollisionSystem.h"
#import "DebugRenderPhysicsSystem.h"
#import "EntityFactory.h"
#import "InputAction.h"
#import "InputSystem.h"
#import "PhysicsSystem.h"
#import "RenderSystem.h"
#import "SlingerControlSystem.h"

@implementation GameLayer

-(id) init
{
	if (self = [super init])
    {
		// Enable events
		self.isTouchEnabled = YES;
        
        _world = [[World alloc] init];
        SystemManager *systemManager = [_world systemManager];
        
        _physicsSystem = [[PhysicsSystem alloc] init];
        [systemManager setSystem:_physicsSystem];
        _collisionSystem = [[CollisionSystem alloc] init];
        [systemManager setSystem:_collisionSystem];
        _renderSystem = [[RenderSystem alloc] initWithLayer:self];
        [systemManager setSystem:_renderSystem];
        _debugRenderPhysicsSystem = [[DebugRenderPhysicsSystem alloc] init];
        [systemManager setSystem:_debugRenderPhysicsSystem];
        _inputSystem = [[InputSystem alloc] init];
        [systemManager setSystem:_inputSystem];
        _slingerControlSystem = [[SlingerControlSystem alloc] init];
        [systemManager setSystem:_slingerControlSystem];
        _boundrySystem = [[BoundrySystem alloc] init];
        [systemManager setSystem:_boundrySystem];
        
        [systemManager initialiseAll];

        [EntityFactory createBackground:_world withFileName:@"Background-01.jpg"];
        [EntityFactory createSlinger:_world withPosition:CGPointMake(150, 250)];
        [EntityFactory createRamp:_world withPosition:CGPointMake(150, 100) andRotation:0.0f];
        [EntityFactory createRamp:_world withPosition:CGPointMake(150, 140) andRotation:0.1f];
        [EntityFactory createRamp:_world withPosition:CGPointMake(150, 180) andRotation:-0.1f];
		
		[self scheduleUpdate];
	}
	
	return self;
}

- (void)dealloc
{
    [_world release];
    
    [_physicsSystem release];
    [_collisionSystem release];
    [_renderSystem release];
    [_debugRenderPhysicsSystem release];
    [_inputSystem release];
    [_slingerControlSystem release];
    [_boundrySystem release];
    
	[super dealloc];
}

-(void) update:(ccTime)delta
{
    [_world loopStart];
    [_world setDelta:delta];
    
    [_physicsSystem process];
    [_collisionSystem process];
    [_renderSystem process];
    [_inputSystem process];
    [_slingerControlSystem process];
    [_boundrySystem process];
}

-(void) draw
{
    [_debugRenderPhysicsSystem process];
    
    if (isTouching)
    {
        CGPoint actualStartPoint = touchStartLocation;
        CGPoint actualEndPoint = ccpAdd(actualStartPoint, touchVector);
        glLineWidth(2.0);
        ccDrawLine(actualStartPoint, actualEndPoint);
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
    
    InputAction *inputAction = [[[InputAction alloc] initWithTouchType:TOUCH_START andTouchLocation:convertedLocation] autorelease];
    [_inputSystem pushInputAction:inputAction];
    
//    NSLog(@"ccTouchesBegan %f,%f -> %f,%f", location.x, location.y, convertedLocation.x, convertedLocation.y);
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
    CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL: location];
    
    touchVector = ccpSub(convertedLocation, touchStartLocation);
    
    InputAction *inputAction = [[[InputAction alloc] initWithTouchType:TOUCH_MOVE andTouchLocation:convertedLocation] autorelease];
    [_inputSystem pushInputAction:inputAction];
    
//    NSLog(@"ccTouchesMoved %f,%f -> %f,%f", location.x, location.y, convertedLocation.x, convertedLocation.y);
}

-(void) ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
    CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL: location];
    
    isTouching = FALSE;
    
    InputAction *inputAction = [[[InputAction alloc] initWithTouchType:TOUCH_END andTouchLocation:convertedLocation] autorelease];
    [_inputSystem pushInputAction:inputAction];
    
//    NSLog(@"ccTouchesEnded %f,%f -> %f,%f", location.x, location.y, convertedLocation.x, convertedLocation.y);
}

@end

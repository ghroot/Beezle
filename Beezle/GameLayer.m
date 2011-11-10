//
//  GameLayer.m
//  Beezle
//
//  Created by Me on 31/10/2011.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "GameLayer.h"

#import "EntityManager.h"
#import "Entity.h"
#import "PhysicsSystem.h"
#import "PhysicsComponent.h"
#import "RenderSystem.h"
#import "RenderComponent.h"
#import "TransformComponent.h"
#import "InputSystem.h"

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
        
        [systemManager initialiseAll];

        _staticEntity = [_world createEntity];
        TransformComponent *transformComponent = [[TransformComponent alloc] initWithPosition:CGPointMake(0, 0)];
        [_staticEntity addComponent:transformComponent];
        RenderComponent *renderComponent = [[RenderComponent alloc] initWithFile:@"Beeater-01.png"];
        [[renderComponent spriteSheet] setVisible:FALSE];
        [_staticEntity addComponent:renderComponent];
        [_staticEntity refresh];
		
		[self scheduleUpdate];
	}
	
	return self;
}

-(void) createEntityAtPosition:(CGPoint) position
{
    Entity *testEntity = [_world createEntity];
    
    TransformComponent *transformComponent = [[TransformComponent alloc] initWithPosition:CGPointMake(position.x, position.y)];
    [testEntity addComponent:transformComponent];
    
    int num = 4;
    CGPoint verts[] = {
        ccp(-24,-54),
        ccp(-24, 54),
        ccp( 24, 54),
        ccp( 24,-54),
    };
    cpBody *body = cpBodyNew(1.0f, cpMomentForPoly(1.0f, num, verts, CGPointZero));
    cpShape *shape = cpPolyShapeNew(body, num, verts, CGPointZero);
    shape->e = 0.5f;
    shape->u = 0.5f;
    PhysicsComponent *physicsComponent = [[PhysicsComponent alloc] initWithBody:body andShape:shape];
    [testEntity addComponent:physicsComponent];
    
    RenderComponent *renderComponent = [[RenderComponent alloc] initWithFile:@"BeeSlingerC-01.png"];
    [testEntity addComponent:renderComponent];
    
    [testEntity refresh];
}

- (void)dealloc
{
    [_world release];
    
	[super dealloc];
}

-(void) update:(ccTime)delta
{
    [_world loopStart];
    [[_world systemManager] processAll];
    
    if (isTouching)
    {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CGPoint projectedStartPoint = ccp(winSize.width / 2, winSize.height / 2);
        CGPoint projectedEndPoint = ccpAdd(projectedStartPoint, touchVector);
        
        TransformComponent *transformComponent = (TransformComponent *)[_staticEntity getComponent:[TransformComponent class]];
        
        [transformComponent setPosition:projectedEndPoint];
        
        if (projectedStartPoint.x == projectedEndPoint.x &&
            projectedStartPoint.y == projectedEndPoint.y)
        {
            [transformComponent setRotation:0];
        }
        else
        {
            CGPoint originPoint = CGPointMake(projectedEndPoint.x - projectedStartPoint.x, projectedEndPoint.y - projectedStartPoint.y);
            float bearingRadians = atan2f(originPoint.y, originPoint.x);
            float bearingDegrees = bearingRadians * (180.0 / M_PI);
            bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees));
            bearingDegrees = 270 - bearingDegrees;
            if (bearingDegrees < 0)
            {
                bearingDegrees += 360;
            }
            bearingDegrees -= 90;
            
            [transformComponent setRotation:bearingDegrees];
        }
    }
}

- (void)draw
{
    if (isTouching)
    {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CGPoint actualStartPoint = touchStartLocation;
        CGPoint actualEndPoint = ccpAdd(actualStartPoint, touchVector);
        glLineWidth(2.0);
        ccDrawLine(actualStartPoint, actualEndPoint);
        
        CGPoint projectedStartPoint = ccp(winSize.width / 2, winSize.height / 2);
        CGPoint projectedEndPoint = ccpAdd(projectedStartPoint, touchVector);
        glLineWidth(5.0);
        ccDrawLine(projectedStartPoint, projectedEndPoint);
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
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGPoint projectedStartPoint = ccp(winSize.width / 2, winSize.height / 2);
    
    TransformComponent *transformComponent = (TransformComponent *)[_staticEntity getComponent:[TransformComponent class]];
    [transformComponent setPosition:projectedStartPoint];
    [transformComponent setRotation:0];
    
    RenderComponent *renderComponent = (RenderComponent *)[_staticEntity getComponent:[RenderComponent class]];
    [[renderComponent spriteSheet] setVisible:TRUE];
    
    [_inputSystem setTouchType:1];
    [_inputSystem setTouchLocation:convertedLocation];
    
//    [self createEntityAtPosition:convertedLocation];
    
//    NSLog(@"ccTouchesBegan %f,%f -> %f,%f", location.x, location.y, convertedLocation.x, convertedLocation.y);
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
    CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL: location];
    
    touchVector = ccpSub(convertedLocation, touchStartLocation);
    
    [_inputSystem setTouchType:2];
    [_inputSystem setTouchLocation:convertedLocation];
    
//    NSLog(@"touchVector: %f, %f", touchVector.x, touchVector.y);
    
//    NSLog(@"ccTouchesMoved %f,%f -> %f,%f", location.x, location.y, convertedLocation.x, convertedLocation.y);
}

-(void) ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
    CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL: location];
    
    isTouching = FALSE;
    
    RenderComponent *renderComponent = (RenderComponent *)[_staticEntity getComponent:[RenderComponent class]];
    [[renderComponent spriteSheet] setVisible:FALSE];
    
    [_inputSystem setTouchType:3];
    [_inputSystem setTouchLocation:convertedLocation];
    
//    NSLog(@"ccTouchesEnded %f,%f -> %f,%f", location.x, location.y, convertedLocation.x, convertedLocation.y);
}

@end

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
#import "TransformSystem.h"
#import "TransformComponent.h"

@implementation GameLayer

-(id) init
{
	if (self=[super init])
    {
		// Enable events
		self.isTouchEnabled = YES;
		
		entityManager = [[EntityManager alloc] init];
        _systems = [[NSMutableArray alloc] init];
        
        _transformSystem = [[TransformSystem alloc] init];
        [_systems addObject:_transformSystem];
        _physicsSystem = [[PhysicsSystem alloc] init];
        [_systems addObject:_physicsSystem];
        _renderSystem = [[RenderSystem alloc] initWithLayer:self];
        [_systems addObject:_renderSystem];
        
        _staticEntity = [entityManager createEntity];
        TransformComponent *transformComponent = [[TransformComponent alloc] initWithPosition:CGPointMake(0, 0)];
        [_staticEntity addComponent:transformComponent];
        RenderComponent *renderComponent = [[RenderComponent alloc] initWithFile:@"Beeater-01.png"];
        [_staticEntity addComponent:renderComponent];
        [_transformSystem entityAdded:_staticEntity];
        [_renderSystem entityAdded:_staticEntity];
		
		[self scheduleUpdate];
	}
	
	return self;
}

-(void) createEntityAtPosition:(CGPoint) position
{
    Entity *testEntity = [entityManager createEntity];
    
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
    
    [_transformSystem entityAdded:testEntity];
    [_physicsSystem entityAdded:testEntity];
    [_renderSystem entityAdded:testEntity];
}

- (void)dealloc
{
	[super dealloc];
}

-(void) update:(ccTime)delta
{
    for (AbstractSystem *system in _systems)
    {
        [system update];
    }
    
    if (isTouching)
    {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CGPoint projectedStartPoint = ccp(winSize.width / 2, winSize.height / 2);
        CGPoint projectedEndPoint = ccpAdd(projectedStartPoint, touchVector);
        
        TransformComponent *transformComponent = (TransformComponent *)[_staticEntity getComponent:[TransformComponent class]];
        
        [transformComponent setPosition:projectedEndPoint];
        
        CGFloat height = projectedEndPoint.y - projectedStartPoint.y;
        CGFloat width = projectedStartPoint.x - projectedEndPoint.x;
        CGFloat rads = atan(height / width);
        float degrees = CC_RADIANS_TO_DEGREES(rads);
        [transformComponent setRotation:degrees];
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
    
    [self createEntityAtPosition:convertedLocation];
    
//    NSLog(@"ccTouchesBegan %f,%f -> %f,%f", location.x, location.y, convertedLocation.x, convertedLocation.y);
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
    CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL: location];
    
    touchVector = ccpSub(convertedLocation, touchStartLocation);
    
//    NSLog(@"touchVector: %f, %f", touchVector.x, touchVector.y);
    
//    NSLog(@"ccTouchesMoved %f,%f -> %f,%f", location.x, location.y, convertedLocation.x, convertedLocation.y);
}

-(void) ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent *)event
{
//    UITouch* touch = [touches anyObject];
//    CGPoint location = [touch locationInView: [touch view]];
//    CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL: location];
    
    isTouching = FALSE;
    
//    NSLog(@"ccTouchesEnded %f,%f -> %f,%f", location.x, location.y, convertedLocation.x, convertedLocation.y);
}

@end

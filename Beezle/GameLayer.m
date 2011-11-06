//
//  GameLayer.m
//  Beezle
//
//  Created by Me on 31/10/2011.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "GameLayer.h"

#import "Actor.h"
#import "TestActor.h"

@implementation GameLayer

-(id) init
{
	if(self=[super init])
    {
		// Enable events
		self.isTouchEnabled = YES;
		
		// Init physics
		[self initPhysics];
		
		// Use batch node. Faster
//		CCSpriteBatchNode *parent = [CCSpriteBatchNode batchNodeWithFile:@"grossini_dance_atlas.png" capacity:100];
//		spriteTexture_ = [parent texture];

//		[self addChild:parent z:0 tag:kTagParentNode];
		
//		[self addNewSpriteAtPosition:ccp(200,200)];
        
        _actors = [[NSMutableArray alloc] init];
        
        testActor = [[TestActor alloc] init];
		
		[self scheduleUpdate];
	}
	
	return self;
}

-(cpSpace *) space
{
    return _space;
}

-(void) addActor:(Actor *)actor
{
    [_actors addObject:actor];
    [actor addedToLayer:self];
}

-(void) removeActor:(Actor *)actor
{
    [_actors removeObject:actor];
    [actor removedFromLayer:self];
}

-(void) initPhysics
{
//	CGSize s = [[CCDirector sharedDirector] winSize];
	
	// Init chipmunk
	cpInitChipmunk();
	
	_space = cpSpaceNew();
	_space->gravity = ccp(0, -100);
	
	//
	// rogue shapes
	// We have to free them manually
	//
	// bottom
//	walls_[0] = cpSegmentShapeNew( _space->staticBody, ccp(0,0), ccp(s.width,0), 0.0f);
//	
//	// top
//	walls_[1] = cpSegmentShapeNew( _space->staticBody, ccp(0,s.height), ccp(s.width,s.height), 0.0f);
//	
//	// left
//	walls_[2] = cpSegmentShapeNew( _space->staticBody, ccp(0,0), ccp(0,s.height), 0.0f);
//	
//	// right
//	walls_[3] = cpSegmentShapeNew( _space->staticBody, ccp(s.width,0), ccp(s.width,s.height), 0.0f);
//	
//	for (int i = 0; i < 4; i++)
//    {
//		walls_[i]->e = 1.0f;
//		walls_[i]->u = 1.0f;
//		cpSpaceAddStaticShape(_space, walls_[i]);
//	}	
}

- (void)dealloc
{
	// manually Free rogue shapes
//	for( int i=0;i<4;i++) {
//		cpShapeFree( walls_[i] );
//	}
	
	cpSpaceFree(_space);
	
	[super dealloc];
	
}

-(void) update:(ccTime) delta
{
	// Should use a fixed size step based on the animation interval.
	int steps = 2;
	CGFloat dt = [[CCDirector sharedDirector] animationInterval] / (CGFloat)steps;
	
	for (int i = 0; i < steps; i++)
    {
		cpSpaceStep(_space, dt);
	}
    
    if (isTouching)
    {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CGPoint projectedStartPoint = ccp(winSize.width / 2, winSize.height / 2);
        CGPoint projectedEndPoint = ccpAdd(projectedStartPoint, touchVector);
        [testActor setPosition:projectedEndPoint];
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

//-(void) addNewSpriteAtPosition:(CGPoint)pos
//{
//	int posx, posy;
//	
//	CCNode *parent = [self getChildByTag:kTagParentNode];
//	
//	posx = CCRANDOM_0_1() * 200.0f;
//	posy = CCRANDOM_0_1() * 200.0f;
//	
//	posx = (posx % 4) * 85;
//	posy = (posy % 3) * 121;
//	
//	PhysicsSprite* sprite = [PhysicsSprite spriteWithTexture:spriteTexture_ rect:CGRectMake(posx, posy, 85, 121)];
//	[parent addChild: sprite];
//	
//	sprite.position = pos;
//	
//	int num = 4;
//	CGPoint verts[] =
//    {
//		ccp(-24,-54),
//		ccp(-24, 54),
//		ccp( 24, 54),
//		ccp( 24,-54),
//	};
//	
//	cpBody* body = cpBodyNew(1.0f, cpMomentForPoly(1.0f, num, verts, CGPointZero));
//	
//	body->p = pos;
//	cpSpaceAddBody(space_, body);
//	
//	cpShape* shape = cpPolyShapeNew(body, num, verts, CGPointZero);
//	shape->e = 0.5f; shape->u = 0.5f;
//	cpSpaceAddShape(space_, shape);
//	
//	[sprite setPhysicsBody:body];
//}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
    CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL: location];
    
    touchStartLocation = convertedLocation;
    touchVector = ccp(0, 0);
    
    isTouching = TRUE;
    
    [self addActor:testActor];
    
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
    
    [self removeActor:testActor];
    
//    NSLog(@"ccTouchesEnded %f,%f -> %f,%f", location.x, location.y, convertedLocation.x, convertedLocation.y);
    
//    [self addNewSpriteAtPosition: location];
}

@end

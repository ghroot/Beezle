//
//  HelloWorldLayer.m
//  Beezle
//
//  Created by Me on 31/10/2011.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "HelloWorldLayer.h"

enum
{
	kTagParentNode = 1,
};

@implementation HelloWorldLayer

-(id) init
{
	if(self=[super init])
    {
		// Enable events
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
		CGSize s = [[CCDirector sharedDirector] winSize];
		
		// Title
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Multi touch the screen" fontName:@"Marker Felt" fontSize:36];
		label.position = ccp( s.width / 2, s.height - 30);
		[self addChild:label z:-1];
		
		// Reset button
		[self createResetButton];
		
		// Init physics
		[self initPhysics];
		
		// Use batch node. Faster
		CCSpriteBatchNode *parent = [CCSpriteBatchNode batchNodeWithFile:@"grossini_dance_atlas.png" capacity:100];
		spriteTexture_ = [parent texture];

		[self addChild:parent z:0 tag:kTagParentNode];
		
//		[self addNewSpriteAtPosition:ccp(200,200)];
		
		[self scheduleUpdate];
	}
	
	return self;
}

-(void) initPhysics
{
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	// Init chipmunk
	cpInitChipmunk();
	
	space_ = cpSpaceNew();
	
	space_->gravity = ccp(0, -100);
	
	//
	// rogue shapes
	// We have to free them manually
	//
	// bottom
	walls_[0] = cpSegmentShapeNew( space_->staticBody, ccp(0,0), ccp(s.width,0), 0.0f);
	
	// top
	walls_[1] = cpSegmentShapeNew( space_->staticBody, ccp(0,s.height), ccp(s.width,s.height), 0.0f);
	
	// left
	walls_[2] = cpSegmentShapeNew( space_->staticBody, ccp(0,0), ccp(0,s.height), 0.0f);
	
	// right
	walls_[3] = cpSegmentShapeNew( space_->staticBody, ccp(s.width,0), ccp(s.width,s.height), 0.0f);
	
	for (int i = 0; i < 4; i++)
    {
		walls_[i]->e = 1.0f;
		walls_[i]->u = 1.0f;
		cpSpaceAddStaticShape(space_, walls_[i]);
	}	
}

- (void)dealloc
{
	// manually Free rogue shapes
	for( int i=0;i<4;i++) {
		cpShapeFree( walls_[i] );
	}
	
	cpSpaceFree( space_ );
	
	[super dealloc];
	
}

-(void) update:(ccTime) delta
{
	// Should use a fixed size step based on the animation interval.
	int steps = 2;
	CGFloat dt = [[CCDirector sharedDirector] animationInterval]/(CGFloat)steps;
	
	for (int i = 0; i < steps; i++)
    {
		cpSpaceStep(space_, dt);
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


-(void) createResetButton
{
	CCMenuItemLabel* reset = [CCMenuItemFont itemFromString:@"Reset" block:^(id sender){
		CCScene* s = [CCScene node];
		id child = [HelloWorldLayer node];
		[s addChild:child];
		[[CCDirector sharedDirector] replaceScene: s];
	}];
	
	CCMenu* menu = [CCMenu menuWithItems:reset, nil];
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	menu.position = ccp(s.width/2, 30);
	[self addChild: menu z:-1];	
	
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
    
//    [self addNewSpriteAtPosition: location];
}

-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0;
	
#define kFilterFactor 0.05f
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	CGPoint v = ccp( accelX, accelY);
	
	space_->gravity = ccpMult(v, 200);
}

@end

//
//  PhysicalBehaviour.m
//
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PhysicsComponent.h"
#import "BodyInfo.h"
#import "CollisionType.h"
#import "PhysicsSystem.h"
#import "Utils.h"

@implementation PhysicsComponent

@synthesize body = _body;
@synthesize shapes = _shapes;
@synthesize positionUpdatedManually = _positionUpdatedManually;

+(id) componentWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	return [[[self alloc] initWithContentsOfDictionary:dict world:world] autorelease];
}

+(id) componentWithBody:(ChipmunkBody *)body andShapes:(NSArray *)shapes
{
	return [[[self alloc] initWithBody:body andShapes:shapes] autorelease];
}

+(id) componentWithBody:(ChipmunkBody *)body andShape:(ChipmunkShape *)shape
{
	return [[[self alloc] initWithBody:body andShape:shape] autorelease];
}

-(id) initWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if (self = [self init])
	{
		if ([dict objectForKey:@"file"] != nil)
		{
			NSString *filePath = [dict objectForKey:@"file"];
			NSString *bodyName = [dict objectForKey:@"bodyName"];
			
			CollisionType *collisionType = nil;
			if ([dict objectForKey:@"collisionType"] != nil)
			{
				collisionType = [CollisionType enumFromName:[dict objectForKey:@"collisionType"]];
				NSAssert(collisionType != nil, @"Unknown collisionType");
			}
			
			PhysicsSystem *physicsSystem = (PhysicsSystem *)[[world systemManager] getSystem:[PhysicsSystem class]];
			BodyInfo *bodyInfo = [physicsSystem createBodyInfoFromFile:filePath bodyName:bodyName collisionType:collisionType];
			
			[self setBody:[bodyInfo body]];
			for (ChipmunkShape *shape in [bodyInfo shapes])
			{	
				if ([dict objectForKey:@"layers"] != nil)
				{
					[shape setLayers:[[dict objectForKey:@"layers"] intValue]];
				}
				if ([dict objectForKey:@"group"] != nil)
				{
					[shape setGroup:[CollisionType enumFromName:[dict objectForKey:@"group"]]];
				}
				
				[self addShape:shape];
			}
		}
		else
		{
			NSDictionary *bodyDict = [dict objectForKey:@"body"];
			float mass = [[bodyDict objectForKey:@"mass"] floatValue];
			ChipmunkBody *body = nil;
			if (mass == 0.0f)
			{
				body = [ChipmunkBody staticBody];
			}
			else if (mass < 0.0f)
			{
				body = [ChipmunkBody bodyWithMass:INFINITY andMoment:INFINITY];
			}
			else
			{
				
				float moment = [[bodyDict objectForKey:@"moment"] floatValue];
				body = [ChipmunkBody bodyWithMass:mass andMoment:moment];
			}
			_body = [body retain];
			
			NSArray *shapeDicts = [dict objectForKey:@"shapes"];
			for (NSDictionary *shapeDict in shapeDicts)
			{
				NSString *shapeType = [shapeDict objectForKey:@"type"];
				float elasticity = [[shapeDict objectForKey:@"elasticity"] floatValue];
				float friction = [[shapeDict objectForKey:@"friction"] floatValue];
				CollisionType *collisionType = [CollisionType enumFromName:[shapeDict objectForKey:@"collisionType"]];
				CGPoint offset;
				if ([shapeDict objectForKey:@"offset"] != nil)
				{
					offset = [Utils stringToPoint:[shapeDict objectForKey:@"offset"]];
				}
				else
				{
					offset = CGPointZero;
				}
				
				ChipmunkShape *shape = nil;
				if ([shapeType isEqualToString:@"poly"])
				{
					NSArray *verticesAsStrings = [shapeDict objectForKey:@"vertices"];
					CGPoint verts[[verticesAsStrings count]];
					for (NSString *vertexAsString in verticesAsStrings)
					{
						CGPoint vert = [Utils stringToPoint:vertexAsString];
						verts[[verticesAsStrings indexOfObject:vertexAsString]] = vert;
					}
					shape = [ChipmunkPolyShape polyWithBody:body count:[verticesAsStrings count] verts:verts offset:offset];
				}
				else if ([shapeType isEqualToString:@"circle"])
				{
					float radius = [[shapeDict objectForKey:@"radius"] floatValue];
					shape = [ChipmunkCircleShape circleWithBody:body radius:radius offset:offset];
				}
				[shape setElasticity:elasticity];
				[shape setFriction:friction];
				[shape setCollisionType:collisionType];
				if ([shapeDict objectForKey:@"layers"] != nil)
				{
					[shape setLayers:[[shapeDict objectForKey:@"layers"] intValue]];
				}
				if ([shapeDict objectForKey:@"group"] != nil)
				{
					[shape setGroup:[CollisionType enumFromName:[shapeDict objectForKey:@"group"]]];
				}
				
				[_shapes addObject:shape];
			}
		}
	}
	return self;
}

// Designated initializer
-(id) initWithBody:(ChipmunkBody *)body andShapes:(NSArray *)shapes
{
    if (self = [super init])
    {
		_name = @"physics";
		if (body != nil)
		{
			_body = [body retain];
		}
		_shapes = [[NSMutableArray alloc] initWithArray:shapes];
		_positionUpdatedManually = FALSE;
    }
    return self;
}

-(id) initWithBody:(ChipmunkBody *)body andShape:(ChipmunkShape *)shape
{
    self = [self initWithBody:body andShapes:[NSMutableArray arrayWithObject:shape]];
    return self;
}

-(id) init
{
	self = [self initWithBody:nil andShapes:[NSArray array]];
	return self;
}

- (void)dealloc
{
    [_shapes release];
    [_body release];
    
    [super dealloc];
}

-(BOOL) isRougeBody
{
	return [_body mass] == INFINITY;
}

-(NSDictionary *) getAsDictionary
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setObject:[Utils pointToString:[_body pos]] forKey:@"position"];
	[dict setObject:[NSNumber numberWithFloat:[_body angle]] forKey:@"angle"];
	return dict;
}

-(void) populateWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if ([dict objectForKey:@"position"] != nil)
	{
		CGPoint position = [Utils stringToPoint:[dict objectForKey:@"position"]];
		[_body setPos:position];
	}
	if ([dict objectForKey:@"angle"] != nil)
	{
		float angle = [[dict objectForKey:@"angle"] floatValue];
		[_body setAngle:angle];
	}
}

-(void) addShape:(ChipmunkShape *)shape
{
	[_shapes addObject:shape];
}

-(ChipmunkShape *) firstPhysicsShape
{
    return [_shapes objectAtIndex:0];
}

-(void) setPositionManually:(CGPoint)position
{
	[_body setPos:position];
	_positionUpdatedManually = TRUE;
}

-(void) setRotationManually:(float)rotation
{
	[_body setAngle:CC_DEGREES_TO_RADIANS(-rotation)];
}

@end

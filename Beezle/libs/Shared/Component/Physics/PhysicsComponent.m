//
//  PhysicalBehaviour.m
//
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PhysicsComponent.h"
#import "BodyInfo.h"
#import "CollisionGroup.h"
#import "PhysicsSystem.h"
#import "Utils.h"

@implementation PhysicsComponent

@synthesize body = _body;
@synthesize shapes = _shapes;
@synthesize overrideBodyName = _overrideBodyName;
@synthesize positionOrRotationUpdatedManually = _positionOrRotationUpdatedManually;

+(id) componentWithBody:(ChipmunkBody *)body andShapes:(NSArray *)shapes
{
	return [[[self alloc] initWithBody:body andShapes:shapes] autorelease];
}

+(id) componentWithBody:(ChipmunkBody *)body andShape:(ChipmunkShape *)shape
{
	return [[[self alloc] initWithBody:body andShape:shape] autorelease];
}

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
        // Type
		if ([typeComponentDict objectForKey:@"file"] != nil)
		{
			NSString *filePath = [typeComponentDict objectForKey:@"file"];
			NSString *bodyName = [typeComponentDict objectForKey:@"bodyName"];
			
			if ([instanceComponentDict objectForKey:@"overrideBodyName"] != nil)
			{
				_overrideBodyName = [[instanceComponentDict objectForKey:@"overrideBodyName"] copy];
				bodyName = _overrideBodyName;
			}
			
			float scale = 1.0f;
			if ([typeComponentDict objectForKey:@"scale"] != nil)
			{
				scale = [[typeComponentDict objectForKey:@"scale"] floatValue];
			}
			
			PhysicsSystem *physicsSystem = (PhysicsSystem *)[[world systemManager] getSystem:[PhysicsSystem class]];
			BodyInfo *bodyInfo = [physicsSystem createBodyInfoFromFile:filePath bodyName:bodyName scale:scale];
			
			[self setBody:[bodyInfo body]];
			for (ChipmunkShape *shape in [bodyInfo shapes])
			{
				if ([typeComponentDict objectForKey:@"elasticity"] != nil)
				{
					[shape setElasticity:[[typeComponentDict objectForKey:@"elasticity"] floatValue]];
				}
				if ([typeComponentDict objectForKey:@"friction"] != nil)
				{
					[shape setFriction:[[typeComponentDict objectForKey:@"friction"] floatValue]];
				}
				if ([typeComponentDict objectForKey:@"layers"] != nil)
				{
					[shape setLayers:[[typeComponentDict objectForKey:@"layers"] intValue]];
				}
				if ([typeComponentDict objectForKey:@"group"] != nil)
				{
					[shape setGroup:[CollisionGroup enumFromName:[typeComponentDict objectForKey:@"group"]]];
				}
				
				[self addShape:shape];
			}
		}
		else
		{
			NSDictionary *bodyDict = [typeComponentDict objectForKey:@"body"];
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
			
			NSArray *shapeDicts = [typeComponentDict objectForKey:@"shapes"];
			for (NSDictionary *shapeDict in shapeDicts)
			{
				NSString *shapeType = [shapeDict objectForKey:@"type"];
				float elasticity = [[shapeDict objectForKey:@"elasticity"] floatValue];
				float friction = [[shapeDict objectForKey:@"friction"] floatValue];
                BOOL isSensor = FALSE;
                if ([shapeDict objectForKey:@"isSensor"] != nil)
                {
                    isSensor = [[shapeDict objectForKey:@"isSensor"] boolValue];
                }
				CGPoint offset;
				if ([shapeDict objectForKey:@"offset"] != nil)
				{
					offset = CGPointFromString([shapeDict objectForKey:@"offset"]);
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
						CGPoint vert = CGPointFromString(vertexAsString);
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
                [shape setSensor:isSensor];
				if ([shapeDict objectForKey:@"layers"] != nil)
				{
					[shape setLayers:[[shapeDict objectForKey:@"layers"] intValue]];
				}
				if ([shapeDict objectForKey:@"group"] != nil)
				{
					[shape setGroup:[CollisionGroup enumFromName:[shapeDict objectForKey:@"group"]]];
				}
				
				[_shapes addObject:shape];
			}
		}
        
        // Instance
        CGPoint position = CGPointFromString([instanceComponentDict objectForKey:@"position"]);
        [_body setPos:position];
        float angle = [[instanceComponentDict objectForKey:@"angle"] floatValue];
        [_body setAngle:angle];
	}
	return self;
}

-(id) initWithBody:(ChipmunkBody *)body andShapes:(NSArray *)shapes
{
    if (self = [super init])
    {
		if (body != nil)
		{
			_body = [body retain];
		}
		_shapes = [[NSMutableArray alloc] initWithArray:shapes];
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

-(void) dealloc
{
    [_shapes release];
    [_body release];
    
    [super dealloc];
}

-(BOOL) isRougeBody
{
	return [_body mass] == INFINITY;
}

-(NSDictionary *) getInstanceComponentDict
{
	NSMutableDictionary *instanceComponentDict = [NSMutableDictionary dictionary];
	[instanceComponentDict setObject:NSStringFromCGPoint([_body pos]) forKey:@"position"];
	[instanceComponentDict setObject:[NSNumber numberWithFloat:[_body angle]] forKey:@"angle"];
	if (_overrideBodyName != nil)
	{
		[instanceComponentDict setObject:_overrideBodyName forKey:@"overrideBodyName"];
	}
	return instanceComponentDict;
}

-(void) addShape:(ChipmunkShape *)shape
{
	[_shapes addObject:shape];
}

-(void) setLayers:(cpLayers)layers
{
	for (ChipmunkShape *shape in _shapes)
	{
		[shape setLayers:layers];
	}
}

-(void) setPositionManually:(CGPoint)position
{
	[_body setPos:position];
	_positionOrRotationUpdatedManually = TRUE;
}

-(void) setRotationManually:(float)rotation
{
	[_body setAngle:CC_DEGREES_TO_RADIANS(-rotation)];
	_positionOrRotationUpdatedManually = TRUE;
}

-(cpBB) boundingBox
{
	cpBB boundingBox = [[_shapes objectAtIndex:0] bb];
	for (ChipmunkShape *shape in _shapes)
	{
		boundingBox = cpBBMerge(boundingBox, [shape bb]);
	}
	return boundingBox;
}

@end

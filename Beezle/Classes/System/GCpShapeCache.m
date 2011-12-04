//
//  GCpShapeCache.h
//  
//  Loads physics sprites created with http://www.PhysicsEditor.de
//
//  Chipmunk version
//
//  Copyright by Andreas Loew 
//      http://www.PhysicsEditor.de
//      http://texturepacker.com
//      http://www.code-and-web.de
//  
//  All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "GCpShapeCache.h"
#import "BodyInfo.h"

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
#   define CGPointFromString_ CGPointFromString
#else
// well - not nice but works for now
static CGPoint CGPointFromString_(NSString* str)
{
    NSString* theString = str;
    theString = [theString stringByReplacingOccurrencesOfString:@"{ " withString:@""];
    theString = [theString stringByReplacingOccurrencesOfString:@" }" withString:@""];
    NSArray *array = [theString componentsSeparatedByString:@","];
    return CGPointMake([[array objectAtIndex:0] floatValue], [[array objectAtIndex:1] floatValue]);
}
#endif

static cpFloat area(cpVect *vertices, int numVertices)
{
	cpFloat area = 0.0f;
    
    int r = (numVertices-1);
	
	area += vertices[0].x*vertices[r].y-vertices[r].x*vertices[0].y;
	for (int i=0; i<numVertices-1; ++i)
    {
		area += vertices[r-i].x*vertices[r-(i+1)].y-vertices[r-(i+1)].x*vertices[r-i].y;
	}
	area *= .5f;
	return area;
}

@interface GPolygon : NSObject
{
    @public
    cpVect *vertices;
    int numVertices;
    cpFloat area;
    cpFloat mass;
    cpFloat momentum;
}
@end

@implementation GPolygon

-(void) dealloc
{
    free(vertices);
    [super dealloc];    
}

@end

typedef enum 
{
    GFIXTURE_POLYGON,
    GFIXTURE_CIRCLE
} GFixtureType;

/**
 * Fixture definition
 * Holds fixture data
 */
@interface GFixtureData : NSObject
{
    @public
    
    GFixtureType fixtureType;
    
    cpFloat mass;
    cpFloat elasticity;
    cpFloat friction;

    cpVect surfaceVelocity;
    
	cpCollisionType collisionType;
	cpGroup group;
	cpLayers layers;
    
    cpFloat area;
    cpFloat momentum;
    
    BOOL isSensor;

    // for circles
    cpVect center;
    cpFloat radius;

    // for polygons
    NSMutableArray *polygons;
}
@end

@implementation GFixtureData

-(id) init
{
    self = [super init];
    if(self)
    {        
        polygons = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) dealloc
{
    [polygons release];
    [super dealloc];    
}

@end



/**
 * Body definition
 * Holds the body and the anchor point
 */
@interface GBodyDef : NSObject
{
@public
    CGPoint anchorPoint;
    NSMutableArray *fixtures;
    cpFloat mass;
    cpFloat momentum;
}
@end


@implementation GBodyDef

-(id) init
{
    self = [super init];
    if(self)
    {        
        fixtures = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) dealloc
{
    [fixtures release];
    [super dealloc];
}

@end


@implementation GCpShapeCache


+ (GCpShapeCache *)sharedShapeCache
{
    static GCpShapeCache *shapeCache = 0;
    if(!shapeCache)
    {
        shapeCache = [[GCpShapeCache alloc] init];
    }
    return shapeCache;
}

-(id) init
{
    self = [super init];
    if(self)
    {
        bodyDefs = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) dealloc
{
    [bodyDefs release];
    [super dealloc];
}

-(CGPoint) anchorPointForShape:(NSString*)shape
{
    GBodyDef *bd = [bodyDefs objectForKey:shape];
    assert(bd);
    return bd->anchorPoint;
}


-(BodyInfo *) createBodyWithName:(NSString*)name
{
    GBodyDef *bd = [bodyDefs objectForKey:name];
    NSAssert(bd != 0, @"Body not found");
    if(!bd)
    {
        return nil;
    }
    
    BodyInfo *bodyInfo = [[[BodyInfo alloc] init] autorelease];
    
    // create and add body to space
    cpBody *body = cpBodyNew(bd->mass, bd->momentum);
    [bodyInfo setBody:body];
    
    // set the center point
    body->p = bd->anchorPoint;

    // iterate over fixtures
    for(GFixtureData *fd in bd->fixtures)
    {
        if(fd->fixtureType == GFIXTURE_CIRCLE)
        {
            cpShape* shape = cpCircleShapeNew(body, fd->radius, fd->center);

            // set values
            shape->e = fd->elasticity; 
            shape->u = fd->friction;
            shape->surface_v = fd->surfaceVelocity;
            shape->collision_type = fd->collisionType;
//            shape->group = fd->group;
//            shape->layers = fd->layers;
            shape->sensor = fd->isSensor;
            
            [bodyInfo addShape:shape];
        }
        else
        {
            // iterate over polygons 
            for(GPolygon *p in fd->polygons)
            {
                // create new shape
                cpShape* shape = cpPolyShapeNew(body, p->numVertices, p->vertices, CGPointZero);
                
                // set values
                shape->e = fd->elasticity; 
                shape->u = fd->friction;
                shape->surface_v = fd->surfaceVelocity;
                shape->collision_type = fd->collisionType;
//                shape->group = fd->group;
//                shape->layers = fd->layers;
                shape->sensor = fd->isSensor;
                
                [bodyInfo addShape:shape];
            }            
        }        
    }
    
    return bodyInfo;
}


-(BOOL) addShapesWithFile:(NSString*)plist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:plist
                                               ofType:nil
                                          inDirectory:nil];

	NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    if(!dictionary)
    {
        return FALSE;
    }

    NSDictionary *metadataDict = [dictionary objectForKey:@"metadata"];
    int format = [[metadataDict objectForKey:@"format"] intValue];

    NSAssert(format == 1, @"Format not supported");
    if(format != 1)
    {
        return FALSE;
    }
    
    NSDictionary *bodyDict = [dictionary objectForKey:@"bodies"];

    for(NSString *bodyName in bodyDict) 
    {
        // get the body data
        NSDictionary *bodyData = [bodyDict objectForKey:bodyName];

        // create body object
        GBodyDef *bodyDef = [[[GBodyDef alloc] init] autorelease];

        // add the body element to the hash
        [bodyDefs setObject:bodyDef forKey:bodyName];

        // set anchor point
        bodyDef->anchorPoint = CGPointFromString_([bodyData objectForKey:@"anchorpoint"]);
        
        // iterate through the fixtures
        NSArray *fixtureList = [bodyData objectForKey:@"fixtures"];

        float totalMass = 0.0f;
        cpFloat totalBodyMomentum = 0.0f;
        for(NSDictionary *fixtureData in fixtureList)
        {
            // create fixture
            GFixtureData *fd = [[[GFixtureData alloc] init] autorelease];
            if(!fd)
            {
                return FALSE;
            }
            
            // add the fixture to the body
            [bodyDef->fixtures addObject:fd];

            fd->friction = [[fixtureData objectForKey:@"friction"] floatValue];            
            fd->elasticity = [[fixtureData objectForKey:@"elasticity"] floatValue];            
            fd->mass = [[fixtureData objectForKey:@"mass"] floatValue];            
            fd->surfaceVelocity = CGPointFromString_([fixtureData objectForKey:@"surface_velocity"]);        
            fd->layers = [[fixtureData objectForKey:@"layers"] intValue];            
            fd->group = [[fixtureData objectForKey:@"group"] intValue];            
            fd->collisionType = [[fixtureData objectForKey:@"collision_type"] intValue];            
            fd->isSensor = [[fixtureData objectForKey:@"fixtureData"] boolValue];
            
            NSString *fixtureType = [fixtureData objectForKey:@"fixture_type"];

            cpFloat totalArea = 0.0f;
            
            // sum up total mass for the body
            totalMass += fd->mass;
            
            // read polygon fixtures. One convave fixture may consist of several convex polygons
            if([fixtureType isEqual:@"POLYGON"])
            {
                NSArray *polygonsArray = [fixtureData objectForKey:@"polygons"];
                
                fd->fixtureType = GFIXTURE_POLYGON;
                
                for(NSArray *polygonArray in polygonsArray)
                {
                    GPolygon *poly = [[[GPolygon alloc] init] autorelease];
                    if(!poly)
                    {
                        return FALSE;
                    }

                    // add the polygon to the fixture
                    [fd->polygons addObject:poly];
                    
                    // add vertices
                    poly->numVertices = [polygonArray count];
                    cpVect *vertices = poly->vertices = malloc(sizeof(cpVect) * poly->numVertices);
                    if(!vertices)
                    {
                        return FALSE;
                    }
                    
                    int vindex=0;
                    for(NSString *pointString in polygonArray)
                    {
                        CGPoint offset = CGPointFromString_(pointString);
                        vertices[vindex].x = offset.x ; 
                        vertices[vindex].y = offset.y ; 
                        vindex++;
                    }

                    // calculate area of the polygon (needed to calculate the mass)
                    poly->area = area(vertices, poly->numVertices);
                    
                    // add up all area
                    totalArea += poly->area;
                }
            }
            else if([fixtureType isEqual:@"CIRCLE"])
            {
                fd->fixtureType = GFIXTURE_CIRCLE;
                
                NSDictionary *circleData = [fixtureData objectForKey:@"circle"];

                fd->radius = [[circleData objectForKey:@"radius"] floatValue];
                fd->center = CGPointFromString_([fixtureData objectForKey:@"center"]);
                totalArea += 3.1415927*fd->radius*fd->radius;
            }
            else
            {
                // unknown type
                assert(0);
            }
    
            fd->area = totalArea;
            
            // update sub polygon's masses and momentum
            cpFloat totalFixtureMomentum = 0.0f;
    
            if(totalArea)
            {
                if(fd->fixtureType == GFIXTURE_CIRCLE)
                {
                    totalFixtureMomentum += cpMomentForCircle(fd->mass, fd->radius, fd->radius, fd->center);
                }
                else
                {
                    for(GPolygon *p in fd->polygons)
                    {
                        // update mass
                        p->mass = (p->area * fd->mass) / fd->area;                    
                        
                        // calculate momentum
                        p->momentum = cpMomentForPoly(p->mass, p->numVertices, p->vertices, CGPointZero);
                        
                        // calculate total momentum
                        totalFixtureMomentum += p->momentum;
                    }                              
                }                
            }
            fd->momentum = totalFixtureMomentum;
            totalBodyMomentum = totalFixtureMomentum;
        }     
        
        // set bodies total mass
        bodyDef->mass = totalMass;
        bodyDef->momentum = totalBodyMomentum;
    }
    
    return TRUE;
}

@end


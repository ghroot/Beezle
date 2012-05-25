//
//  BodyInfo.m
//  Beezle
//
//  Created by Me on 03/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BodyInfo.h"

@implementation BodyInfo

@synthesize body = _body;
@synthesize shapes = _shapes;

-(id) init
{
    if (self = [super init])
    {
        _shapes = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) dealloc
{
    [_body release];
    [_shapes release];
    
    [super dealloc];
}

-(void) addShape:(ChipmunkShape *)shape
{
    [_shapes addObject:shape];
}

@end

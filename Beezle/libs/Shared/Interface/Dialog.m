//
//  Dialog.m
//  Beezle
//
//  Created by KM Lagerstrom on 08/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Dialog.h"
#import "CCBReader.h"
#import "CoverLayer.h"

@implementation Dialog

-(id) initWithNode:(CCNode *)node
{
	if (self = [super init])
	{
		_coverLayer = [CoverLayer new];
		[self addChild:_coverLayer];

		_node = [node retain];
		[self addChild:_node];
	}
	return self;
}

-(id) initWithInterfaceFile:(NSString *)filePath
{
	self = [self initWithNode:[CCBReader nodeGraphFromFile:filePath owner:self]];
	return self;
}

-(void) dealloc
{
	[_coverLayer release];
	[_node release];

	[super dealloc];
}

-(void) close
{
	[self removeFromParentAndCleanup:TRUE];
}

@end

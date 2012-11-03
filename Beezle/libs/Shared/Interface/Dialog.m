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

-(id) initWithNode:(CCNode *)node coverOpacity:(GLubyte)opacity instantCoverOpacity:(BOOL)instantCoverOpacity
{
	if (self = [super init])
	{
		_coverLayer = [[CoverLayer alloc] initWithOpacity:opacity instant:instantCoverOpacity];
		[self addChild:_coverLayer];

		_node = [node retain];
		[self addChild:_node];
	}
	return self;
}

-(id) initWithNode:(CCNode *)node coverOpacity:(GLubyte)opacity
{
	return [self initWithNode:node coverOpacity:opacity instantCoverOpacity:FALSE];
}

-(id) initWithNode:(CCNode *)node
{
	self = [self initWithNode:node coverOpacity:128];
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

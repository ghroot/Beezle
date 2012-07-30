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

-(id) initWithInterfaceFile:(NSString *)filePath
{
	if (self = [super init])
	{
		[self addChild:[CoverLayer node]];
		[self addChild:[CCBReader nodeGraphFromFile:filePath owner:self]];
	}
	return self;
}

@end

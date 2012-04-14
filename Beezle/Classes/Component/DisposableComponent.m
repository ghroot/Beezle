//
//  DisposableComponent.m
//  Beezle
//
//  Created by Me on 11/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DisposableComponent.h"

@implementation DisposableComponent

@synthesize destroyEntityWhenDisposed = _destroyEntityWhenDisposed;
@synthesize isDisposed = _isDisposed;

-(id) init
{
    if (self = [super init])
    {
		_name = @"disposable";
		_destroyEntityWhenDisposed = FALSE;
    }
    return self;
}

-(id) initWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if (self = [self init])
	{
		if ([dict objectForKey:@"destroyEntityWhenDisposed"] != nil)
		{
			_destroyEntityWhenDisposed = [[dict objectForKey:@"destroyEntityWhenDisposed"] boolValue];
		}
	}
	return self;
}

@end

//
//  DisposableComponent.m
//  Beezle
//
//  Created by Me on 11/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DisposableComponent.h"

@implementation DisposableComponent

@synthesize deleteEntityWhenDisposed = _deleteEntityWhenDisposed;
@synthesize isDisposed = _isDisposed;
@synthesize isAboutToBeDeleted = _isAboutToBeDeleted;

-(id) init
{
    if (self = [super init])
    {
		_name = @"disposable";
		_deleteEntityWhenDisposed = FALSE;
    }
    return self;
}

-(id) initWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if (self = [self init])
	{
		if ([dict objectForKey:@"deleteEntityWhenDisposed"] != nil)
		{
			_deleteEntityWhenDisposed = [[dict objectForKey:@"deleteEntityWhenDisposed"] boolValue];
		}
	}
	return self;
}

@end

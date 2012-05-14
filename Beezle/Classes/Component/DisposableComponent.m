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
@synthesize keepEntityDisabledInsteadOfDelete = _keepEntityDisabledInsteadOfDelete;
@synthesize isDisposed = _isDisposed;
@synthesize isAboutToBeDeleted = _isAboutToBeDeleted;

-(id) init
{
    if (self = [super init])
    {
		_name = @"disposable";
    }
    return self;
}

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
        // Type
        _deleteEntityWhenDisposed = [[typeComponentDict objectForKey:@"deleteEntityWhenDisposed"] boolValue];
        _keepEntityDisabledInsteadOfDelete = [[typeComponentDict objectForKey:@"keepEntityDisabledInsteadOfDelete"] boolValue];
	}
	return self;
}

@end

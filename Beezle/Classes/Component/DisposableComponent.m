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

-(id) initWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if (self = [self init])
	{
		if ([dict objectForKey:@"deleteEntityWhenDisposed"] != nil)
		{
			_deleteEntityWhenDisposed = [[dict objectForKey:@"deleteEntityWhenDisposed"] boolValue];
		}
		if ([dict objectForKey:@"keepEntityDisabledInsteadOfDelete"] != nil)
		{
			_keepEntityDisabledInsteadOfDelete = [[dict objectForKey:@"keepEntityDisabledInsteadOfDelete"] boolValue];
		}
	}
	return self;
}

@end

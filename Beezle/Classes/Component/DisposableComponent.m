//
//  DisposableComponent.m
//  Beezle
//
//  Created by Me on 11/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DisposableComponent.h"

@implementation DisposableComponent

@synthesize disposableId = _disposableId;
@synthesize isDisposed = _isDisposed;

-(id) init
{
    if (self = [super init])
    {
		_name = @"disposable";
        _isDisposed = FALSE;
    }
    return self;
}

-(void) dealloc
{
	[_disposableId release];
	
	[super dealloc];
}

-(NSDictionary *) getAsDictionary
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	if (_disposableId != nil)
	{
		[dict setObject:_disposableId forKey:@"disposableId"];
	}
	return dict;
}

-(void) populateWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if ([dict objectForKey:@"disposableId"] != nil)
	{
		[self setDisposableId:[dict objectForKey:@"disposableId"]];
	}
}

@end

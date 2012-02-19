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
@synthesize isConsumable = _isConsumable;
@synthesize isDisposed = _isDisposed;

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
		if ([dict objectForKey:@"consumable"] != nil)
		{
			_isConsumable = [[dict objectForKey:@"consumable"] boolValue];
		}
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

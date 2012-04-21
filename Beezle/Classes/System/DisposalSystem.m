//
//  DisposalSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 17/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DisposalSystem.h"
#import "DisposableComponent.h"
#import "EntityUtil.h"
#import "RenderComponent.h"

@implementation DisposalSystem

-(id) init
{
    self = [super initWithUsedComponentClasses:[NSArray arrayWithObject:[DisposableComponent class]]];
    return self;
}

-(void) processEntity:(Entity *)entity
{
	if ([EntityUtil isEntityDisposed:entity])
	{
		DisposableComponent *disposalComponent = [DisposableComponent getFrom:entity];
		if ([disposalComponent deleteEntityWhenDisposed] &&
			![disposalComponent isAboutToBeDeleted])
		{
			RenderComponent *renderComponent = [RenderComponent getFrom:entity];
			if ([renderComponent hasDefaultDestroyAnimation])
			{
				[EntityUtil animateAndDeleteEntity:entity];
			}
			else
			{
				[entity deleteEntity];
			}
		}
	}
}

@end

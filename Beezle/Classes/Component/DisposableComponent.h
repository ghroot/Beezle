//
//  DisposableComponent.h
//  Beezle
//
//  Created by Me on 11/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Component.h"

@interface DisposableComponent : Component
{
	NSString *_disposableId;
	BOOL _isConsumable;
    BOOL _isDisposed;
}

@property (nonatomic, copy) NSString *disposableId;
@property (nonatomic) BOOL isConsumable;
@property (nonatomic) BOOL isDisposed;

@end

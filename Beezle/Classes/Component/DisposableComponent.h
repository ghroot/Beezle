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
	BOOL _destroyEntityWhenDisposed;
    BOOL _isDisposed;
}

@property (nonatomic) BOOL destroyEntityWhenDisposed;
@property (nonatomic) BOOL isDisposed;

@end

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
	BOOL _deleteEntityWhenDisposed;
    BOOL _isDisposed;
}

@property (nonatomic) BOOL deleteEntityWhenDisposed;
@property (nonatomic) BOOL isDisposed;

@end

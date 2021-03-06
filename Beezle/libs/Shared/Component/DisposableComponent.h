//
//  DisposableComponent.h
//  Beezle
//
//  Created by Me on 11/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

/**
  Keeps track of if an entity is disposed.
 */
@interface DisposableComponent : Component
{
    // Type
	BOOL _deleteEntityWhenDisposed;
	BOOL _keepEntityDisabledInsteadOfDelete;
    
    // Transient
    BOOL _isDisposed;
	BOOL _isAboutToBeDeleted;
}

@property (nonatomic) BOOL deleteEntityWhenDisposed;
@property (nonatomic) BOOL keepEntityDisabledInsteadOfDelete;
@property (nonatomic) BOOL isDisposed;
@property (nonatomic) BOOL isAboutToBeDeleted;

@end

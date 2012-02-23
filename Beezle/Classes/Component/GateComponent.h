//
//  GateComponent.h
//  Beezle
//
//  Created by KM Lagerstrom on 20/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Component.h"

@interface GateComponent : Component
{
	NSString *_hiddenLevelName;
	BOOL _isOpened;
}

@property (nonatomic, readonly) NSString *hiddenLevelName;
@property (nonatomic) BOOL isOpened;

@end

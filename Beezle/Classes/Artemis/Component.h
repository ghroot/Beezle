//
//  Component.h
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@interface Component : NSObject
{
    BOOL _enabled;
}

@property (nonatomic, readonly) BOOL enabled;

-(void) enable;
-(void) disable;

@end

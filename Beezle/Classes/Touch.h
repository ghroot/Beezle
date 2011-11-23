//
//  TouchLocation.h
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Touch : NSObject
{
    CGPoint _point;
}

@property (nonatomic, readonly) CGPoint point;

-(id) initWithPoint:(CGPoint)point;

@end

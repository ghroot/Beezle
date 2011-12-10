//
//  GameMode.h
//  Beezle
//
//  Created by Me on 10/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface GameMode : NSObject
{
    NSArray *_systems;
}

+(GameMode *) mode;
+(GameMode *) modeWithSystems:(NSArray *)systems;

-(id) initWithSystems:(NSArray *)systems;

-(void) processSystems;
-(void) enter;
-(void) leave;

@end

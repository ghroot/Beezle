//
//  EntityGroupSelectMenuItem.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 06/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface EntityGroupSelectMenuItem : CCMenuItemFont
{
	NSArray *_entityTypes;
}

@property (nonatomic, readonly) NSArray *entityTypes;

-(id) initWithGroupName:(NSString *)groupName andEntityTypes:(NSArray *)entityTypes target:(id)target selector:(SEL)selector;

@end

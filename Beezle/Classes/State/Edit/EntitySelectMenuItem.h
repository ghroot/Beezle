//
//  EntitySelectMenuItem.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 06/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface EntitySelectMenuItem : CCMenuItemFont
{
	NSString *_entityType;
}

@property (nonatomic, readonly) NSString *entityType;

-(id) initWithEntityType:(NSString *)entityType target:(id)target selector:(SEL)selector;

@end

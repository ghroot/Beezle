//
//  SoundButton
//  Beezle
//
//  Created by marcus on 06/10/2012.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface SoundButton : CCNode
{
	CCMenu *_menu;
	CCMenuItemImage *_soundOnMenuItem;
	CCMenuItemImage *_soundOffMenuItem;
	CCSprite *_soundButtonExplosionSprite;
}

@end
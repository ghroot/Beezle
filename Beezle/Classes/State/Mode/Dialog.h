//
//  Dialog.h
//  Beezle
//
//  Created by KM Lagerstrom on 08/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface Dialog : CCNode
{
	CCSprite *_imageSprite;
}

-(id) initWithImage:(NSString *)imagePath;

@end

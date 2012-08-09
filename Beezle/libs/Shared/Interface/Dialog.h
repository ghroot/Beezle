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
	CCLayer *_coverLayer;
	CCNode *_node;
}

-(id) initWithNode:(CCNode *)node;
-(id) initWithInterfaceFile:(NSString *)filePath;

-(void) close;

@end

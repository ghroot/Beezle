//
//  CoverLayer.h
//  Beezle
//
//  Created by KM Lagerstrom on 08/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface CoverLayer : CCLayerColor <CCTouchOneByOneDelegate>

-(id) initWithOpacity:(GLubyte)opacity instant:(BOOL)instant;
-(id) initWithOpacity:(GLubyte)opacity;

@end

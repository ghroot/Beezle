//
//  BalloonDialog.h
//  Beezle
//
//  Created by Marcus on 08/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Dialog.h"

@interface BalloonDialog : Dialog
{
	BOOL _balloonCanBeClosed;
}

-(id) initWithFileName:(NSString *)fileName andOffset:(CGPoint)offset;

@end

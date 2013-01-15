//
//  FacebookHighscoresState.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 01/14/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "FacebookManager.h"

@interface FacebookHighscoresState : GameState <FacebookScoresDelegate>
{
	CCSprite *_loadingSprite;
}

@end

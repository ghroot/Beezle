//
// Created by Marcus on 18/04/2013.
//

#import "cocos2d.h"
#import "artemis.h"
#import "InAppPurchasesManager.h"

@interface InAppLayer : CCLayer <InAppPurchasesDelegate>
{
	CCNode *_interfaceNode;
	BOOL _isInView;
	CCSprite *_buyBurneeTagSprite;
	CCSprite *_buyGogglesTagSprite;

	World *_world;
}

-(id) initWithWorld:(World *)world;

-(void) useBurnee;
-(void) useGoggles;
-(void) ensureInView:(BOOL)shouldBeInView;

@end

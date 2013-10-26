//
// Created by Marcus on 18/04/2013.
//

#import "cocos2d.h"
#import "artemis.h"
#import "InAppPurchasesManager.h"

@class Game;
@class GameplayState;

@interface InAppLayer : CCLayer <InAppPurchasesDelegate>
{
	CCNode *_interfaceNode;
	BOOL _isInView;
	Game *_game;
	GameplayState *_gameplayState;

	CCMenu *_menu;
	CCLabelAtlas *_ironBeeQuantityLabel;
	CCSprite *_buyIronBeeTagSprite;
	CCLabelAtlas *_stingeeQuantityLabel;
	CCSprite *_buyStingeeTagSprite;
	CCLabelAtlas *_burneeQuantityLabel;
	CCSprite *_buyBurneeTagSprite;
	CCLabelAtlas *_gogglesQuantityLabel;
	CCSprite *_buyGogglesTagSprite;

	CCLayerColor *_coverLayer;

	World *_world;
}

-(id) initWithWorld:(World *)world game:(Game *)game gameplayState:(GameplayState *)gameplayState;

-(void) useBurnee;
-(void) useStingee;
-(void) useIronBee;
-(void) useGoggles;
-(void) ensureInView:(BOOL)shouldBeInView;

@end

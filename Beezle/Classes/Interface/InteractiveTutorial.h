//
// Created by Marcus on 26/02/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "cocos2d.h"
#import "artemis.h"

@class CCBAnimationManager;
@class SlingerControlSystem;

@interface InteractiveTutorial : NSObject <CCTouchOneByOneDelegate>
{
	CCLayer *_layer;
	World *_world;
	SlingerControlSystem *_slingerControlSystem;

	CCNode *_tutorialNode;
	CCBAnimationManager *_tutorialAnimationManager;
	int _tutorialState;

	CCSprite *_tutorialTargetSprite;
}

-(id) initWithLayer:(CCLayer *)layer world:(World *)world;

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event;
-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event;
-(void) update;

@end

//
//  HelloWorldLayer.h
//  Beezle
//
//  Created by Me on 31/10/2011.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "PhysicsSprite.h"

#import "chipmunk.h"
#import "cocos2d.h"

@interface HelloWorldLayer : CCLayer
{
	CCTexture2D *spriteTexture_; // weak ref
	
	cpSpace *space_; // strong ref
	
	cpShape *walls_[4];
    
    BOOL isTouching;
    CGPoint touchStartLocation;
    CGPoint touchVector;
}

//-(void) addNewSpriteAtPosition:(CGPoint)pos;
-(void) createResetButton;
-(void) initPhysics;

@end

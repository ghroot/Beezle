//
//  RenderableBehaviour.h
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Component.h"
#import "cocos2d.h"

@class RenderSprite;

@interface RenderComponent : Component
{
	NSMutableArray *_renderSprites;
    int _z;
}

@property (nonatomic, readonly) NSArray *renderSprites;
@property (nonatomic) int z;

+(RenderComponent *) renderComponentWithRenderSprites:(NSArray *)renderSprites;
+(RenderComponent *) renderComponentWithRenderSprite:(RenderSprite *)renderSprite;

-(void) addRenderSprite:(RenderSprite *)renderSprite;
-(void) playAnimation:(NSString *)animationName withLoops:(int)nLoops;
-(void) playAnimation:(NSString *)animationName withCallbackTarget:(id)target andCallbackSelector:(SEL)selector;

@end

//
//  MenuState.m
//  Beezle
//
//  Created by Me on 24/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuState.h"
#import "Beezle.h"
#import "CocosGameContainer.h"
#import "ForwardLayer.h"

@implementation MenuState

-(void) initialiseWithContainer:(GameContainer *)container andGame:(StateBasedGame *)game
{
    _game = game;
    
    _startGameButton = [CCMenuItemImage
                                    itemFromNormalImage:@"Icon-72.png"
                                    selectedImage:@"Icon-72.png"
                                    target:self
                                    selector:@selector(startGame:)];
    
    _startTestButton = [CCMenuItemImage
                                   itemFromNormalImage:@"Icon-Small-50.png"
                                   selectedImage:@"Icon-Small-50.png"
                                   target:self
                                   selector:@selector(startTest:)];
    
    _menu = [CCMenu menuWithItems: _startGameButton, _startTestButton, nil];
    [_menu alignItemsHorizontallyWithPadding:40.0f];
}

-(void) startGame:(id)sender
{
    [_game enterState:STATE_GAMEPLAY];
}

-(void) startTest:(id)sender
{
    [_game enterState:STATE_TEST];
}

-(void) enterWithContainer:(GameContainer *)container andGame:(StateBasedGame *)game
{
    CocosGameContainer *cocosGameContainer = (CocosGameContainer *)container;
	CCLayer *layer = [cocosGameContainer layer];
    
    [layer addChild:_menu];
}

-(void) leaveWithContainer:(GameContainer *)container andGame:(StateBasedGame *)game
{
    CocosGameContainer *cocosGameContainer = (CocosGameContainer *)container;
	CCLayer *layer = [cocosGameContainer layer];
    
    [layer removeChild:_menu cleanup:TRUE];
}

@end

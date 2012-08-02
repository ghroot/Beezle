//
//  LevelSelectMenuState.m
//  Beezle
//
//  Created by Me on 02/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelSelectMenuState.h"
#import "Game.h"
#import "GameplayState.h"
#import "CCBReader.h"
#import "PlayerInformation.h"

static const int DRAG_DISTANCE_BLOCK_MENU_ITEMS = 10;

@interface LevelSelectMenuState()

-(void) addBackground;
-(void) addInterfaceLevelsMenu;
-(CCMenu *) getMenu:(CCNode *)node;
-(void) createBackMenu;
-(void) startGame:(id)sender;

@end

@implementation LevelSelectMenuState

+(LevelSelectMenuState *) stateWithTheme:(NSString *)theme
{
	return [[[self alloc] initWithTheme:theme] autorelease];
}

// Designated initialiser
-(id) initWithTheme:(NSString *)theme
{
    if (self = [super init])
    {
		_theme = [theme copy];
    }
    return self;
}

-(id) init
{
	return [self initWithTheme:nil];
}

-(void) initialise
{
	[super initialise];

    [self addBackground];
    [self addInterfaceLevelsMenu];
	[self createBackMenu];
}

-(void) addBackground
{
    CCSprite *backgroundSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"Colour-%@.jpg", _theme]];
	[backgroundSprite setAnchorPoint:CGPointMake(0.0f, 0.0f)];
	[self addChild:backgroundSprite];
}

-(void) addInterfaceLevelsMenu
{
//    NSString *nodeFileName = [NSString stringWithFormat:@"LevelSelect-%@.ccbi", _theme];
    NSString *nodeFileName = @"LevelSelect-A.ccbi";
	_draggableNode = [[CCBReader nodeGraphFromFile:nodeFileName owner:self] retain];
    CCMenu *menu = [self getMenu:_draggableNode];
    for (CCMenuItemImage *menuItemImage in [menu children])
    {
        NSString *levelName = [NSString stringWithFormat:@"Level-%@%d", _theme, [menuItemImage tag]];
        if ([[PlayerInformation sharedInformation] pollenRecord:levelName] > 0)
        {
            NSString *openImageName = [NSString stringWithFormat:@"LevelCell-%@-Open.png", _theme];
            [menuItemImage setNormalImage:[CCSprite spriteWithFile:openImageName]];
            [menuItemImage setSelectedImage:[CCSprite spriteWithFile:openImageName]];
            [menuItemImage setDisabledImage:[CCSprite spriteWithFile:openImageName]];
        }
		else
		{
			NSString *imageName = [NSString stringWithFormat:@"LevelCell-%@-Bee.png", _theme];
			[menuItemImage setNormalImage:[CCSprite spriteWithFile:imageName]];
			[menuItemImage setSelectedImage:[CCSprite spriteWithFile:imageName]];
			[menuItemImage setDisabledImage:[CCSprite spriteWithFile:imageName]];
		}
        
        NSString *levelString = [NSString stringWithFormat:@"%d", [menuItemImage tag]];
        CCLabelAtlas *label = [[[CCLabelAtlas alloc] initWithString:levelString charMapFile:@"numberImages.png" itemWidth:30 itemHeight:30 startCharMap:'/'] autorelease];
        [label setAnchorPoint:CGPointMake(0.5f, 0.5f)];
        [label setPosition:[menuItemImage position]];
        [_draggableNode addChild:label];
    }
	[self addChild:_draggableNode];
}

-(CCMenu *) getMenu:(CCNode *)node
{
    for (CCNode *childNode in [node children])
	{
		if ([childNode isKindOfClass:[CCMenu class]])
		{
            return (CCMenu *)childNode;
		}
	}
    return nil;
}

-(void) createBackMenu
{
    CCMenu *backMenu = [CCMenu node];
	CCMenuItemImage *backMenuItem = [CCMenuItemImage itemWithNormalImage:@"ReturnArrow.png" selectedImage:@"ReturnArrow.png" block:^(id sender){
        if (_didDragEnoughToBlockMenuItems)
        {
            return;
        }
		[_game popState];
	}];
	[backMenuItem setPosition:CGPointMake(2.0f, 2.0f)];
	[backMenuItem setAnchorPoint:CGPointMake(0.0f, 0.0f)];
	[backMenu setPosition:CGPointZero];
	[backMenu addChild:backMenuItem];
	[self addChild:backMenu];
}

-(void) dealloc
{
	[_theme release];
    [_draggableNode release];
	
	[super dealloc];
}

-(void) startGame:(id)sender
{
    if (_didDragEnoughToBlockMenuItems)
    {
        return;
    }
    
	CCMenuItemImage *menuItem = (CCMenuItemImage *)sender;
	NSString *levelName = [NSString stringWithFormat:@"Level-%@%d", _theme, [menuItem tag]];
	[_game clearAndReplaceState:[GameplayState stateWithLevelName:levelName]];
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [touch locationInView: [touch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL: location];

	if (_isDragging)
	{
		if (!_didDragEnoughToBlockMenuItems &&
			abs(_startDragTouchX - convertedLocation.x) >= DRAG_DISTANCE_BLOCK_MENU_ITEMS)
		{
			_didDragEnoughToBlockMenuItems = TRUE;
		}

		float newX = _startDragNodeX + (convertedLocation.x - _startDragTouchX);
		newX = min(0, newX);
		newX = max(-720, newX);
		[_draggableNode setPosition:CGPointMake(newX, 0)];
	}
	else
	{
		_isDragging = TRUE;
		_startDragTouchX = convertedLocation.x;
		_startDragNodeX = [_draggableNode position].x;
		_didDragEnoughToBlockMenuItems = FALSE;
	}
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    _isDragging = FALSE;
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self ccTouchEnded:touch withEvent:event];
}

@end

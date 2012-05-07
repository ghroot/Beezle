//
//  RateLevelState.m
//  Beezle
//
//  Created by KM Lagerstrom on 07/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RateLevelState.h"
#import "Game.h"
#import "GameplayState.h"
#import "LevelOrganizer.h"
#import "LevelRatings.h"
#import "MainMenuState.h"

@interface RateLevelState()

-(void) createMenu;
-(void) rateOneStar:(id)sender;
-(void) rateTwoStars:(id)sender;
-(void) rateThreeStars:(id)sender;
-(void) loadNextLevel;

@end

@implementation RateLevelState

+(id) stateWithLevelName:(NSString *)levelName
{
	return [[[self alloc] initWithLevelName:levelName] autorelease];
}

-(id) initWithLevelName:(NSString *)levelName
{
	if (self = [super init])
	{
		_levelName = [levelName retain];
	}
	return self;
}

-(void) dealloc
{
	[_levelName release];
	
	[super dealloc];
}

-(void) initialise
{
	[super initialise];
	
    [self createMenu];
}

-(void) createMenu
{
    _menu = [CCMenu menuWithItems:nil];
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	CCLabelTTF *titleLabel = [CCLabelTTF labelWithString:@"Please rate this level:" fontName:@"Marker Felt" fontSize:26.0f];
	[titleLabel setAnchorPoint:CGPointMake(0.5f, 0.5f)];
	[titleLabel setPosition:CGPointMake(winSize.width / 2, winSize.height - 40.0f)];
	[self addChild:titleLabel];
	
	CCMenuItemFont *oneStarMenuItem = [CCMenuItemFont itemWithString:@"1" target:self selector:@selector(rateOneStar:)];
	[oneStarMenuItem setFontSize:90.0f];
	[_menu addChild:oneStarMenuItem];
	
	CCMenuItemFont *twoStarsMenuItem = [CCMenuItemFont itemWithString:@"2" target:self selector:@selector(rateTwoStars:)];
	[twoStarsMenuItem setFontSize:90.0f];
	[_menu addChild:twoStarsMenuItem];
	
	CCMenuItemFont *threeStarsMenuItem = [CCMenuItemFont itemWithString:@"3" target:self selector:@selector(rateThreeStars:)];
	[threeStarsMenuItem setFontSize:90.0f];
	[_menu addChild:threeStarsMenuItem];
	
	CCLabelTTF *helpLabel = [CCLabelTTF labelWithString:@"1 = Not good, 2 = Ok, 3 = Great" fontName:@"Marker Felt" fontSize:20.0f];
	[helpLabel setAnchorPoint:CGPointMake(0.5f, 0.5f)];
	[helpLabel setPosition:CGPointMake(winSize.width / 2, 40.0f)];
	[self addChild:helpLabel];
	
	[_menu alignItemsHorizontallyWithPadding:40.0f];
	
	[self addChild:_menu];
}

-(void) rateOneStar:(id)sender
{
	[[LevelRatings sharedRatings] rate:_levelName numberOfStars:1];
	[[LevelRatings sharedRatings] save];
	
	[self loadNextLevel];
}

-(void) rateTwoStars:(id)sender
{
	[[LevelRatings sharedRatings] rate:_levelName numberOfStars:2];
	[[LevelRatings sharedRatings] save];
	
	[self loadNextLevel];
}

-(void) rateThreeStars:(id)sender
{
	[[LevelRatings sharedRatings] rate:_levelName numberOfStars:3];
	[[LevelRatings sharedRatings] save];
	
	[self loadNextLevel];
}

-(void) loadNextLevel
{
	NSString *nextLevelName = [[LevelOrganizer sharedOrganizer] levelNameAfter:_levelName];
    if (nextLevelName != nil)
    {
        [_game replaceState:[GameplayState stateWithLevelName:nextLevelName]];
    }
    else
    {
		[_game replaceState:[MainMenuState state]];
    }
}

@end

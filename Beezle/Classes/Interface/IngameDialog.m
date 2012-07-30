//
//  IngameDialog.m
//  Beezle
//
//  Created by Marcus on 07/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IngameDialog.h"
#import "LevelSession.h"
#import "PlayerInformation.h"

@interface IngameDialog()

-(void) fixMenuItemImageCentering:(CCMenuItemImage *)menuItemImage;

@end

@implementation IngameDialog

-(id) initWithInterfaceFile:(NSString *)filePath andLevelSession:(LevelSession *)levelSession
{
	if (self = [super initWithInterfaceFile:filePath])
	{
		_levelSession = levelSession;

		CCLabelAtlas *levelPollenCountLabel = [[CCLabelAtlas alloc] initWithString:@"0" charMapFile:@"numberImages.png" itemWidth:30 itemHeight:30 startCharMap:'/'];
		[levelPollenCountLabel setPosition:[_levelPollenCountLabelPosition position]];
		[levelPollenCountLabel setString:[NSString stringWithFormat:@"%d", [levelSession totalNumberOfPollen]]];
		[self addChild:levelPollenCountLabel];

		CCLabelAtlas *totalPollenCountLabel = [[CCLabelAtlas alloc] initWithString:@"0" charMapFile:@"numberImages.png" itemWidth:30 itemHeight:30 startCharMap:'/'];
		[totalPollenCountLabel setString:[NSString stringWithFormat:@"%d", [[PlayerInformation sharedInformation] totalNumberOfPollen]]];
		[totalPollenCountLabel setPosition:[_totalPollenCountLabelPosition position]];
		[self addChild:totalPollenCountLabel];
	}
	return self;
}

-(void) useOrangeResumeButton
{
	[_resumeWhiteMenuItem setVisible:FALSE];
	[self fixMenuItemImageCentering:_resumeOrangeMenuItem];
}

-(void) useWhiteResumeButton
{
	[_resumeOrangeMenuItem setVisible:FALSE];
	[self fixMenuItemImageCentering:_resumeWhiteMenuItem];
}

-(void) useNoResumeButton
{
	[_resumeOrangeMenuItem setVisible:FALSE];
	[_resumeWhiteMenuItem setVisible:FALSE];
}

-(void) resumeGame
{
}

-(void) useOrangeRestartButton
{
	[_redoWhiteMenuItem setVisible:FALSE];
	[self fixMenuItemImageCentering:_redoOrangeMenuItem];
}

-(void) useWhiteRestartButton
{
	[_redoOrangeMenuItem setVisible:FALSE];
	[self fixMenuItemImageCentering:_redoWhiteMenuItem];
}

-(void) useNoRestartButton
{
	[_redoOrangeMenuItem setVisible:FALSE];
	[_redoWhiteMenuItem setVisible:FALSE];
}

-(void) restartGame
{
}

-(void) useOrangeNextLevelButton
{
	[self fixMenuItemImageCentering:_nextLevelOrangeMenuItem];
}

-(void) useWhiteNextLevelButton
{
	[_nextLevelOrangeMenuItem setVisible:FALSE];
}

-(void) useNoNextLevelButton
{
	[_nextLevelOrangeMenuItem setVisible:FALSE];
}

-(void) nextLevel
{
}

-(void) fixMenuItemImageCentering:(CCMenuItemImage *)menuItemImage
{
	[[menuItemImage selectedImage] setPosition:CGPointMake([menuItemImage contentSize].width / 2, [menuItemImage contentSize].height / 2)];
	[[menuItemImage selectedImage] setAnchorPoint:CGPointMake(0.5f, 0.5f)];
}

@end

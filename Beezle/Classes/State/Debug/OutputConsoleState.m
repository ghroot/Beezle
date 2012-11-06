//
// Created by Marcus on 06/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "OutputConsoleState.h"
#import "Game.h"
#import "Logger.h"

@interface OutputConsoleState()

-(NSString *) createOutputString;

@end

@implementation OutputConsoleState

-(id) init
{
	if (self = [super init])
	{
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		CGSize labelSize = CGSizeMake(winSize.width, winSize.height - 30.0f);
		_label = [CCLabelTTF labelWithString:[self createOutputString] fontName:@"Marker Felt" fontSize:14 dimensions:labelSize hAlignment:kCCTextAlignmentLeft];
		[_label setAnchorPoint:CGPointMake(0.0f, 1.0f)];
		[_label setPosition:CGPointMake(0.0f, winSize.height)];
		[self addChild:_label];

		CCMenuItemFont *backMenuItem = [CCMenuItemFont itemWithString:@"Back" block:^(id sender){
			[_game popState];
		}];
		[backMenuItem setAnchorPoint:CGPointZero];
		[backMenuItem setPosition:CGPointZero];
		[backMenuItem setFontSize:20];
		CCMenu *backMenu = [CCMenu menuWithItems:backMenuItem, nil];
		[backMenu setPosition:CGPointZero];
		[self addChild:backMenu];
	}
	return self;
}

-(NSString *) createOutputString
{
	NSMutableString *outputString = [NSMutableString string];
	for (NSString *line in [[Logger defaultLogger] lines])
	{
		[outputString appendFormat:@"%@\n", line];
	}
	return outputString;
}

@end

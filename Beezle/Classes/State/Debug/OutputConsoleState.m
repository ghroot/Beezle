//
// Created by Marcus on 06/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "OutputConsoleState.h"
#import "Game.h"
#import "Logger.h"
#import "ScrollView.h"
#import "NotificationTypes.h"

@interface OutputConsoleState()

-(void) createScrollView;
-(NSString *) createOutputString;
-(void) handleLogNotification:(NSNotification *)notification;

@end

@implementation OutputConsoleState

-(id) init
{
	if (self = [super init])
	{
		[self createScrollView];

		CCMenuItemFont *backMenuItem = [CCMenuItemFont itemWithString:@"Back" block:^(id sender){
			[_game popState];
		}];
		[backMenuItem setAnchorPoint:CGPointZero];
		[backMenuItem setPosition:CGPointZero];
		[backMenuItem setFontSize:20];
		CCMenu *backMenu = [CCMenu menuWithItems:backMenuItem, nil];
		[backMenu setPosition:CGPointZero];
		[self addChild:backMenu];

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLogNotification:) name:NOTIFICATION_LOG object:nil];
	}
	return self;
}

-(void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];

	[super dealloc];
}

-(void) createScrollView
{
	if (_scrollView != nil)
	{
		[self removeChild:_scrollView];
		_scrollView = nil;
	}

	CGSize winSize = [[CCDirector sharedDirector] winSize];
	CGSize labelSize = CGSizeMake(winSize.width, fmaxf(16.0f * [[[Logger defaultLogger] lines] count], winSize.height));
	CCLabelTTF *label = [CCLabelTTF labelWithString:[self createOutputString] fontName:@"Marker Felt" fontSize:14 dimensions:labelSize hAlignment:kCCTextAlignmentLeft];
	[label setAnchorPoint:CGPointMake(0.5f, 0.0f)];
	[label setContentSize:labelSize];
	[label setPosition:CGPointMake(winSize.width / 2, 0.0f)];

	_scrollView = [ScrollView viewWithContent:label];
	[_scrollView setScrollVertically:TRUE];
	[self addChild:_scrollView];
}

-(NSString *) createOutputString
{
	NSMutableString *outputString = [NSMutableString string];
	for (NSString *line in [[Logger defaultLogger] lines])
	{
		[outputString appendFormat:@"                 %@\n", line];
	}
	return outputString;
}

-(void) handleLogNotification:(NSNotification *)notification
{
	[self createScrollView];
}

@end

//
// Created by Marcus on 06/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "Logger.h"
#import "NotificationTypes.h"

@implementation Logger

@synthesize lines = _lines;

+(Logger *)defaultLogger
{
	static Logger *logger = 0;
	if (!logger)
	{
		logger = [[self alloc] init];
	}
	return logger;
}

-(id) init
{
	if (self = [super init])
	{
		_lines = [NSMutableArray new];
	}
	return self;
}

-(void) dealloc
{
	[_lines release];

	[super dealloc];
}

-(void) log:(NSString *)message
{
	NSLog(@"%@", message);

	NSDate *now = [NSDate date];
	NSDateFormatter *dateFormat = [[NSDateFormatter new] autorelease];
	[dateFormat setDateFormat:@"HH:mm:ss"];
	[_lines addObject:[NSString stringWithFormat:@"[%@] %@", [dateFormat stringFromDate:now], message]];

	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOG object:self];
}

@end

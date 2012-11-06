//
// Created by Marcus on 06/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

@interface Logger : NSObject
{
	NSMutableArray *_lines;
}

@property (nonatomic, readonly) NSArray *lines;

+(Logger *) defaultLogger;

-(void) log:(NSString *)message;

@end

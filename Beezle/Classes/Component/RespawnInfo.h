//
// Created by Marcus on 04/12/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

@interface RespawnInfo : NSObject
{
	NSString *_entityType;
	CGPoint _position;
	int _countdown;
}

@property (nonatomic, readonly) NSString *entityType;
@property (nonatomic, readonly) CGPoint position;

-(id) initWithEntityType:(NSString *)entityType andPosition:(CGPoint)position;

-(BOOL) hasCountdownReachedZero;
-(void) decreaseCountdown;

@end

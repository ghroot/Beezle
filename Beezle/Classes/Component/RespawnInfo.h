//
// Created by Marcus on 04/12/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

@interface RespawnInfo : NSObject
{
	NSString *_entityType;
	CGPoint _position;
	NSString *_respawnAnimationName;
	int _countdown;
}

@property (nonatomic, readonly) NSString *entityType;
@property (nonatomic, readonly) CGPoint position;
@property (nonatomic, readonly) NSString *respawnAnimationName;

-(id) initWithEntityType:(NSString *)entityType position:(CGPoint)position respawnAnimationName:(NSString *)respawnAnimationName;

-(BOOL) hasCountdownReachedZero;
-(void) decreaseCountdown;

@end

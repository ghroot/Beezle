//
// Created by Marcus on 2013-10-03.
//

#import "artemis.h"

@interface StingerComponent : Component
{
	// Type
	NSString *_inflateStartAnimation;
	NSString *_inflateEndAnimation;
	NSString *_stingSound;

	// Transient
	int _countdownUntilNextPossibleSting;
}

@property (nonatomic, copy) NSString *inflateStartAnimation;
@property (nonatomic, copy) NSString *inflateEndAnimation;
@property (nonatomic, copy) NSString *stingSound;
@property (nonatomic) int countdownUntilNextPossibleSting;

@end

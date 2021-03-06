//
// Created by Marcus on 18/02/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "artemis.h"

@interface BurnableComponent : Component
{
	// Type / Instance
	BOOL _useDefaultBurnBehaviour;
	NSMutableDictionary *_burnRenderSpritesByName;
	NSString *_pieceSpriteSheetName;
	NSString *_pieceAnimationFileName;
	NSArray *_pieceAnimationNames;
	NSMutableArray *_pieceVelocities;
	NSArray *_pieceSmallAnimationNames;
	float _pieceDelay;
	NSString *_burnSoundName;
}

@property (nonatomic, readonly) BOOL useDefaultBurnBehaviour;
@property (nonatomic, readonly) NSDictionary *burnRenderSpritesByName;
@property (nonatomic, readonly) NSString *pieceSpriteSheetName;
@property (nonatomic, readonly) NSString *pieceAnimationFileName;
@property (nonatomic, readonly) NSArray *pieceAnimationNames;
@property (nonatomic, readonly) NSArray *pieceVelocities;
@property (nonatomic, readonly) NSArray *pieceSmallAnimationNames;
@property (nonatomic, readonly) float pieceDelay;
@property (nonatomic, readonly) NSString *burnSoundName;

@end

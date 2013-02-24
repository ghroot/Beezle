//
// Created by Marcus on 18/02/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "BurnableComponent.h"

@implementation BurnableComponent

@synthesize burnRenderSpritesByName = _burnRenderSpritesByName;
@synthesize pieceSpriteSheetName = _pieceSpriteSheetName;
@synthesize pieceAnimationFileName = _pieceAnimationFileName;
@synthesize pieceAnimationNames = _pieceAnimationNames;
@synthesize pieceVelocities = _pieceVelocities;
@synthesize pieceSmallAnimationNames = _pieceSmallAnimationNames;
@synthesize pieceDelay = _pieceDelay;
@synthesize numberOfFlames = _numberOfFlames;
@synthesize burnSoundName = _burnSoundName;

-(id) init
{
	if (self = [super init])
	{
		_burnRenderSpritesByName = [NSMutableDictionary new];
	}
	return self;
}

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
		// Type
		for (NSDictionary *spriteDict in [typeComponentDict objectForKey:@"burnSprites"])
		{
			[_burnRenderSpritesByName setObject:spriteDict forKey:[spriteDict objectForKey:@"name"]];
		}
		_pieceSpriteSheetName = [[typeComponentDict objectForKey:@"pieceSpriteSheet"] copy];
		_pieceAnimationFileName = [[typeComponentDict objectForKey:@"pieceAnimationFile"] copy];
		_pieceAnimationNames = [[NSArray alloc] initWithArray:[typeComponentDict objectForKey:@"pieceAnimations"]];
		_pieceVelocities = [NSMutableArray new];
		for (NSString *pieceVelocityAsString in [typeComponentDict objectForKey:@"pieceVelocities"])
		{
			[_pieceVelocities addObject:[NSValue valueWithCGPoint:CGPointFromString(pieceVelocityAsString)]];
		}
		_pieceSmallAnimationNames = [[NSArray alloc] initWithArray:[typeComponentDict objectForKey:@"pieceSmallAnimations"]];
		_pieceDelay = [[typeComponentDict objectForKey:@"pieceDelay"] floatValue];
		_numberOfFlames = [[typeComponentDict objectForKey:@"numberOfFlames"] intValue];
	}
	return self;
}

-(void) dealloc
{
	[_burnRenderSpritesByName release];
	[_pieceSpriteSheetName release];
	[_pieceAnimationFileName release];
	[_pieceAnimationNames release];
	[_pieceVelocities release];
	[_pieceSmallAnimationNames release];
	[_burnSoundName release];

	[super dealloc];
}

@end

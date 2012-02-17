//
//  GlassComponent.h
//  Beezle
//
//  Created by KM Lagerstrom on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Component.h"

@interface GlassComponent : Component
{
	int _piecesCount;
	CGPoint _piecesSpawnAreaOffset;
	CGSize _piecesSpawnAreaSize;
}

@property (nonatomic, readonly) int piecesCount;
@property (nonatomic, readonly) CGPoint piecesSpawnAreaOffset;
@property (nonatomic, readonly) CGSize piecesSpawnAreaSize;

+(id) componentWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world;

@end

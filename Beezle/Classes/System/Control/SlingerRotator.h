//
// Created by Marcus on 10/12/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "artemis.h"

@interface SlingerRotator : NSObject
{
	Entity *_slingerEntity;
	float _rotation;
}

@property (nonatomic) float rotation;

-(id) initWithSlingerEntity:(Entity *)slingerEntity;

@end

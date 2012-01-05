//
//  EditableComponent.h
//  Beezle
//
//  Created by Me on 17/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface EditComponent : Component
{
	NSString *_levelLayoutType;
	BOOL _isSelected;
}

@property (nonatomic, retain) NSString *levelLayoutType;
@property (nonatomic) BOOL isSelected;

+(EditComponent *) componentWithLevelLayoutType:(NSString *)levelLayoutType;

-(id) initWithLevelLayoutType:(NSString *)levelLayoutType;

@end

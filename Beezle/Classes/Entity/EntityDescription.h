//
//  EntityDescription.h
//  Beezle
//
//  Created by KM Lagerstrom on 05/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface EntityDescription : NSObject
{
	NSString *_type;
	NSArray *_groups;
	NSArray *_labels;
	NSArray *_tags;
	NSDictionary *_typeComponentsDict;
}

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSArray *groups;
@property (nonatomic, copy) NSArray *labels;
@property (nonatomic, copy) NSArray *tags;
@property (nonatomic, copy) NSDictionary *typeComponentsDict;

-(NSArray *) createComponents:(World *)world instanceComponentsDict:(NSDictionary *)instanceComponentsDict;

@end

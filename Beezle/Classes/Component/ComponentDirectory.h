//
//  ComponentDirectory.h
//  Beezle
//
//  Created by Marcus on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface ComponentDirectory : NSObject
{
    NSMutableDictionary *_componentClassesByName;
}

+(ComponentDirectory *) sharedDirectory;

-(void) registerComponentClass:(Class)componentClass forName:(NSString *)name;
-(Class) componentClassForName:(NSString *)name;

@end

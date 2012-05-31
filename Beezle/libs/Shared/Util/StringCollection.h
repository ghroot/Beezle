//
//  StringCollection.h
//  Beezle
//
//  Created by Marcus on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface StringCollection : NSObject
{
    NSMutableArray *_strings;
}

@property (nonatomic, readonly) NSArray *strings;

-(id) initFromDictionary:(NSDictionary *)dict baseName:(NSString *)baseName;
-(void) addStringsFromDictionary:(NSDictionary *)dict baseName:(NSString *)baseName;
-(void) addString:(NSString *)string;
-(BOOL) hasStrings;
-(NSString *) randomString;

@end

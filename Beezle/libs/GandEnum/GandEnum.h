//
//  GandEnum.h
//
//  Created by glenn andreas on 2/17/10.
//  Copyright 2010 glenn andreas. .
//
//All rights reserved.
//
//Redistribution and use in source and binary forms, with or without
//modification, are permitted provided that the following conditions are met:
//* Redistributions of source code must retain the above copyright
//notice, this list of conditions and the following disclaimer.
//* Redistributions in binary form must reproduce the above copyright
//notice, this list of conditions and the following disclaimer in the
//documentation and/or other materials provided with the distribution.
//* Neither the name of the <organization> nor the
//names of its contributors may be used to endorse or promote products
//derived from this software without specific prior written permission.
//
//THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
//DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <Foundation/Foundation.h>

@interface GandEnum : NSObject<NSCopying, NSCoding> {
    NSString *name;
    int ordinal;
    NSDictionary *properties;
    // cached to speed up prev/next - these are all "assign", not that it matters because they are all singletons 
    id previousWrappingEnum;
    id nextWrappingEnum;
    BOOL isFirstEnum, isLastEnum, isCacheValid;
}
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) int ordinal;
+ (id) enumFromName: (NSString *) name;
+ (id) enumFromOrdinal: (int) ordinal;
+ (NSArray *) allEnums;
// note the use of id make these no longer type safe
+ (id) firstEnum;
+ (id) lastEnum;
@property (nonatomic, readonly) id previousEnum;
@property (nonatomic, readonly) id nextEnum;
@property (nonatomic, readonly) id previousWrappingEnum;
@property (nonatomic, readonly) id nextWrappingEnum;
- (id) deltaEnum: (NSInteger) delta wrapping: (BOOL) wrapping;
// this should only be called from with the enum declaration methods
- (id) initWithName: (NSString *) name ordinal: (int) ordinal properties: (NSDictionary *) properties;
+ (void) invalidateEnumCache; // if you've done dynamic code loading and added an enum through a category, call this for each enum class modified
@end

// Macro to declare the enum implementation.  The name and ordinal value are the first two parameters, what follows is then a list of objects and keys for additional properties
// This list is used for +[NSDictionary  dictionaryWithObjectsAndKeys:]  - note that you do not need to specify a nil at the end (it is added automatically)
// These properties will be dynamically generated.  Currently, properties are restricted to objects, classes, SEL (encoded as strings), and scalar values.  
// Generic pointers (include c-strings) should be enocded via [NSValue valueWithPointer: ptr]
// Under UIKit, we also support CGPoint, CGSize, and CGRect (encoded as NSValue *)
// Under AppKit, we also support NSPoint, NSSize and NSRect (encoded as NSValue *)
// For now, encode all other structs as NSValues and make the property be of type NSValue *, or explicitly implement the property yourself
#define GANDENUM(ename, evalue, eproperties...) \
+ (id) ename { \
static id retval = nil; \
if (retval == nil) { \
retval = [[self alloc] initWithName: @ #ename ordinal: evalue properties: [NSDictionary dictionaryWithObjectsAndKeys: eproperties, nil]]; \
}\
return retval;\
}

#if 0
/* So, for example: */
@interface Color : GandEnum
+ (Color *) RED;
+ (Color *) GREEN;
+ (Color *) BLUE;
@property (nonatomic, readonly) float hue;
@end

// ...


@implementation Color
@dynamic hue;
GANDENUM(RED, 0, [NSNumber numberWithFloat: 0.0], @"hue")
GANDENUM(GREEN, 1, [NSNumber numberWithFloat: 1./3.], @"hue")
GANDENUM(BLUE, 2, [NSNumber numberWithFloat: 2./3.], @"hue")
@end

void test()
{
    for (Color *c = Color.firstEnum; c != nil; c = c.nextEnum) {
	NSLog(@"Color: %@", c);
	if (c == Color.GREEN) {
	    NSLog(@"This is green, hue = %g", c.hue);
	}
    }
}
#endif

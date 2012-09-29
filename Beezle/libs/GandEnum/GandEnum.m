//
//  GandEnum.m
//  Mapad
//
//  Created by glenn andreas on 2/18/10.
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


#import "GandEnum.h"
#import <objc/runtime.h>


@implementation GandEnum
@synthesize name, ordinal;
- (void) dealloc
{
    [name release];
    [super dealloc];
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:properties forKey:@"properties"];
    [aCoder encodeInt:ordinal forKey:@"ordinal"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
	// see if the enum name exists - it should
	NSString *ename = [aDecoder decodeObjectForKey:@"name"];
	SEL sel = NSSelectorFromString(ename);
	id cls = [self class];
	if ([cls respondsToSelector:sel]) {
	    [self release];
	    return [cls performSelector:sel];
	}
	// no enum for this name, so treat as normal, which is the best we can hope for currently
	name = [ename retain];
	properties = [[aDecoder decodeObjectForKey:@"properties"] retain];
	ordinal = [aDecoder decodeIntForKey:@"ordinal"];
    }
    return self;
}

- (id) initWithName: (NSString *) aname ordinal: (int) anordinal properties: (NSDictionary *) aproperties
{
    self = [super init];
    if (self) {
	name = [aname retain];
	ordinal = anordinal;
	properties = [aproperties retain];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone;
{
    // we're immutable, just retain ourselves again
    return [self retain];
}
+ (id) enumFromName: (NSString *) nam
{
    SEL sel = NSSelectorFromString(nam);
    if ([self respondsToSelector: sel]) {
	return [self performSelector: sel];
    }
    return nil;
}
+ (id) enumFromOrdinal: (int) ordinal
{
    // find first enum that has the corresponding ordinal
    for (GandEnum *retval in [self allEnums]) {
	if (retval.ordinal == ordinal)
	    return retval;
    }
    return nil;
}

- (NSString *) description
{
    return name;
}
- (NSString *) debugDescription
{
    if ([properties count]) {
	return [NSString stringWithFormat: @"<%@:%@ %@=%d %@>",NSStringFromClass([self class]), self, name, ordinal, properties];
    } else {
	return [NSString stringWithFormat: @"<%@:%@ %@=%d>",NSStringFromClass([self class]), self, name, ordinal];
    }
}
- (NSUInteger) hash
{
    return [name hash]; // use the hash of the string, that way "if two objects are
    // equal (as determined by the isEqual: method) they must have the same hash value"
}
- (BOOL) isEqual: (id) other
{
    if (other == self) return YES;
    if ([other isKindOfClass:[self class]] || [self isKindOfClass:[other class]]) {
	return [name isEqual: [other name]];
    } else {
	return NO;
    }
}

#pragma mark Accessing
static NSInteger sortByOrdinal(id left, id right, void *ctx)
{
    return [left ordinal] - [right ordinal];
}
static NSMutableDictionary *gAllEnums = nil;
+ (NSArray *) allEnums
{
    // use the class as a key for what enum list we want - it's expensive to build on the fly
    if (!gAllEnums) {
	gAllEnums = [[NSMutableDictionary dictionary] retain];
    }
    NSMutableArray *retval = [gAllEnums objectForKey:self]; 
    if (retval)
	return retval;
    retval = [NSMutableArray array];
    [gAllEnums setObject:retval forKey:(id)self];
    // walk the class methods 
    unsigned int methodCount = 0;
    Method *mlist = class_copyMethodList(object_getClass(self), &methodCount);
    for (unsigned int i=0;i<methodCount;i++) {
	NSString *mname = NSStringFromSelector(method_getName(mlist[i]));
	if ([[mname uppercaseString] isEqualToString:mname]) { // entirely in uppercase, it's an enum
	    [retval addObject:[self performSelector: method_getName(mlist[i])]]; // call it to retrieve the singleton
	}
    }
    if ([retval count]) { // there may be no enums yet
	[retval sortUsingFunction:sortByOrdinal context:nil];
	// set up the next/prev cached variables
	GandEnum *last = [retval lastObject];
	last->isLastEnum = YES;
	((GandEnum *)[retval objectAtIndex:0])->isFirstEnum = YES;
	for (GandEnum *e in retval) {
	    e->previousWrappingEnum = last;
	    last->nextWrappingEnum = e;
	    e->isCacheValid = YES;
	    last = e;
	}
    }
    free(mlist);
    return retval;
}
+ (void) invalidateEnumCache // if you've done dynamic code loading and added an enum through a category, call this
{
    for (GandEnum *e in [gAllEnums objectForKey:self]) {
	e->isCacheValid = NO;
    }
    [gAllEnums removeObjectForKey:self];
}
// note the use of id make these no longer type safe
+ (id) firstEnum
{
    NSArray *allEnums = [self allEnums];
    if ([allEnums count])
	return [[self allEnums] objectAtIndex:0];
    return nil;
}
+ (id) lastEnum
{
    return [[self allEnums] lastObject];
}
- (id) previousEnum
{
    if (!isCacheValid) { [[self class] allEnums]; } // update cache
    return isFirstEnum ? nil : previousWrappingEnum;
}
- (id) nextEnum
{
    if (!isCacheValid) { [[self class] allEnums]; } // update cache
    return isLastEnum ? nil : nextWrappingEnum;
}
- (id) previousWrappingEnum
{
    if (!isCacheValid) { [[self class] allEnums]; } // update cache
    return previousWrappingEnum;
}
- (id) nextWrappingEnum
{
    if (!isCacheValid) { [[self class] allEnums]; } // update cache
    return nextWrappingEnum;
}
- (id) deltaEnum: (NSInteger) delta wrapping: (BOOL) wrapping
{
    NSArray *allEnums = [[self class] allEnums];
    NSInteger index = [allEnums indexOfObject:self];
//    NSAssert1(index != NSNotFound, @"%@ does not exist in own classes list of enums", self);
    if (index == NSNotFound)
	return nil;
    index += delta;
    int count = [allEnums count];
    if (wrapping) {
	while (index < 0)
	    index += count;
	while (index >= count)
	    index -= count;
    } else {
	if (index <0 || index >= count)
	    return nil;
    }
    return [allEnums objectAtIndex:index];
}

#pragma mark dynamic ivar support
- (id)valueForUndefinedKey:(NSString *)key
{
    return [properties objectForKey:key];
}

// to speed this code up, should create a map from SEL to NSString mapping selectors to their keys.

// converts a getter selector to an NSString, equivalent to NSStringFromSelector().
NS_INLINE NSString *getterKey(SEL sel) {
    return [NSString stringWithUTF8String:sel_getName(sel)];
}

// Generic accessor methods for property types id, double, and NSRect.

static id getProperty(GandEnum *self, SEL name) {
    return [self->properties objectForKey:getterKey(name)];
}
static SEL getSelProperty(GandEnum *self, SEL name) {
    return NSSelectorFromString([self->properties objectForKey:getterKey(name)]);
}
#define TYPEDGETTER(type,Type,typeValue) \
static type get ## Type ## Property(GandEnum *self, SEL name) {\
    return [[self->properties objectForKey:getterKey(name)] typeValue];\
}
TYPEDGETTER(double, Double, doubleValue)
TYPEDGETTER(float, Float, floatValue)
TYPEDGETTER(char, Char, charValue)
TYPEDGETTER(unsigned char, UnsignedChar, unsignedCharValue)
TYPEDGETTER(short, Short, shortValue)
TYPEDGETTER(unsigned short, UnsignedShort, unsignedShortValue)
TYPEDGETTER(int, Int, intValue)
TYPEDGETTER(unsigned int, UnsignedInt, unsignedIntValue)
TYPEDGETTER(long, Long, longValue)
TYPEDGETTER(unsigned long, UnsignedLong, unsignedLongValue)
TYPEDGETTER(long long, LongLong, longLongValue)
TYPEDGETTER(unsigned long long, UnsignedLongLong, unsignedLongLongValue)
TYPEDGETTER(BOOL, Bool, boolValue)
TYPEDGETTER(void *, Pointer, pointerValue)
#ifdef UIKIT_EXTERN
static CGRect getCGRectProperty(GandEnum *self, SEL name) {
    return [[self->properties objectForKey:getterKey(name)] CGRectValue];
}
static CGPoint getCGPointProperty(GandEnum *self, SEL name) {
    return [[self->properties objectForKey:getterKey(name)] CGPointValue];
}
static CGSize getCGSizeProperty(GandEnum *self, SEL name) {
    return [[self->properties objectForKey:getterKey(name)] CGSizeValue];
}
#endif
#ifdef NSKIT_EXTERN
static NSRect getNSRectProperty(GandEnum *self, SEL name) {
    return [[self->properties objectForKey:getterKey(name)] rectValue];
}
static NSPoint getNSPointProperty(GandEnum *self, SEL name) {
    return [[self->properties objectForKey:getterKey(name)] pointValue];
}
static NSSize getNSSizeProperty(GandEnum *self, SEL name) {
    return [[self->properties objectForKey:getterKey(name)] sizeValue];
}
#endif

static const char* getPropertyType(objc_property_t property) {
    // parse the property attribues. this is a comma delimited string. the type of the attribute starts with the
    // character 'T' should really just use strsep for this, using a C99 variable sized array.
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T') {
            // return a pointer scoped to the autorelease pool. Under GC, this will be a separate block.
            return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute)] bytes];
        }
    }
    return "@";
}

static BOOL getPropertyInfo(Class cls, NSString *propertyName, Class *propertyClass, const char* *propertyType) {
    const char *name = [propertyName UTF8String];
    while (cls != NULL) {
        objc_property_t property = class_getProperty(cls, name);
        if (property) {
            *propertyClass = cls;
            *propertyType = getPropertyType(property);
            return YES;
        }
        cls = class_getSuperclass(cls);
    }
    return NO;
}

+ (BOOL)resolveInstanceMethod:(SEL)name {
    Class propertyClass;
    const char *propertyType;
    IMP accessor = NULL;
    const char *signature = NULL;
    // TODO:  handle more property types.
    if (strncmp("set", sel_getName(name), 3) == 0) {
        // choose an appropriately typed generic setter function. - we have no setters, enum properties are read only
    } else {
        // choose an appropriately typed getter function.
        if (getPropertyInfo(self, getterKey(name), &propertyClass, &propertyType)) {
            switch (propertyType[0]) {
		case _C_ID:
		    accessor = (IMP)getProperty, signature = "@@:"; break;
		case _C_CLASS:
		    accessor = (IMP)getProperty, signature = "#@:"; break;
		case _C_CHR:
		    accessor = (IMP)getCharProperty, signature = "c@:"; break;
		case _C_UCHR:
		    accessor = (IMP)getUnsignedCharProperty, signature = "C@:"; break;
		case _C_SHT:
		    accessor = (IMP)getShortProperty, signature = "s@:"; break;
		case _C_USHT:
		    accessor = (IMP)getUnsignedShortProperty, signature = "S@:"; break;
		case _C_INT:
		    accessor = (IMP)getIntProperty, signature = "i@:"; break;
		case _C_UINT:
		    accessor = (IMP)getUnsignedIntProperty, signature = "I@:"; break;
		case _C_LNG:
		    accessor = (IMP)getLongProperty, signature = "l@:"; break;
		case _C_ULNG:
		    accessor = (IMP)getUnsignedLongProperty, signature = "L@:"; break;
		case _C_LNG_LNG:
		    accessor = (IMP)getLongLongProperty, signature = "q@:"; break;
		case _C_ULNG_LNG:
		    accessor = (IMP)getUnsignedLongLongProperty, signature = "Q@:"; break;
		case _C_BOOL:
		    accessor = (IMP)getBoolProperty, signature = "B@:"; break;
		case _C_DBL:
		    accessor = (IMP)getDoubleProperty, signature = "d@:"; break;
		case _C_FLT:
		    accessor = (IMP)getFloatProperty, signature = "f@:"; break;
		case _C_PTR:
		    accessor = (IMP)getPointerProperty, signature = "^@:"; break;
		case _C_CHARPTR:
		    accessor = (IMP)getPointerProperty, signature = "*@:"; break;
		case _C_STRUCT_B:
#ifdef UIKIT_EXTERN
		    if (strncmp(propertyType, "{_CGRect=", 9) == 0)
			accessor = (IMP)getCGRectProperty, signature = "{_CGRect}@:";
		    if (strncmp(propertyType, "{_CGPoint=", 10) == 0)
			accessor = (IMP)getCGPointProperty, signature = "{_CGPoint}@:";
		    if (strncmp(propertyType, "{_CGSize=", 9) == 0)
			accessor = (IMP)getCGSizeProperty, signature = "{_CGSize}@:";
#endif
#ifdef NSKIT_EXTERN
		    if (strncmp(propertyType, "{_NSRect=", 9) == 0)
			accessor = (IMP)getNSRectProperty, signature = "{_NSRect}@:";
		    if (strncmp(propertyType, "{_NSPoint=", 10) == 0)
			accessor = (IMP)getNSPointProperty, signature = "{_NSPoint}@:";
		    if (strncmp(propertyType, "{_NSSize=", 9) == 0)
			accessor = (IMP)getNSSizeProperty, signature = "{_NSSize}@:";
#endif
		    break;
            }
        }
    }
    if (accessor && signature) {
        class_addMethod(propertyClass, name, accessor, signature);
        return YES;
    }
    return NO;
}

@end


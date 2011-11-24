/**
* Based on Artemis Entity System Framework
* 
* Copyright 2011 GAMADU.COM. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
*    1. Redistributions of source code must retain the above copyright notice, this list of
*       conditions and the following disclaimer.
* 
*    2. Redistributions in binary form must reproduce the above copyright notice, this list
*       of conditions and the following disclaimer in the documentation and/or other materials
*       provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY GAMADU.COM ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL GAMADU.COM OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* 
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of GAMADU.COM.
*/

#import "EntitySystem.h"
#import "Component.h"
#import "Entity.h"

@implementation EntitySystem

@synthesize world = _world;

-(id) initWithUsedComponentClasses:(NSArray *)usedComponentClasses
{
    if (self = [super init])
    {
        _usedComponentClasses = [usedComponentClasses retain];
        _entities = [[NSMutableArray alloc] init];
    }
    return self;
}

-(id) init
{
    return [self initWithUsedComponentClasses:[NSArray array]];
}

-(void) dealloc
{
    [_usedComponentClasses release];
    [_entities release];
    
    [super dealloc];
}

-(void) begin
{
}

-(void) process
{
    if ([self checkProcessing])
    {
        [self begin];
        [self processEntities:_entities];
        [self end];
    }
}

-(void) end
{
}

-(void) processEntities:(NSArray *)entities
{
}

-(BOOL) checkProcessing
{
    return TRUE;
}

-(void) initialise
{
}

-(void) entityAdded:(Entity *)entity
{
}

-(void) entityRemoved:(Entity *)entity
{
}

-(void) entityChanged:(Entity *)entity
{
    BOOL hasAllUsedComponents = TRUE;
    for (Class usedComponentClass in _usedComponentClasses)
    {
        Component *component = [entity getComponent:usedComponentClass];
        if (component == nil || ![component enabled])
        {
            hasAllUsedComponents = FALSE;
            break;
        }
    }
    
    if ([_entities containsObject:entity] && (!hasAllUsedComponents || [entity deleted]))
    {
        [self removeEntity:entity];
    }
    else if (![_entities containsObject:entity] && hasAllUsedComponents)
    {
        [_entities addObject:entity];
        [self entityAdded:entity];
    }
}

-(void) removeEntity:(Entity *)entity
{
    [_entities removeObject:entity];
    [self entityRemoved:entity];
}

-(BOOL) hasEntity:(Entity *)entity
{
    return [_entities containsObject:entity];
}

@end

#import "Bag.h"

@implementation Bag

-(id) init
{
	return [self initWithCapacity:16];
}

-(id) initWithCapacity:(int)capacity
{
	if (self = [super init])
	{
		_data = [[NSMutableArray alloc] initWithCapacity:capacity];
		_size = 0;
	}
	return self;
}

-(void) dealloc
{
	[_data release];

	[super dealloc];
}

-(id) removeAtIndex:(int)index
{
	id o = [_data objectAtIndex:index];
	[_data replaceObjectAtIndex:index withObject:[_data objectAtIndex:--_size]];
	[_data removeObjectAtIndex:_size];
	return o;
}

-(id) removeLast
{
	if (_size > 0)
	{
		id o = [_data objectAtIndex:--_size];
		[_data removeObjectAtIndex:_size];
		return o;
	}
	return nil;
}

-(BOOL) remove:(id)o
{
	for (int i = 0; i < _size; i++)
	{
		id o1 = [_data objectAtIndex:i];
		if (o == o1)
		{
			[_data replaceObjectAtIndex:i withObject:[_data objectAtIndex:--_size]];
			[_data removeObjectAtIndex:_size];
			return TRUE;
		}
	}
	return FALSE;
}

-(BOOL) contains:(id)o
{
	for (int i = 0; i < _size; i++)
	{
		if (o == [_data objectAtIndex:i])
		{
			return TRUE;
		}
	}
	return FALSE;
}

-(BOOL) removeAll:(Bag *)bag
{
	BOOL modified = FALSE;
	for (int i = 0; i < [bag size]; i++)
	{
		id o1 = [bag get:i];
		for (int j = 0; j < _size; j++)
		{
			id o2 = [_data objectAtIndex:j];
			if (o1 == o2)
			{
				[self removeAtIndex:j];
				j--;
				modified = TRUE;
				break;
			}
		}
	}
	return modified;
}

-(id) get:(int)index
{
	return [_data objectAtIndex:index];
}

-(int) size
{
	return _size;
}

-(int) getCapacity
{
	return [_data count];
}

-(BOOL) isEmpty
{
	return _size == 0;
}

-(void) add:(id)o
{
	if (_size == [_data count])
	{
		[self grow];
	}
	[_data replaceObjectAtIndex:_size++ withObject:o];
}

-(void) set:(id)o atIndex:(int)index
{
	if (index >= [_data count])
	{
		[self growTo:index * 2];
	}
	_size = index + 1;
	[_data replaceObjectAtIndex:index withObject:o];
}

-(void) grow
{
	int newCapacity = ([_data count] * 3) / 2 + 1;
	[self growTo:newCapacity];
}

-(void) growTo:(int)newCapacity
{
	NSMutableArray *oldData = _data;
	[_data release];
	_data = [[NSMutableArray alloc] initWithCapacity:newCapacity];
	[_data addObjectsFromArray:oldData];
}

-(void) clear
{
	for (int i = 0; i < _size; i++)
	{
		[_data removeObjectAtIndex:i];
	}
	_size = 0;
}

-(void) addAll:(Bag *)bag
{
	for (int i = 0; i < [bag size]; i++)
	{
		[self add:[bag get:i]];
	}
}

@end
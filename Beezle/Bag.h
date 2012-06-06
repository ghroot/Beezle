@interface Bag : NSObject
{
	NSMutableArray *_data;
	int _size;
}

-(id) initWithCapacity:(int)capacity;

-(id) removeAtIndex:(int)index;
-(id) removeLast;
-(BOOL) remove:(id)o;
-(BOOL) contains:(id)o;
-(BOOL) removeAll:(Bag *)bag;
-(id) get:(int)index;
-(int) size;
-(int) getCapacity;
-(BOOL) isEmpty;
-(void) add:(id)o;
-(void) set:(id)o atIndex:(int)index;
-(void) grow;
-(void) growTo:(int)newCapacity;
-(void) clear;
-(void) addAll:(Bag *)bag;

@end
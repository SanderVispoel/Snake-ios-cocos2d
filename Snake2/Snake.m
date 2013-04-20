//
//  Snake.m
//  Snake2
//
//  Created by Sander Vispoel on 4/8/13.
//
//

#import "cocos2d.h"
#import "Snake.h"

@implementation Snake

@synthesize directionFlag=_directionFlag, arrayDirectionFlags=_arrayDirectionFlags, arrayChangePoint=_arrayChangePoint;

-(void)dealloc
{
    [[self arrayChangePoint] removeAllObjects];
    [[self arrayDirectionFlags] removeAllObjects];

    [super dealloc];
}

-(id)init
{
    if((self=[super init])) {
        
        // default
        _directionFlag = MOVE_RIGHT;
        
        _arrayDirectionFlags = [[NSMutableArray alloc] init];
        _arrayChangePoint = [[NSMutableArray alloc] init];
        
        [self initWithFile:@"dot.png"];
    }
    
    return self;
}

#pragma mark - DirectionFlag

-(void)addDirectionFlag:(int)flag
{
    [_arrayDirectionFlags addObject:[NSNumber numberWithInt:flag]];
}

-(void)removeDirectionFlagAtIndex:(int)i
{
    [_arrayDirectionFlags removeObjectAtIndex:i];
}

-(int)getDirectionFlagAtIndex:(int)i
{
    return [[_arrayDirectionFlags objectAtIndex:i] integerValue];
}

-(int)getDirectionFlagsCount
{
    return [_arrayDirectionFlags count];
}

#pragma mark - ChangePoint

-(void)addChangePoint:(CGPoint)point
{
    [_arrayChangePoint addObject:[NSNumber valueWithCGPoint:point]];
}

-(void)removeChangePointAtIndex:(int)i
{
    [_arrayChangePoint removeObjectAtIndex:i];
}

-(CGPoint)getChangePointAtIndex:(int)i
{
    return [[_arrayChangePoint objectAtIndex:i] CGPointValue];
}

-(int)getChangePointsCount
{
    return [_arrayChangePoint count];
}

@end

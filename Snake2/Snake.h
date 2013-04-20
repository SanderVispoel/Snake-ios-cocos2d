//
//  Snake.h
//  Snake2
//
//  Created by Sander Vispoel on 4/8/13.
//
//

#import "CCSprite.h"

#define SNAKE_WIDTH     8.0
#define SNAKE_HEIGHT    8.0

#define MOVE_RIGHT      1
#define MOVE_LEFT       3
#define MOVE_UP         2
#define MOVE_DOWN       4


@interface Snake : CCSprite
{
    int _directionFlag;                     // welke kant het deel op moet bewegen
    
    NSMutableArray *_arrayChangePoint;
    NSMutableArray *_arrayDirectionFlags;
}

@property (nonatomic, assign) int directionFlag;
@property (assign) NSMutableArray *arrayDirectionFlags;
@property (assign) NSMutableArray *arrayChangePoint;

// direction flag
-(void)addDirectionFlag:(int)flag;
-(void)removeDirectionFlagAtIndex:(int)i;
-(int)getDirectionFlagAtIndex:(int)i;
-(int)getDirectionFlagsCount;

// change point
-(void)addChangePoint:(CGPoint)point;
-(void)removeChangePointAtIndex:(int)i;
-(CGPoint)getChangePointAtIndex:(int)i;
-(int)getChangePointsCount;

@end

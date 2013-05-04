//
//  GameBoard.m
//  Snake2
//
//  Created by Sander Vispoel on 4/8/13.
//
//

#import "cocos2d.h"

#import "InterfaceLayer.h"
#import "GameOverLayer.h"
#import "GameBoard.h"
#import "Snake.h"

#define WALL_RIGHT      472.0
#define WALL_LEFT       4.0
#define WALL_TOP        312.0
#define WALL_BOTTOM     80.0

#define FIELD_WIDTH     472
#define FIELD_HEIGHT    240

#define COLLISION_WALL  1
#define COLLISION_CANDY 2

#define HEAD_TAG        1

@interface GameBoard()
{
    // save snake tails in this CCNode
    CCNode *_snakeParts;
    
    // save candy in a CCSprite
    CCSprite *_candy;
    
    // score handling
    InterfaceLayer *_interface;
    
    NSMutableArray *_fieldOpen;
    NSMutableArray *_fieldTaken;
}

@end

@implementation GameBoard

@synthesize maxPartTag=_maxPartTag, dpad=_dpad;

#pragma mark - deallocs

-(void)dealloc
{
    [_fieldOpen release];
    _fieldOpen = nil;
    [_fieldTaken release];
    _fieldTaken = nil;
    
    [self unscheduleAllSelectors];
    [self stopAllActions];
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    
    [super dealloc];
}

-(void)onExit
{   
    [_snakeParts removeAllChildrenWithCleanup:YES];
    [_candy removeAllChildrenWithCleanup:YES];
    
    [super onExit];
}

#pragma mark - initializers

-(id)init
{
    if((self=[super init])) {
        
        // snake ccnode
        _snakeParts = [CCNode node];
        [self addChild:_snakeParts];
        
        // candy sprite
        _candy = [[CCSprite alloc] initWithFile:@"candy.png"];
        [self addChild:_candy];
        
        // score
        _interface = [[InterfaceLayer alloc] init];
        [_interface setPlayerScorePositionX:64.0 Y:32.0];
        [self addChild:_interface];
        
        // dpad sprite
        _dpad = [[CCSprite alloc] initWithFile:@"d-pad.png"];
        _dpad.position = ccp( (480 - (64/2)) - 8, (64/2) ); // screen height - dpad's height(also width) divided by 2, - 8px correction.
        _dpad.tag = 1;
        [self addChild:_dpad];
        
        // saves open and taken field spots
        _fieldOpen = [[NSMutableArray alloc] init];
        _fieldTaken = [[NSMutableArray alloc] init];
        
        // fill with entire field
        for (int x = 8; x <= FIELD_WIDTH; x += 8) {
            
            for (int y = 80; y <= FIELD_HEIGHT; y += 8) {
                [_fieldOpen addObject:[NSValue valueWithCGPoint:ccp(x,y)]];
            }
        }
        
        NSLog(@" << open field spots: %u >> ", [_fieldOpen count]);
        
        // save last tag
        _maxPartTag = 0;
        
        // enable touch
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self
                                                                  priority:1
                                                           swallowsTouches:YES];
    }
    
    return self;
}

-(void)onEnter
{
    [super onEnter];
    
    // start game
    [self startGame];
}

-(void)startGame
{
    // game restart
    if ([[_snakeParts children] count] > 0) {
        
        _maxPartTag = 0;
        [_interface setPlayerScore:0];
        
        [_interface setPlayerScorePositionX:64 Y:32];
    }
    
    [self setupSnake];
    [self placeCandy];
    
    [self schedule:@selector(gameTick:) interval:0.1];
}

-(void)gameOver
{
    // TODO show Menu
    
    // stop Game
    [self unscheduleAllSelectors];
    [self stopAllActions];
    
    CCScene *gameOverScene = [GameOverLayer sceneGameOver:_interface];
    [[CCDirector sharedDirector] replaceScene:gameOverScene];
}

#pragma mark - world stuff

-(void)removeFromFieldOpen:(Snake *)snake
{
    for (NSValue *value in _fieldOpen) {
        CGPoint pos = [value CGPointValue];
        
        if (CGPointEqualToPoint(pos, snake.position)){
            [_fieldOpen removeObject:value];
            break;  // stop enumerating to prevent crash
        }
    }
}

-(void)addToFieldTaken:(Snake *)snake
{
    CGPoint pos = snake.position;
    
    [_fieldTaken addObject:[NSValue valueWithCGPoint:pos]];
}

#pragma mark - Snake Stuff

-(void)setupSnake
{
    for (int i = 0; i < 8; i++) {
        
        [self addSnakePartToField];
    }
}

-(void)addSnakePartToField
{
    // create new part
    Snake *new = [[Snake alloc] init];
    
    // add to our CCNode
    [_snakeParts addChild:new];
    
    // give tag
    new.tag = _maxPartTag+1;
    _maxPartTag = new.tag;
    
    // put first part (head) on the field and stop.
    if (new.tag == HEAD_TAG) {
        new.position = ccp(64, 96); // bottom left
        return;
    }
    
    CGFloat x;
    CGFloat y;
    
    for (Snake *tail in [_snakeParts children]) {
        
        // we only need the part made before the new one
        if (tail.tag != (new.tag - 1))
            continue;
        
        // check direction
        // from that we decide where we can place our new part
        switch (tail.directionFlag) {
            case MOVE_RIGHT:
                x = tail.position.x - SNAKE_WIDTH;
                y = tail.position.y;
                break;
                
            case MOVE_LEFT:
                x = tail.position.x + SNAKE_WIDTH;
                y = tail.position.y;
                break;
            
            case MOVE_UP:
                x = tail.position.x;
                y = tail.position.y - SNAKE_HEIGHT;
                break;
                
            case MOVE_DOWN:
                x = tail.position.x;
                y = tail.position.y + SNAKE_HEIGHT;
                break;
                
            default:
                break;
        }
        
        // give him the current directionFlag of the last part
        new.directionFlag = tail.directionFlag;
        
        // inherit arrays
        // directionFlag and changePoint arrays are parallel
        for (int i = 0; i < [tail getDirectionFlagsCount]; i++) {
            
            // directionFlag
            [new addDirectionFlag:[tail getDirectionFlagAtIndex:i]];
            
            // same for changePoint
            [new addChangePoint:[tail getChangePointAtIndex:i]];
        }
    }
    
    // and finally, place in field
    new.position = ccp(x,y);
}

-(void)placeCandy
{
    int randPos = 0;
    
    // first add taken spots back to open
    for (NSValue *value in _fieldTaken) {
        [_fieldOpen addObject:value];
    }
    
    // then remove all taken spots
    [_fieldTaken removeAllObjects];
    
    // as last, fill new taken spots
    for (Snake *s in [_snakeParts children]) {
        [self addToFieldTaken:s];
        [self removeFromFieldOpen:s];
    }
    
    NSLog(@"<< open: %u, taken: %u >>", [_fieldOpen count], [_fieldTaken count]);
    
    // now we can determine our candy's location
    
    // random through OpenField array
    randPos = arc4random() % [_fieldOpen count];
    
    // give new position
    _candy.position = [[_fieldOpen objectAtIndex:randPos] CGPointValue];
}


-(void)changeDirectionPoint:(int)directionFlag coords:(CGPoint)coords from:(Snake *)head
{
    // only need information of the head piece
    // information for the head is changed in this method
    // other parts get it done at gameTick:
    
    
    // add 'directionFlag' and 'changePoint' to our CCNode children
    for (Snake *s in [_snakeParts children]) {
        
        // don't need to add anything to head piece, it's controlled directly by us
        if (s.tag == HEAD_TAG)
            continue;
        
        [s addDirectionFlag:directionFlag];
        [s addChangePoint:coords];
    }
    
    // instantly change 'directionFlag' for our head
    head.directionFlag = directionFlag;
}


-(int)collisionCheck:(CGPoint)pos DirectionFlag:(int)flag For:(Snake *)head
{
    CGFloat candyX = _candy.position.x;
    CGFloat candyY = _candy.position.y;
    
    // snake tail
    CGFloat tailX;
    CGFloat tailY;
    
    int hasCollided = 0;
    
    // look through all snake parts (not very efficient?)
    for (Snake *s in [_snakeParts children]) {
        
        // skip head, can't collide with itself
        if (s.tag == head.tag)
            continue;
        
        // snake tail coords
        tailX = s.position.x;
        tailY = s.position.y;
        
        CGFloat nextX;
        CGFloat nextY;

        // look what direction we are heading
        // decide if the next step is valid
        switch (flag) {
            case MOVE_RIGHT:
            {
                nextX = pos.x + SNAKE_WIDTH;
                nextY = pos.y;
                
                if (nextX > WALL_RIGHT) {
                    hasCollided = true;
                }
 
            }break;
                
            case MOVE_LEFT:
            {
                nextX = pos.x - SNAKE_WIDTH;
                nextY = pos.y;

                if (nextX < WALL_LEFT) {
                    hasCollided = true;
                }
 
            }break;
                
            case MOVE_UP:
            {
                nextX = pos.x;
                nextY = pos.y + SNAKE_HEIGHT;

                if (nextY > WALL_TOP) {
                    hasCollided = true;
                }
 
            }break;
                
            case MOVE_DOWN:
            {
                nextX = pos.x;
                nextY = pos.y - SNAKE_HEIGHT;

                if (nextY < WALL_BOTTOM) {
                    hasCollided = true;
                }
 
            }break;
                
            default:
                break;
        }
        
        // wall check
        if (nextX == tailX && nextY == tailY)
            hasCollided = COLLISION_WALL;

        if (nextX == candyX && nextY == candyY)
            hasCollided = COLLISION_CANDY;
    }
    
    return hasCollided;
}

-(void)gameTick:(ccTime)dt
{
    // check if anything is hit before iterating throught the snake
    Snake *head = (Snake *)[_snakeParts getChildByTag:HEAD_TAG];
    
    int colCheck = [self collisionCheck:head.position DirectionFlag:head.directionFlag For:head];
    if (colCheck == COLLISION_CANDY) {
        
        // update score
        [_interface addScore:10];
        
        // grow snake
        [self addSnakePartToField];
        [self placeCandy];
    } else if (colCheck == COLLISION_WALL) {
        
        // quit game
        [self gameOver];
        return;
    }
    
    for (Snake *s in [_snakeParts children]) {
        
        CGFloat x = s.position.x;
        CGFloat y = s.position.y;
        
        // Loop through the points, check coordinates.
        // if we are on one of the points, change directionFlag.
        for (int i = 0; i < [s getDirectionFlagsCount]; i++) {
            
            CGPoint changeDirectionXY = [s getChangePointAtIndex:i];
            
            if (s.position.x == changeDirectionXY.x &&
                s.position.y == changeDirectionXY.y) {
                
                // set directionFlag.
                // changePoint and directionFlag are parallel.
                s.directionFlag = [s getDirectionFlagAtIndex:i];
                
                // remove the used points
                [s removeDirectionFlagAtIndex:i];
                [s removeChangePointAtIndex:i];
                
                // we found a change point, stop here
                break;
            }
        }
        
        // directionFlag + movement
        switch (s.directionFlag) {
            case MOVE_RIGHT: {
                x += SNAKE_WIDTH;
                break;
            }
            case MOVE_LEFT: {
                x -= SNAKE_WIDTH;
                break;
            }
            case MOVE_UP: {
                y += SNAKE_HEIGHT;
                break;
            }
            case MOVE_DOWN: {
                y -= SNAKE_HEIGHT;
                break;
            }
            default:
                // MOVE_RIGHT
                x += SNAKE_WIDTH;
                break;
        }
    
        // set position
        s.position = ccp(x,y);
    }
}

#pragma mark - Touch Stuff

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    //    CGSize s = [[CCDirector sharedDirector] winSize];

    // are we touching the dpad? If not, quit
    CGRect dpadBox = _dpad.boundingBox;
    if (!CGRectContainsPoint(dpadBox, touchLocation)) {
        return YES;
    }

    // pak hoofd
    Snake *snakeHead;
    for (Snake *s in [_snakeParts children]) {
        if (s.tag == HEAD_TAG) {
            snakeHead = s;
            break;
        }
    }
    
    int dflag = MOVE_RIGHT;
    CGFloat tx = floor(touchLocation.x);
    CGFloat ty = floor(touchLocation.y);
    float dpad_midX = _dpad.position.x;
    float dpad_midY = _dpad.position.y;
    
    // dpad location
/*
    float dpad_minX = _dpad.position.x - dpadsize.size.width/2;
    float dpad_maxX = _dpad.position.x + dpadsize.size.width/2;
    float dpad_minY = _dpad.position.y - dpadsize.size.height/2;
    float dpad_maxY = _dpad.position.y + dpadsize.size.height/2;
*/
    
    // DPAD LOGIC
    
    if (ty >= dpad_midY) {
        if (tx >= dpad_midX) {
            // up / right
            
            if (snakeHead.directionFlag == MOVE_UP ||
                snakeHead.directionFlag == MOVE_DOWN) {
                dflag = MOVE_RIGHT;
            } else if (snakeHead.directionFlag == MOVE_LEFT ||
                       snakeHead.directionFlag == MOVE_RIGHT) {
                dflag = MOVE_UP;
            }
        } else if (tx <= dpad_midX) {
            // up / left
            
            if (snakeHead.directionFlag == MOVE_UP ||
                snakeHead.directionFlag == MOVE_DOWN) {
                dflag = MOVE_LEFT;
            } else if (snakeHead.directionFlag == MOVE_LEFT ||
                       snakeHead.directionFlag == MOVE_RIGHT) {
                dflag = MOVE_UP;
            }
        }
    } else if (ty <= dpad_midY) {
        if (tx >= dpad_midX) {
            // down / right
            
            if (snakeHead.directionFlag == MOVE_UP ||
                snakeHead.directionFlag == MOVE_DOWN) {
                dflag = MOVE_RIGHT;
            } else if (snakeHead.directionFlag == MOVE_LEFT ||
                       snakeHead.directionFlag == MOVE_RIGHT) {
                dflag = MOVE_DOWN;
            }
        } else if (tx <= dpad_midX) {
            // down / left
            
            if (snakeHead.directionFlag == MOVE_UP ||
                snakeHead.directionFlag == MOVE_DOWN) {
                dflag = MOVE_LEFT;
            } else if (snakeHead.directionFlag == MOVE_LEFT ||
                       snakeHead.directionFlag == MOVE_RIGHT) {
                dflag = MOVE_DOWN;
            }
        }
    }
  
    // give new information to head
    [self changeDirectionPoint:dflag coords:snakeHead.position from:snakeHead];
    
    return YES;
}

@end

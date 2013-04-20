//
//  GameBoard.h
//  Snake2
//
//  Created by Sander Vispoel on 4/8/13.
//
//
#import "cocos2d.h"
#import "CCLayer.h"
@class Snake;

@interface GameBoard : CCLayer
{
    int _maxPartTag;
    CCSprite *_dpad;
}

@property (nonatomic, assign) int maxPartTag;
@property (readonly) CCSprite *dpad;

// application
-(void)onEnter;
-(void)onExit;

// game
-(void)startGame;
-(void)gameOver;
-(void)setupSnake;
-(void)removeFromFieldOpen:(Snake *)snake;
-(void)addToFieldTaken:(Snake *)snake;
-(void)addSnakePartToField;
-(void)placeCandy;
-(void)changeDirectionPoint:(int)directionFlag coords:(CGPoint)coords from:(Snake *)head;
-(BOOL)collisionCheck:(CGPoint)pos DirectionFlag:(int)flag For:(Snake *)head;
-(void)gameTick:(ccTime)dt;

// touch
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;

@end

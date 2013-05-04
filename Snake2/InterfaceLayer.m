//
//  InterfaceLayer.m
//  Snake2
//
//  Created by Sander Vispoel on 4/14/13.
//
//
#import "cocos2d.h"

#import "InterfaceLayer.h"

@interface InterfaceLayer () {
    
    CCLabelTTF *_gameScore;
}

@end

@implementation InterfaceLayer

@synthesize playerScore=_playerScore;

-(id)init
{
    if((self=[super init])) {
        
        _gameScore = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Arial" fontSize:20];
        [self addChild:_gameScore];
        
        _gameScore.position = ccp(64,32);
        
        _playerScore = 0;
    }
    
    return self;
}

-(CCLabelTTF *)getPlayerScoreTxt
{
    return [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %i", _playerScore] fontName:@"Arial" fontSize:20];
}

-(void)setPlayerScore:(int)playerScore
{
    _playerScore = playerScore;
    [_gameScore setString:[NSString stringWithFormat:@"Score: %i", _playerScore]];

}

-(void)addScore:(int)value
{
    _playerScore += value;
    [_gameScore setString:[NSString stringWithFormat:@"Score: %i", _playerScore]];
}

-(void)setPlayerScorePositionX:(CGFloat)x Y:(CGFloat)y
{
    _gameScore.position = ccp(x,y);
}

@end

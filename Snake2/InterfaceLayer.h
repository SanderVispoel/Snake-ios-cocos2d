//
//  InterfaceLayer.h
//  Snake2
//
//  Created by Sander Vispoel on 4/14/13.
//
//

#import "CCLayer.h"

@interface InterfaceLayer : CCLayer
{
    int _playerScore;
}

@property (nonatomic, assign) int playerScore;

-(CCLabelTTF *)getPlayerScoreTxt;
-(void)addScore:(int)value;
-(void)setPlayerScorePositionX:(CGFloat)x Y:(CGFloat)y;

@end

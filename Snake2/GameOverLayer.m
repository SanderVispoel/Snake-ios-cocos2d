//
//  GameOverLayer.m
//  Snake2
//
//  Created by Sander Vispoel on 5/4/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameOverLayer.h"
//#import "GameBoard.h"
#import "GameScene.h"
#import "InterfaceLayer.h"


@implementation GameOverLayer

+(CCScene *)sceneGameOver:(InterfaceLayer *)interface
{
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [[[GameOverLayer alloc] initGameOver:interface] autorelease];
    
    [scene addChild:layer];
    
    return scene;
}

-(id) initGameOver:(InterfaceLayer *)interface
{
    
    if ((self = [super init])) {
        
        // show GAME OVER
        NSString *msg = @"GAME OVER";
        
        CGFloat posX = [[CCDirector sharedDirector] winSize].width/2;
        CGFloat posY = [[CCDirector sharedDirector] winSize].height/2+45;
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:msg
                                               fontName:@"Arial"
                                               fontSize:56];
        
        label.position = ccp(posX, posY);
        [self addChild:label];
        
        // put score below the GAME OVER text
        CCLabelTTF *score = [interface getPlayerScoreTxt];
        score.position = ccp(posX, posY - 35.0);
        [self addChild:score];
        
        [self runAction:
         [CCSequence actions:
          [CCDelayTime actionWithDuration:3],
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             [[CCDirector sharedDirector] replaceScene:[GameScene scene]];
         }],
          nil]];
    }
    
    return self;
}

@end

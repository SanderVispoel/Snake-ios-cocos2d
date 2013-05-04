//
//  GameScene.m
//  Snake2
//
//  Created by Sander Vispoel on 4/8/13.
//
//

#import "cocos2d.h"

#import "GameScene.h"
#import "InterfaceLayer.h"
#import "Background.h"
#import "GameBoard.h"

@implementation GameScene

@synthesize gameBoard=_gameBoard, background=_background;

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    
    // 'layer' is an autorelease object.
    GameScene *layer = [GameScene node];
    
    // add layer as a child to scene
    [scene addChild: layer];
    
    // return the scene
    return scene;
}

-(void)dealloc
{
    [_background removeAllChildrenWithCleanup:YES];
    [_gameBoard removeAllChildrenWithCleanup:YES];
    
    [super dealloc];
}

-(id)init
{
    if((self=[super init])) {
        
        // add background
        _background = [Background node];
        [self addChild:_background];
        
        // add world
        _gameBoard = [GameBoard node];
        [self addChild:_gameBoard];
        
    }
    
    return self;
}

@end

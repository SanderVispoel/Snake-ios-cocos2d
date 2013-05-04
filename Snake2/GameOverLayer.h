//
//  GameOverLayer.h
//  Snake2
//
//  Created by Sander Vispoel on 5/4/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class InterfaceLayer;

@interface GameOverLayer : CCLayer {
    
}

+(CCScene *)sceneGameOver:(InterfaceLayer *)interface;
-(id)initGameOver:(InterfaceLayer *)interface;

@end

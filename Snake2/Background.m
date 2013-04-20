//
//  Background.m
//  Snake2
//
//  Created by Sander Vispoel on 4/8/13.
//
//

#import "cocos2d.h"

#import "Background.h"

@implementation Background

-(id)init
{
    if ((self=[super init])) {
        
        // window size
        CGSize s = [[CCDirector sharedDirector] winSize];
        
        // background color
        CCSprite *bg = [CCLayerColor layerWithColor:ccc4(0.0, 0.0, 0.0, 0.0)
                                                       width:s.width
                                                      height:s.height];
        
        // border
        CCSprite *border_bottom = [[CCSprite alloc] initWithFile:@"border-bottom.png"];
        border_bottom.position = ccp(s.height/2, 72.0);
        
        CCSprite *border_top = [[CCSprite alloc] initWithFile:@"border-top.png"];
        border_top.position = ccp(s.height/2, 319.0);
        
        CCSprite *border_side_left = [[CCSprite alloc] initWithFile:@"border-side.png"];
        CCSprite *border_side_right = [[CCSprite alloc] initWithFile:@"border-side.png"];
        
        border_side_left.position  = ccp(1.0,          34.0 + s.width/2);
        border_side_right.position = ccp(s.height-0.9, 34.0 + s.width/2);
        
        [self addChild:bg];
        [self addChild:border_bottom];
        [self addChild:border_top];
        [self addChild:border_side_left];
        [self addChild:border_side_right];
    }

    return self;
}
@end

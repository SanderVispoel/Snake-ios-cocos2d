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

-(void)dealloc
{
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}

-(id)init
{
    if ((self=[super initWithColor:ccc4(0, 0, 0, 0)])) {
        
        //
    }

    return self;
}

-(void)onEnter
{
    // window size
    CGSize s = [[CCDirector sharedDirector] winSize];
    
    // border
    CCSprite *border_bottom = [[CCSprite alloc] initWithFile:@"border-bottom.png"];
    //        border_bottom.position = ccp(s.height/2, 72.0);
    border_bottom.position = ccp(s.width/2, 72.0);
    
    CCSprite *border_top = [[CCSprite alloc] initWithFile:@"border-top.png"];
    //        border_top.position = ccp(s.height/2, 319.0);
    border_top.position = ccp(s.width/2, 319.0);
    
    CCSprite *border_side_left = [[CCSprite alloc] initWithFile:@"border-side.png"];
    CCSprite *border_side_right = [[CCSprite alloc] initWithFile:@"border-side.png"];
    
    //        border_side_left.position  = ccp(1.0,          34.0 + s.width/2);
    border_side_left.position  = ccp(1.0,          34.0 + s.height/2);
    //        border_side_right.position = ccp(s.height-0.9, 34.0 + s.width/2);
    border_side_right.position = ccp(s.width-0.9, 34.0 + s.height/2);
    
    [self addChild:border_bottom];
    [self addChild:border_top];
    [self addChild:border_side_left];
    [self addChild:border_side_right];
}
@end

//
//  LoadingAnimation.h
//  Fifteen Puzzle
//
//  Created by Scott Bouloutian on 6/3/13.
//  Copyright 2013 Scott Bouloutian. All rights reserved.
//
//  Concept for loading animation credited to Hugo Giraudel:
//  http://tympanus.net/codrops/2012/11/14/creative-css-loading-animations/

#import <Foundation/Foundation.h>
#import "cocos2d.h"

const ccTime TIMES[4]={1.13,1.86,1.45,1.72};

@interface LoadingAnimation : CCNode {
    CCSprite *blue;
    CCSprite *red;
    CCSprite *yellow;
    CCSprite *green;
}
-(void)start;
-(void)stop;
@end

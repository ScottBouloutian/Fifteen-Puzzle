//
//  LoadingAnimation.m
//  Fifteen Puzzle
//
//  Created by Scott Bouloutian on 6/3/13.
//  Copyright 2013 Scott Bouloutian. All rights reserved.
//

#import "LoadingAnimation.h"


@implementation LoadingAnimation

-(void)start{
    int i=0;
    CCSprite *child;
    CCARRAY_FOREACH(self.children, child){
        [child stopAllActions];
        [child runAction:[CCFadeIn actionWithDuration:0.5]];
        [child runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:TIMES[i] angle:360]]];
        i++;
    }
}

-(void)stop{
    CCSprite *child;
    CCARRAY_FOREACH(self.children, child){
        [child stopAllActions];
        [child runAction:[CCFadeOut actionWithDuration:0.5]];
    }
}

@end


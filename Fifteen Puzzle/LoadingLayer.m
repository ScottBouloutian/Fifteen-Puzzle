//
//  LoadingLayer.m
//  Fifteen Puzzle
//
//  Created by Scott Bouloutian on 5/31/13.
//  Copyright 2013 Scott Bouloutian. All rights reserved.
//

#import "LoadingLayer.h"


@implementation LoadingLayer
-(void)doneTouched:(id)sender{
    [[CCDirector sharedDirector] popScene];
}
-(void)doneLoading{
    doneButton.visible=YES;
}
@end

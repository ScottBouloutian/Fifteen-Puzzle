//
//  PuzzleLayer.h
//  Fifteen Puzzle
//
//  Created by Scott Bouloutian on 3/10/13.
//  Copyright 2013 Scott Bouloutian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PuzzleEngine.h"
#import "CCControlButton.h"
#import "Tile.h"
#import "CCBReader.h"
#import "LoadingAnimation.h"

static const int SCRAMBLE_DEPTH=30;
@interface PuzzleLayer : CCLayer {
    CCControlButton *editButton;
    CCControlButton *scrambleButton;
    CCControlButton *solveButton;
    CCControlButton *resetButton;
    CCLayer *tileLayer;
    CCLabelTTF *statusLabel;
    PuzzleEngine *puzzle;
    Tile * selTile; //Stores the currently selected tile in edit mode
    bool inEditMode;
    bool isMoving;
    CGPoint positions[16];
    NSOperationQueue *queue;
    CCSprite *arrowLeft;
    CCSprite *arrowRight;
    NSMutableArray *_solution;
    int step;
    CCLayerColor *loadingLayer;
    CCControlButton *doneButton;
    LoadingAnimation *loadingAnimation;
}

@end

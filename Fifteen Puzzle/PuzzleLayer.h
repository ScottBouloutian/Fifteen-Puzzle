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

static const int SCRAMBLE_DEPTH=30;
@interface PuzzleLayer : CCLayer {
    CCControlButton *editButton;
    CCControlButton *scrambleButton;
    CCControlButton *solveButton;
    CCControlButton *resetButton;
    CCLayerColor *layer;
    CCLabelTTF *statusLabel;
    PuzzleEngine *puzzle;
    Tile * selTile; //Stores the currently selected tile in edit mode
    bool inEditMode;
    bool isMoving;
    CGPoint positions[9];
}

@end

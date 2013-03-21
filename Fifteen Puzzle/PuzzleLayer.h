//
//  PuzzleLayer.h
//  Fifteen Puzzle
//
//  Created by Scott Bouloutian on 3/10/13.
//  Copyright 2013 Scott Bouloutian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PuzzleBoard.h"
#import "CCControlButton.h"

static const int SCRAMBLE_DEPTH=30;
@interface PuzzleLayer : CCLayer {
    CCControlButton *editButton;
    CCLayerColor *layer;
    CCLabelTTF *statusLabel;
    PuzzleBoard *puzzle;
    CCSprite * selSprite; //Stores the currently selected tile in edit mode
    CGPoint selOldPosition; //Stores the position the currently selected tile used to be in before it was dragged away
    bool isSwapping; //Whether or not two tiles are swapping in edit mode
    bool inEditMode;
}

@end

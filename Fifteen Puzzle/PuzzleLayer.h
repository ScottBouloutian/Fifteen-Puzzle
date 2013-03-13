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

static const int SCRAMBLE_DEPTH=30;
@interface PuzzleLayer : CCLayer {
    CCLayerColor *layer;
    CCLabelTTF *statusLabel;
    PuzzleBoard *puzzle;
}

@end

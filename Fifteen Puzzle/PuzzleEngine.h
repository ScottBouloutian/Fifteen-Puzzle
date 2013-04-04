//
//  PuzzleEngine.h
//  Fifteen Puzzle
//
//  Created by Scott Bouloutian on 3/5/13.
//  Copyright (c) 2013 Scott Bouloutian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PuzzleState.h"

@interface PuzzleEngine : NSObject{
    PuzzleState* currentState;
    int lastRandomMove;
}
-(void)resetPuzzle;
-(int)randomMove;
-(int)canMoveTile:(int)tileNumber;
-(bool)isSolved;
-(void)swapTiles:(int)tileOneNum:(int)tileTwoNum;
-(NSMutableArray*)solve;
-(bool)isSolvableState;
@end

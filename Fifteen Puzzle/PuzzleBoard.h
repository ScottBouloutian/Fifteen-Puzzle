//
//  PuzzleBoard.h
//  Fifteen Puzzle
//
//  Created by Scott Bouloutian on 3/5/13.
//  Copyright (c) 2013 Scott Bouloutian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PuzzleBoard : NSObject{
    int tileRows[9]; //stores the row that each tile is in
    int tileCols[9]; //stores the column that each tile is in
    int lastRandomMove;
}

-(void)resetBoardState; //resets everything to its default state
-(int)randomMove;
-(void)possibleMoves:(int[])tiles:(int*)numPossible; //stores the tiles that are possible to be moved in the given tiles array
-(int)canMoveTile:(int)tileNumber; //returns the direction a tile can be moved or zero otherwise
-(int)moveTile:(int)tileNumber; //slides a tile with the given number if it can be moved and returns the direction that it moved
-(bool)isSolved;
-(void)setBoardState;
@end

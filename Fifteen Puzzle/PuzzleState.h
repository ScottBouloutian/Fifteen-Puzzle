//
//  PuzzleState.h
//  Fifteen Puzzle
//
//  Created by Scott Bouloutian on 3/28/13.
//  Copyright (c) 2013 Scott Bouloutian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PuzzleState : NSObject{
    int tileRows[16]; //stores the row that each tile is in
    int tileCols[16]; //stores the column that each tile is in
}
-(void)swapTiles:(int)tileOneNum:(int)tileTwoNum;
-(int)canMoveTile:(int)tileNumber;
-(int)possibleMoves:(int[])tiles;
-(bool)isSolved;
-(void)copyFrom:(PuzzleState*)state;
-(int)getTileRow:(int)tileNum;
-(int)getTileCol:(int)tileNum;
-(int)getTileIndex:(int)tileNum;
-(int)getTileAtIndex:(int)index;
-(int)getTileAtPosition:(int)tileRow:(int)tileCol;
-(int)getTileAtDirection:(int)direction;
@end

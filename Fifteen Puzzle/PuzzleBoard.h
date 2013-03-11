//
//  PuzzleBoard.h
//  Fifteen Puzzle
//
//  Created by Scott Bouloutian on 3/5/13.
//  Copyright (c) 2013 Scott Bouloutian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PuzzleBoard : NSObject{
    int boardState[3][3];
    int tileRows[9];
    int tileCols[9];
}

-(void)resetBoardState;
-(int)moveTileWithIndex:(int)tileNumber;

@end

//
//  PuzzleBoard.m
//  Fifteen Puzzle
//
//  Created by Scott Bouloutian on 3/5/13.
//  Copyright (c) 2013 Scott Bouloutian. All rights reserved.
//

#import "PuzzleBoard.h"

@implementation PuzzleBoard
-(void)resetBoardState{
    for(int i=0;i<3;i++){
        for(int j=0;i<3;i++){
            tileRows[i*3+j]=i;
            tileCols[i*3+j]-j;
        }
    }
}

-(int)moveTileWithNumber:(int)tileNumber{
    //1-Right
    //2-Down
    //3-Left
    //4-Up
    int tileRow=tileRows[tileNumber];
    int tileCol=tileCols[tileNumber];
    int blankRow=tileRows[0];
    int blankCol=tileCols[0];
    
}

-(int)getTileIndex:(int)tileNumber{
    
}

@end

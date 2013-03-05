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
        for(int j=0;j<3;j++){
            tileRows[(i*3+j)]=i;
            tileCols[(i*3+j)]=j;
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
    int blankRow=tileRows[8];
    int blankCol=tileCols[8];
    
    int direction=0;
    
    if(tileRow==blankRow){
        if(tileCol==blankCol+1){
            direction=3;
        }
        else if(tileCol==blankCol-1){
            direction=1;
        }
    }
    else if(tileCol==blankCol){
        if(tileRow==blankRow+1){
            direction=4;
        }
        else if(tileRow==blankRow-1){
            direction=2;
        }
    }

    //if the tile can actually be moved
    if(direction!=0){
        tileRows[8]=tileRow;
        tileCols[8]=tileCol;
        tileRows[tileNumber]=blankRow;
        tileCols[tileNumber]=blankCol;

    }
    
    return direction;
}

@end

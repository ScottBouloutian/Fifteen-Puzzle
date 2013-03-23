//
//  PuzzleBoard.m
//  Fifteen Puzzle
//
//  Created by Scott Bouloutian on 3/5/13.
//  Copyright (c) 2013 Scott Bouloutian. All rights reserved.
//

#import "PuzzleBoard.h"

@implementation PuzzleBoard

-(id) init
{
	if( (self=[super init]) ) {
        [self resetBoardState];
    }
	return self;
}

-(void)resetBoardState{
    for(int i=0;i<3;i++){
        for(int j=0;j<3;j++){
            tileRows[(i*3+j)]=i;
            tileCols[(i*3+j)]=j;
        }
    }
    lastRandomMove=0;
}

-(void)swapTiles:(int)tileOneNum:(int)tileTwoNum{
    int tempRow=tileRows[tileOneNum-1];
    tileRows[tileOneNum-1]=tileRows[tileTwoNum-1];
    tileRows[tileTwoNum-1]=tempRow;

    int tempCol=tileCols[tileOneNum-1];
    tileCols[tileOneNum-1]=tileCols[tileTwoNum-1];
    tileCols[tileTwoNum-1]=tempCol;
}

-(int)randomMove{
    int tiles[4];
    int numPossible;
    int random=0;
    [self possibleMoves:tiles:&numPossible];
    while(tiles[random]==lastRandomMove){
        random=arc4random()%numPossible;
    }
    lastRandomMove=tiles[random];
    return tiles[random];
}

-(void)possibleMoves:(int[])tiles:(int*)numPossible{
    for(int i=0;i<4;i++){
        tiles[i]=-1;
    }

    int index=0;
    for(int i=1;i<9;i++){
        if([self canMoveTile:i]!=0){
            tiles[index]=i;
            index++;
        }
    }
    *numPossible=index;
}

-(int)canMoveTile:(int)tileNumber{
    //1-Right
    //2-Down
    //3-Left
    //4-Up
    int tileRow=tileRows[tileNumber-1];
    int tileCol=tileCols[tileNumber-1];
    int blankRow=tileRows[8];
    int blankCol=tileCols[8];

    if(tileRow==blankRow){
        if(tileCol==blankCol+1){
            return 3;
        }
        else if(tileCol==blankCol-1){
            return 1;
        }
    }
    else if(tileCol==blankCol){
        if(tileRow==blankRow+1){
            return 4;
        }
        else if(tileRow==blankRow-1){
            return 2;
        }
    }
    return 0;
}

-(bool)isSolved{
    for(int i=0;i<3;i++){
        for(int j=0;j<3;j++){
            if(tileRows[(i*3+j)]!=i || tileCols[(i*3+j)]!=j){
                return false;
            }
        }
    }
    return true;
}

@end

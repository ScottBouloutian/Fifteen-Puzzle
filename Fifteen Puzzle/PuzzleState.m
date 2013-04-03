//
//  PuzzleState.m
//  Fifteen Puzzle
//
//  Created by Scott Bouloutian on 3/28/13.
//  Copyright (c) 2013 Scott Bouloutian. All rights reserved.
//

#import "PuzzleState.h"

@implementation PuzzleState
@synthesize pathCost,totalCost;

-(id) init
{
	if( (self=[super init]) ) {
        //Initialize the puzzle state
        for(int i=0;i<3;i++){
            for(int j=0;j<3;j++){
                tileRows[(i*3+j)]=i;
                tileCols[(i*3+j)]=j;
            }
        }
        pathCost=0;
        totalCost=0;
    }
	return self;
}

-(void)swapTiles:(int)tileOneNum:(int)tileTwoNum{
    int tempRow=tileRows[tileOneNum-1];
    tileRows[tileOneNum-1]=tileRows[tileTwoNum-1];
    tileRows[tileTwoNum-1]=tempRow;
    
    int tempCol=tileCols[tileOneNum-1];
    tileCols[tileOneNum-1]=tileCols[tileTwoNum-1];
    tileCols[tileTwoNum-1]=tempCol;
}

-(int)possibleMoves:(int[])tiles{
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
    return index;
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
            if(tileRows[i*3+j]!=i || tileCols[i*3+j]!=j){
                return false;
            }
        }
    }
    return true;
}

-(void)copyFrom:(PuzzleState*)state{
    for(int i=0;i<9;i++){
        tileRows[i]=[state getTileRow:i];
        tileCols[i]=[state getTileCol:i];
    }
}

-(int)getTileRow:(int)tileNum{
    return tileRows[tileNum];
}

-(int)getTileCol:(int)tileNum{
    return tileCols[tileNum];
}

-(void)calcTotalCost{
    int heuristic=0;
    for (int i=0;i<9;i++){
        heuristic+=ABS(tileRows[i]-(i/3))+ABS(tileCols[i]-(i%3));
    }
    totalCost=pathCost+heuristic;
}

-(BOOL)isEqual:(id)object{
    if ([object isKindOfClass:[PuzzleState class]]) {
        PuzzleState *state=object;
        for (int i=0;i<9;i++){
            if(tileRows[i]!=[state getTileRow:i] || tileCols[i]!=[state getTileCol:i]){
                return NO;
            }
        }
        return YES;
    }
    else{
        return NO;
    }
}

@end

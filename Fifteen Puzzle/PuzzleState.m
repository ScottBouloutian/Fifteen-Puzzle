//
//  PuzzleState.m
//  Fifteen Puzzle
//
//  Created by Scott Bouloutian on 3/28/13.
//  Copyright (c) 2013 Scott Bouloutian. All rights reserved.
//

#import "PuzzleState.h"

@implementation PuzzleState

-(id) init
{
	if( (self=[super init]) ) {
        //Initialize the puzzle state
        for(int i=0;i<4;i++){
            for(int j=0;j<4;j++){
                tileRows[(i*4+j)]=i;
                tileCols[(i*4+j)]=j;
            }
        }
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
    for(int i=1;i<16;i++){
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
    int blankRow=tileRows[15];
    int blankCol=tileCols[15];
    
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
    for(int i=0;i<4;i++){
        for(int j=0;j<4;j++){
            if(tileRows[i*4+j]!=i || tileCols[i*4+j]!=j){
                return false;
            }
        }
    }
    return true;
}

-(void)copyFrom:(PuzzleState*)state{
    for(int i=0;i<16;i++){
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

-(int)getTileIndex:(int)tileNum{
    return tileRows[tileNum]*4+tileCols[tileNum];
}

-(int)getTileAtIndex:(int)index{
    int tileRow=index/4;
    int tileCol=index%4;
    for(int i=0;i<16;i++){
        if(tileRows[i]==tileRow && tileCols[i]==tileCol){
            return i;
        }
    }
    return -1;
}

-(BOOL)isEqual:(id)object{
    if ([object isKindOfClass:[PuzzleState class]]) {
        PuzzleState *state=object;
        for (int i=0;i<16;i++){
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

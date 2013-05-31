//
//  PuzzleEngine.m
//  Fifteen Puzzle
//
//  Created by Scott Bouloutian on 3/5/13.
//  Copyright (c) 2013 Scott Bouloutian. All rights reserved.
//

#import "PuzzleEngine.h"

@implementation PuzzleEngine

-(id) init
{
	if( (self=[super init]) ) {
        [self resetPuzzle];
    }
	return self;
}

-(void)resetPuzzle{
    currentState=[[PuzzleState alloc]init];
    lastRandomMove=0;
}

-(void)swapTiles:(int)tileOneNum:(int)tileTwoNum{
    [currentState swapTiles:tileOneNum :tileTwoNum];
}

-(int)randomMove{
    int tiles[4];
    int numPossible;
    int random=0;
    numPossible=[currentState possibleMoves:tiles];
    while(tiles[random]==lastRandomMove){
        random=arc4random()%numPossible;
    }
    lastRandomMove=tiles[random];
    return tiles[random];
}

-(int)canMoveTile:(int)tileNumber{
    return [currentState canMoveTile:tileNumber];
}

-(NSMutableArray*)solve{
    std::string path([[[NSBundle mainBundle]bundlePath] UTF8String]);
    Solver solver(path);
    byte tiles[16];
    for(int i=0;i<16;i++){
        tiles[[currentState getTileIndex:i]]=(i+1)%16;
    }
    Node state(tiles,0,-1);
    solver.solve(state);
    return [[NSMutableArray alloc]init];
}

-(bool)isSolved{
    return [currentState isSolved];
}

-(bool)isSolvableState{
    int n=0;
    for(int i=0;i<16;i++){
        for(int j=i+1;j<16;j++){
            if([currentState getTileAtIndex:i]!=15 && [currentState getTileAtIndex:j]!=15 && [currentState getTileAtIndex:j]<[currentState getTileAtIndex:i]){
                n++;
            }
        }
    }
    n+=[currentState getTileRow:15];
    if(n%2){
        return YES;
    }
    else{
        return NO;
    }
}

@end

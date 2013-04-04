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
    
    PuzzleState *node=currentState;
    NSMutableArray *frontier=[[NSMutableArray alloc]initWithObject:node];
    NSMutableArray *explored=[[NSMutableArray alloc]init];
    NSMutableArray *solution=[[NSMutableArray alloc]init];
    
    while(1){
        
        //Fails if the frontier is empty
        if(frontier.count==0){
            return solution;
        }
        
        //Finds and removes the lowest-cost node in the frontier
        NSSortDescriptor *sortDescriptor=[[NSSortDescriptor alloc] initWithKey:@"totalCost" ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        [frontier sortUsingDescriptors:sortDescriptors];
        node=[frontier lastObject];
        [frontier removeLastObject];
        
        //Check to see if a solution is found
        if([node isSolved]){
            while(node.parentState!=nil){
                [solution insertObject:[NSNumber numberWithInt:node.action] atIndex:0];
                node=node.parentState;
            }
            
            return solution;
        }
        
        //Add the node to list of explored states
        [explored addObject:node];
        
        //Expand the node and add possible states to the frontier
        int possible[4];
        int num=[node possibleMoves:possible];
        for(int i=0;i<num;i++){
            PuzzleState *child=[[PuzzleState alloc]init];
            [child copyFrom:node];
            child.action=possible[i];
            child.parentState=node;
            [child swapTiles:possible[i]:9];
            child.pathCost=node.pathCost+1;
            [child calcTotalCost];
            if([explored indexOfObject:child]==NSNotFound){
                int index=[frontier indexOfObject:child];
                if(index==NSNotFound){
                    [frontier addObject:child];
                }
                else{
                    PuzzleState *state=[frontier objectAtIndex:index];
                    if(state.pathCost>child.pathCost){
                        [frontier setObject:child atIndexedSubscript:index];
                    }
                }
            }
        }

    }
}

-(bool)isSolved{
    return [currentState isSolved];
}

-(bool)isSolvableState{
    int n=0;
    for(int i=0;i<9;i++){
        for(int j=i+1;j<9;j++){
            if([currentState getTileAtIndex:i]!=8 && [currentState getTileAtIndex:j]!=8 && [currentState getTileAtIndex:j]<[currentState getTileAtIndex:i]){
                n++;
            }
        }
    }
    if(n%2==0){
        return YES;
    }
    else{
        return NO;
    }
}

@end

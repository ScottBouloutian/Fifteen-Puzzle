//
//  PuzzleLayer.m
//  Fifteen Puzzle
//
//  Created by Scott Bouloutian on 3/10/13.
//  Copyright 2013 Scott Bouloutian. All rights reserved.
//

#import "PuzzleLayer.h"

@implementation PuzzleLayer

-(void)scrambleTouched:(id)sender{
    for(int i=0;i<SCRAMBLE_DEPTH;i++){
        [self swapTiles:[self getTile:[puzzle randomMove]]:[self getTile:9]];
    }
}

-(void)moveTiles:(NSMutableArray*)tiles{
    for(NSNumber *tileNum in tiles){
        [self swapTiles:[self getTile:tileNum.intValue]:[self getTile:9]];
    }
}

-(void)solveTouched:(id)sender{
    if([puzzle isSolved]){
        return;
    }
    else if(![puzzle isSolvableState]){
        UIAlertView *view=[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Puzzle cannot be solved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
        [view show];
        [view release];
    }
    else{
        CCRotateTo * rotLeft = [CCRotateBy actionWithDuration:0.1 angle:-12.0];
        [activityIndicator runAction:[CCRepeatForever actionWithAction:rotLeft]];
        
        activityIndicator.visible=YES;
        scrambleButton.enabled=NO;
        solveButton.enabled=NO;
        resetButton.enabled=NO;
        editButton.enabled=NO;
        
        
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(solve) object:nil];
        [queue addOperation:operation];
    }
}

-(void) solve{
    NSMutableArray *solution=[puzzle solve];
    [self performSelectorOnMainThread:@selector(updateUI:) withObject:solution waitUntilDone:YES];
}

-(void) updateUI:(NSMutableArray*)solution{
    [self moveTiles:solution];
    editButton.enabled=YES;
    resetButton.enabled=YES;
    solveButton.enabled=YES;
    scrambleButton.enabled=YES;
    activityIndicator.visible=NO;
    
    [activityIndicator stopAllActions];
    [activityIndicator runAction:[CCRotateTo actionWithDuration:0.1 angle:0]];
}

-(void)resetTouched:(id)sender{
    [puzzle resetPuzzle];
    for(int i=1;i<10;i++){
        [self moveTile:[self getTile:i] toLocation:i];
    }
    [self checkForSolution];
}

-(Tile*)getTile:(int)tileNumber{
    for(Tile *tile in layer.children){
        if(tile.number==tileNumber){
            return tile;
        }
    }
    return nil;
}

-(void)rearrangeTouched:(id)sender{
    if(inEditMode) {
        [selTile stopActionByTag:2];
        [selTile runAction:[CCRotateTo actionWithDuration:0.1 angle:0]];
        scrambleButton.enabled=YES;
        solveButton.enabled=YES;
        resetButton.enabled=YES;
        [editButton setTitle:@"Rearrange" forState:CCControlStateNormal];
        inEditMode=false;
    }else{
        selTile=nil;
        [editButton setTitle:@"Done" forState:CCControlStateNormal];
        resetButton.enabled=NO;
        solveButton.enabled=NO;
        scrambleButton.enabled=NO;
        inEditMode=true;
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if(inEditMode & !isMoving){
        float distance;
        float minDistance=ccpDistance(selTile.position, positions[selTile.location-1]);
        Tile *closestTile=selTile;
        
        for (Tile *tile in layer.children) {
            
            //If they are not the same tile...
            if(selTile.number!=tile.number){
                distance=ccpDistance(selTile.position, tile.position);
                if(distance<minDistance){
                    minDistance=distance;
                    closestTile=tile;
                }
            }
            
        }
        
        if(closestTile==selTile){
            //Move the tile to where it used to be located
            [self moveTile:selTile toLocation:selTile.location];
        }else{
            [self swapTiles:selTile :closestTile];
        }
    }}

-(void)doneMoving{
    isMoving=false;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if(inEditMode & !isMoving){
        CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
        [self selectSpriteForTouch:touchLocation];
    }else if(!inEditMode){
        CGPoint location = [self convertTouchToNodeSpace:touch];
        for (Tile *tile in layer.children) {
            if(CGRectContainsPoint([tile boundingBox], location)){
                if([puzzle canMoveTile:tile.number]!=0){
                    [self swapTiles:tile:[self getTile:9]];
                }
            }
        }
    }
    
    return true;
}

- (void)selectSpriteForTouch:(CGPoint)touchLocation {
    Tile * newTile = nil;
    for (Tile *tile in layer.children) {
        if (CGRectContainsPoint(tile.boundingBox, touchLocation)) {
            newTile = tile;
            break;
        }
    }
    
    if (newTile!=nil && newTile.number!=9 && newTile != selTile) {
        [selTile stopAllActions];
        [selTile runAction:[CCRotateTo actionWithDuration:0.1 angle:0]];
        CCRotateTo * rotLeft = [CCRotateBy actionWithDuration:0.1 angle:-4.0];
        CCRotateTo * rotRight = [CCRotateBy actionWithDuration:0.1 angle:4.0];
        CCSequence * rotSeq = [CCSequence actions:rotLeft, rotRight, rotRight, rotLeft, nil];
        CCRepeatForever* wiggle=[CCRepeatForever actionWithAction:rotSeq];
        wiggle.tag=2;
        [newTile runAction:wiggle];
        selTile = newTile;
    }
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    if(inEditMode & !isMoving){
        CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
        
        CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
        oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
        oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
        
        CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
        CGPoint newPos = ccpAdd(selTile.position, translation);
        selTile.position = newPos;
    }
}

-(void)moveTile:(Tile*)tile toLocation:(int)location{
    isMoving=true;
    id doneAction = [CCCallFuncN actionWithTarget:self selector:@selector(doneMoving)];
    CCMoveTo *tileMove=[CCMoveTo actionWithDuration:0.25 position:positions[location-1]];
    [tile stopActionByTag:1];
    CCSequence *moveSeq=[CCSequence actions:tileMove,doneAction, nil];
    moveSeq.tag=1;
    [tile runAction:moveSeq];
    tile.location=location;
}

-(void)swapTiles:(Tile*)tileOne:(Tile*)tileTwo{
    int tempLoc=tileOne.location;
    [self moveTile:tileOne toLocation:tileTwo.location];
    [self moveTile:tileTwo toLocation:tempLoc];
    [puzzle swapTiles:tileOne.number :tileTwo.number];
    [self checkForSolution];
}

-(void)checkForSolution{
    if([puzzle isSolved]){
        statusLabel.string=@"Solved";
    }
    else if(![puzzle isSolvableState]){
        statusLabel.string=@"Unsolvable Puzzle State";
    }
    else{
        statusLabel.string=@"Not Solved";
    }
}

-(id) init
{
	if( (self=[super init]) ) {
        queue = [NSOperationQueue new];
        puzzle=[[PuzzleEngine alloc]init];
        inEditMode=false;
        isMoving=false;
        CCDirector *director=[CCDirector sharedDirector];
        [[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
        CGSize winSize = [director winSize];
        for (int i=0;i<3;i++){
            for(int j=0;j<3;j++){
                positions[i*3+j]=ccp(50+100*j,winSize.height-50-100*i);
            }
        }
    }
	return self;
}
@end

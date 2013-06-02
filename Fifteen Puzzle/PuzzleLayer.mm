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

    //Make the arrows invisible
    arrowLeft.visible=NO;
    arrowRight.visible=NO;

    for(int i=0;i<SCRAMBLE_DEPTH;i++){
        [self swapTiles:[self getTile:[puzzle randomMove]]:[self getTile:16]];
    }
}

//-(void)moveTilesSequentialy:(NSMutableArray*)tiles{
//    isMoving=true;
//    tileSequence=tiles;
//    count=0;
//    
//    [self doneMovingSequentialy];
//}
//
//-(void)doneMovingSequentialy{
//    if(count>=tileSequence.count){
//        isMoving=false;
//        return;
//    }
//    else{
//        NSNumber *tileNumber=[tileSequence objectAtIndex:count];
//        count++;
//        Tile* tile=[self getTile:tileNumber.intValue];
//        Tile* blank=[self getTile:9];
//        
//        //Swap the locations of the tiles
//        [puzzle swapTiles:tileNumber.intValue :9];
//        int tmpLoc=blank.location;
//        blank.location=tile.location;
//        tile.location=tmpLoc;
//
//        //Move the blank space to its new position
//        blank.position=positions[blank.location-1];
//        
//        //Move the tile to the blank space's position
//        CCMoveTo *tileMove=[CCMoveTo actionWithDuration:0.25 position:positions[tile.location-1]];
//        id doneAction = [CCCallFuncN actionWithTarget:self selector:@selector(doneMovingSequentialy)];
//        CCSequence *moveSeq=[CCSequence actions:tileMove,doneAction, nil];
//        [tile runAction:moveSeq];
//        
//    }
//}

-(void)solveTouched:(id)sender{
    
    //Make the arrows invisible
    arrowLeft.visible=NO;
    arrowRight.visible=NO;

    if([puzzle isSolved]){
        return;
    }
    else if(![puzzle isSolvableState]){
        UIAlertView *view=[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Puzzle cannot be solved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
        [view show];
        [view release];
    }
    else{
        loadingScene=[CCBReader sceneWithNodeGraphFromFile:@"LoadingScene.ccbi"];

        [[CCDirector sharedDirector] pushScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:loadingScene]];
        
        //Disable all the buttons
        scrambleButton.enabled=NO;
        solveButton.enabled=NO;
        resetButton.enabled=NO;
        editButton.enabled=NO;
        
        //Start the algorithm on another thread
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(solve) object:nil];
        [queue addOperation:operation];
    }
}

-(void) solve{
    NSMutableArray *solution=[puzzle solve];
    [self performSelectorOnMainThread:@selector(updateUI:) withObject:solution waitUntilDone:YES];
}

-(void) updateUI:(NSMutableArray*)solution{
    //Allow user to touch arrows to progress through the solution sequence
    _solution=solution;
    step=0;
    arrowLeft.visible=YES;
    arrowRight.visible=YES;
    statusLabel.string=@"Touch Arrows to View Solution";
    
    //Re-enable the buttons
    editButton.enabled=YES;
    resetButton.enabled=YES;
    solveButton.enabled=YES;
    scrambleButton.enabled=YES;

    //Notify the loading layer that the computation on this layer has completed
    LoadingLayer *layer=(LoadingLayer*)loadingScene.children.lastObject;
    [layer doneLoading];
}

-(void)resetTouched:(id)sender{

    //Make the arrows invisible
    arrowLeft.visible=NO;
    arrowRight.visible=NO;

    [puzzle resetPuzzle];
    for(int i=1;i<17;i++){
        [self moveTile:[self getTile:i] toLocation:i];
    }
    [self checkForSolution];
}

-(Tile*)getTile:(int)tileNumber{
    for(Tile *tile in tileLayer.children){
        if(tile.number==tileNumber){
            return tile;
        }
    }
    return nil;
}

-(void)rearrangeTouched:(id)sender{
    
    //Make the arrows invisible
    arrowLeft.visible=NO;
    arrowRight.visible=NO;

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
        
        for (Tile *tile in tileLayer.children) {
            
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
    }
    
    //Check for the touch of one of the arrows used to step through the solution sequence
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    if(arrowLeft.visible && CGRectContainsPoint([arrowLeft boundingBox], touchLocation)){
        if(step>0){
            step--;
            NSNumber *tileNum=[_solution objectAtIndex:step];
            [self swapTiles:[self getTile:tileNum.intValue] :[self getTile:16]];
        }
    }
    else if(arrowRight.visible && CGRectContainsPoint([arrowRight boundingBox], touchLocation)){
        if(step<_solution.count){
            NSNumber *tileNum=[_solution objectAtIndex:step];
            [self swapTiles:[self getTile:tileNum.intValue] :[self getTile:16]];
            step++;
        }
    }
}

-(void)doneMoving{
    isMoving=false;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [tileLayer convertTouchToNodeSpace:touch];
    if(inEditMode & !isMoving){
        [self selectSpriteForTouch:touchLocation];
    }else if(!inEditMode){
        for (Tile *tile in tileLayer.children) {
            if(CGRectContainsPoint([tile boundingBox], touchLocation)){
                if([puzzle canMoveTile:tile.number]!=0){
                    [self swapTiles:tile:[self getTile:16]];
                }
                
                //Make the arrows invisible if you slide a tile
                arrowLeft.visible=NO;
                arrowRight.visible=NO;

                return true;
            }
        }
    }
    
    return true;
}

- (void)selectSpriteForTouch:(CGPoint)touchLocation {
    Tile * newTile = nil;
    for (Tile *tile in tileLayer.children) {
        if (CGRectContainsPoint(tile.boundingBox, touchLocation)) {
            newTile = tile;
            newTile.zOrder=0;
            break;
        }
    }
    
    if (newTile!=nil && newTile.number!=16 && newTile != selTile) {
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
        CGPoint touchLocation = [tileLayer convertTouchToNodeSpace:touch];
        
        CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
        oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
        oldTouchLocation = [tileLayer convertToNodeSpace:oldTouchLocation];
        
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
        loadingScene=[CCBReader sceneWithNodeGraphFromFile:@"LoadingScene.ccbi"];
        queue = [NSOperationQueue new];
        puzzle=[[PuzzleEngine alloc]init];
        inEditMode=false;
        isMoving=false;
        CCDirector *director=[CCDirector sharedDirector];
        [[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
        for (int i=0;i<4;i++){
            for(int j=0;j<4;j++){
                positions[i*4+j]=ccp(37.5+75*j,300-37.5-75*i);
            }
        }
        NSLog(@"%f,%f",positions[10].x,positions[10].y);
    }
	return self;
}
@end
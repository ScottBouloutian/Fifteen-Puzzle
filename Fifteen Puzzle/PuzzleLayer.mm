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
    }
    else{
        //Display the loading screen
        [loadingLayer runAction:[CCFadeIn actionWithDuration:0.5f]];
        [loadingAnimation start];
        loadingLayer.visible=YES;
        instructionsLabel.visible=NO;
        doneButton.visible=NO;

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
    //Check if a solution was succesfully found
    NSNumber *solved=(NSNumber*)solution.lastObject;
    [solution removeLastObject];
    if(solved.boolValue){
        NSNumber *time=solution.lastObject;
        [solution removeLastObject];
        instructionsLabel.string=[NSString stringWithFormat:@"Optimal Solution\n%i moves\n%i seconds",solution.count,time.intValue];
    }else{
        instructionsLabel.string=@"A solution to the puzzle was not able to be found within 30 seconds. Try moving around some tiles and trying again!";
        UIAlertView *view=[[UIAlertView alloc] initWithTitle:@"Timeout" message:@"Puzzle was not solved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
        [view show];

    }
    
    //Set the solution and step counter
    _solution=solution;
    step=0;

    //Show view solution button, stop the loading animation, and show the instructions label
    doneButton.visible=YES;
    [loadingAnimation stop];
    instructionsLabel.visible=YES;
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
    return (Tile*)[tileLayer getChildByTag:tileNumber];
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
        [editButton setBackgroundSprite:[CCScale9Sprite spriteWithFile:@"greyButton.png"] forState:CCControlStateNormal];
        [editButton setBackgroundSprite:[CCScale9Sprite spriteWithFile:@"greyButtonHighlight.png"] forState:CCControlStateHighlighted];
        [editButton setTitleColor:ccBLACK forState:CCControlStateNormal];
        [editButton setTitleColor:ccBLACK forState:CCControlStateHighlighted];
        inEditMode=false;
    }else{
        selTile=nil;
        [editButton setTitle:@"Done" forState:CCControlStateNormal];
        [editButton setBackgroundSprite:[CCScale9Sprite spriteWithFile:@"blueButton.png"] forState:CCControlStateNormal];
        [editButton setBackgroundSprite:[CCScale9Sprite spriteWithFile:@"blueButtonHighlight.png"] forState:CCControlStateHighlighted];
        [editButton setTitleColor:ccWHITE forState:CCControlStateNormal];
        [editButton setTitleColor:ccWHITE forState:CCControlStateHighlighted];
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
            int tileNum=[puzzle getTileAtDirection:([[_solution objectAtIndex:step] intValue]+2)%4+1]+1;
            [self swapTiles:[self getTile:tileNum] :[self getTile:16]];
        }
    }
    else if(arrowRight.visible && CGRectContainsPoint([arrowRight boundingBox], touchLocation)){
        if(step<_solution.count){
            int tileNum=[puzzle getTileAtDirection:[[_solution objectAtIndex:step] intValue]+1]+1;
            [self swapTiles:[self getTile:tileNum] :[self getTile:16]];
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
        //Convert touch location to proper node space
        CGPoint touchLocation = [tileLayer convertTouchToNodeSpace:touch];
        CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
        oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
        oldTouchLocation = [tileLayer convertToNodeSpace:oldTouchLocation];
        
        //If the beggining of the tile drag starts on top of the currently selected tile...
        if(CGRectContainsPoint(selTile.boundingBox, oldTouchLocation)){
            CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
            CGPoint newPos = ccpAdd(selTile.position, translation);
            selTile.position = newPos;
        }
    }
}

-(void)moveTile:(Tile*)tile toLocation:(int)location{
    tile.zOrder=0;
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

-(void)doneTouched:(id)sender{
    //Close the loading layer
    [loadingLayer runAction:[CCFadeOut actionWithDuration:0.5f]];
    loadingLayer.visible=NO;

    //Allow user to touch arrows to progress through the solution sequence
    arrowLeft.visible=YES;
    arrowRight.visible=YES;
    statusLabel.string=@"Touch Arrows to View Solution";
    
    //Re-enable the buttons
    editButton.enabled=YES;
    resetButton.enabled=YES;
    solveButton.enabled=YES;
    scrambleButton.enabled=YES;

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
        for (int i=0;i<4;i++){
            for(int j=0;j<4;j++){
                positions[i*4+j]=ccp(37.5+75*j,300-37.5-75*i);
            }
        }
    }
	return self;
}
@end

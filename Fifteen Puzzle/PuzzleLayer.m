//
//  PuzzleLayer.m
//  Fifteen Puzzle
//
//  Created by Scott Bouloutian on 3/10/13.
//  Copyright 2013 Scott Bouloutian. All rights reserved.
//

#import "PuzzleLayer.h"
#import "Tile.h"

@implementation PuzzleLayer

-(void)scrambleTouched:(id)sender{
//    for(int i=0;i<SCRAMBLE_DEPTH;i++){
//        [self moveTile:[self getTile:[puzzle randomMove]]];
//    }
    [self updateBoardState];
}

-(void)rearrangeTouched:(id)sender{
    if(inEditMode) {
        [editButton setTitle:@"Rearrange" forState:CCControlStateNormal];
        inEditMode=false;
    }else{
        [editButton setTitle:@"Done" forState:CCControlStateNormal];
        inEditMode=true;
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if(inEditMode && !isSwapping){
        isSwapping=true;
        
        float distance;
        float minDistance=ccpDistance(selSprite.position, selOldPosition);
        CCSprite *closestTile=selSprite;
        for (CCSprite *sprite in layer.children) {
            
            //If they are not the same tile...
            if(selSprite.tag!=sprite.tag){
                distance=ccpDistance(selSprite.position, sprite.position);
                if(distance<minDistance){
                    minDistance=distance;
                    closestTile=sprite;
                }
            }
            
        }
        
        CCSequence * swapSeq;
        id doneAction = [CCCallFuncN actionWithTarget:self selector:@selector(doneSwapping)];
        if(closestTile==selSprite){
            //Move the tile to where it used to be located
            swapSeq = [CCSequence actions:[CCMoveTo actionWithDuration:0.25 position:selOldPosition],doneAction, nil];
            [selSprite runAction:swapSeq];
        }else{
            //Swap the tile with the closest one to it
            swapSeq = [CCSequence actions:[CCMoveTo actionWithDuration:0.25 position:closestTile.position], nil];
            [selSprite runAction:swapSeq];
            swapSeq = [CCSequence actions:[CCMoveTo actionWithDuration:0.25 position:selOldPosition],doneAction, nil];
            [closestTile runAction:swapSeq];
            selOldPosition=closestTile.position;
        }
        
    }else if(!inEditMode){
        CGPoint location = [self convertTouchToNodeSpace:touch];
        
        CCNode *child;
        for(int i=1;i<9;i++){
            child=[self getTile:i];
            if(CGRectContainsPoint([child boundingBox], location)){
                [self moveTile:child];
            }
        }
        
    }
    
}

-(void)doneSwapping{
    isSwapping=false;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if(inEditMode && !isSwapping){
        CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
        [self selectSpriteForTouch:touchLocation];
    }
    return TRUE;
}

- (void)selectSpriteForTouch:(CGPoint)touchLocation {
    CCSprite * newSprite = nil;
    for (CCSprite *sprite in layer.children) {
        if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) {
            newSprite = sprite;
            break;
        }
    }
    if (newSprite != selSprite) {
        [selSprite stopAllActions];
        [selSprite runAction:[CCRotateTo actionWithDuration:0.1 angle:0]];
        CCRotateTo * rotLeft = [CCRotateBy actionWithDuration:0.1 angle:-4.0];
        CCRotateTo * rotRight = [CCRotateBy actionWithDuration:0.1 angle:4.0];
        CCSequence * rotSeq = [CCSequence actions:rotLeft, rotRight, rotRight, rotLeft, nil];
        [newSprite runAction:[CCRepeatForever actionWithAction:rotSeq]];
        selSprite = newSprite;
        selOldPosition=selSprite.position;
    }
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    if(inEditMode && !isSwapping){
        CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
        
        CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
        oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
        oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
        
        CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
        CGPoint newPos = ccpAdd(selSprite.position, translation);
        selSprite.position = newPos;
    }
}

-(CCNode*)getTile:(int)tileNum{
    if(tileNum>0&&tileNum<9){
        CCNode *child;
        CCARRAY_FOREACH(layer.children, child){
            //if this node is a numbered tile
            if(child.tag==tileNum){
                return child;
            }
        }
    }
    return nil;
}

-(void)moveTile:(CCNode*)tile{
    int direction=[puzzle moveTile:tile.tag];
    switch(direction){
        case 1:
            [tile runAction:[CCMoveTo actionWithDuration:0.25 position:ccp(tile.position.x+100, tile.position.y)]];
            break;
        case 2:
            [tile runAction:[CCMoveTo actionWithDuration:0.25 position:ccp(tile.position.x,tile.position.y-100)]];
            break;
        case 3:
            [tile runAction:[CCMoveTo actionWithDuration:0.25 position:ccp(tile.position.x-100, tile.position.y)]];
            break;
        case 4:
            [tile runAction:[CCMoveTo actionWithDuration:0.25 position:ccp(tile.position.x,tile.position.y+100)]];
            break;
    }
    [self checkForSolution];
}

-(void)checkForSolution{
    if([puzzle isSolved]){
        statusLabel.string=@"Solved";
    }
    else{
        statusLabel.string=@"Not Solved";
    }
}

-(void)updateBoardState{
    int state[8];
    for (Tile *tile in layer.children) {
        state[tile.number-1]=tile.location;
    }
    for (int i=0;i<9;i++){
        NSLog(@"%i%i",i+1,state[i]);
    }
}

-(id) init
{
	if( (self=[super init]) ) {
        puzzle=[[PuzzleBoard alloc]init];
        inEditMode=false;
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
    }
	return self;
}
@end

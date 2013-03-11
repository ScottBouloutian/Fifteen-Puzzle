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
    
}
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [self convertTouchToNodeSpace:touch];
    
    CCNode *child;
    for(int i=1;i<9;i++){
        child=[self getTile:i];
        if(CGRectContainsPoint([child boundingBox], location)){
            [self moveTile:child];
        }
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
    int direction=[puzzle moveTileWithIndex:(tile.tag-1)];
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
}


-(id) init
{
	if( (self=[super init]) ) {
        puzzle=[[PuzzleBoard alloc]init];
        [puzzle resetBoardState];
    }
	return self;
}
@end

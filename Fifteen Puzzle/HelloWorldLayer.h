//
//  HelloWorldLayer.h
//  Fifteen Puzzle
//
//  Created by Scott Bouloutian on 3/5/13.
//  Copyright Scott Bouloutian 2013. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "PuzzleBoard.h"

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    PuzzleBoard *puzzle;
    NSMutableArray *tiles;
    NSMutableArray *labels;
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end

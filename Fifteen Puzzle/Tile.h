//
//  Tile.h
//  Fifteen Puzzle
//
//  Created by Scott Bouloutian on 3/21/13.
//  Copyright (c) 2013 Scott Bouloutian. All rights reserved.
//

#import "CCSprite.h"

@interface Tile : CCSprite{
        int location;
        int number;
    }
    
    @property (nonatomic,assign) int location;
    @property (nonatomic,assign) int number;


    @end

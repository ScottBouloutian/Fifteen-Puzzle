//
//  LoadingLayer.h
//  Fifteen Puzzle
//
//  Created by Scott Bouloutian on 5/31/13.
//  Copyright 2013 Scott Bouloutian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCControlButton.h"

@interface LoadingLayer : CCLayer {
    CCControlButton *doneButton;
}
-(void)doneLoading;
@end

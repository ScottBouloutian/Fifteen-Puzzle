//
//  HelloWorldLayer.m
//  Fifteen Puzzle
//
//  Created by Scott Bouloutian on 3/5/13.
//  Copyright Scott Bouloutian 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void)resetBoardState{
    for(int i=0;i<9;i++){
        boardState[i]=i;
    }
    emptyTile=8;
}

-(void)moveTile:(int)tileNum{
    int tileIndex=0;
    for(int i=0;i<9;i++){
        if(boardState[i]==tileNum){
            tileIndex=i;
        }
    }
    CCSprite *tile=[tiles objectAtIndex:tileNum];
    CCMoveTo *moveRight = [CCMoveTo actionWithDuration:0.25 position:ccp(tile.position.x+100, tile.position.y)];
    CCMoveTo *moveLeft = [CCMoveTo actionWithDuration:0.25 position:ccp(tile.position.x-100, tile.position.y)];
    CCMoveTo *moveDown = [CCMoveTo actionWithDuration:0.25 position:ccp(tile.position.x,tile.position.y-100)];
    CCMoveTo *moveUp = [CCMoveTo actionWithDuration:0.25 position:ccp(tile.position.x,tile.position.y+100)];
    if(tileIndex==emptyTile-1){
        [tile runAction:moveRight];
        boardState[tileIndex]=8;
        boardState[emptyTile]=tileNum;
        emptyTile--;
    }
    else if(tileIndex==emptyTile+1){
        [tile runAction:moveLeft];
        boardState[tileIndex]=8;
        boardState[emptyTile]=tileNum;
        emptyTile++;
    }
    else if(tileIndex==emptyTile-3){
        [tile runAction:moveDown];
        boardState[tileIndex]=8;
        boardState[emptyTile]=tileNum;
        emptyTile-=3;
    }
    else if(tileIndex==emptyTile+3){
        [tile runAction:moveUp];
        boardState[tileIndex]=8;
        boardState[emptyTile]=tileNum;
        emptyTile+=3;
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [self convertTouchToNodeSpace:touch];
    
    for(int i=0;i<8;i++){
        if(CGRectContainsPoint([[tiles objectAtIndex:i] boundingBox], location)){
            [self moveTile:i];
        }
    }
}

// on "init" you need to initialize your instance
-(id) init
{
	if( (self=[super init]) ) {
        tiles=[[NSMutableArray alloc]init];
        [self setTouchEnabled:YES];
        [self resetBoardState];
		CGSize size = [[CCDirector sharedDirector] winSize];
        for(int row=0;row<3;row++){
            for(int col=0;col<3;col++){
                if(row!=2 || col!=2){
                    CCSprite *tile = [CCSprite spriteWithFile:@"tile.png"];
                    [tiles addObject:tile];
                    tile.position=ccp(col*100+50,size.height-(row*100+50));
                    [self addChild:tile];
                }
            }
        }
    }
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end

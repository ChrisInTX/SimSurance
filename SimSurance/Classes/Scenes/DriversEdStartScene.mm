//
//  DriversEdStartScene.m
//  SimSurance
//
//  Created by Chris Lowe on 7/26/11.
//  Copyright 2011 USAA. All rights reserved.
//

#import "DriversEdStartScene.h"

#import "MainMenuScene.h"
#import "GameScene.h"
#import "CCBReader.h"
#import "SimpleAudioEngine.h"

@implementation DriversEdStartScene

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"driversEdLevelStart.ccb"];
	
    // return the scene
	return scene;
}

//- (void) didLoadFromCCB
//{
//}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        self.isTouchEnabled = YES;
        NSLog(@"*** In Level Start Scene");
        
        // ****************
        // This Scene is setup in the MainMenu.ccb file from CocosBuilder
		// ****************
        
    }
    
    return self;
    
}

-(void)startButtonSelected:(id)sender  
{
    NSLog(@"** Play!!!");
    [[CCDirector sharedDirector] replaceScene:[GameScene sceneWithLevel:GameLevelDriversEd]];
}

-(void)mainMenuSelected:(id)sender  
{
    NSLog(@"** Menu!!!");
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSplitCols transitionWithDuration:1.0 scene:[MainMenuScene scene]]];
}

@end

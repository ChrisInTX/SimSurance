//
//  StageSelectScene.m
//  SimSurance
//
//  Created by Rich Tanner on 8/16/11.
//  Copyright 2011 Redshirt Interactive Technologies. All rights reserved.
//

#import "StageSelectScene.h"
#import "MainMenuScene.h"
#import "GameScene.h"

@implementation StageSelectScene

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	StageSelectScene *layer = [StageSelectScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        self.isTouchEnabled = YES;
        
		// create and initialize the background image
		CCSprite *background = [CCSprite spriteWithFile:@"stageSelect.png"];
        CGSize size = [[CCDirector sharedDirector] winSize];
        background.position =  ccp( size.width /2 , size.height/2 );
        [self addChild:background];  
        
        //stage 4 (armybase) level
        CCMenuItemImage *stage4Button = [CCMenuItemImage itemFromNormalImage:@"stage4.png" selectedImage:@"stageSelected.png" target:self selector:@selector(goToArmyBase)];;
        CCMenu *stage4Menu = [CCMenu menuWithItems:stage4Button, nil];
		stage4Menu.position = ccp( screenSize.width /2 , screenSize.height-300);
        [stage4Menu alignItemsVertically];
        [self addChild:stage4Menu];

        
        //stage 8 (hospital) level
        CCMenuItemImage *stage8Button = [CCMenuItemImage itemFromNormalImage:@"stage8.png" selectedImage:@"stageSelected.png" target:self selector:@selector(goToHospital)];;
        CCMenu *stage8Menu = [CCMenu menuWithItems:stage8Button, nil];
		stage8Menu.position = ccp( screenSize.width /3 , screenSize.height-500);
        [stage8Menu alignItemsVertically];
        [self addChild:stage8Menu];
        
        
        // create and initialize the back button
        CCMenuItemImage *backButton = [CCMenuItemImage itemFromNormalImage:@"mainMenu.png" selectedImage:@"mainMenu-selected.png" target:self selector:@selector(goToMainMenu)];;
        CCMenu *backMenu = [CCMenu menuWithItems:backButton, nil];
		backMenu.position = ccp( screenSize.width /2 , screenSize.height-700);
        [backMenu alignItemsVertically];
        [self addChild:backMenu];
        
	}
	return self;
}

- (void)goToArmyBase {
    CCLOG(@"Stage 8 button selected, popping...");
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSplitCols transitionWithDuration:1.0 scene:[GameScene sceneWithLevel:GameLevelBasicTraining]]];
}

- (void)goToHospital {
    CCLOG(@"Stage 8 button selected, popping...");
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSplitCols transitionWithDuration:1.0 scene:[GameScene sceneWithLevel:GameLevelHospital]]];
}

- (void)goToMainMenu  
{
    CCLOG(@"Main Menu button selected, popping...");
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:0.5 scene:[MainMenuScene scene]]];
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
@end


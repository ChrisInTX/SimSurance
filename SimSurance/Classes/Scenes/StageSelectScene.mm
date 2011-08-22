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
#import "LevelSplashScene.h"

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
        
        //stage 1 menu
        CCMenuItemImage *stage1Button = [CCMenuItemImage itemFromNormalImage:@"stage1disabled.png" selectedImage:@"stageSelected.png" target:self selector:@selector(goToLevel1Splash)];
        CCMenu *stage1Menu = [CCMenu menuWithItems:stage1Button, nil];
		stage1Menu.position = ccp(600, 610);
        [stage1Menu alignItemsVertically];
        [self addChild:stage1Menu];
        
        //stage 2 menu
        CCMenuItemImage *stage2Button = [CCMenuItemImage itemFromNormalImage:@"stage2disabled.png" selectedImage:@"stageSelected.png" target:self selector:@selector(goToLevel2Splash)];
        CCMenu *stage2Menu = [CCMenu menuWithItems:stage2Button, nil];
        stage2Menu.position = ccp(400, 510);
        [stage2Menu alignItemsVertically];
        [self addChild:stage2Menu];
        
        //stage 3 menu
        CCMenuItemImage *stage3Button = [CCMenuItemImage itemFromNormalImage:@"stage3disabled.png" selectedImage:@"stageSelected.png" target:self selector:@selector(goToLevel3Splash)];
        CCMenu *stage3Menu = [CCMenu menuWithItems:stage3Button, nil];
        stage3Menu.position = ccp(800, 510);
        [stage3Menu alignItemsVertically];
        [self addChild:stage3Menu];
        
        //***  stage 4 (armybase) level  ***//
        CCMenuItemImage *stage4Button = [CCMenuItemImage itemFromNormalImage:@"stage4.png" selectedImage:@"stageSelected.png" target:self selector:@selector(goToLevel4Splash)];;
        CCMenu *stage4Menu = [CCMenu menuWithItems:stage4Button, nil];
        stage4Menu.position = ccp(310, 385);
        [stage4Menu alignItemsVertically];
        [self addChild:stage4Menu];

        //stage 5 menu
        CCMenuItemImage *stage5Button = [CCMenuItemImage itemFromNormalImage:@"stage5disabled.png" selectedImage:@"stageSelected.png" target:self selector:@selector(goToLevel5Splash)];
        CCMenu *stage5Menu = [CCMenu menuWithItems:stage5Button, nil];
		stage5Menu.position = ccp(600, 385);
        [stage5Menu alignItemsVertically];
        [self addChild:stage5Menu];
        
        //stage 6 menu
        CCMenuItemImage *stage6Button = [CCMenuItemImage itemFromNormalImage:@"stage6disabled.png" selectedImage:@"stageSelected.png" target:self selector:@selector(goToLevel6Splash)];
        CCMenu *stage6Menu = [CCMenu menuWithItems:stage6Button, nil];
        stage6Menu.position = ccp(890, 385);
        [stage6Menu alignItemsVertically];
        [self addChild:stage6Menu];
        
        //stage 7 menu
        CCMenuItemImage *stage7Button = [CCMenuItemImage itemFromNormalImage:@"stage7disabled.png" selectedImage:@"stageSelected.png" target:self selector:@selector(goToLevel7Splash)];
        CCMenu *stage7Menu = [CCMenu menuWithItems:stage7Button, nil];
        stage7Menu.position = ccp(400, 260);
        [stage7Menu alignItemsVertically];
        [self addChild:stage7Menu];
        
        //***  stage 8 (hospital) level  ***//
        CCMenuItemImage *stage8Button = [CCMenuItemImage itemFromNormalImage:@"stage8.png" selectedImage:@"stageSelected.png" target:self selector:@selector(goToLevel8Splash)];
        CCMenu *stage8Menu = [CCMenu menuWithItems:stage8Button, nil];
        stage8Menu.position = ccp(800, 260);
        [stage8Menu alignItemsVertically];
        [self addChild:stage8Menu];
        
        //stage 9 menu
        CCMenuItemImage *stage9Button = [CCMenuItemImage itemFromNormalImage:@"stage9disabled.png" selectedImage:@"stageSelected.png" target:self selector:@selector(goToLevel9Splash)];
        CCMenu *stage9Menu = [CCMenu menuWithItems:stage9Button, nil];
        stage9Menu.position = ccp(600, 160);
        [stage9Menu alignItemsVertically];
        [self addChild:stage9Menu];
        
        // create and initialize the back button
        CCMenuItemImage *backButton = [CCMenuItemImage itemFromNormalImage:@"mainMenu.png" selectedImage:@"mainMenu-selected.png" target:self selector:@selector(goToMainMenu)];
        CCMenu *backMenu = [CCMenu menuWithItems:backButton, nil];
		backMenu.position = ccp( screenSize.width /2 , screenSize.height-700);
        [backMenu alignItemsVertically];
        [self addChild:backMenu];
        
	}
	return self;
}

/***** commented out.  we will go to level splash first **********
- (void)goToArmyBase {
    CCLOG(@"Stage 4 button selected, popping...");
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSplitCols transitionWithDuration:1.0 scene:[GameScene sceneWithLevel:GameLevelBasicTraining]]];
}

- (void)goToHospital {
    CCLOG(@"Stage 8 button selected, popping...");
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSplitCols transitionWithDuration:1.0 scene:[GameScene sceneWithLevel:GameLevelHospital]]];
}
 
***** commented out.  we will go to level splash first **********/

- (void)goToMainMenu  
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:0.5 scene:[MainMenuScene scene]]];
}

- (void)goToLevel1Splash 
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5 scene:[LevelSplashScene sceneForLevel:1]]];
}

- (void)goToLevel2Splash 
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5 scene:[LevelSplashScene sceneForLevel:2]]];
}

- (void)goToLevel3Splash 
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5 scene:[LevelSplashScene sceneForLevel:3]]];
}

- (void)goToLevel4Splash 
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5 scene:[LevelSplashScene sceneForLevel:4]]];
}

- (void)goToLevel5Splash 
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5 scene:[LevelSplashScene sceneForLevel:5]]];
}

- (void)goToLevel6Splash 
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5 scene:[LevelSplashScene sceneForLevel:6]]];
}

- (void)goToLevel7Splash 
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5 scene:[LevelSplashScene sceneForLevel:7]]];
}

- (void)goToLevel8Splash 
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5 scene:[LevelSplashScene sceneForLevel:8]]];
}

- (void)goToLevel9Splash 
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5 scene:[LevelSplashScene sceneForLevel:9]]];
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


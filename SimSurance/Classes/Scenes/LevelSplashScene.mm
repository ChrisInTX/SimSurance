//
//  LevelSplashScene.m
//  SimSurance
//
//  Created by Rich Tanner on 8/18/11.
//  Copyright 2011 Redshirt Interactive Technologies. All rights reserved.
//

#import "LevelSplashScene.h"
#import "MainMenuScene.h"
#import "StageSelectScene.h"
#import "GameScene.h"

@implementation LevelSplashScene

@synthesize level = level_;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LevelSplashScene *layer = [LevelSplashScene node];  //  nodeWithLevel:levelz];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

+(CCScene *) sceneForLevel:(int)levelz {
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LevelSplashScene *layer = [LevelSplashScene nodeWithLevel:levelz];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

+(id) nodeWithLevel:(int)level
{
	return [[[self alloc] initWithLevel:level] autorelease];
}

-(id)initWithLevel:(int)levelz {
    self.level = levelz;
    return [self init];
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        self.isTouchEnabled = YES;
        NSString *backgroundImage = @"splashSubmenu.png";
        CCMenuItemImage *backButton = [CCMenuItemImage itemFromNormalImage:@"RedCarRounder.png" selectedImage:@"sport_red_wreck.png" target:self selector:@selector(goToStageSelect)];
        
        
        //here we will set the title of our levels background image, and do anything special we need to do for the "next" button, such as different images and different @selectors
        switch (self.level) {
            case LevelSplashOne:
                       
                backgroundImage = @"levelOneSplash.png";
                backButton = [CCMenuItemImage itemFromNormalImage:@"goButton.png" selectedImage:@"goButton-selected.png" target:self selector:@selector(goToStageSelect)];

                break;
            case LevelSplashTwo:
                
                backgroundImage = @"levelTwoSplash.png";
                backButton = [CCMenuItemImage itemFromNormalImage:@"goButton.png" selectedImage:@"goButton-selected.png" target:self selector:@selector(goToStageSelect)];
                
                break;
            case LevelSplashThree:
                
                backgroundImage = @"levelThreeSplash.png";
                backButton = [CCMenuItemImage itemFromNormalImage:@"goButton.png" selectedImage:@"goButton-selected.png" target:self selector:@selector(goToStageSelect)];
                
                break;
            case LevelSplashFour:
                
                backgroundImage = @"levelFourSplash.png";
                backButton = [CCMenuItemImage itemFromNormalImage:@"goButton.png" selectedImage:@"goButton-selected.png" target:self selector:@selector(goToArmyBase)];
                
                break;
            case LevelSplashFive:
                
                backgroundImage = @"levelFiveSplash.png";
                backButton = [CCMenuItemImage itemFromNormalImage:@"goButton.png" selectedImage:@"goButton-selected.png" target:self selector:@selector(goToStageSelect)];
                
                break;
            case LevelSplashSix:
                
                backgroundImage = @"levelSixSplash.png";
                backButton = [CCMenuItemImage itemFromNormalImage:@"goButton.png" selectedImage:@"goButton-selected.png" target:self selector:@selector(goToStageSelect)];
                
                break;
            case LevelSplashSeven:
                
                backgroundImage = @"levelSevenSplash.png";
                backButton = [CCMenuItemImage itemFromNormalImage:@"goButton.png" selectedImage:@"goButton-selected.png" target:self selector:@selector(goToStageSelect)];
                
                break;
            case LevelSplashEight:
                
                backgroundImage = @"levelOneSplash.png";
                backButton = [CCMenuItemImage itemFromNormalImage:@"goButton.png" selectedImage:@"goButton-selected.png" target:self selector:@selector(goToHospital)];
                
                break;
            case LevelSplashNine:
            
                backgroundImage = @"levelNineSplash.png";
                backButton = [CCMenuItemImage itemFromNormalImage:@"goButton.png" selectedImage:@"goButton-selected.png" target:self selector:@selector(goToStageSelect)];

                break;
            default:
                break;
        }
        // create and initialize the background image
        CCSprite *background = [CCSprite spriteWithFile:backgroundImage];
        CGSize size = [[CCDirector sharedDirector] winSize];
        background.position =  ccp( size.width /2 , size.height/2 );
        [self addChild:background];  
        
        
        // create and initialize the back button
        
        CCMenu *backMenu = [CCMenu menuWithItems:backButton, nil];
        backMenu.position = ccp( screenSize.width /2 , screenSize.height-700);
        [backMenu alignItemsVertically];
        [self addChild:backMenu];
        
	}
	return self;
}

- (void)goToStageSelect {
   [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:0.5 scene:[StageSelectScene scene]]];
}

- (void)goToArmyBase {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSplitCols transitionWithDuration:1.0 scene:[GameScene sceneWithLevel:GameLevelBasicTraining]]];
}

- (void)goToHospital {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSplitCols transitionWithDuration:1.0 scene:[GameScene sceneWithLevel:GameLevelHospital]]];
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



//
//  MainMenuLayer.m
//  SimSurance
//
//  Created by Chris Lowe on 6/25/11.
//  Copyright 2011 USAA. All rights reserved.
//

#import "MainMenuScene.h"
#import "GameScene.h"
#import "AboutScene.h"
#import "DriversEdStartScene.h"
#import "SettingsScene.h"
#import "CCBReader.h"
#import "SimpleAudioEngine.h"

@implementation MainMenuScene

//+(CCScene *) scene
//{
//	// 'scene' is an autorelease object.
//	CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"MainMenu.ccb"];
//	
//    // return the scene
//	return scene;
//}
//
//- (void) didLoadFromCCB
//{
//    // Need to readjust the center point - I set it up wrong in Cocos Builder :(
//    self.position = CGPointMake([[CCDirector sharedDirector] winSize].width/2, [[CCDirector sharedDirector] winSize].height/2);
//}
//
//// on "init" you need to initialize your instance
//-(id) init
//{
//	// always call "super" init
//	// Apple recommends to re-assign "self" with the "super" return value
//	if( (self=[super init])) {
//        
//        self.isTouchEnabled = YES;
//        NSLog(@"*** In MainMenu Scene");
//
//        // ****************
//        // This Scene is setup in the MainMenu.ccb file from CocosBuilder
//		// ****************
//        
//    }
//    
//    return self;
//    
//}


+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenuScene *layer = [MainMenuScene node];
	
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
		CCSprite *background = [CCSprite spriteWithFile:@"splashMain.png"];
        CGSize size = [[CCDirector sharedDirector] winSize];
        background.position =  ccp( size.width /2 , size.height/2 );
        [self addChild:background];  
        
//        NSString *labelText = @"About\n--------- \n\n Created by:\nChris Lowe\nRich Tanner\n\n USAA Auto Insurance Prototype\n2011";
//        
//        CGSize maxSize = { 2450, 2000 };
//        CGSize actualSize = [labelText sizeWithFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:32]
//                                  constrainedToSize:maxSize
//                                      lineBreakMode:UILineBreakModeWordWrap];
//        
//        CGSize containerSize = { actualSize.width, actualSize.height };
//        
//        CCLabelTTF *label = [CCLabelTTF labelWithString:labelText dimensions:containerSize
//                                              alignment:UITextAlignmentCenter
//                                               fontName:@"AmericanTypewriter-Bold"
//                                               fontSize:32];
//        label.color = ccWHITE;
//        label.position =  ccp( screenSize.width /2 , screenSize.height/2 );
//        
//        [self addChild:label];
        
        // create and initialize the back button
        CCMenuItemImage *tutButton = [CCMenuItemImage itemFromNormalImage:@"tutorialMenuItem.png" selectedImage:@"tutorialMenuItem-selected.png" target:self selector:@selector(playButtonTopSelected:)];;
        CCMenu *tutMenu = [CCMenu menuWithItems:tutButton, nil];
		tutMenu.position = ccp( screenSize.width -120 , screenSize.height-50);
        [tutMenu alignItemsVertically];
        [self addChild:tutMenu];
        
        CCMenuItemImage *playButton = [CCMenuItemImage itemFromNormalImage:@"playMenuItem.png" selectedImage:@"playMenuItem-selected.png" target:self selector:@selector(playButtonBottomSelected:)];;
        CCMenu *playMenu = [CCMenu menuWithItems:playButton, nil];
		playMenu.position = ccp( screenSize.width -120 , screenSize.height-120);
        [playMenu alignItemsVertically];
        [self addChild:playMenu];

        CCMenuItemImage *aboutButton = [CCMenuItemImage itemFromNormalImage:@"aboutMenuItem.png" selectedImage:@"aboutMenuItem-selected.png" target:self selector:@selector(aboutButtonSelected:)];;
        CCMenu *aboutMenu = [CCMenu menuWithItems:aboutButton, nil];
		aboutMenu.position = ccp( screenSize.width -120 , screenSize.height-190);
        [aboutMenu alignItemsVertically];
        [self addChild:aboutMenu];

        CCMenuItemImage *settingsButton = [CCMenuItemImage itemFromNormalImage:@"settingsMenuItem.png" selectedImage:@"settingsMenuItem-selected.png" target:self selector:@selector(settingsButtonSelected:)];;
        CCMenu *settingsMenu = [CCMenu menuWithItems:settingsButton, nil];
		settingsMenu.position = ccp( screenSize.width -120 , screenSize.height-260);
        [settingsMenu alignItemsVertically];
        [self addChild:settingsMenu];

        
	}
	return self;
}


-(void)playButtonTopSelected:(id)sender  
{
    NSLog(@"** Play!!!");
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSplitCols transitionWithDuration:1.0 scene: [DriversEdStartScene scene]]];
}

-(void)playButtonBottomSelected:(id)sender  
{
    NSLog(@"** Play!!!");
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSplitCols transitionWithDuration:1.0 scene:[GameScene sceneWithLevel:GameLevelHospital]]];
}

-(void)aboutButtonSelected:(id)sender  
{
    NSLog(@"** About!!!");
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:1.0 scene:[AboutScene scene]]];

}

-(void)settingsButtonSelected:(id)sender  
{
    NSLog(@"** Settings!!!");
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInB transitionWithDuration:1.0 scene:[SettingsScene scene]]];

}

@end

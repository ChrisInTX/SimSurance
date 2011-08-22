//
//  PauseLayer.m
//  SimSurance
//
//  Created by Chris Lowe on 6/23/11.
//  Copyright 2011 USAA. All rights reserved.
//

#import "PauseLayer.h"
#import "GameScene.h"
#import "MainMenuScene.h"
#import "SimpleAudioEngine.h"

@implementation PauseLayer

-(id) init
{
	if ((self = [super initWithColor:ccc4(139, 137, 137, 200)])) // Random Gray Color
	{
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Game Paused!" fontName:@"Marker Felt" fontSize:45];
		label.color = ccWHITE;
		label.position = CGPointMake(screenSize.width/2,screenSize.height/2+200);
		//label.anchorPoint = CGPointMake(0.5f, 1);
		[self addChild:label z:0 tag:1000];
        
        CCMenuItemImage *play = [CCMenuItemImage itemFromNormalImage:@"playMenuItem.png" selectedImage:@"playMenuItem-selected.png" target:self selector:@selector(playButtonSelected)];        
        CCMenuItemImage *back = [CCMenuItemImage itemFromNormalImage:@"mainMenu.png" selectedImage:@"mainMenu-selected.png" target:self selector:@selector(mainMenuButtonSelected)];
        CCMenuItemImage *achivements = [CCMenuItemImage itemFromNormalImage:@"achievementMenuItem.png" selectedImage:@"achievementMenuItem-selected.png" target:self selector:@selector(achivementsButtonSelected)];        
        CCMenuItemImage *leaderboard = [CCMenuItemImage itemFromNormalImage:@"leaderboardMenuItem.png" selectedImage:@"leaderboardMenuItem-selected.png" target:self selector:@selector(leaderboardButtonSelected)];        

        CCMenu *menu = [CCMenu menuWithItems:back, play, leaderboard, achivements, nil];
        menu.position =  ccp( screenSize.width /2 , screenSize.height/2);
        [menu alignItemsVertically];
        [self addChild:menu];
        
    }
	return self;
}

- (void)updateMainLabelWithText:(NSString *)text {
    CCLabelTTF *label = (CCLabelTTF *)[self getChildByTag:1000];
    [label setString:text];
}
- (void)mainMenuButtonSelected  
{
    if (musicSwitch && musicSwitch.superview) {
        [musicSwitch removeFromSuperview]; // Need to remove the Switch from the OpenGL view manually (Since its a UIKit Element)
        musicSwitch = nil;
    }
    
    CCLOG(@"Main Menu button selected, popping...");
    [[GameScene sharedGameScene] setShowingPausedMenu:NO];
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSplitRows transitionWithDuration:1.0 scene:[MainMenuScene scene]]];
    [[GameScene sharedGameScene] removeChildByTag:GameScenePauseTag cleanup:YES];
    
}

-(void)playButtonSelected
{
    if (musicSwitch && musicSwitch.superview) {
        [musicSwitch removeFromSuperview]; // Need to remove the Switch from the OpenGL view manually (Since its a UIKit Element)
        musicSwitch = nil;
    }
    
    [[GameScene sharedGameScene] setShowingPausedMenu:NO];
    [[CCDirector sharedDirector] resume];
    
    [[GameScene sharedGameScene] removeChildByTag:GameScenePauseTag cleanup:YES];
   

}

- (void)achivementsButtonSelected {
    [[GameScene sharedGameScene] showAchievements];
}

- (void)leaderboardButtonSelected {
    [[GameScene sharedGameScene] showLeaderboard];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

-(void) dealloc
{
	[super dealloc];
}

- (void)onEnterTransitionDidFinish {
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    [super onEnterTransitionDidFinish];
    
    NSString *labelText = @"Music";
    CGSize maxSize = { 2450, 2000 };
    CGSize actualSize = [labelText sizeWithFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:32]
                              constrainedToSize:maxSize
                                  lineBreakMode:UILineBreakModeWordWrap];
    
    CGSize containerSize = { actualSize.width, actualSize.height };
    CCLabelTTF *label = [CCLabelTTF labelWithString:labelText dimensions:containerSize
                                          alignment:UITextAlignmentCenter
                                           fontName:@"AmericanTypewriter-Bold"
                                           fontSize:32];
    label.color = ccWHITE;
    label.position =  ccp( screenSize.width /2-60 , 230 );
    [self addChild:label];
    
    BOOL playMusic = [[NSUserDefaults standardUserDefaults] boolForKey:@"playBackgroundMusic"];
    musicSwitch = [[ UISwitch alloc ] initWithFrame: CGRectMake(screenSize.width/2+15, 525, 0,0) ];
    musicSwitch.on = !playMusic;  //set to be ON at start
    musicSwitch.tag = 1;    // this is not necessary - only to find later
    [musicSwitch addTarget:self action:@selector(muteMusic) forControlEvents:UIControlEventValueChanged];
    [[[CCDirector sharedDirector] openGLView] addSubview:musicSwitch];
    //[musicSwitch release];   // don't forget to release memory
}

- (void)muteMusic
{
    
    if([[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying])
    {
        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
    } else {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"My Dog Blue.mp3"];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:musicSwitch.on forKey:@"playBackgroundMusic"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


@end

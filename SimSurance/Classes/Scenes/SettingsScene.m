//
//  SetingsScene.m
//  SimSurance
//
//  Created by Chris Lowe on 6/25/11.
//  Copyright 2011 USAA. All rights reserved.
//

#import "SettingsScene.h"
#import "MainMenuScene.h"
#import "SimpleAudioEngine.h"

@implementation SettingsScene
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SettingsScene *layer = [SettingsScene node];
	
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
		CCSprite *background = [CCSprite spriteWithFile:@"splashSubmenu.png"];
        background.position =  ccp( screenSize.width /2 , screenSize.height/2 );
        [self addChild:background];  
        
        NSString *labelText = @"Settings \n\n Here you can do stuff.\n Like read this message.\n\n Music:   ";
        
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
        label.position =  ccp( screenSize.width /2 , screenSize.height/2 );
        
        [self addChild:label];
        
        
        CCMenuItemImage *back = [CCMenuItemImage itemFromNormalImage:@"mainMenu.png" selectedImage:@"mainMenu-selected.png" target:self selector:@selector(goToMainMenu)];
        CCMenu *menu = [CCMenu menuWithItems:back, nil];
        menu.position =  ccp( screenSize.width /2 , screenSize.height-700);
        [menu alignItemsVertically];
        [self addChild:menu];
        
    }
	return self;
}

- (void)onEnterTransitionDidFinish {
    CGSize screenSize = [[CCDirector sharedDirector] winSize];

    [super onEnterTransitionDidFinish];
    BOOL playMusic = [[NSUserDefaults standardUserDefaults] boolForKey:@"playBackgroundMusic"];
    musicSwitch = [[ UISwitch alloc ] initWithFrame: CGRectMake(screenSize.width/2, screenSize.height-250, 0,0) ];
    musicSwitch.on = playMusic;  //set to be ON at start
    musicSwitch.tag = 1;  // this is not necessary - only to find later
    [musicSwitch addTarget:self action:@selector(muteMusic) forControlEvents:UIControlEventValueChanged];
    [[[CCDirector sharedDirector] openGLView] addSubview:musicSwitch];
    [musicSwitch release];   // don't forget to release memory
}
- (void)goToMainMenu  
{
    [musicSwitch removeFromSuperview]; // Need to remove the Switch from the OpenGL view manually (Since its a UIKit Element)
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInT transitionWithDuration:0.5 scene:[MainMenuScene scene]]];
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

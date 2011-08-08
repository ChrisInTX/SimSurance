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

@implementation PauseLayer

-(id) init
{
	if ((self = [super initWithColor:ccc4(139, 137, 137, 200)])) // Random Gray Color
	{
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Game Paused!" fontName:@"Marker Felt" fontSize:45];
		label.color = ccBLACK;
		label.position = CGPointMake(screenSize.width/2,screenSize.height/2+200);
		//label.anchorPoint = CGPointMake(0.5f, 1);
		[self addChild:label z:0 tag:1];
        
        CCMenuItemImage *play = [CCMenuItemImage itemFromNormalImage:@"playMenuItem.png" selectedImage:@"playMenuItem-selected.png" target:self selector:@selector(playButtonSelected)];        
        CCMenuItemImage *back = [CCMenuItemImage itemFromNormalImage:@"mainMenu.png" selectedImage:@"mainMenu-selected.png" target:self selector:@selector(mainMenuButtonSelected)];
        CCMenu *menu = [CCMenu menuWithItems:back, play, nil];
        menu.position =  ccp( screenSize.width /2 , screenSize.height/2);
        [menu alignItemsVertically];
        [self addChild:menu];
        
    }
	return self;
}

- (void)mainMenuButtonSelected  
{
    CCLOG(@"Main Menu button selected, popping...");
    [[GameScene sharedGameScene] setShowingPausedMenu:NO];
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSplitRows transitionWithDuration:1.0 scene:[MainMenuScene scene]]];
    [[GameScene sharedGameScene] removeChildByTag:GameScenePauseTag cleanup:YES];

}

-(void)playButtonSelected
{
    [[GameScene sharedGameScene] setShowingPausedMenu:NO];
    [[CCDirector sharedDirector] resume];
    [[GameScene sharedGameScene] removeChildByTag:GameScenePauseTag cleanup:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

-(void) dealloc
{
	[super dealloc];
}

@end

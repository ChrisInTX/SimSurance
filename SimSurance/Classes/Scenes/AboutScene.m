//
//  AboutScene.m
//  InsuroRacer
//
//  Created by Chris Lowe on 5/27/11.
//  Copyright 2011 USAA. All rights reserved.
//

#import "AboutScene.h"
#import "MainMenuScene.h"

@implementation AboutScene

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	AboutScene *layer = [AboutScene node];
	
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
        CGSize size = [[CCDirector sharedDirector] winSize];
        background.position =  ccp( size.width /2 , size.height/2 );
        [self addChild:background];  
        
        NSString *labelText = @"About\n--------- \n\n Created by:\nChris Lowe\nRich Tanner\n\n USAA Auto Insurance Prototype\n2011";
        
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

        // create and initialize the back button
        CCMenuItemImage *backButton = [CCMenuItemImage itemFromNormalImage:@"mainMenu.png" selectedImage:@"mainMenu-selected.png" target:self selector:@selector(goToMainMenu)];;
        CCMenu *backMenu = [CCMenu menuWithItems:backButton, nil];
		backMenu.position = ccp( screenSize.width /2 , screenSize.height-700);
        [backMenu alignItemsVertically];
        [self addChild:backMenu];
                
	}
	return self;
}

- (void)goToMainMenu  
{
    CCLOG(@"Main Menu button selected, popping...");
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInB transitionWithDuration:1.0 scene:[MainMenuScene scene]]];
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

//
//  GameOverScene.m
//  SimSurance
//
//  Created by Chris Lowe on 7/28/11.
//  Copyright 2011 USAA. All rights reserved.
//

#import "GameOverScene.h"


@implementation GameOverScene

-(id)initWithLevel:(int)levelz {
    gameLevel = levelz;
    return [self init];
}

+(id) nodeWithLevel:(int)level
{
	return [[[self alloc] initWithLevel:level] autorelease];
}

+(CCScene *) sceneWithLevel:(int)levelz
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameOverScene *layer = [GameOverScene nodeWithLevel:levelz];
    
	// add layer as a child to scene
	[scene addChild:layer z:-2 tag:-2];

	// return the scene
	return scene;
}





-(id) init
{
	if ((self = [super initWithColor:ccc4(139, 137, 137, 200)]))
	{
//        CGSize screenSize = [[CCDirector sharedDirector] winSize];
//
//        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Game Paused!" fontName:@"Marker Felt" fontSize:45];
//		label.color = ccWHITE;
//		label.position = CGPointMake(screenSize.width/2,screenSize.height/2+200);
//		//label.anchorPoint = CGPointMake(0.5f, 1);
//		[self addChild:label z:0 tag:1];
//        
//        CCMenuItemImage *play = [CCMenuItemImage itemFromNormalImage:@"playMenuItem.png" selectedImage:@"playMenuItem-selected.png" target:self selector:@selector(playButtonSelected)];        
//        CCMenuItemImage *back = [CCMenuItemImage itemFromNormalImage:@"mainMenu.png" selectedImage:@"mainMenu-selected.png" target:self selector:@selector(mainMenuButtonSelected)];
//        CCMenu *menu = [CCMenu menuWithItems:back, play, nil];
//        menu.position =  ccp( screenSize.width /2 , screenSize.height/2);
//        [menu alignItemsVertically];
//        [self addChild:menu];
	}
	
	return self;
}

-(void) dealloc
{
	[super dealloc];
}
@end

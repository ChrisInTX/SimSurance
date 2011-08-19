//
//  HUDLayer.m
//  SimSurance
//
//  Created by Chris Lowe on 6/21/11.
//  Copyright 2011 USAA. All rights reserved.
//

#import "HUDLayer.h"
#import "GameScene.h"

@implementation HUDLayer

-(id) init
{
	if ((self = [super initWithColor:ccc4(122, 122, 122, 1)]))
	{
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        CCSprite* uiframe = [CCSprite spriteWithFile:@"dashboard.png"];
        uiframe.scaleX = 1.0f;
        uiframe.scaleY = 1.0f;
		uiframe.position = CGPointMake(0, screenSize.height);
		uiframe.anchorPoint = CGPointMake(0, 1);
		[self addChild:uiframe z:-1];
		
        NSString *amount = @"";
        if ([[GameScene sharedGameScene] level] == GameLevelDriversEd) {
            dollarAmount = 100;
            amount = [NSString stringWithFormat:@"%i Points", dollarAmount];
        } else {
            dollarAmount = 5000;
            amount = [NSString stringWithFormat:@"$%i", dollarAmount];
        }
        
        // These values are hard coded for Drivers Ed, should be refacotred for more flexability
		amountLabel = [CCLabelTTF labelWithString:amount fontName:@"Marker Felt" fontSize:22];
		amountLabel.color = ccRED;
		amountLabel.position = CGPointMake(188,753);
		amountLabel.anchorPoint = CGPointMake(0.5f, 1);
		[self addChild:amountLabel z:0 tag:kAmountLabel];

		messageLabel = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:55];
		messageLabel.color = ccRED;
		messageLabel.position = CGPointMake(700,740);
		messageLabel.anchorPoint = CGPointMake(0.5f, 1);
		[self addChild:messageLabel z:0 tag:kMessageLabel];
        
        CCMenuItemImage *pause = [CCMenuItemImage itemFromNormalImage:@"pauseButton.png" selectedImage:@"pauseButtonPressed.png" target:self selector:@selector(pauseButtonSelected)];
        CCMenu *menu = [CCMenu menuWithItems:pause, nil];
        menu.position = CGPointMake(screenSize.width - 35, screenSize.height - 35); // top right corner (based on center point of object)
        [self addChild:menu z:0 tag:kPauseButton];
    }
	
	return self;
}
- (void)pauseButtonSelected {
    NSLog(@"** Pause");
    if (![[GameScene sharedGameScene] isShowingPausedMenu]) {
        [[GameScene sharedGameScene] setShowingPausedMenu:YES];
        [[GameScene sharedGameScene] showPausedMenu];
        [[CCDirector sharedDirector] pause];
    }
    
}
-(void) updatePointCounter:(int)amount
{
    
    if ([[GameScene sharedGameScene] level] == GameLevelDriversEd) {
        dollarAmount += amount;
        if (dollarAmount < 75 && dollarAmount > 50) {
            [amountLabel setColor:ccORANGE];
        } else if (dollarAmount < 50) {
            dollarAmount = 0;
            [amountLabel setColor:ccRED];
        }
        
        NSString *amounts = [NSString stringWithFormat:@"%i Points", dollarAmount];
        [amountLabel setString:amounts];
    } else {
        dollarAmount += amount;
        if (dollarAmount < 4000 && dollarAmount > 2000) {
            [amountLabel setColor:ccORANGE];
        } else if (dollarAmount < 2000 && dollarAmount > 0) {
            [amountLabel setColor:ccYELLOW];
        } else {
            [amountLabel setColor:ccRED];
        }
        
        NSString *amounts = [NSString stringWithFormat:@"$%i", dollarAmount];
        [amountLabel setString:amounts];
    }
    
    
}

-(void) updatePointCounter:(int)amount withMessage:(NSString *)message {
    [self updatePointCounter:amount];
    
    id blinkAction = [CCBlink actionWithDuration:2.0 blinks:3];
    // id fadeAction = [CCFadeOut actionWithDuration:3.0];
    [messageLabel stopAllActions];
    [messageLabel setString:message];
    [messageLabel runAction:blinkAction];
    //[CCSequence actionOne:blinkAction two:fadeAction]];
}

- (int)currentPointAmount {
    return dollarAmount;
}

-(void) dealloc
{
	[super dealloc];
}

@end

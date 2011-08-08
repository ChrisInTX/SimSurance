//
//  InputLayer.h
//  InsuroRacer
//
//  Created by Chris Lowe on 6/1/11.
//  Copyright 2011 USAA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// SneakyInput headers
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedBase.h"
#import "ColoredCircleSprite.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "SneakyExtensions.h"

@interface InputLayer : CCLayer 
{
	SneakyJoystick* joystick;
    SneakyButton *gasPedal;
    SneakyButton *brakePedal;
    CGPoint lastVelocity;
}
- (void)addGasPedal;
- (void)addBrakePedal;
@end

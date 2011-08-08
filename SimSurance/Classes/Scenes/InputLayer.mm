//
//  InputLayer.m
//  InsuroRacer
//
//  Created by Chris Lowe on 6/1/11.
//  Copyright 2011 USAA. All rights reserved.
//

#import "InputLayer.h"
#import "GameScene.h"

@interface InputLayer (PrivateMethods)
-(void) addJoystick;
@end

@implementation InputLayer

-(id) init
{
	if ((self = [super init]))
	{
        lastVelocity = ccp(0,0);
		[self addJoystick];	
        [self addGasPedal];
        [self addBrakePedal];
        [self schedule:@selector(joystickTick:) interval:1.0f/30.0f];
	}
	
	return self;
}

-(void) dealloc
{
	[super dealloc];
}

-(void) addJoystick
{
    // Setting up SneakyJoystick
	float stickRadius = 50;
    
	joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0, 0, stickRadius, stickRadius)];
	joystick.deadRadius = 10.0f;
	SneakyJoystickSkinnedBase* skinStick = [[[SneakyJoystickSkinnedBase alloc] init] autorelease];
	skinStick.position = CGPointMake(stickRadius * 3.0f, stickRadius * 3.0f);
	skinStick.backgroundSprite = [CCSprite spriteWithFile:@"steering_wheel.png"];
    skinStick.thumbSprite.color = ccBLACK;
    skinStick.thumbSprite = [ColoredCircleSprite circleWithColor:ccc4(100, 100, 100, 100) radius:48];
    joystick.deadRadius = 20;
	skinStick.joystick = joystick;
	[self addChild:skinStick z:0 tag:12];
}

-(void) addGasPedal
{
	float buttonRadius = 50;
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
	gasPedal = [SneakyButton button];
	gasPedal.isHoldable = YES;
	
	SneakyButtonSkinnedBase* skinFireButton = [SneakyButtonSkinnedBase skinnedButton];
	skinFireButton.position = CGPointMake(screenSize.width - buttonRadius, buttonRadius * 2.0f);
	skinFireButton.defaultSprite = [CCSprite spriteWithFile:@"gas.png"];
	skinFireButton.pressSprite = [CCSprite spriteWithFile:@"gas_down.png"];
	skinFireButton.button = gasPedal;
	[self addChild:skinFireButton];
}

-(void) addBrakePedal
{
	float buttonRadius = 50;
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
	brakePedal = [SneakyButton button];
	brakePedal.isHoldable = YES;
	
	SneakyButtonSkinnedBase* skinFireButton = [SneakyButtonSkinnedBase skinnedButton];
	skinFireButton.position = CGPointMake(screenSize.width - buttonRadius * 3.5f, buttonRadius * 2.0f);
	skinFireButton.defaultSprite = [CCSprite spriteWithFile:@"brake.png"];
	skinFireButton.pressSprite = [CCSprite spriteWithFile:@"brake_down.png"];
	skinFireButton.button = brakePedal;
	[self addChild:skinFireButton];
}

-(void) joystickTick: (ccTime) dt {
	
	// Apply the joystick movement
	SneakyJoystickSkinnedBase *joy = (SneakyJoystickSkinnedBase *)[self getChildByTag:12];
	CGPoint scaledVelocity = ccpMult(joy.joystick.velocity, 1024.0f / 100); 
	
    // Move it if possible	
	if (CGPointEqualToPoint(lastVelocity, scaledVelocity) == NO) {
        if(scaledVelocity.x == 0) { // If we are not touching the wheel
            [GameScene sharedGameScene].steeringAngle = 0.0f;
        }
        else if(scaledVelocity.x > 0) { // If the wheel is to the right
            [GameScene sharedGameScene].steeringAngle = 0.085f;
        }
        else { // If the wheel is to the left
            [GameScene sharedGameScene].steeringAngle = -0.085f;
        }
    }
	
    lastVelocity = scaledVelocity;
    
	if(gasPedal.value) {
        if ([GameScene sharedGameScene].engineSpeed <= 6.5) { // Speeding up
            [GameScene sharedGameScene].engineSpeed = [GameScene sharedGameScene].engineSpeed + 1.0f; // Increment by 1
            NSLog(@"** Speeding up by 1");
        }
	}
    else if (brakePedal.value) { // You should slow down faster braking, than normal slowing
        if ([GameScene sharedGameScene].engineSpeed > 0) { // Slowing down
            [GameScene sharedGameScene].engineSpeed = [GameScene sharedGameScene].engineSpeed - 3.0f; // Braking
            NSLog(@"** Slowing down to 0");
        } else {
            if ([GameScene sharedGameScene].engineSpeed > -3) { // Reverse
            [GameScene sharedGameScene].engineSpeed = [GameScene sharedGameScene].engineSpeed - 1.0f; // Natural slow down
            }
        }
    } else {
        if ([GameScene sharedGameScene].engineSpeed > 0) { // 2nd Natural slow down
            [GameScene sharedGameScene].engineSpeed = [GameScene sharedGameScene].engineSpeed - 1.0f;
            NSLog(@"** Slowing down by 1");
        } else if ([GameScene sharedGameScene].engineSpeed < 0) { // Compensate to come to a stop
            [GameScene sharedGameScene].engineSpeed = [GameScene sharedGameScene].engineSpeed + 1.0f;
            NSLog(@"** Speeding up by 1 from drift");
        } else {
            [GameScene sharedGameScene].engineSpeed = 0.0f; // Failsafe, kill the enginge
        }
        
    }
}

@end


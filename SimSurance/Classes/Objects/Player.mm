////
////  Player.m
////  InsuroRacer
////
////  Created by Chris Lowe on 6/1/11.
////  Copyright 2011 USAA. All rights reserved.
////
//
//#import "Player.h"
//#import "GameScene.h"
//
//@implementation Player
//
//+(id)playerWithPosition:(CGPoint)position
//{
//	return [[[self alloc] initWithCarPosition:position] autorelease];
//}
//
//-(id)initWithCarPosition:(CGPoint)position
//{
//    
//	if ((self = [super initWithFile:@"RedCarRounder.png"])) {
//        
//        self.position = position;
//        engineSpeed = 0;
//        steeringAngle = 0;
//        
//        // define our body
//        b2BodyDef bodyDef;
//        bodyDef.type = b2_dynamicBody;
//        bodyDef.position.Set(position.x/PTM_RATIO, position.y/PTM_RATIO);
//        bodyDef.userData = self;
//        bodyDef.linearDamping = 1;
//        bodyDef.angularDamping = 1;
//        body = [[GameScene sharedGameScene] world]->CreateBody(&bodyDef);
//        
//        float boxW = 0.3f;
//        float boxH = 0.7f;
//        float wheelW = 0.08f;
//        float wheelH = 0.2f;
//        float wheelX = 0.35f;
//        float wheelY = 0.35f;
//        
//        // Front Wheels
//        // Left
//        b2BodyDef leftWheelDef;
//        leftWheelDef.type = b2_dynamicBody;
//        leftWheelDef.position.Set(position.x/PTM_RATIO-wheelX, position.y/PTM_RATIO-wheelY);
//        leftWheel = [[GameScene sharedGameScene] world]->CreateBody(&leftWheelDef);
//        
//        // Right
//        b2BodyDef rightWheelDef;
//        rightWheelDef.type = b2_dynamicBody;
//        rightWheelDef.position.Set(position.x/PTM_RATIO+wheelX, position.y/PTM_RATIO-wheelY);
//        rightWheel = [[GameScene sharedGameScene] world]->CreateBody(&rightWheelDef);
//        
//        // Back Wheels
//        // Left
//        b2BodyDef leftRearWheelDef;
//        leftRearWheelDef.type = b2_dynamicBody;
//        leftRearWheelDef.position.Set(position.x/PTM_RATIO-wheelX, position.y/PTM_RATIO+wheelY);
//        leftRearWheel = [[GameScene sharedGameScene] world]->CreateBody(&leftRearWheelDef);
//        // Right
//        b2BodyDef rightRearWheelDef;
//        rightRearWheelDef.type = b2_dynamicBody;
//        rightRearWheelDef.position.Set(position.x/PTM_RATIO+wheelX, position.y/PTM_RATIO+wheelY);
//        rightRearWheel = [[GameScene sharedGameScene] world]->CreateBody(&rightRearWheelDef);
//        
//        // define our shapes
//        b2PolygonShape boxDef;
//        boxDef.SetAsBox(boxW,boxH);
//        b2FixtureDef fixtureDef;
//        fixtureDef.shape = &boxDef;
//        fixtureDef.density = 1.0F;
//        fixtureDef.friction = 0.3f;
//        body->CreateFixture(&fixtureDef);
//        
//        //Left Front Wheel shape
//        b2PolygonShape leftWheelShapeDef;
//        leftWheelShapeDef.SetAsBox(wheelW, wheelH);
//        b2FixtureDef fixtureDefLeftWheel;
//        fixtureDefLeftWheel.shape = &leftWheelShapeDef;
//        fixtureDefLeftWheel.density = 1.0F;
//        fixtureDefLeftWheel.friction = 0.3f;
//        leftWheel->CreateFixture(&fixtureDefLeftWheel);
//        
//        //Right Front Wheel shape
//        b2PolygonShape rightWheelShapeDef;
//        rightWheelShapeDef.SetAsBox(wheelW, wheelH);
//        b2FixtureDef fixtureDefRightWheel;
//        fixtureDefRightWheel.shape = &rightWheelShapeDef;
//        fixtureDefRightWheel.density = 1.0F;
//        fixtureDefRightWheel.friction = 0.3f;
//        rightWheel->CreateFixture(&fixtureDefRightWheel);
//        
//        //Left Back Wheel shape
//        b2PolygonShape leftRearWheelShapeDef;
//        leftRearWheelShapeDef.SetAsBox(wheelW, wheelH);
//        b2FixtureDef fixtureDefLeftRearWheel;
//        fixtureDefLeftRearWheel.shape = &leftRearWheelShapeDef;
//        fixtureDefLeftRearWheel.density = 1.0F;
//        fixtureDefLeftRearWheel.friction = 0.3f;
//        leftRearWheel->CreateFixture(&fixtureDefLeftRearWheel);
//        
//        //Right Back Wheel shape
//        b2PolygonShape rightRearWheelShapeDef;
//        rightRearWheelShapeDef.SetAsBox(wheelW, wheelH);
//        b2FixtureDef fixtureDefRightRearWheel;
//        fixtureDefRightRearWheel.shape = &rightRearWheelShapeDef;
//        fixtureDefRightRearWheel.density = 1.0F;
//        fixtureDefRightRearWheel.friction = 0.3f;
//        rightRearWheel->CreateFixture(&fixtureDefRightRearWheel);
//        
//        // ------ JOINTS ---------
//        
//        b2RevoluteJointDef leftJointDef;
//        leftJointDef.Initialize(body, leftWheel, leftWheel->GetWorldCenter());
//        leftJointDef.enableMotor = true;
//        leftJointDef.motorSpeed = 0.0f;
//        leftJointDef.maxMotorTorque = 1000.f;
//        
//        b2RevoluteJointDef rightJointDef;
//        rightJointDef.Initialize(body, rightWheel, rightWheel->GetWorldCenter());
//        rightJointDef.enableMotor = true;
//        rightJointDef.motorSpeed = 0.0f;
//        rightJointDef.maxMotorTorque = 1000.f;
//        
//        leftJoint = (b2RevoluteJoint *) [[GameScene sharedGameScene] world]->CreateJoint(&leftJointDef);
//        rightJoint = (b2RevoluteJoint *) [[GameScene sharedGameScene] world]->CreateJoint(&rightJointDef);
//        
//        b2Vec2 wheelAngle;
//        wheelAngle.Set(1,0);
//        
//        // Join back wheels
//        // Left
//        b2PrismaticJointDef leftRearJointDef;
//        leftRearJointDef.Initialize(body, leftRearWheel, leftRearWheel->GetWorldCenter(),wheelAngle);
//        leftRearJointDef.enableLimit = true;
//        leftRearJointDef.lowerTranslation = 0.0f;
//        leftRearJointDef.upperTranslation = 0.0f;
//        (b2PrismaticJoint*) [[GameScene sharedGameScene] world]->CreateJoint(&leftRearJointDef);
//        // Right
//        b2PrismaticJointDef rightRearJointDef;
//        rightRearJointDef.Initialize(body, rightRearWheel, rightRearWheel->GetWorldCenter(),wheelAngle);
//        rightRearJointDef.enableLimit = true;
//        rightRearJointDef.lowerTranslation = 0.0f;
//        rightRearJointDef.upperTranslation = 0.0f;
//        (b2PrismaticJoint*)[[GameScene sharedGameScene] world]->CreateJoint(&rightRearJointDef);
//    }
//    
//    return self;
//}
//
//-(void) dealloc
//{
//    
//	// don't forget to call "super dealloc"
//	[super dealloc];
//}
////
////-(void) onCollideBody:(CCBodySprite *)sprite withForce:(float)force withFrictionForce:(float)frictionForce {
////    NSLog(@"** Collision Detected");
////    NSLog(@"** SPRITE: %i", sprite.collisionType);
////    if((sprite.collisionType == kObjectCollisionType)) {
////        
////        NSLog(@"** Player hit Object");
////        self.color = ccGREEN;
////        [[[GameScene sharedGameScene] gameHUD] updatePointCounter:-5 withMessage:@"DON'T HIT MY SIGNS!!"];
////        CCBodySprite *roadSign = (CCBodySprite *)sprite.userData;
////        roadSign.velocity = self.velocity;
////        [roadSign setTexture:[[CCTextureCache sharedTextureCache] addImage:@"cone_down2.png"]];
////    }
////}
//
//@end

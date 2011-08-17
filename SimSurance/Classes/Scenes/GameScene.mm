//
//  GameScene.m
//  SimSurance
//
//  Created by Chris Lowe on 6/12/11.
//  Copyright 2011 USAA. All rights reserved.
//

#import "GameScene.h"
#import "GameOverScene.h"
#import "PauseLayer.h"
#import "AppSpecificValues.h"
#import "AppDelegate.h"
#import "GKAchievementNotification.h"
#import "GKAchievementHandler.h"

@implementation GameScene
@synthesize mainPlayer = mainPlayer_, 
        tiledMap = tiledMap_, 
        backgroundLayer = backgroundLayer_, 
        stopLayer = stopLayer_, 
        wrongWayLayer = wrongWayLayer_, 
        gameHUD = gameHUD_,
        showingPausedMenu = showingPausedMenu_,
        coneLayer = coneLayer_,
        gameCenterManager = gameCenterManager_,
        currentLeaderboard = currentLeaderboard_,
        world, steeringAngle, engineSpeed, level;

+(CCScene *) sceneWithLevel:(int)levelz
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameScene *layer = [GameScene nodeWithLevel:levelz];
	InputLayer *inputLayer = [InputLayer node];
    HUDLayer *hudLayer = [HUDLayer node];
    layer.gameHUD = hudLayer; // This matches up the HUDLayer to our gameHUD property
    
	// add layer as a child to scene
	[scene addChild:layer z:-2 tag:GameSceneGameTag];
	[scene addChild:inputLayer z:0 tag:GameSceneInputTag];
    [scene addChild:hudLayer z:-1 tag:GameSceneHUDTag];
    
	// return the scene
	return scene;
}
// This is a default scene that calls the Drivers Ed method
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameScene *layer = [GameScene nodeWithLevel:GameLevelDriversEd];
	InputLayer *inputLayer = [InputLayer node];
    HUDLayer *hudLayer = [HUDLayer node];
    layer.gameHUD = hudLayer; // This matches up the HUDLayer to our gameHUD property
    
	// add layer as a child to scene
	[scene addChild:layer z:-2 tag:GameSceneGameTag];
	[scene addChild:inputLayer z:0 tag:GameSceneInputTag];
    [scene addChild:hudLayer z:-1 tag:GameSceneHUDTag];
    
	// return the scene
	return scene;
}

+(id) nodeWithLevel:(int)level
{
	return [[[self alloc] initWithLevel:level] autorelease];
}

-(id)initWithLevel:(int)levelz {
    self.level = levelz;
    return [self init];
}

// Singleton Instance of GameScene so that we manage everything through the Game loop
static GameScene* instanceOfGameScene;

+ (GameScene *) sharedGameScene
{
	NSAssert(instanceOfGameScene != nil, @"GameScene instance not yet initialized!");
	return instanceOfGameScene;
}

// Quasi-singleton Instance of Player
- (CCSprite *) defaultPlayer
{
	CCNode *node = [self getChildByTag:GameScenePlayerTag];
	NSAssert([node isKindOfClass:[CCSprite class]], @"node is not the Player!");
	return (CCSprite *)[self getChildByTag:GameScenePlayerTag];
}

- (void)addWorldToScene {
    // Define the gravity vector.
    b2Vec2 gravity;
    gravity.Set(0.0f, 0.0f);
    
    // Do we want to let bodies sleep?
    // This will speed up the physics simulation
    bool doSleep = true;
    
    // Construct a world object, which will hold and simulate the rigid bodies.
    self.world = new b2World(gravity, doSleep);
   // self.world->SetContinuousPhysics(true);
    
}

// Add the box2D game boundries
- (void)addBoundingBoxToScene {
    CGFloat newX = self.tiledMap.mapSize.width * self.tiledMap.tileSize.width;
    CGFloat newY = self.tiledMap.mapSize.height * self.tiledMap.tileSize.height;
    
    CGSize screenSize = CGSizeMake(newX, newY);
    
    // Create edges around the entire screen
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0,0);
    groundBody = self.world->CreateBody(&groundBodyDef);
    b2PolygonShape groundBox;
    b2FixtureDef groundBoxDef;

    // bottom
    groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(screenSize.width/PTM_RATIO,0));
    groundBody->CreateFixture(&groundBox,0);
    
    // top
    groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO));
    groundBody->CreateFixture(&groundBox,0);
    
    // left
    groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(0,0));
    groundBody->CreateFixture(&groundBox,0);
    
    // right
    groundBox.SetAsEdge(b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,0));
    groundBody->CreateFixture(&groundBox,0);

    
}

// This is generic code usable for any object you want to add physics too (note this is static body, however)
-(void)addHummerToScene {
   // CCSprite *hummer = [CCSprite spriteWithFile:@"army_hummer.png"];
    CCSprite *hummer = [CCSprite spriteWithFile:@"army_truck.png"];

    NSMutableDictionary* spawnPointRecord = [[self.tiledMap objectGroupNamed:@"hummer"] objectNamed:@"npc"];
    CGPoint startPos = ccp([[spawnPointRecord valueForKey:@"x"] intValue],
                           [[spawnPointRecord valueForKey:@"y"] intValue]);
    hummer.position = startPos;
    [self addChild:hummer z:1 tag:GameSceneHummerTag];
    
    // Set Hummer properties
    b2BodyDef hummerBodyDef;
    hummerBodyDef.type = b2_staticBody;
    hummerBodyDef.position.Set(startPos.x/PTM_RATIO, startPos.y/PTM_RATIO); // This matches the position above
    hummerBodyDef.userData = hummer;
    hummerBody = self.world->CreateBody(&hummerBodyDef);
    
    // Create Box2D Hummer Shape
    b2PolygonShape hummerShape;
    hummerShape.SetAsBox(hummer.contentSize.width/PTM_RATIO/2, 
                       hummer.contentSize.height/PTM_RATIO/2);
    
    // Create Shape Definition and Add to Body
    b2FixtureDef hummerShapeDef;
    hummerShapeDef.shape = &hummerShape;
    hummerShapeDef.density = 0.8f;
    hummerShapeDef.friction = 0.8f;
    hummerShapeDef.restitution = 0.3f;
    hummerBody->CreateFixture(&hummerShapeDef);

}

// Setup our car, lots of physics here
- (void)addMainPlayerToSceneAtPosition:(CGPoint)position {
  
    self.mainPlayer.position = position;
    self.engineSpeed = 0;
    self.steeringAngle = 0;
    [self addChild:self.mainPlayer z:1 tag:GameScenePlayerTag];

    // define our body
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(position.x/PTM_RATIO, position.y/PTM_RATIO);
    bodyDef.userData = self.mainPlayer;
    bodyDef.linearDamping = 1;
    bodyDef.angularDamping = 1;
    body = self.world->CreateBody(&bodyDef);
    
    float boxW = 0.3f;
    float boxH = 0.7f;
    float wheelW = 0.08f;
    float wheelH = 0.2f;
    float wheelX = 0.35f;
    float wheelY = 0.35f;
    
    // Front Wheels
    // Left
    b2BodyDef leftWheelDef;
    leftWheelDef.type = b2_dynamicBody;
    leftWheelDef.position.Set(position.x/PTM_RATIO-wheelX, position.y/PTM_RATIO-wheelY);
    leftWheel = self.world->CreateBody(&leftWheelDef);
    
    // Right
    b2BodyDef rightWheelDef;
    rightWheelDef.type = b2_dynamicBody;
    rightWheelDef.position.Set(position.x/PTM_RATIO+wheelX, position.y/PTM_RATIO-wheelY);
    rightWheel = self.world->CreateBody(&rightWheelDef);
    
    // Back Wheels
    // Left
    b2BodyDef leftRearWheelDef;
    leftRearWheelDef.type = b2_dynamicBody;
    leftRearWheelDef.position.Set(position.x/PTM_RATIO-wheelX, position.y/PTM_RATIO+wheelY);
    leftRearWheel = self.world->CreateBody(&leftRearWheelDef);
    // Right
    b2BodyDef rightRearWheelDef;
    rightRearWheelDef.type = b2_dynamicBody;
    rightRearWheelDef.position.Set(position.x/PTM_RATIO+wheelX, position.y/PTM_RATIO+wheelY);
    rightRearWheel = self.world->CreateBody(&rightRearWheelDef);
    
    // define our shapes
    b2PolygonShape boxDef;
    boxDef.SetAsBox(boxW,boxH);
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &boxDef;
    fixtureDef.density = 1.0F;
    fixtureDef.friction = 0.3f;
    carFixture = body->CreateFixture(&fixtureDef);
    
    //Left Front Wheel shape
    b2PolygonShape leftWheelShapeDef;
    leftWheelShapeDef.SetAsBox(wheelW, wheelH);
    b2FixtureDef fixtureDefLeftWheel;
    fixtureDefLeftWheel.shape = &leftWheelShapeDef;
    fixtureDefLeftWheel.density = 1.0F;
    fixtureDefLeftWheel.friction = 0.3f;
    leftWheel->CreateFixture(&fixtureDefLeftWheel);
    
    //Right Front Wheel shape
    b2PolygonShape rightWheelShapeDef;
    rightWheelShapeDef.SetAsBox(wheelW, wheelH);
    b2FixtureDef fixtureDefRightWheel;
    fixtureDefRightWheel.shape = &rightWheelShapeDef;
    fixtureDefRightWheel.density = 1.0F;
    fixtureDefRightWheel.friction = 0.3f;
    rightWheel->CreateFixture(&fixtureDefRightWheel);
    
    //Left Back Wheel shape
    b2PolygonShape leftRearWheelShapeDef;
    leftRearWheelShapeDef.SetAsBox(wheelW, wheelH);
    b2FixtureDef fixtureDefLeftRearWheel;
    fixtureDefLeftRearWheel.shape = &leftRearWheelShapeDef;
    fixtureDefLeftRearWheel.density = 1.0F;
    fixtureDefLeftRearWheel.friction = 0.3f;
    leftRearWheel->CreateFixture(&fixtureDefLeftRearWheel);
    
    //Right Back Wheel shape
    b2PolygonShape rightRearWheelShapeDef;
    rightRearWheelShapeDef.SetAsBox(wheelW, wheelH);
    b2FixtureDef fixtureDefRightRearWheel;
    fixtureDefRightRearWheel.shape = &rightRearWheelShapeDef;
    fixtureDefRightRearWheel.density = 1.0F;
    fixtureDefRightRearWheel.friction = 0.3f;
    rightRearWheel->CreateFixture(&fixtureDefRightRearWheel);
    
    // ------ JOINTS ---------
    
    b2RevoluteJointDef leftJointDef;
    leftJointDef.Initialize(body, leftWheel, leftWheel->GetWorldCenter());
    leftJointDef.enableMotor = true;
    leftJointDef.motorSpeed = 0.0f;
    leftJointDef.maxMotorTorque = 1000.f;
    
    b2RevoluteJointDef rightJointDef;
    rightJointDef.Initialize(body, rightWheel, rightWheel->GetWorldCenter());
    rightJointDef.enableMotor = true;
    rightJointDef.motorSpeed = 0.0f;
    rightJointDef.maxMotorTorque = 1000.f;
    
    leftJoint = (b2RevoluteJoint *) self.world->CreateJoint(&leftJointDef);
    rightJoint = (b2RevoluteJoint *) self.world->CreateJoint(&rightJointDef);
    
    b2Vec2 wheelAngle;
    wheelAngle.Set(1,0);
    
    // Join back wheels
    // Left
    b2PrismaticJointDef leftRearJointDef;
    leftRearJointDef.Initialize(body, leftRearWheel, leftRearWheel->GetWorldCenter(),wheelAngle);
    leftRearJointDef.enableLimit = true;
    leftRearJointDef.lowerTranslation = 0.0f;
    leftRearJointDef.upperTranslation = 0.0f;
    (b2PrismaticJoint*) self.world->CreateJoint(&leftRearJointDef);  // This stupid joint is missing from CCBox2D (need to add it, contribute to project)
   
    // Right
    b2PrismaticJointDef rightRearJointDef;
    rightRearJointDef.Initialize(body, rightRearWheel, rightRearWheel->GetWorldCenter(),wheelAngle);
    rightRearJointDef.enableLimit = true;
    rightRearJointDef.lowerTranslation = 0.0f;
    rightRearJointDef.upperTranslation = 0.0f;
    (b2PrismaticJoint*)self.world->CreateJoint(&rightRearJointDef);

}

-(void)addConeToScene {
    
    // Iterate through the list of tiles in the tile layer (self.coneLayer)
    CGSize tileSize = [self.coneLayer layerSize];
    for (int x = 0; x < tileSize.width; x++) {
        for (int y = 0; y < tileSize.height; y++) {
            int tileGid1 = [self.coneLayer tileGIDAt:CGPointMake(x, y)];
            
            if (tileGid1) { // Then check if we put a cone in that tile
                NSDictionary *properties = [self.tiledMap propertiesForGID:tileGid1];
                if (properties) {
                    NSString *collision = [properties valueForKey:@"cone"];
                    
                    if (collision && [collision isEqualToString:@"YES"]) {
                        CCSprite *cone = [CCSprite spriteWithFile:@"cone_straight.png"];
                        CGPoint x2 = [self.coneLayer positionAt:CGPointMake(x, y)];

                        cone.position = x2;
                        [self addChild:cone z:1 tag:GameSceneHazardTag];
                        
                        // Create Box2D Paddle Body
                        b2BodyDef coneBodyDef;
                        coneBodyDef.type = b2_dynamicBody;
                        coneBodyDef.position.Set(x2.x/PTM_RATIO, x2.y/PTM_RATIO); // This matches the position above
                        coneBodyDef.userData = cone;
                        coneBody = self.world->CreateBody(&coneBodyDef);
                        
                        // Create Box2D Paddle Shape
                        b2PolygonShape coneShape;
                        coneShape.SetAsBox(cone.contentSize.width/PTM_RATIO/2, 
                                           cone.contentSize.height/PTM_RATIO/2);
                        
                        // Create Shape Definition and Add to Body
                        b2FixtureDef coneShapeDef;
                        coneShapeDef.shape = &coneShape;
                        coneShapeDef.density = 0.4f;
                        coneShapeDef.friction = 0.4f;
                        coneShapeDef.restitution = 0.9f;
                        coneFixture = coneBody->CreateFixture(&coneShapeDef);
                    }
                }

                
            
            }
        }
    }
        
}

-(void)addHouseBlocksToScene {
    
    // Iterate through the list of tiles in the tile layer (self.stopLayer)
    CGSize tileSize = [self.stopLayer layerSize];
    for (int x = 0; x < tileSize.width; x++) {
        for (int y = 0; y < tileSize.height; y++) {
            int tileGid1 = [self.stopLayer tileGIDAt:CGPointMake(x, y)];
            
            if (tileGid1) { // Then check if we put a cone in that tile
                NSDictionary *properties = [self.tiledMap propertiesForGID:tileGid1];
                if (properties) {
                    NSString *collision = [properties valueForKey:@"collision"];
                    
                    if (collision && [collision isEqualToString:@"YES"]) {
                        CCSprite *block = [CCSprite spriteWithFile:@"transparent.png"];
                        CGPoint x2 = [self.stopLayer positionAt:CGPointMake(x, y)];
                        
                        block.position = x2;
                        [self addChild:block z:1 tag:GameSceneBlockTag];
                        
                        // Create Box2D Paddle Body
                        b2BodyDef blockBodyDef;
                        blockBodyDef.type = b2_staticBody;
                        blockBodyDef.position.Set(x2.x/PTM_RATIO, x2.y/PTM_RATIO); // This matches the position above
                        blockBodyDef.userData = block;
                        houseBody = self.world->CreateBody(&blockBodyDef);
                        
                        // Create Box2D Paddle Shape
                        b2PolygonShape houseShape;
                        houseShape.SetAsBox(block.contentSize.width/PTM_RATIO/2, 
                                           block.contentSize.height/PTM_RATIO/2);
                        
                        // Create Shape Definition and Add to Body
                        b2FixtureDef houseShapeDef;
                        houseShapeDef.shape = &houseShape;
                        houseShapeDef.density = 1.0f;
                        houseShapeDef.friction = 0.4f;
                        houseShapeDef.restitution = 0.0f;
                        houseBody->CreateFixture(&houseShapeDef);
                    }
                }
                
                
                
            }
        }
    }
    
}


// on "init" you need to initialize your instance
-(id) init
{

	if( (self=[super init])) {
        
        instanceOfGameScene = self;
		self.isTouchEnabled = YES;
		pointCounter = 0;
        inTransition = NO;
        
        // Load our various layers and set them to not visable (since they are 'meta' properties anyways)
        switch (self.level) {
            case GameLevelDriversEd: //Drivers Ed tutorial
                self.tiledMap = [CCTMXTiledMap tiledMapWithTMXFile:@"driversEd.tmx"];
                self.backgroundLayer = [self.tiledMap layerNamed:@"base"];
                self.stopLayer = [self.tiledMap layerNamed:@"collision"];
                self.stopLayer.visible = NO;
                self.coneLayer = [self.tiledMap layerNamed:@"coneLayout"];
                self.coneLayer.visible = NO;
                
                [self addChild:self.tiledMap z:-1];

                // Setup our Box2D World 
                [self addWorldToScene];
                [self addBoundingBoxToScene];    
                [self addConeToScene];
                [self addHummerToScene];
                
                self.mainPlayer = [CCSprite spriteWithFile:@"sport_red.png"];
                
                break;
            case GameLevelBasicTraining:
                self.tiledMap = [CCTMXTiledMap tiledMapWithTMXFile:@"neighborhood.tmx"];
                self.backgroundLayer = [self.tiledMap layerNamed:@"base"];
                self.stopLayer = [self.tiledMap layerNamed:@"collision"];
                self.stopLayer.visible = NO;

                [self addChild:self.tiledMap z:-1];

                // Setup our Box2D World 
                [self addWorldToScene];
                [self addBoundingBoxToScene];    
                [self addHouseBlocksToScene];
                
                self.mainPlayer = [CCSprite spriteWithFile:@"army_hummer.png"];

                break;
            case GameLevelHospital:
                self.tiledMap = [CCTMXTiledMap tiledMapWithTMXFile:@"neighborhood.tmx"];
                self.backgroundLayer = [self.tiledMap layerNamed:@"base"];
                self.stopLayer = [self.tiledMap layerNamed:@"collision"];
                self.stopLayer.visible = NO;

                [self addChild:self.tiledMap z:-1];

                // Setup our Box2D World 
                [self addWorldToScene];
                [self addBoundingBoxToScene];    
                [self addHouseBlocksToScene];
                
                self.mainPlayer = [CCSprite spriteWithFile:@"suv_green.png"];

                break;
            default:
                break;
        }
        
        // Add a 'contact listener' for Collision Detection in Box2D
        contactListener = new MyContactListener();
        self.world->SetContactListener(contactListener);
        
        [self schedule:@selector(tick:) interval:1.0/60.0f];
        
        // Get the location of the user from the tile map object
        NSMutableDictionary* spawnPointRecord = [[self.tiledMap objectGroupNamed:@"player"] objectNamed:@"player"];
        CGPoint startPos = ccp([[spawnPointRecord valueForKey:@"x"] intValue],
                               [[spawnPointRecord valueForKey:@"y"] intValue]);
    
        [self addMainPlayerToSceneAtPosition:startPos];
        [self setViewpointCenter:self.mainPlayer.position];
        self.showingPausedMenu = NO;   
        
        self.currentLeaderboard = kLeaderboardID;
        
        if ([GameCenterManager isGameCenterAvailable]) {
            self.gameCenterManager = [[[GameCenterManager alloc] init] autorelease];
            [self.gameCenterManager setDelegate:self];
            [self.gameCenterManager authenticateLocalUser];
        }
    }
    
    return self;
    
}

// This centers the camera on either the player or against an edge (so the camera doesnt go off the map)
-(void)setViewpointCenter:(CGPoint) position {
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    int x = MAX(position.x, screenSize.width / 2);
    int y = MAX(position.y, screenSize.height / 2);
    x = MIN(x, (self.tiledMap.mapSize.width * self.tiledMap.tileSize.width) 
            - screenSize.width / 2);
    y = MIN(y, (self.tiledMap.mapSize.height * self.tiledMap.tileSize.height) 
            - screenSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    CGPoint centerOfView = ccp(screenSize.width/2, screenSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    self.position = viewPoint;
    
}
// Convert the pixel position to the tiled coordinate
- (CGPoint)tileCoordForPosition:(CGPoint)position {
    int x = position.x / self.tiledMap.tileSize.width;
    int y = ((self.tiledMap.mapSize.height * self.tiledMap.tileSize.height) - position.y) / self.tiledMap.tileSize.height;
    return ccp(x, y);
}

// Double fail-safe, make sure player doesnt go off the map.  Also, check for #winning scenario
-(BOOL)shouldMovePlayerToPosition:(CGPoint)position {
    
    CGFloat newX = self.tiledMap.mapSize.width * self.tiledMap.tileSize.width;
    CGFloat newY = self.tiledMap.mapSize.height * self.tiledMap.tileSize.height;
    
    CGSize winSize = CGSizeMake(newX, newY);
    BOOL move = NO;
    // First, make sure we're not going off the screen
   if (position.x < 0)
       move = NO;
    else if (position.x > winSize.width)
        move = NO;
    else if (position.y < 0)
        move = NO;
    else if (position.y > winSize.height)
        move = NO;
    else {
        CGPoint tileCoord = [self tileCoordForPosition:position];
        int tileGid1 = [self.stopLayer tileGIDAt:tileCoord];
        move = YES;
        // For Drivers Ed map, check to see if we are in the "red zone" (check map)
        if (tileGid1) { // Then check if we can go to that tile
            NSDictionary *properties = [self.tiledMap propertiesForGID:tileGid1];
            if (properties) {
                NSString *collision = [properties valueForKey:@"collision"];
                
                if (collision && [collision isEqualToString:@"YES"]) {
                    if (self.level == GameLevelDriversEd) {
                        [self playerReachedEndOfLevel:0];
                    }
                    //[self playerReachedEndOfLevel:0];
                    move = NO;  // added for neighborhood level
                    //was using collision for win condition.  tsk, tsk
                }
            }
        }
}
    return  move;
}

- (void)playerReachedEndOfLevel:(int)levelz {
    if (!inTransition) {
        inTransition = YES;
        switch (levelz) {
            case 0:
                NSLog(@"** Rearched End of Level 0");
                [self showEndOfLevelSceneForLevel:level];
                break;
            case 1:
                NSLog(@"** Rearched End of Level 1");
                [self showEndOfLevelSceneForLevel:level];
                break;
            default:
                break;
        }
    }
}

- (void)showEndOfLevelSceneForLevel:(int)levelz {
    [self checkAchievementsForLevel:levelz];
    [self showGameOverMenu]; // I couldnt get GameOverScene to play nice, so show the Pause Menu
                           // inTransition = NO;
    
}

- (void)showGameOverMenu {
    PauseLayer *pauzy = [PauseLayer node];
    [pauzy updateMainLabelWithText:@"Game Over!"];
    [self setViewpointCenter:self.position];
    [pauzy setPositionInPixels:self.position];
    [self addChild:pauzy z:100 tag:GameScenePauseTag];
}

- (void)showPausedMenu {
    PauseLayer *pauzy = [PauseLayer node];
    [self setViewpointCenter:self.position];
    [pauzy setPositionInPixels:self.position];
    [self addChild:pauzy z:100 tag:GameScenePauseTag];
}

// Randomly get a cone sprite when hit
- (void)setRandomConePositionForSprite:(CCSprite *)spriteA {
    int cone = arc4random() % 3;
    [spriteA setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"cone_down%i.png", cone]]];
}


// This allows the wheels to "roll", thats all I know :)
-(void) killOrthogonalVelocityForTarget:(b2Body *)targetBody
{
	b2Vec2 localPoint;
	localPoint.Set(0,0);
	b2Vec2 velocity = targetBody->GetLinearVelocityFromLocalPoint(localPoint);
	
	b2Vec2 sidewaysAxis = targetBody->GetTransform().R.col2;
	sidewaysAxis *= b2Dot(velocity,sidewaysAxis);
	
	targetBody->SetLinearVelocity(sidewaysAxis);
}
static BOOL hit = YES;    

// Box2D tick and Cocos2D step
-(void) tick: (ccTime) dt
{
    
	int32 velocityIterations = 10;
	int32 positionIterations = 10;

	self.world->Step(dt, velocityIterations, positionIterations);
   
    // Car Tick
    [self killOrthogonalVelocityForTarget:leftWheel];
    [self killOrthogonalVelocityForTarget:rightWheel];
    [self killOrthogonalVelocityForTarget:leftRearWheel];
    [self killOrthogonalVelocityForTarget:rightRearWheel];
    
    //Driving tick
    b2Vec2 localPoint;
    localPoint.Set(0,0);
    b2Vec2 ldirection = leftWheel->GetTransform().R.col2;
    ldirection *= self.engineSpeed;
    b2Vec2 rdirection = rightWheel->GetTransform().R.col2;
    rdirection *= self.engineSpeed;
    leftWheel->ApplyForce(ldirection, leftWheel->GetPosition());
    rightWheel->ApplyForce(rdirection, rightWheel->GetPosition());
    
    //Steering tick
    float mspeed = self.steeringAngle - leftJoint->GetJointAngle();
    leftJoint->SetMotorSpeed(mspeed * 1.5F);
    mspeed = self.steeringAngle - rightJoint->GetJointAngle();
    rightJoint->SetMotorSpeed(mspeed * 1.5F);
	
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
    {
        if (b->GetUserData() != NULL) {            
            // Make sure we are getting the player
            if ([(CCSprite*)b->GetUserData() isEqual:self.mainPlayer]) {
              CGPoint newPosition = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
                // Check to see if the new position is good or not
                if ([self shouldMovePlayerToPosition:newPosition]) {
                    self.mainPlayer = (CCSprite*)b->GetUserData();
                    self.mainPlayer.position = newPosition;
                    self.mainPlayer.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
                    [self setViewpointCenter:self.mainPlayer.position];
                }
               
            }
        }
    }
    
    // Below is some C++ jazz that detects collisions
    std::vector<b2Body *>toDestroy;
    std::vector<MyContact>::iterator pos;
    for(pos = contactListener->_contacts.begin(); 
        pos != contactListener->_contacts.end(); ++pos) {
        MyContact contact = *pos;
        
        b2Body *bodyA = contact.fixtureA->GetBody();
        b2Body *bodyB = contact.fixtureB->GetBody();
        if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL) {
            CCSprite *spriteA = (CCSprite *) bodyA->GetUserData();
            CCSprite *spriteB = (CCSprite *) bodyB->GetUserData();
            
            // Sprite A = player, Sprite B = cone
            if (spriteA.tag == GameScenePlayerTag && spriteB.tag == GameSceneHazardTag) {
                if (std::find(toDestroy.begin(), toDestroy.end(), bodyB) == toDestroy.end()) {
                    toDestroy.push_back(bodyB);
                }
            }
            // For Drivers Ed, at least, we will always fall into this trap since Player is hitting Cone
            // Sprite A = cone, Sprite B = player
            else if (spriteA.tag == GameSceneHazardTag && spriteB.tag == GameScenePlayerTag) {
                if (std::find(toDestroy.begin(), toDestroy.end(), bodyA) == toDestroy.end()) {
                    toDestroy.push_back(bodyA); // Not sure what this does...
                    [self setRandomConePositionForSprite:spriteA];
                    CGPoint newPosition = CGPointMake( bodyA->GetPosition().x * PTM_RATIO, bodyA->GetPosition().y * PTM_RATIO);
                    spriteA.position = newPosition;
                    spriteA.rotation = -1 * CC_RADIANS_TO_DEGREES(bodyA->GetAngle());
                    pointCounter++;
                    // Yell at the player after hitting 5+ cones
                    if (pointCounter > 5) {
                        [self.gameHUD updatePointCounter:-5 withMessage:@"Don't hit the cones!"];
                        [spriteB setTexture:[[CCTextureCache sharedTextureCache] addImage:@"sport_red_wreck.png"]];
                        pointCounter = 0;
                    }
                }
                // Hitting the truck is a big no-no!!
            } else if (spriteA.tag == GameSceneHummerTag && spriteB.tag == GameScenePlayerTag) {
                [self.gameHUD updatePointCounter:-15 withMessage:@"Don't hit my truck!"];
                [spriteB setTexture:[[CCTextureCache sharedTextureCache] addImage:@"sport_red_wreck.png"]];
                // Hitting the houses on the non-Drivers Ed maps
            } else if (spriteA.tag == GameSceneBlockTag && spriteB.tag == GameScenePlayerTag) {
               // This logic will only count a collision once
                static CGPoint thisPos = spriteA.position;
                static CGPoint lastPos = CGPointMake(0, 0);
                thisPos = spriteA.position;
                if (!CGPointEqualToPoint(thisPos, lastPos)) {
                    [self.gameHUD updatePointCounter:-250 withMessage:@"Collision: -$250!"];
                    if (self.level == GameLevelDriversEd) {
                        [spriteB setTexture:[[CCTextureCache sharedTextureCache] addImage:@"sport_red_wreck.png"]];
                    }
                    hit = NO;
                    lastPos = spriteA.position;
                }
            }
        }            
    }
}

#pragma mark -
#pragma mark Game Center Methods
- (IBAction) showLeaderboard
{
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != NULL)
    {
        AppDelegate * delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        leaderboardController.category = self.currentLeaderboard;
        leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
        leaderboardController.leaderboardDelegate = self;
        [delegate.viewController presentModalViewController:leaderboardController animated:YES];
    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [viewController becomeFirstResponder];
    [viewController dismissModalViewControllerAnimated: YES];
}

- (IBAction) showAchievements
{
    AppDelegate * delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
    if (achievements != NULL)
    {
        achievements.achievementDelegate = self;
        [delegate.viewController presentModalViewController: achievements animated: YES];
    }
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController;
{
    AppDelegate * delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate.viewController dismissModalViewControllerAnimated: YES];
}

- (void)checkAchievementsForLevel:(int)levelz {
    NSString *award = nil;
    NSString *awardTitle = nil;
    NSString *awardText = nil;
    double percentComplete = 0;
    switch (levelz) {
        case 0:
        {
            NSLog(@"** Player won Achivement Drivers License");
            award = kAchievementDriversLicense;
            awardTitle = @"Earned Driver's License";
            awardText = @"You passed the Driver's Ed course!  You are now a certified driver!";
            percentComplete = 100.0;
        }
            break;
        case 1:
        {
            NSLog(@"** Player won Achivement Sir, Yes Sir!");
            award = kAchievementPassedMilitaryLevel;
            awardTitle = @"Earned Driver's License";
            awardText = @"Way to go, soldier!  You are now allowed to drive the simplest of machines, don't hurt your head!";
            percentComplete = 100.0;
        }
            break;
        case 2:
        {
            NSLog(@"** Player won Achivement Life Saver");
            award = kAchievementPassedHospitalLevel;
            awardTitle = @"Life Saver";
            awardText = @"Whew!  You made it!  Congrats on the new baby!";
            percentComplete = 100.0;
        }
            break;
        default:
            break;
    }
    if (award) {
        [self.gameCenterManager submitAchievement: award percentComplete: percentComplete];
        [self.gameCenterManager submitAchievement: kAchievementPlayedAllLevels percentComplete: 33.0]; // This will always show 25% complete (for demo purposes)
        int64_t score = self.gameHUD.currentPointAmount;
        [self.gameCenterManager reportScore:score forCategory:self.currentLeaderboard];
       
        // grab an achievement description from where ever you saved them
        //GKAchievementDescription *achievement = [[GKAchievementDescription alloc] init];
        
        if (awardText && awardTitle) {
            // notify the user
            [[GKAchievementHandler defaultHandler] setImage:[UIImage imageNamed:@"iconProto.png"]];
            [[GKAchievementHandler defaultHandler] notifyAchievementTitle:awardTitle andMessage:awardText];
        }
    }
}
- (void)dealloc {
   
    delete world;
    delete contactListener;
	world = NULL;
    houseBody = NULL;
	groundBody = NULL;
    body = NULL;
    hummerBody = NULL;
    coneBody = NULL;
    leftWheel = NULL;
    leftRearWheel = NULL;
    rightWheel = NULL;
    rightRearWheel = NULL;
    
    instanceOfGameScene = nil;
    self.mainPlayer = nil;
    self.wrongWayLayer = nil;
    self.tiledMap = nil;
    self.backgroundLayer = nil;
    self.stopLayer = nil;
    self.coneLayer = nil;
    self.gameHUD = nil;
    self.gameCenterManager = nil;
    self.currentLeaderboard = nil;
    [super dealloc];
}
@end
//
//  HelloWorldLayer.h
//  demo
//
//  Created by Chris Lowe on 6/22/11.
//  Copyright USAA 2011. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "HUDLayer.h"
#import "InputLayer.h"
#import "SimSuranceConstants.h"
#import "Box2D.h"
#import "MyContactListener.h"
#import "GameCenterManager.h"
#import <GameKit/GameKit.h>

// Tags for the various game layers, if needed to be retrieved from code
typedef enum 
{
    GameSceneGameTag = 1,
    GameSceneHUDTag,
    GameSceneInputTag,
    GameScenePlayerTag,
    GameSceneHazardTag,
    GameScenePauseTag,
    GameSceneHummerTag,
    GameSceneBlockTag,
    
} GameSceneLayerTags;

// Tags for the various game levels
typedef enum 
{
    GameLevelDriversEd = 0,
    GameLevelBasicTraining,
    GameLevelHospital,
} GameLevelTags;

@interface GameScene : CCLayer <GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate, GameCenterManagerDelegate>
{
    int level;
    
    //GameCenter Setup
    GameCenterManager *gameCenterManager_;
    NSString *currentLeaderboard_;
    
    // Box2D World
    b2World *world;
    b2Body *groundBody;
    
    // TileMap & Various Layers
    CCTMXTiledMap *tiledMap_;
    CCTMXTiledMap *tiledUpperMap_;  //  RWT
    CCTMXLayer *stopLayer_;
    CCTMXLayer *wrongWayLayer_;
    CCTMXLayer *backgroundLayer_;
    CCTMXLayer *coneLayer_;
    CCTMXLayer *fenceLayer_;
    MyContactListener *contactListener;
    HUDLayer *gameHUD_;
    BOOL showingPausedMenu_;

    // Cone Details
    b2Body *coneBody;
    b2Fixture *coneFixture;
    
    b2Body *houseBody;
    b2Body *hummerBody;
    
    // Car Details
    CCSprite *mainPlayer_;
    b2Fixture *carFixture;
    b2Body *body;
	b2Body *leftWheel;
	b2Body *rightWheel;
	b2Body *leftRearWheel;
	b2Body *rightRearWheel;
	b2RevoluteJoint * leftJoint;
	b2RevoluteJoint * rightJoint;
	float engineSpeed;
	float steeringAngle;
    
    int pointCounter; // Scoring
    BOOL inTransition; // Transitioning between scenes
    BOOL shouldGetLicenseDiscount;
    
}
@property (nonatomic, retain) CCSprite *mainPlayer; // Eventually, make this a real player class
@property (nonatomic, retain) HUDLayer *gameHUD; // Specific layer for HUD
@property (nonatomic, retain) CCTMXTiledMap *tiledMap; // General Tilemap
@property (nonatomic, retain) CCTMXTiledMap *tiledUpperMap; // General Tilemap  //  RWT
@property (nonatomic, retain) CCTMXLayer *backgroundLayer; // Specific Tile layer
@property (nonatomic, retain) CCTMXLayer *stopLayer;
@property (nonatomic, retain) CCTMXLayer *wrongWayLayer;
@property (nonatomic, retain) CCTMXLayer *coneLayer;
@property (nonatomic, retain) CCTMXLayer *fenceLayer; // Specific Tile Layer for Basic Training
@property b2World *world;
@property float engineSpeed;
@property float steeringAngle;
@property (nonatomic, getter = isShowingPausedMenu) BOOL showingPausedMenu;
@property int level;
@property (nonatomic, retain) GameCenterManager *gameCenterManager;
@property (nonatomic, retain) NSString *currentLeaderboard;


// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

// Singleton Instance for accessing/modified the game and/or other layers - IE, do NOT modify game elements directly, instead access them through the instance
+(GameScene*) sharedGameScene;

// Default Initializer
-(id) initWithLevel:(int)level;
+(id) nodeWithLevel:(int)level;
+(CCScene *) sceneWithLevel:(int)levelz;

// Access the main Player through the GameScenes defaultPlayer method.  This ensures that you are getting the one that is active on the screen
-(CCSprite *) defaultPlayer;
-(void)showPausedMenu;
- (void)playerReachedEndOfLevel:(int)level;

// Game Center
- (IBAction) showLeaderboard;
- (IBAction) showAchievements;
- (void)checkAchievementsForLevel:(int)levelz;

// Private
-(void)setViewpointCenter:(CGPoint) position;
-(CGPoint)tileCoordForPosition:(CGPoint)position;
-(void)showEndOfLevelSceneForLevel:(int)level;
-(void)showGameOverMenu;

@end

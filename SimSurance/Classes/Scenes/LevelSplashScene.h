//
//  LevelSplashScene.h
//  SimSurance
//
//  Created by Rich Tanner on 8/18/11.
//  Copyright 2011 Redshirt Interactive Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// Tags for the various game levels splashies
typedef enum 
{
    LevelSplashOne = 1,
    LevelSplashTwo,
    LevelSplashThree,
    LevelSplashFour,
    LevelSplashFive,
    LevelSplashSix,
    LevelSplashSeven,
    LevelSplashEight,
    LevelSplashNine
} LevelSplashTags;

@interface LevelSplashScene : CCLayer {
    int level_;
}

@property int level;

+(CCScene *) scene;
+(CCScene *) sceneForLevel:(int)levelz;
+(id) nodeWithLevel:(int)level;

@end
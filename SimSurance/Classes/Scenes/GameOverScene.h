//
//  GameOverScene.h
//  SimSurance
//
//  Created by Chris Lowe on 7/28/11.
//  Copyright 2011 USAA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOverScene : CCLayerColor {
    int gameLevel;
}

+(CCScene *) sceneWithLevel:(int)levelz;
+(id) nodeWithLevel:(int)level;

@end

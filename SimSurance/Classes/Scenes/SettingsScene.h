//
//  SetingsScene.h
//  SimSurance
//
//  Created by Chris Lowe on 6/25/11.
//  Copyright 2011 USAA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SettingsScene : CCLayer {
    UISwitch *musicSwitch;
}
+(CCScene *) scene;

@end

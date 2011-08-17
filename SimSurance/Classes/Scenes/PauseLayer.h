//
//  PauseLayer.h
//  SimSurance
//
//  Created by Chris Lowe on 6/23/11.
//  Copyright 2011 USAA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PauseLayer : CCLayerColor <CCTargetedTouchDelegate> {
    
}
- (void)updateMainLabelWithText:(NSString *)text;
@end

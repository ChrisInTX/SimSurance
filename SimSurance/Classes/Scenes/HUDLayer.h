//
//  HUDLayer.h
//  SimSurance
//
//  Created by Chris Lowe on 6/21/11.
//  Copyright 2011 USAA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    kAmountLabel,
    kMessageLabel,
    kPauseButton,
} HUDTypes;

@interface HUDLayer : CCLayerColor {
    int dollarAmount;
    CCLabelTTF* amountLabel;
    CCLabelTTF* messageLabel;
}
-(void) updatePointCounter:(int)amount;
-(void) updatePointCounter:(int)amount withMessage:(NSString *)message;
- (int)currentPointAmount;
@end

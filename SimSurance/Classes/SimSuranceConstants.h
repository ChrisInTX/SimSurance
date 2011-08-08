//
//  SimSuranceConstants.h
//  SimSurance
//
//  Created by Chris Lowe on 6/17/11.
//  Copyright 2011 USAA. All rights reserved.
//

//#import <Foundation/Foundation.h>

// This macro defines if we should load directly into Drivers Ed or Main Menu
//#define GAME_ONLY

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

// Tags for the various collision types - box (other objects) or wall
typedef enum {
	
    kBoxCollisionType = 1,
	kWallCollisionType,
    kPlayerCollisionType,
    kOtherVehicleCollisionType,
    kBuildingCollisionType,
    kObjectCollisionType,
    
} CCBox2DCollisionTypes;


@interface SimSuranceConstants : NSObject {
    
}

@end

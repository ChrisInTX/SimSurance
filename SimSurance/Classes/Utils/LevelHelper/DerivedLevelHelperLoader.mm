//
//  DerivedLevelHelperLoader.m
//  presentation
//
//  Created by Bogdan Vladu on 5/31/11.
//  Copyright 2011 USAA. All rights reserved.
//

#import "DerivedLevelHelperLoader.h"

@implementation DerivedLevelHelperLoader

-(id) initWithContentOfFile:(NSString *)levelFile
{
    NSAssert(nil != levelFile, @"Invalid file given to DerivedLevelHelperLoader");
    
    if(!(self = [super initWithContentOfFile:levelFile]))
    {
        NSLog(@"DerivedLevelHelperLoader ***ERROR*** : [super init] failed");
        
        return self;
    }
    
    return self;
}

-(CCSprite*) spriteFromDictionary:(NSDictionary*)spriteProp
{ 
    CCSprite* yourSprite = nil;
    //if you want to have a custom sprite for every game object
    //you can test for the tag and construct the CCSprite acordingly.
    
    //This method will not be used when calling instantiateObject or instantiateSprites
    //but the spriteWithBatchFromDictionary will get called
    //this is used when calling "newSpriteWithUniqueName" or "newObjectWithUniqueName"
    
    switch ([[spriteProp objectForKey:@"Tag"] integerValue]) 
    {
        //as you can see from the level file we have two distinct objects
        //wood and stones
        //when we load our level we will only have the stone loaded
        case STONE:

           // yourSprite = [[YourCCSprite alloc] initWithFile:[spriteProp objectForKey:@"Image"]
            //                                           rect:CGRectFromString([spriteProp objectForKey:@"UV"])];
    
        break;

        case WOOD:
            
            //yourSprite = [[YourCCSprite alloc] initWithFile:[spriteProp objectForKey:@"Image"]
            //                                             rect:CGRectFromString([spriteProp objectForKey:@"UV"])];
            break;
        default:
            break;
    }
	
	
    [self setSpriteProperties:(CCSprite*)yourSprite spriteProperties:spriteProp];
	
	return yourSprite;

}

-(CCSprite*) spriteWithBatchFromDictionary:(NSDictionary*)spriteProp 
                                 batchNode:(CCSpriteBatchNode*)batch
{
    CCSprite* yourSprite = nil;
    //if you want to have a custom sprite for every game object
    //you can test for the tag and construct the CCSprite acordingly.
    
    switch ([[spriteProp objectForKey:@"Tag"] integerValue]) 
    {
        //as you can see from the level file we have two distinct objects
        //wood and stones
        //when we load our level we will only have the stone loaded
        case STONE:
            
            //yourSprite = [[YourCCSprite alloc] initWithBatchNode:batch
            //                                           rect:CGRectFromString([spriteProp objectForKey:@"UV"])];
            
            break;

        case WOOD:
            
            //uncoment the following 2 lines to load the wood also
            //yourSprite = [[YourCCSprite alloc] initWithBatchNode:batch
            //                                                  rect:CGRectFromString([spriteProp objectForKey:@"UV"])];
            
            break;    
        default:
            break;
    }
	
	
    [self setSpriteProperties:(CCSprite*)yourSprite spriteProperties:spriteProp];
	
	return yourSprite;
    
}

//this is needed when releasing the level
//in case you want to do a special release of your custom ccsprite
//in this case we do nothing
-(void) removeFromBatchNode:(CCSprite*)sprite
{
    CCSpriteBatchNode *batchNode = [sprite batchNode];
	
	if(nil == batchNode)
		return;
	
	[batchNode removeChild:sprite cleanup:YES];
    
}

- (void)dealloc
{
    [super dealloc];
}

@end

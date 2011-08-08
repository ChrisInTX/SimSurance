//
//  DerivedLevelHelperLoader.h
//  presentation
//
//  Created by Bogdan Vladu on 5/31/11.
//  Copyright 2011 USAA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LevelHelperLoader.h"

@interface DerivedLevelHelperLoader : LevelHelperLoader {
    
}

-(id) initWithContentOfFile:(NSString *)levelFile;

@end

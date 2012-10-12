//
//  Tier.h
//  Kapitel2
//
//  Created by Rodewig Klaus on 27.05.12.
//  Copyright (c) 2012 Klaus M. Rodewig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Droid : NSObject

@property(copy) NSString *droidID;

-(id)initWithID:(NSInteger)inDroidID;
-(void)sayName;

@end

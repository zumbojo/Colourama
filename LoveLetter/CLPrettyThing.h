//
//  CLPrettyThing.h
//  LoveLetter
//
//  Created by user on 1/31/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLPrettyThing : NSObject

// from API:
@property (nonatomic) NSUInteger remoteId;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *userName;
@property (nonatomic) NSUInteger numViews;
@property (nonatomic) NSUInteger numVotes;
@property (nonatomic) NSUInteger numComments;
@property (nonatomic) NSUInteger numHearts;
@property (nonatomic) NSUInteger rank;

@end

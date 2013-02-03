//
//  CLPrettyThing.m
//  LoveLetter
//
//  Created by user on 1/31/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import "CLPrettyThing.h"

@implementation CLPrettyThing

- (CLPrettyThing *)initWithJSON:(id)json {
    self = [super init]; // http://stackoverflow.com/a/12428407/103058
    if (self) {
        self.remoteId = [[json valueForKeyPath:@"id"] intValue];
        self.title = [json valueForKeyPath:@"title"];
        self.userName = [json valueForKeyPath:@"userName"];
        self.numViews = [[json valueForKeyPath:@"numViews"] intValue];
        self.numVotes = [[json valueForKeyPath:@"numVotes"] intValue];
        self.numComments = [[json valueForKeyPath:@"numComments"] intValue];
        self.numHearts = [[json valueForKeyPath:@"numHearts"] intValue];
    }
    return self;
}

@end

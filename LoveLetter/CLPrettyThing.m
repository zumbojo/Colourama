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
        self.url = [NSURL URLWithString:[json valueForKeyPath:@"url"]];
    }
    return self;
}

- (NSString *)shortPrintableUrl {
    // "colourlovers.com/palette/92095" instead of http://www.colourlovers.com/palette/92095/Giant_Goldfish
    
    if (!self.url){
        return nil;
    }

    NSString *longUrl = [self.url absoluteString];
    
    // basic regex capture group example from http://www.raywenderlich.com/30288/nsregularexpression-tutorial-and-cheat-sheet
    NSString *pattern = @"(\\w+\\.com\\/\\w+\\/\\d+)";
    
    // `\w+\.com\/\w+\/\d+` is just something I threw together in five minutes on http://regexpal.com/ (test data is `http://www.colourlovers.com/palette/92095/Giant_Goldfish`)
    // this will probably break if colourlovers changes their urls, etc.
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:NULL];
    return [regex stringByReplacingMatchesInString:longUrl options:NSMatchingReportProgress range:NSMakeRange(0, longUrl.length) withTemplate:@"$1"];;
}


@end

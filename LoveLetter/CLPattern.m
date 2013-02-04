//
//  CLPattern.m
//  LoveLetter
//
//  Created by user on 2/2/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import "CLPattern.h"

@interface CLPattern ()

@property (nonatomic) NSURL *imageUrl;

@end

@implementation CLPattern

- (CLPattern *)initWithJSON:(id)json {
    // example from http://www.colourlovers.com/api/pattern/1451?format=json
    /*
    [
     {
         "id": 1451,
         "title": "Geek Chic",
         "userName": "_183",
         "numViews": 624,
         "numVotes": 3,
         "numComments": 2,
         "numHearts": 0,
         "rank": 0,
         "dateCreated": "2007-12-09 15:36:03",
         "colors": [
                    "52202E",
                    "1A1313",
                    "F7F6A8",
                    "C4F04D"
                    ],
         "description": "",
         "url": "http://www.colourlovers.com/pattern/1451/Geek_Chic",
         "imageUrl": "http://colourlovers.com.s3.amazonaws.com/images/patterns/1/1451.png",
         "badgeUrl": "http://www.colourlovers.com/images/badges/n/1/1451_Geek_Chic.png",
         "apiUrl": "http://www.colourlovers.com/api/pattern/1451"
     }
     ]
    */
    
    self = [super initWithJSON:json];
    if (self) {
        self.imageUrl = [NSURL URLWithString:[json valueForKeyPath:@"imageUrl"]];
        
        // todo: load image using imageUrl.
    }
    return self;
}

+ (NSString *)pluralApiPath {
    return @"patterns";
}



@end

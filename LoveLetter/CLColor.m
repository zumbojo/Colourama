//
//  CLColor.m
//  LoveLetter
//
//  Created by user on 2/2/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import "CLColor.h"

@implementation CLColor

- (CLColor *)initWithJSON:(id)json {
    // example from http://www.colourlovers.com/api/color/6B4106?format=json

    /*
    [
     {
         "id": 903893,
         "title": "wet dirt",
         "userName": "jessicabrown",
         "numViews": 254,
         "numVotes": 1,
         "numComments": 0,
         "numHearts": 0,
         "rank": 0,
         "dateCreated": "2008-03-17 11:22:21",
         "hex": "6B4106",
         "rgb": {
             "red": 107,
             "green": 65,
             "blue": 6
         },
         "hsv": {
             "hue": 35,
             "saturation": 94,
             "value": 42
         },
         "description": "",
         "url": "http://www.colourlovers.com/color/6B4106/wet_dirt",
         "imageUrl": "http://www.colourlovers.com/img/6B4106/100/100/wet_dirt.png",
         "badgeUrl": "http://www.colourlovers.com/images/badges/c/903/903893_wet_dirt.png",
         "apiUrl": "http://www.colourlovers.com/api/color/6B4106"
     }
     ]
     */
    
    self = [super initWithJSON:json];
    if (self) {
        self.hex = [json valueForKeyPath:@"hex"];
        self.color = UIColorFromRGBString(self.hex);
    }
    return self;
}

@end

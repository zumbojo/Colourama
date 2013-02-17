
// Macros:

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// from http://stackoverflow.com/questions/1560081/how-can-i-create-a-uicolor-from-a-hex-string

// UIColorFromRGBString()
//
// by KML, 2012-01-06
// based on syntax from http://stackoverflow.com/questions/2679182/have-macro-return-a-value
// and scanner logic from http://stackoverflow.com/questions/8976148/how-to-get-an-int-in-decimal-from-a-hex-nsstring
// requires UIColorFromRGB()
#define UIColorFromRGBString(str) ({ \
NSUInteger rgbHex; \
[[NSScanner scannerWithString:str] scanHexInt:&rgbHex]; \
UIColorFromRGB(rgbHex); \
})

// Constants:
#define COLOURLOVERS_URL_BASE       @"http://www.colourlovers.com"
#define BYLINE_BACKGROUND_HEIGHT    26
#define BAR_SHADOW_HEIGHT           2
#define BAR_BACKGROUND_COLOR        UIColorFromRGBString(@"F1F1F1")
#define BAR_SHADOW_COLOR            UIColorFromRGBString(@"CCCCCC")
#define BAR_TEXT_AND_ICON_COLOR     UIColorFromRGBString(@"808080")
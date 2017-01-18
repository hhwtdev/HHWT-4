//
//  UIColor+FPColorUtility.m
//  FanPage
//
//  Created by Velmurugan on 19/06/15.
//  Copyright (c) 2015 ImpigerTechnologies. All rights reserved.
//

#import "UIColor+FPColorUtility.h"

@implementation UIColor (FPColorUtility)
// takes @"#123456"
+ (UIColor *)fbColorWithHexString:(NSString *)str {
    if(!str) return [UIColor blackColor];
    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
    UInt32 x = (UInt32)strtol(cStr+1, NULL, 16);
    return [UIColor colorWithHex:x];
}

// takes 0x123456
+ (UIColor *)colorWithHex:(UInt32)col {
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
}
- (UIColor *)lighterColorForColor
{
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MIN(r + 0.2, 1.0) green:MIN(g + 0.2, 1.0) blue:MIN(b + 0.2, 1.0) alpha:a];
    return nil;
}

- (UIColor *)darkerColorForColor
{
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.2, 0.0) green:MAX(g - 0.2, 0.0) blue:MAX(b - 0.2, 0.0) alpha:a];
    return nil;
}

@end

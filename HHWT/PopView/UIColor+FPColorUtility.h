//
//  UIColor+FPColorUtility.h
//  FanPage
//
//  Created by Velmurugan on 19/06/15.
//  Copyright (c) 2015 ImpigerTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (FPColorUtility)
/*!
 *  @brief  Hex integer to UIColor Utlity
 *
 *  @param col Takes a hex as integer ex:  0x123456
 *
 *  @example  UIColor *green = [UIColor colorWithHex: 0x123456];
 *
 *  @return UIColor for the HEX Int
 */
+(UIColor *)colorWithHex:(UInt32)col;
/*!
 *  @brief  Convert Hex value to UIColor
 *
 *  @param str Color Hex String . ex: @"#00ff00"
 *
 *  @example UIColor *green = [UIColor colorWithHexString:@"#00FF00"];
 *
 *  @return UIColor for Given Hex Value.
 */
+(UIColor *)fbColorWithHexString:(NSString *)str;

- (UIColor *)lighterColorForColor;
- (UIColor *)darkerColorForColor;
@end

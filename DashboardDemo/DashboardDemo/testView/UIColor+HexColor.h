//
//  UIColor+HexColor.h
//  YNGS
//
//  Created by URoad_MP on 15/7/29.
//  Copyright (c) 2015年 URoad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)

+(UIColor *)colorWithHex:(NSString *)hexColor;

+(UIColor *)colorWithHex:(NSString *)hexColor alpha:(float)alpha;

+(UIColor *)randomColor;
@end

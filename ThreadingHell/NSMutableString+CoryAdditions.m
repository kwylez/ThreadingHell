//
//  NSMutableString+WNAdditions.m
//  WhoNote
//
//  Created by Cory D. Wiles on 7/18/12.
//  Copyright (c) 2012 Cory D. Wiles. All rights reserved.
//

#import "NSMutableString+CoryAdditions.h"

@implementation NSMutableString (CoryAdditions)

+ (NSMutableString *)randomStringWithCapacity:(int)len {

  static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

  NSMutableString *randomString = [NSMutableString stringWithCapacity:len];

  for (int i = 0; i < len; i++) {
    [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
  }

  return randomString;
}

@end

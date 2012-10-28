//
//  main.m
//  ThreadingHell
//
//  Created by Cory D. Wiles on 10/19/12.
//  Copyright (c) 2012 Cory D. Wiles. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ModelManager.h"

int main(int argc, const char * argv[])
{

  @autoreleasepool {

    [[ModelManager sharedManager] getAccountListMetaInformation:^(id obj, BOOL success, NSError *error){

      NSLog(@"obj: %@", obj);
      NSLog(@"error: %@", error);
    }];
  }
    return 0;
}


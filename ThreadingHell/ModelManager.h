//
//  ModelManager.h
//  ThreadingHell
//
//  Created by Cory D. Wiles on 10/19/12.
//  Copyright (c) 2012 Cory D. Wiles. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^IMFRequestCompletionBlock)(id obj, BOOL success, NSError *error);

@interface ModelManager : NSObject

+ (ModelManager *)sharedManager;
- (void)getAccountListMetaInformation:(IMFRequestCompletionBlock)completion;
- (void)getAccountDetailsForAccountNumber:(NSString* )accountNumber
                          completionBlock:(IMFRequestCompletionBlock)completion;

@end

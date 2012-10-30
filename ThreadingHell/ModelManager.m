//
//  ModelManager.m
//  ThreadingHell
//
//  Created by Cory D. Wiles on 10/19/12.
//  Copyright (c) 2012 Cory D. Wiles. All rights reserved.
//

#import "ModelManager.h"
#import "NSMutableString+CoryAdditions.h"

static NSString* const wsRequestErrorDomain = @"net.epb.imf.im3.request.error";
static char const *imfQueueName             = "net.epb.imf.im3.queue";
static char const *imfNetworkQueueName      = "net.epb.imf.im3.network.queue";
static dispatch_queue_t _imfDispatchQueue;
static dispatch_queue_t _imfDispatchNeworkQueue;
static dispatch_group_t _imfDispatchGroup;

@implementation ModelManager

+ (void)initialize {
  _imfDispatchQueue       = dispatch_queue_create(imfQueueName, DISPATCH_QUEUE_CONCURRENT);
  _imfDispatchNeworkQueue = dispatch_queue_create(imfNetworkQueueName, 0);
  _imfDispatchGroup       = dispatch_group_create();
}

+ (ModelManager *)sharedManager {

  static ModelManager *_sharedClient = nil;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    _sharedClient = [[self alloc] init];
  });

  return _sharedClient;
}

- (void)getAccountDetailsForAccountNumber:(NSString* )accountNumber
                          completionBlock:(IMFRequestCompletionBlock)completion {

  __block NSMutableString *details = [NSMutableString randomStringWithCapacity:10];

  dispatch_sync(_imfDispatchNeworkQueue, ^{

    /**
     * This is a LONG NETWORK REQUEST
     */

    [details appendFormat:@" accountNumber: %@ details", accountNumber];

    NSLog(@"inside details: %@", details);

    if (completion) {

      NSLog(@"inside completion for %s", __PRETTY_FUNCTION__);

      if (details) {

        NSLog(@"details are found for account");

        completion(details, YES, nil);

      } else {

        NSString *errorMessage = [NSString stringWithFormat:@"Failed getting details for account: %@", accountNumber];
        NSError *failerror     = [NSError errorWithDomain:wsRequestErrorDomain
                                                     code:1002
                                                 userInfo:[NSDictionary dictionaryWithObject:NSLocalizedString(errorMessage, nil)
                                                                                      forKey:NSLocalizedDescriptionKey]];
        completion(nil, NO, failerror);
      }
    }
  });
}

- (void)getAccountListMetaInformation:(IMFRequestCompletionBlock)completion {

  __block NSMutableArray *accountDetails   = [NSMutableArray new];

  NSArray *loginResponse = @[@"account1", @"account2", @"account3", @"account4", @"account5"];

  if (loginResponse) {

    NSLog(@"inside loginResponse");

    [loginResponse enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){

      NSLog(@"inside account loop for obj: %@", obj);

      dispatch_group_async(_imfDispatchGroup, _imfDispatchQueue, ^{

        [self getAccountDetailsForAccountNumber:obj completionBlock:^(id obj, BOOL success, NSError *error) {

          if (success) {

            NSLog(@"success account looop");

            [accountDetails addObject:obj];

            NSLog(@"current instance of accountDetails: %@", accountDetails);

          } else {

            NSLog(@"failed to get any accont details from account: %@ %@", obj, [error localizedDescription]);
          }
        }];
      });
    }];

    dispatch_group_wait(_imfDispatchGroup, DISPATCH_TIME_FOREVER);

    NSLog(@"!!!!!!!!!! about to call completion block. This should be last");

    if (completion) {

      if (accountDetails.count) {

        NSLog(@">>>>>>>>>>>>> final instance of accountDetails: %@", accountDetails);

        completion(accountDetails, YES, nil);

      } else {

        NSString *errorMessage = @"There was error getting your accounts. Please login again.";
        NSError *failerror     = [NSError errorWithDomain:wsRequestErrorDomain
                                                     code:1003
                                                 userInfo:[NSDictionary dictionaryWithObject:NSLocalizedString(errorMessage, nil)
                                                                                      forKey:NSLocalizedDescriptionKey]];
        completion(nil, NO, failerror);
      }
    }
  }
}

@end

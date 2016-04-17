//
//  NetworkFetcher.h
//  Venus
//
//  Created by zhaoqin on 4/15/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NetworkFetcherCompletionHandler)();
typedef void(^NetworkFetcherErrorHandler)(NSString *error);

#define deBUG true

@interface NetworkFetcher : NSObject


@end

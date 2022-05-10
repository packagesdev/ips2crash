//
//  IPSSummarySerialization.h
//  ips2crash
//
//  Created by stephane on 24/04/2022.
//  Copyright © 2022 Whitebox. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IPSSummary.h"

@interface IPSSummarySerialization : NSObject

+ (IPSSummary *)summaryWithData:(NSData *)inData error:(out NSError **)outError;

@end

//
//  IPSReport+Obfuscation.m
//  ips2crash
//
//  Created by stephane on 15/07/2022.
//  Copyright © 2022 Whitebox. All rights reserved.
//

#import "IPSReport+Obfuscating.h"

#import "IPSCrashSummary+Obfuscating.h"
#import "IPSIncident+Obfuscating.h"

@implementation IPSReport (Obfuscating)

- (id)obfuscateWithObfuscator:(IPSObfuscator *)inObfuscator
{
    return [[IPSReport alloc] initWithSummary:[((IPSCrashSummary *)self.summary) obfuscateWithObfuscator:inObfuscator]
                                     incident:[self.incident obfuscateWithObfuscator:inObfuscator]];
}

@end

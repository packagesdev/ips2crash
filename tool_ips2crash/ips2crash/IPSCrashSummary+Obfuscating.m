//
//  IPSCrashSummary+Obfuscating.m
//  ips2crash
//
//  Created by stephane on 15/07/2022.
//  Copyright © 2022 Whitebox. All rights reserved.
//

#import "IPSCrashSummary+Obfuscating.h"

@interface IPSCrashSummary (Private)

- (void)setApplicationName:(NSString *)inApplicationName;

- (void)setApplicationVersion:(NSString *)inApplicationVersion;

- (void)setApplicationBuildVersion:(NSString *)inApplicationBuildVersion;

@end

@implementation IPSCrashSummary (Obfuscating)

- (id)obfuscateWithObfuscator:(IPSObfuscator *)inObfuscator
{
    IPSCrashSummary * nObfuscatedSummary=[[IPSCrashSummary alloc] initWithSummary:self];
    
    if (nObfuscatedSummary!=nil)
    {
        nObfuscatedSummary.applicationName=[inObfuscator obfuscatedStringWithString:self.applicationName family:IPSStringFamilyBinary];
        
        nObfuscatedSummary.applicationVersion=[self.applicationVersion copy];
        
        nObfuscatedSummary.applicationBuildVersion=[self.applicationBuildVersion copy];
    }
    
    return nObfuscatedSummary;
}

@end

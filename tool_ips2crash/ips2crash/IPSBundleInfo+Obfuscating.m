//
//  IPSBundleInfo+Obfuscating.m
//  ips2crash
//
//  Created by stephane on 15/07/2022.
//  Copyright © 2022 Whitebox. All rights reserved.
//

#import "IPSBundleInfo+Obfuscating.h"

@interface IPSBundleInfo (Private)

- (void)setBundleIdentifier:(NSString *)inBundleIdentifier;

@end

@implementation IPSBundleInfo (Obfuscating)

- (id)obfuscateWithObfuscator:(IPSObfuscator *)inObfuscator
{
    IPSBundleInfo * nObfuscatedBundleInfo=[self copy];
    
    if (nObfuscatedBundleInfo!=nil)
    {
        nObfuscatedBundleInfo.bundleIdentifier=[inObfuscator obfuscatedStringWithString:self.bundleIdentifier family:IPSStringFamilyBundleIdentifier];
    }
    
    return nObfuscatedBundleInfo;
}

@end

//
//  IPSObfuscator.m
//  ips2crash
//
//  Created by stephane on 15/07/2022.
//  Copyright © 2022 Whitebox. All rights reserved.
//

#import "IPSObfuscator.h"

@implementation IPSObfuscator

- (NSString *)obfuscatedStringWithString:(NSString *)inString family:(IPSStringFamily)inFamily
{
    switch(inFamily)
    {
        case IPSStringFamilyBinary:
            
            return @"toto";
            
        case IPSStringFamilyBundleIdentifier:
            
            return @"com.example.something";
        
        case IPSStringFamilyPath:
            
            return @"/some/path";
            
        default:
            
            return @"example";
    }
    
    return @"default";
}

@end

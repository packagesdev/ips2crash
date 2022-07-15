//
//  IPSObfuscator.h
//  ips2crash
//
//  Created by stephane on 15/07/2022.
//  Copyright © 2022 Whitebox. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, IPSStringFamily)
{
    IPSStringFamilyNone,
    IPSStringFamilyBinary,
    IPSStringFamilyBundleIdentifier,
    IPSStringFamilyPath
};


@interface IPSObfuscator : NSObject

- (NSString *)obfuscatedStringWithString:(NSString *)inString family:(IPSStringFamily)inFamily;

@end

@protocol IPSObfuscating <NSObject>

- (id)obfuscateWithObfuscator:(IPSObfuscator *)inObfuscator;

@end

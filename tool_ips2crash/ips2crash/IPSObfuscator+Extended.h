//
//  IPSObfuscator+Extended.h
//  ips2crash
//
//  Created by stephane on 18/07/2022.
//  Copyright © 2022 Whitebox. All rights reserved.
//

#import "IPSObfuscator.h"

@interface IPSObfuscator (Extended)

- (id)sharedObjectForKey:(NSString *)inKey;
- (void)setSharedObject:(id)inObject forKey:(NSString *)inKey;

@end

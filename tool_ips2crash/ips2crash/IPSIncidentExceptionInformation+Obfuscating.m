//
//  IPSIncidentExceptionInformation+Obfuscating.m
//  ips2crash
//
//  Created by stephane on 16/07/2022.
//  Copyright © 2022 Whitebox. All rights reserved.
//

#import "IPSIncidentExceptionInformation+Obfuscating.h"

@implementation IPSIncidentExceptionInformation (Obfuscating)

- (id)obfuscateWithObfuscator:(IPSObfuscator *)inObfuscator
{
    IPSIncidentExceptionInformation * nIncidentExceptionInformation=[self copy];
    
    if (nIncidentExceptionInformation!=nil)
    {
        // A COMPLETER
    }
    
    return nIncidentExceptionInformation;
}

@end

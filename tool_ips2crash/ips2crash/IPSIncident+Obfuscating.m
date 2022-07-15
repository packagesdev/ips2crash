//
//  IPSIncident+Obfuscating.m
//  ips2crash
//
//  Created by stephane on 15/07/2022.
//  Copyright © 2022 Whitebox. All rights reserved.
//

#import "IPSIncident+Obfuscating.h"

#import "IPSIncidentHeader+Obfuscating.h"

#import "IPSIncidentExceptionInformation+Obfuscating.h"

@interface IPSIncident (Private)

- (void)setHeader:(IPSIncidentHeader *)inHeader;

- (void)setExceptionInformation:(IPSIncidentExceptionInformation *)inExceptionInformation;

@end

@implementation IPSIncident (Obfuscating)

- (id)obfuscateWithObfuscator:(IPSObfuscator *)inObfuscator
{
    IPSIncident * nIncident=[IPSIncident alloc];
    
    if (nIncident!=nil)
    {
        nIncident.header=[self.header obfuscateWithObfuscator:inObfuscator];
        
        nIncident.exceptionInformation=[self.exceptionInformation obfuscateWithObfuscator:inObfuscator];
        
        // A COMPLETER
    }
    
    return nIncident;
}

@end

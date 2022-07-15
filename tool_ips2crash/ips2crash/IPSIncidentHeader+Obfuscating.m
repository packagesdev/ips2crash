//
//  IPSIncidentHeader+Obfuscating.m
//  ips2crash
//
//  Created by stephane on 15/07/2022.
//  Copyright © 2022 Whitebox. All rights reserved.
//

#import "IPSIncidentHeader+Obfuscating.h"

#import "IPSBundleInfo+Obfuscating.h"

@interface IPSIncidentHeader (Private)

- (void)setProcessName:(NSString *)inProcessName;

- (void)setProcessPath:(NSString *)inProcessPath;

- (void)setBundleInfo:(IPSBundleInfo *)inBundleInfo;

- (void)setParentProcessName:(NSString *)inParentProcessName;

- (void)setResponsibleProcessName:(NSString *)inResponsibleProcessName;

@end

@implementation IPSIncidentHeader (Obfuscating)

- (id)obfuscateWithObfuscator:(IPSObfuscator *)inObfuscator
{
    IPSIncidentHeader * nIncidentHeader=[self copy];
    
    if (nIncidentHeader!=nil)
    {
        nIncidentHeader.processName=[inObfuscator obfuscatedStringWithString:self.processName family:IPSStringFamilyBinary];
        
        nIncidentHeader.processPath=[inObfuscator obfuscatedStringWithString:self.processPath family:IPSStringFamilyPath];
        
        nIncidentHeader.bundleInfo=[self.bundleInfo obfuscateWithObfuscator:inObfuscator];
        
        nIncidentHeader.parentProcessName=[inObfuscator obfuscatedStringWithString:self.parentProcessName family:IPSStringFamilyBinary];
        
        nIncidentHeader.responsibleProcessName=[inObfuscator obfuscatedStringWithString:self.responsibleProcessName family:IPSStringFamilyBinary];
    }
    
    return nIncidentHeader;
}

@end

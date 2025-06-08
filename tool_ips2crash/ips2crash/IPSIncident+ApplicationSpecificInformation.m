/*
 Copyright (c) 2025, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "IPSIncident+ApplicationSpecificInformation.h"

@implementation IPSIncident (ApplicationSpecificInformation)

- (NSArray<NSString *> *)applicationSpecificInformationMessage
{
    IPSIncidentDiagnosticMessage * tDiagnosticMessage=self.diagnosticMessage;
    IPSExceptionReason * tExceptionReason=self.exceptionInformation.exceptionReason;
    
    if (tDiagnosticMessage.asi==nil && tExceptionReason==nil)
        return nil;
    
    NSMutableArray<NSString *> * tMutableArray=[NSMutableArray array];
    
    if (tExceptionReason != nil)
    {
        NSMutableString * tMutableString=[NSMutableString stringWithFormat:@"*** Terminating app due to uncaught exception '%@'",tExceptionReason.name];
        
        NSString * tDetailedReason=tExceptionReason.composed_message;
        
        if ([tDetailedReason hasPrefix:@"*** "] == YES)
            tDetailedReason = [tDetailedReason substringFromIndex:4];
        
        [tMutableString appendFormat:@", reason: '%@'",tDetailedReason];
        
        [tMutableArray addObject:tMutableString];
    }
    
    [tDiagnosticMessage.asi.applicationsInformation enumerateKeysAndObjectsUsingBlock:^(NSString * bProcess, NSArray * bInformation, BOOL * bOutStop) {
        
        [tMutableArray addObjectsFromArray:bInformation];
    }];
        
    if (tExceptionReason!=nil)
    {
        [tMutableArray addObject:[NSString stringWithFormat:@"terminating with uncaught exception of type %@",tExceptionReason.className]];
    }
    
    return [tMutableArray copy];
}

@end

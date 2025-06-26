/*
 Copyright (c) 2022, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "IPSIncident+Obfuscating.h"

#import "IPSObfuscator+Extended.h"

#import "NSArray+WBExtensions.h"

#import "IPSIncidentHeader+Obfuscating.h"

#import "IPSIncidentExceptionInformation+Obfuscating.h"

#import "IPSIncidentDiagnosticMessage+Obfuscating.h"

#import "IPSThread+Obfuscating.h"

#import "IPSImage+Obfuscating.h"
#import "IPSImage+UserCode.h"

@interface IPSIncident (Private)

- (void)setHeader:(IPSIncidentHeader *)inHeader;

- (void)setExceptionInformation:(IPSIncidentExceptionInformation *)inExceptionInformation;

- (void)setDiagnosticMessage:(IPSIncidentDiagnosticMessage *)inDiagnosticMessage;

- (void)setThreads:(NSArray<IPSThread *> * )inThreads;

- (void)setBinaryImages:(NSArray<IPSImage *> * )inBinaryImages;

- (void)setVmSummary:(NSString *)inVmSummary;

@end

@implementation IPSIncident (Obfuscating)

- (id)obfuscateWithObfuscator:(IPSObfuscator *)inObfuscator
{
	IPSIncident * nIncident=[self copy];
	
	if (nIncident!=nil)
	{
		nIncident.header=[self.header obfuscateWithObfuscator:inObfuscator];
		
		nIncident.exceptionInformation=[self.exceptionInformation obfuscateWithObfuscator:inObfuscator];
		
		NSMutableIndexSet * tMutableIndexSet=[NSMutableIndexSet indexSet];
		
		nIncident.binaryImages=[self.binaryImages WB_arrayByMappingObjectsUsingBlock:^IPSImage *(IPSImage * bImage, NSUInteger bIndex) {
			
			BOOL tIsUserCode=bImage.isUserCode;
			
			if (tIsUserCode==YES)
			{
				[tMutableIndexSet addIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(bImage.loadAddress,bImage.size)]];
				
				[inObfuscator setSharedObject:@(YES) forKey:[NSString stringWithFormat:@"image_%lu",bIndex]];
			}
			
			return [bImage obfuscateWithObfuscator:inObfuscator];
		}];
		
		[inObfuscator setSharedObject:[tMutableIndexSet copy] forKey:@"userCodeIndexSet"];
		
		nIncident.diagnosticMessage=[self.diagnosticMessage obfuscateWithObfuscator:inObfuscator];
		
		nIncident.threads=[self.threads WB_arrayByMappingObjectsUsingBlock:^id(IPSThread * bThread, NSUInteger bIndex) {
		   
			return [bThread obfuscateWithObfuscator:inObfuscator];
			
		}];
		
		nIncident.vmSummary=self.vmSummary;
	}
	
	return nIncident;
}

@end

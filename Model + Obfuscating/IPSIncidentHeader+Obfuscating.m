/*
 Copyright (c) 2022-2025, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "IPSIncidentHeader+Obfuscating.h"

#import "IPSBundleInfo+Obfuscating.h"


@interface IPSCodeSigningInfo (Private) <IPSObfuscating>

- (void)setIdentifier:(NSString *)inIdentifier;

- (void)setTeamIdentifier:(NSString *)inProcessPath;

@end


@interface IPSIncidentHeader (Private)

- (void)setProcessName:(NSString *)inProcessName;

- (void)setProcessPath:(NSString *)inProcessPath;

- (void)setBundleInfo:(IPSBundleInfo *)inBundleInfo;

- (void)setCodeSigningInfo:(IPSCodeSigningInfo *)inCodeSigningInfo;

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
		
		nIncidentHeader.codeSigningInfo=[self.codeSigningInfo obfuscateWithObfuscator:inObfuscator];
		
		nIncidentHeader.bundleInfo=[self.bundleInfo obfuscateWithObfuscator:inObfuscator];
		
		nIncidentHeader.parentProcessName=[inObfuscator obfuscatedStringWithString:self.parentProcessName family:IPSStringFamilyBinary];
		
		nIncidentHeader.responsibleProcessName=[inObfuscator obfuscatedStringWithString:self.responsibleProcessName family:IPSStringFamilyBinary];
	}
	
	return nIncidentHeader;
}

@end


@implementation IPSCodeSigningInfo (Obfuscating)

- (id)obfuscateWithObfuscator:(IPSObfuscator *)inObfuscator
{
	IPSCodeSigningInfo * nCodeSigningInfo=[self copy];
	
	if (nCodeSigningInfo!=nil)
	{
		nCodeSigningInfo.identifier=[inObfuscator obfuscatedStringWithString:self.identifier family:IPSStringFamilyBundleIdentifier];
		
		nCodeSigningInfo.teamIdentifier=[inObfuscator obfuscatedStringWithString:self.teamIdentifier family:IPSStringFamilyNone];
	}
	
	return nCodeSigningInfo;
}

@end

/*
 Copyright (c) 2022, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "IPSThread+Obfuscating.h"

#import "IPSThreadFrame+Obfuscating.h"
#import "IPSThreadState+Obfuscating.h"

#import "NSArray+WBExtensions.h"

@interface IPSThread (Private)

- (void)setQueue:(NSString *)inQueue;
- (void)setName:(NSString *)inName;
- (void)setFrames:(NSArray<IPSThreadFrame *> *)inFrames;
- (void)setThreadState:(IPSThreadState *)inThreadState;

@end

@implementation IPSThread (Obfuscating)

- (id)obfuscateWithObfuscator:(IPSObfuscator *)inObfuscator
{
	IPSThread * nThread=[self copy];
	
	if (nThread!=nil)
	{
		nThread.queue=[inObfuscator obfuscatedStringWithString:self.queue family:IPSStringFamilyQueue];
		
		nThread.name=[inObfuscator obfuscatedStringWithString:self.name family:IPSStringFamilyThreadName];
		
		nThread.frames=[self.frames WB_arrayByMappingObjectsUsingBlock:^IPSThreadFrame *(IPSThreadFrame * bThreadFrame, NSUInteger bIndex) {
		   
			return [bThreadFrame obfuscateWithObfuscator:inObfuscator];
			
		}];
		
		nThread.threadState=[self.threadState obfuscateWithObfuscator:inObfuscator];
	}
	
	return nThread;
}

@end

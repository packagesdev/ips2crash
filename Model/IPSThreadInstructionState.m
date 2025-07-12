/*
 Copyright (c) 2021-2025, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "IPSThreadInstructionState.h"

NSString * const IPSThreadInstructionStateInstructionStreamKey=@"instructionStream";

@interface IPSThreadInstructionState ()

	@property (readwrite) IPSThreadInstructionStream * instructionStream;

@end


@implementation IPSThreadInstructionState

- (nullable instancetype)initWithRepresentation:(nullable NSDictionary *)inRepresentation error:(out NSError **)outError
{
	if (inRepresentation==nil)
	{
		if (outError!=NULL)
			*outError=[NSError errorWithDomain:IPSErrorDomain code:IPSRepresentationNilRepresentationError userInfo:nil];
		
		return nil;
	}
	
	if ([inRepresentation isKindOfClass:NSDictionary.class]==NO)
	{
		if (outError!=NULL)
			*outError=[NSError errorWithDomain:IPSErrorDomain code:IPSRepresentationInvalidTypeOfValueError userInfo:nil];
		
		return nil;
	}
	
	self=[super init];
	
	if (self!=nil)
	{
		NSDictionary * tDictionary=inRepresentation[IPSThreadInstructionStateInstructionStreamKey];
		
		_instructionStream=[[IPSThreadInstructionStream alloc] initWithRepresentation:tDictionary error:NULL];
	}
	
	return self;
}

#pragma mark -

- (NSDictionary *)representation
{
	return @{
			 IPSThreadInstructionStateInstructionStreamKey:[self.instructionStream representation]
			 };
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)inZone
{
	IPSThreadInstructionState * nThreadInstructionState=[IPSThreadInstructionState allocWithZone:inZone];
	
	if (nThreadInstructionState!=nil)
	{
		nThreadInstructionState->_instructionStream=[self.instructionStream copyWithZone:inZone];
	}
	
	return nThreadInstructionState;
}

@end

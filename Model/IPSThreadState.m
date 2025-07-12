/*
 Copyright (c) 2021-2025, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "IPSThreadState.h"

#import "NSDictionary+WBExtensions.h"

#import "NSDictionary+WBExtensions.h"

NSString * const IPSThreadStateFlavorKey=@"flavor";

NSString * const IPSThreadStateCpuKey=@"cpu";

NSString * const IPSThreadStateErrKey=@"err";

NSString * const IPSThreadStateTrapKey=@"trap";

NSString * const IPSThreadStateXKey=@"x";

@interface IPSThreadState ()

	@property (readwrite,copy) NSString * flavor;

	@property (readwrite) NSDictionary<NSString *,IPSRegisterState *> * registersStates;

@end

@implementation IPSThreadState

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
		NSString * tString=inRepresentation[IPSThreadStateFlavorKey];
		
		IPSFullCheckStringValueForKey(tString,IPSThreadStateFlavorKey);
		
		_flavor=[tString copy];
		
		__block BOOL tDidFail=NO;
		__block NSError * tError=nil;
		
		_registersStates=[inRepresentation WB_dictionaryByMappingObjectsLenientlyUsingBlock:^IPSRegisterState *(NSString * bKey, NSDictionary * bThreadStateRepresentation) {
			
			if (tDidFail==YES)
				return nil;
			
			if ([bKey isEqualToString:IPSThreadStateFlavorKey]==YES)
				return nil;
			
			if ([bKey isEqualToString:IPSThreadStateXKey]==YES)
				return nil;
			
			IPSRegisterState * tRegisterState=[[IPSRegisterState alloc] initWithRepresentation:bThreadStateRepresentation error:&tError];
			
			tDidFail=(tRegisterState==nil);
			
			return tRegisterState;
		}];
		
		if (tDidFail==YES)
		{
			if (outError!=NULL)
				*outError=tError;
			
			return nil;
		}
		
		NSArray * tArray=inRepresentation[IPSThreadStateXKey];
		
		if (tArray!=nil)
		{
			NSMutableDictionary * tMutableDictionary=[_registersStates mutableCopy];
			
			[tArray enumerateObjectsUsingBlock:^(NSDictionary * bThreadStateRepresentation, NSUInteger bRegisterIndex, BOOL * bOutStop) {
			
				IPSRegisterState * tRegisterState=[[IPSRegisterState alloc] initWithRepresentation:bThreadStateRepresentation error:&tError];
				
				if (tRegisterState!=nil)
				{
					tMutableDictionary[[NSString stringWithFormat:@"x%u",(unsigned int)bRegisterIndex]]=tRegisterState;
				}
			}];
			
			_registersStates=[tMutableDictionary copy];
		}
	}
	
	return self;
}

#pragma mark -

- (NSDictionary *)representation
{
	return @{};
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)inZone
{
	IPSThreadState * nThreadState=[IPSThreadState allocWithZone:inZone];
	
	if (nThreadState!=nil)
	{
		nThreadState->_flavor=[self.flavor copyWithZone:inZone];
		
		nThreadState->_registersStates=[self.registersStates WB_dictionaryByMappingObjectsUsingBlock:^IPSRegisterState *(id bKey, IPSRegisterState * bRegisterState) {
			
			return [bRegisterState copyWithZone:inZone];
		}];
	}
	
	return nThreadState;
}

@end

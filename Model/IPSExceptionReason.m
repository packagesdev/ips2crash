/*
 Copyright (c) 2025, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "IPSExceptionReason.h"

NSString * const IPSExceptionReasonNameKey=@"name";

NSString * const IPSExceptionReasonTypeKey=@"type";

NSString * const IPSExceptionReasonClassKey=@"class";


@interface IPSExceptionReason ()

	@property (readwrite) NSString *name;

	@property (readwrite) NSString *type;

	@property (readwrite) NSString *className;

	@property (readwrite) NSArray <NSString *> *arguments;

	@property (readwrite) NSString *format_string;

	@property (readwrite) NSString *composed_message;

@end

@implementation IPSExceptionReason

- (instancetype)initWithRepresentation:(NSDictionary *)inRepresentation error:(out NSError **)outError
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
	}
	
	return self;
}

#pragma mark -

- (NSDictionary *)representation
{
	NSMutableDictionary * tMutableDictionary=[NSMutableDictionary dictionary];
	
	if (self.name!=nil)
		tMutableDictionary[IPSExceptionReasonNameKey]=self.name;
	
	if (self.type!=nil)
		tMutableDictionary[IPSExceptionReasonTypeKey]=self.type;
	 
	 if (self.className!=nil)
		 tMutableDictionary[IPSExceptionReasonClassKey]=self.className;
	
	return [tMutableDictionary copy];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)inZone
{
	IPSExceptionReason * nExceptionReason=[IPSExceptionReason allocWithZone:inZone];
	
	if (nExceptionReason!=nil)
	{
		nExceptionReason->_name=[self.name copyWithZone:inZone];
		
		nExceptionReason->_type=[self.type copyWithZone:inZone];
		
		nExceptionReason->_className=[self.className copyWithZone:inZone];
		
		nExceptionReason->_format_string=[self.format_string copyWithZone:inZone];
		
		nExceptionReason->_composed_message=[self.composed_message copyWithZone:inZone];
	}
	
	return nExceptionReason;
}

@end

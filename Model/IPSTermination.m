/*
 Copyright (c) 2021, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "IPSTermination.h"

NSString * const IPSTerminationCodeKey=@"code";

NSString * const IPSTerminationFlagsKey=@"flags";

NSString * const IPSTerminationIndicatorKey=@"indicator";

NSString * const IPSTerminationNamespaceKey=@"namespace";

NSString * const IPSTerminationByProcKey=@"byProc";

NSString * const IPSTerminationByPidKey=@"byPid";

@interface IPSTermination ()

	@property (readwrite) NSUInteger code;

	@property (readwrite) NSUInteger flags;

	@property (nullable,readwrite,copy) NSString * indicator;

	@property (readwrite,copy) NSString * namespace;

	@property (nullable,readwrite,copy) NSString * byProc;

	@property (readwrite) pid_t byPid;

@end

@implementation IPSTermination

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
		NSNumber * tNumber=inRepresentation[IPSTerminationCodeKey];

		IPSFullCheckNumberValueForKey(tNumber,IPSTerminationCodeKey);

		_code=[tNumber unsignedIntegerValue];

		tNumber=inRepresentation[IPSTerminationFlagsKey];

		IPSFullCheckNumberValueForKey(tNumber,IPSTerminationFlagsKey);

		_flags=[tNumber unsignedIntegerValue];

		NSString * tString=inRepresentation[IPSTerminationIndicatorKey];

		if (tString!=nil)
		{
			IPSClassCheckStringValueForKey(tString,IPSTerminationIndicatorKey);

			_indicator=[tString copy];
		}

		tString=inRepresentation[IPSTerminationNamespaceKey];

		IPSFullCheckStringValueForKey(tString,IPSTerminationNamespaceKey);

		_namespace=[tString copy];

		tString=inRepresentation[IPSTerminationByProcKey];

		if (tString!=nil)
		{
			IPSClassCheckStringValueForKey(tString,IPSTerminationByProcKey);

			_byProc=[tString copy];

			tNumber=inRepresentation[IPSTerminationByPidKey];

			IPSFullCheckNumberValueForKey(tNumber,IPSTerminationByPidKey);

			_byPid=[tNumber intValue];
		}
	}

	return self;
}

#pragma mark -

- (NSDictionary *)representation
{
	NSMutableDictionary * tMutableDictionary=[NSMutableDictionary dictionaryWithDictionary:@{
																							 IPSTerminationCodeKey:@(self.code),
																							 IPSTerminationFlagsKey:@(self.flags),
																							 IPSTerminationNamespaceKey:self.namespace
																							 }];
	
	if (self.byProc!=nil)
	{
		tMutableDictionary[IPSTerminationByProcKey]=self.byProc;
		tMutableDictionary[IPSTerminationByPidKey]=@(self.byPid);
	}

	if (self.indicator!=nil)
		tMutableDictionary[IPSTerminationIndicatorKey]=self.indicator;

	return [tMutableDictionary copy];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)inZone
{
	IPSTermination * nTermination=[IPSTermination allocWithZone:inZone];

	if (nTermination!=nil)
	{
		nTermination->_code=self.code;

		nTermination->_flags=self.flags;

		nTermination->_indicator=[self.indicator copyWithZone:inZone];

		nTermination->_namespace=[self.namespace copyWithZone:inZone];

		nTermination->_byProc=[self.byProc copyWithZone:inZone];

		nTermination->_byPid=self.byPid;
	}

	return nTermination;
}

@end

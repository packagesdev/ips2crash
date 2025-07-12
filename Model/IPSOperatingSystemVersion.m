/*
 Copyright (c) 2021-2025, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "IPSOperatingSystemVersion.h"

NSString * const IPSOperatingSystemVersionTrainKey=@"train";

NSString * const IPSOperatingSystemVersionBuildKey=@"build";

NSString * const IPSOperatingSystemVersionReleaseTypeKey=@"releaseType";


@interface IPSOperatingSystemVersion ()

	@property (readwrite,copy) NSString * train;

	@property (readwrite,copy) NSString * build;

	@property (readwrite,copy) NSString * releaseType;

@end

@implementation IPSOperatingSystemVersion

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
		NSString * tString=inRepresentation[IPSOperatingSystemVersionTrainKey];

		IPSFullCheckStringValueForKey(tString,IPSOperatingSystemVersionTrainKey);

		_train=[tString copy];

		tString=inRepresentation[IPSOperatingSystemVersionBuildKey];

		IPSFullCheckStringValueForKey(tString,IPSOperatingSystemVersionBuildKey);

		_build=[tString copy];

		tString=inRepresentation[IPSOperatingSystemVersionReleaseTypeKey];

		IPSFullCheckStringValueForKey(tString,IPSOperatingSystemVersionReleaseTypeKey);

		_releaseType=[tString copy];
	}

	return self;
}

#pragma mark -

- (NSDictionary *)representation {
	
	return @{
			 IPSOperatingSystemVersionTrainKey:self.train,
			 IPSOperatingSystemVersionBuildKey:self.build,
			 IPSOperatingSystemVersionReleaseTypeKey:self.releaseType
			 };
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)inZone
{
	IPSOperatingSystemVersion * nOperatingSystemVersion=[IPSOperatingSystemVersion allocWithZone:inZone];

	if (nOperatingSystemVersion!=nil)
	{
		nOperatingSystemVersion->_train=[self.train copyWithZone:inZone];

		nOperatingSystemVersion->_build=[self.build copyWithZone:inZone];

		nOperatingSystemVersion->_releaseType=[self.releaseType copyWithZone:inZone];
	}
	
	return nOperatingSystemVersion;
}

@end

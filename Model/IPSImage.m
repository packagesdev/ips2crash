/*
 Copyright (c) 2021-2025, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "IPSImage.h"

NSString * const IPSImageSourceKey=@"source";

NSString * const IPSImageArchitectureKey=@"arch";

NSString * const IPSImageNameKey=@"name";

NSString * const IPSImageBundleVersion=@"CFBundleVersion";

NSString * const IPSImageBundleShortVersionString=@"CFBundleShortVersionString";

NSString * const IPSImageBundleIdentifierKey=@"CFBundleIdentifier";

NSString * const IPSImagePathKey=@"path";

NSString * const IPSImageUUIDKey=@"uuid";

NSString * const IPSImageBaseAddressKey=@"base";

NSString * const IPSImageSizeKey=@"size";

@interface IPSImage ()

	@property (readwrite,copy) NSString * source;

	@property (nullable,readwrite,copy) NSString * name;

	@property (nullable,readwrite,copy) NSString * bundleIdentifier;

	@property (nullable,readwrite,copy) NSString * bundleVersion;

	@property (nullable,readwrite,copy) NSString * bundleShortVersionString;

	@property (nullable,readwrite,copy) NSString * path;

	@property (readwrite) NSUUID * UUID;

	@property (nullable,readwrite,copy) NSString * architecture;

	@property (readwrite) NSUInteger loadAddress;

	@property (readwrite) NSUInteger size;

@end

@implementation IPSImage

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
		NSString * tString=inRepresentation[IPSImageSourceKey];
		
		IPSFullCheckStringValueForKey(tString,IPSImageSourceKey);
			
		_source=[tString copy];
		
		tString=inRepresentation[IPSImageNameKey];
		
		if (tString!=nil)
		{
			IPSFullCheckStringValueForKey(tString,IPSImageNameKey);
			
			_name=[tString copy];
		}
		
		tString=inRepresentation[IPSImageBundleVersion];
		
		if (tString!=nil)
		{
			IPSClassCheckStringValueForKey(tString,IPSImageBundleVersion);
		
			_bundleVersion=[tString copy];
		}
		
		tString=inRepresentation[IPSImageBundleShortVersionString];
		
		if (tString!=nil)
		{
			IPSClassCheckStringValueForKey(tString,IPSImageBundleShortVersionString);
			
			_bundleShortVersionString=[tString copy];
		}
		
		tString=inRepresentation[IPSImageBundleIdentifierKey];
		
		if (tString!=nil)
		{
			IPSClassCheckStringValueForKey(tString,IPSImageBundleIdentifierKey);
			
			_bundleIdentifier=[tString copy];
		}
		
		tString=inRepresentation[IPSImagePathKey];
		
		if (tString!=nil)
		{
			IPSFullCheckStringValueForKey(tString,IPSImagePathKey);
			
			_path=[tString copy];
		}
		
		tString=inRepresentation[IPSImageUUIDKey];
		
		IPSFullCheckStringValueForKey(tString,IPSImageUUIDKey);
		
		_UUID=[[NSUUID alloc] initWithUUIDString:tString];
		
		tString=inRepresentation[IPSImageArchitectureKey];
		
		if (tString!=nil)
		{
			IPSFullCheckStringValueForKey(tString,IPSImageArchitectureKey);
		
			_architecture=[tString copy];
		}
		
		NSNumber * tNumber=inRepresentation[IPSImageBaseAddressKey];
		
		IPSFullCheckNumberValueForKey(tNumber,IPSImageBaseAddressKey);
		
		_loadAddress=[tNumber unsignedIntegerValue];
		
		tNumber=inRepresentation[IPSImageSizeKey];
		
		IPSFullCheckNumberValueForKey(tNumber,IPSImageSizeKey);
		
		_size=[tNumber unsignedIntegerValue];
		
	}
	
	return self;
}

#pragma mark -

- (NSComparisonResult)compare:(IPSImage *)otherImage
{
	if (self.loadAddress==otherImage.loadAddress)
		return NSOrderedSame;
	
	if (self.loadAddress>otherImage.loadAddress)
		return NSOrderedDescending;
	
	return NSOrderedAscending;
}

#pragma mark -

- (NSDictionary *)representation
{
	return @{};
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)inZone
{
	IPSImage * nImage=[IPSImage allocWithZone:inZone];
	
	if (nImage!=nil)
	{
		nImage->_source=[self.source copyWithZone:inZone];
		
		nImage->_name=[self.name copyWithZone:inZone];
		
		nImage->_bundleIdentifier=[self.bundleIdentifier copyWithZone:inZone];
		
		nImage->_bundleVersion=[self.bundleVersion copyWithZone:inZone];
		
		nImage->_bundleShortVersionString=[self.bundleShortVersionString copyWithZone:inZone];
		
		nImage->_path=[self.path copyWithZone:inZone];
		
		nImage->_UUID=self.UUID;
		
		nImage->_architecture=[self.architecture copyWithZone:inZone];
		
		nImage->_loadAddress=self.loadAddress;
		
		nImage->_size=self.size;
	}
	
	return nImage;
}

@end

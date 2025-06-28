/*
 Copyright (c) 2021-2025, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "IPSIncidentHeader.h"

#import "IPSDateFormatter.h"

NSString * const IPSIncidentHeaderProcessNameKey=@"procName";

NSString * const IPSIncidentHeaderProcessIDKey=@"pid";

NSString * const IPSIncidentHeaderProcessPathKey=@"procPath";

NSString * const IPSIncidentHeaderBundleInfoKey=@"bundleInfo";

NSString * const IPSIncidentHeaderCPUTypeKey=@"cpuType";

NSString * const IPSIncidentHeaderTranslatedKey=@"translated";

NSString * const IPSIncidentHeaderParentProcessNameKey=@"parentProc";

NSString * const IPSIncidentHeaderParentProcessIDKey=@"parentPid";

NSString * const IPSIncidentHeaderResponsibleProcessNameKey=@"responsibleProc";

NSString * const IPSIncidentHeaderResponsibleProcessIDKey=@"responsiblePid";


NSString * const IPSIncidentHeaderCodeSigningIDKey=@"codeSigningID";

NSString * const IPSIncidentHeaderCodeSigningTeamIDKey=@"codeSigningTeamID";

NSString * const IPSIncidentHeaderCodeSigningFlagsKey=@"codeSigningFlags";

NSString * const IPSIncidentHeaderCodeSigningValidationCategoryKey=@"codeSigningValidationCategory";

NSString * const IPSIncidentHeaderCodeSigningTrustLevelKey=@"codeSigningTrustLevel";

NSString * const IPSIncidentHeaderCodeSigningAuxiliaryInfoKey=@"codeSigningAuxiliaryInfo";


NSString * const IPSIncidentHeaderUserIDKey=@"userID";



NSString * const IPSIncidentHeaderCaptureTimeKey=@"captureTime";

NSString * const IPSIncidentHeaderOperatingSystemVersionKey=@"osVersion";

NSString * const IPSIncidentHeaderCrashReporterKey=@"crashReporterKey";


NSString * const IPSIncidentHeaderSleepWakeUUIDKey=@"sleepWakeUUID";


NSString * const IPSIncidentHeaderUptimeKey=@"uptime";


NSString * const IPSIncidentHeaderSystemIntegrityProtectionKey=@"sip";


@interface IPSCodeSigningInfo ()

	@property (readwrite,copy) NSString * identifier;	// can be nil

	@property (readwrite,copy) NSString * teamIdentifier;	// can be nil

	@property (readwrite) NSUInteger flags;

	@property (readwrite) NSUInteger validationCategory;

	@property (readwrite) NSUInteger trustLevel;

	@property (readwrite) NSUInteger auxiliaryInfo;

@end


@interface IPSIncidentHeader ()

	@property (readwrite,copy) NSString * processName;

	@property (readwrite) pid_t processID;

	@property (readwrite,copy) NSString * processPath;

	@property (readwrite) IPSBundleInfo * bundleInfo;

	@property (readwrite,copy) NSString * cpuType;

	@property (readwrite) BOOL translated;

	@property (readwrite,copy) NSString * parentProcessName;

	@property (readwrite) pid_t parentProcessID;

	@property (readwrite,copy) NSString * responsibleProcessName;	// can be nil

	@property (readwrite) pid_t responsibleProcessID;

	@property (readwrite) IPSCodeSigningInfo * codeSigningInfo;	// can be nil

	@property (readwrite) uid_t userID;


	@property (readwrite) NSDate * captureTime;

	@property (readwrite) IPSOperatingSystemVersion * operatingSystemVersion;

	@property (readwrite) NSUInteger reportVersion;

	@property (readwrite) NSUUID * crashReporterKey;


	@property (readwrite) NSUUID * sleepWakeUUID;


	@property (readwrite) NSUInteger uptime;


	@property (readwrite) BOOL systemIntegrityProtectionEnable;

@end

@implementation IPSIncidentHeader

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
		NSString * tString=inRepresentation[IPSIncidentHeaderProcessNameKey];

		IPSFullCheckStringValueForKey(tString,IPSIncidentHeaderProcessNameKey);

		_processName=[tString copy];

		NSNumber * tNumber=inRepresentation[IPSIncidentHeaderProcessIDKey];

		IPSFullCheckNumberValueForKey(tNumber,IPSIncidentHeaderProcessIDKey);

		_processID=[tNumber intValue];

		tString=inRepresentation[IPSIncidentHeaderProcessPathKey];

		IPSFullCheckStringValueForKey(tString,IPSIncidentHeaderProcessPathKey);

		_processPath=[tString copy];

		NSError * tError=nil;
		NSDictionary * tDictionary=inRepresentation[IPSIncidentHeaderBundleInfoKey];

		if (tDictionary!=nil)
		{
			_bundleInfo=[[IPSBundleInfo alloc] initWithRepresentation:tDictionary error:&tError];

			if (_bundleInfo==nil)
			{
				NSString * tPathError=IPSIncidentHeaderOperatingSystemVersionKey;
	
				if (tError.userInfo[IPSKeyPathErrorKey]!=nil)
					tPathError=[tPathError stringByAppendingPathComponent:tError.userInfo[IPSKeyPathErrorKey]];

				if (outError!=NULL)
					*outError=[NSError errorWithDomain:IPSErrorDomain
												  code:tError.code
											  userInfo:@{IPSKeyPathErrorKey:tPathError}];

				return nil;
			}
		}

		tString=inRepresentation[IPSIncidentHeaderCPUTypeKey];

		IPSFullCheckStringValueForKey(tString,IPSIncidentHeaderCPUTypeKey);

		_cpuType=[tString copy];

		tNumber=inRepresentation[IPSIncidentHeaderTranslatedKey];

		if (tNumber!=nil)
		{
			IPSClassCheckNumberValueForKey(tNumber,IPSIncidentHeaderTranslatedKey);

			_translated=[tNumber boolValue];
		}

		tString=inRepresentation[IPSIncidentHeaderParentProcessNameKey];

		IPSFullCheckStringValueForKey(tString,IPSIncidentHeaderParentProcessNameKey);

		_parentProcessName=[tString copy];

		tNumber=inRepresentation[IPSIncidentHeaderParentProcessIDKey];

		IPSFullCheckNumberValueForKey(tNumber,IPSIncidentHeaderParentProcessIDKey);

		_parentProcessID=[tNumber intValue];


		tString=inRepresentation[IPSIncidentHeaderResponsibleProcessNameKey];

		if (tString!=nil)
		{
			IPSClassCheckStringValueForKey(tString,IPSIncidentHeaderResponsibleProcessNameKey);

			_responsibleProcessName=[tString copy];

			tNumber=inRepresentation[IPSIncidentHeaderResponsibleProcessIDKey];

			IPSFullCheckNumberValueForKey(tNumber,IPSIncidentHeaderResponsibleProcessIDKey);

			_responsibleProcessID=[tNumber intValue];
		}
	
		_codeSigningInfo = [[IPSCodeSigningInfo alloc] initWithRepresentation:inRepresentation error:&tError];
		
		if (_codeSigningInfo==nil)
		{
			if (outError!=NULL && tError!=nil)
				*outError=tError;

			return nil;
		}
        
		tNumber=inRepresentation[IPSIncidentHeaderUserIDKey];

		IPSFullCheckNumberValueForKey(tNumber,IPSIncidentHeaderUserIDKey);

		_userID=[tNumber unsignedIntValue];



		tString=inRepresentation[IPSIncidentHeaderCaptureTimeKey];

		IPSFullCheckStringValueForKey(tString,IPSIncidentHeaderCaptureTimeKey);

		_captureTime=[[IPSDateFormatter sharedFormatter] dateFromString:tString];


		tDictionary=inRepresentation[IPSIncidentHeaderOperatingSystemVersionKey];


		tError=nil;
		_operatingSystemVersion=[[IPSOperatingSystemVersion alloc] initWithRepresentation:tDictionary error:&tError];

		if (_operatingSystemVersion==nil)
		{
			NSString * tPathError=IPSIncidentHeaderOperatingSystemVersionKey;

			if (tError.userInfo[IPSKeyPathErrorKey]!=nil)
				tPathError=[tPathError stringByAppendingPathComponent:tError.userInfo[IPSKeyPathErrorKey]];

			if (outError!=NULL)
				*outError=[NSError errorWithDomain:IPSErrorDomain
											  code:tError.code
										  userInfo:@{IPSKeyPathErrorKey:tPathError}];

			return nil;
		}

		tString=inRepresentation[IPSIncidentHeaderCrashReporterKey];
	
		IPSFullCheckStringValueForKey(tString,IPSIncidentHeaderCrashReporterKey);
	
		_crashReporterKey=[[NSUUID alloc] initWithUUIDString:tString];



		tString=inRepresentation[IPSIncidentHeaderSleepWakeUUIDKey];

		if (tString!=nil)
		{
			IPSClassCheckStringValueForKey(tString,IPSIncidentHeaderSleepWakeUUIDKey);

			_sleepWakeUUID=[[NSUUID alloc] initWithUUIDString:tString];
		}


		tNumber=inRepresentation[IPSIncidentHeaderUptimeKey];

		IPSFullCheckNumberValueForKey(tNumber,IPSIncidentHeaderUptimeKey);

		_uptime=[tNumber unsignedIntegerValue];


		tString=inRepresentation[IPSIncidentHeaderSystemIntegrityProtectionKey];

		if (tString!=nil)
		{
			IPSClassCheckStringValueForKey(tString,IPSIncidentHeaderSystemIntegrityProtectionKey);

			_systemIntegrityProtectionEnable=[tString isEqualToString:@"enabled"];
		}
	}
	
	return self;
}

- (NSDictionary *)representation
{
	NSMutableDictionary * tMutableRepresentation=[NSMutableDictionary dictionary];

	// A COMPLETER

	[tMutableRepresentation addEntriesFromDictionary:[self.codeSigningInfo representation]];

	return [tMutableRepresentation copy];
}

#pragma mark -

- (id)copyWithZone:(NSZone *)inZone
{
	IPSIncidentHeader * nIncidentHeader=[IPSIncidentHeader allocWithZone:inZone];

	if (nIncidentHeader!=nil)
	{
		nIncidentHeader->_processName=[self.processName copyWithZone:inZone];
	
		nIncidentHeader->_processID=self.processID;

		nIncidentHeader->_processPath=[self.processPath copyWithZone:inZone];

		nIncidentHeader->_bundleInfo=[self.bundleInfo copyWithZone:inZone];

		nIncidentHeader->_cpuType=self.cpuType;

		nIncidentHeader->_translated=self.translated;

		nIncidentHeader->_parentProcessName=[self.parentProcessName copyWithZone:inZone];

		nIncidentHeader->_parentProcessID=self.parentProcessID;

		nIncidentHeader->_responsibleProcessName=[self.responsibleProcessName copyWithZone:inZone];

		nIncidentHeader->_responsibleProcessID=self.responsibleProcessID;

		nIncidentHeader->_codeSigningInfo=[self.codeSigningInfo copyWithZone:inZone];

		nIncidentHeader->_userID=self.userID;

		nIncidentHeader->_captureTime=self.captureTime;

		nIncidentHeader->_operatingSystemVersion=[self.operatingSystemVersion copyWithZone:inZone];

		nIncidentHeader->_reportVersion=self.reportVersion;

		nIncidentHeader.crashReporterKey=self.crashReporterKey;

		nIncidentHeader.sleepWakeUUID=self.sleepWakeUUID;

		nIncidentHeader.uptime=self.uptime;

		nIncidentHeader.systemIntegrityProtectionEnable=self.systemIntegrityProtectionEnable;
	}

	return nIncidentHeader;
}

@end


@implementation IPSCodeSigningInfo

#pragma mark -

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
		NSString * tString=inRepresentation[IPSIncidentHeaderCodeSigningIDKey];
	
		if (tString!=nil)
		{
			IPSClassCheckStringValueForKey(tString,IPSIncidentHeaderCodeSigningIDKey);

			if (tString.length>0)
				_identifier=[tString copy];
		}

		tString=inRepresentation[IPSIncidentHeaderCodeSigningTeamIDKey];
		
		if (tString!=nil)
		{
			IPSClassCheckStringValueForKey(tString,IPSIncidentHeaderCodeSigningTeamIDKey);
			
			if (tString.length>0)
				_teamIdentifier=[tString copy];
		}
	
		NSNumber * tNumber=inRepresentation[IPSIncidentHeaderCodeSigningFlagsKey];
		
		if (tNumber!=nil)
		{
			IPSClassCheckNumberValueForKey(tNumber,IPSIncidentHeaderCodeSigningFlagsKey);

			_flags=tNumber.unsignedIntegerValue;
		}

		tNumber=inRepresentation[IPSIncidentHeaderCodeSigningValidationCategoryKey];

		if (tNumber!=nil)
		{
			IPSClassCheckNumberValueForKey(tNumber,IPSIncidentHeaderCodeSigningValidationCategoryKey);

			_validationCategory=tNumber.unsignedIntegerValue;
		}

		tNumber=inRepresentation[IPSIncidentHeaderCodeSigningTrustLevelKey];
		
		if (tNumber!=nil)
		{
			IPSClassCheckNumberValueForKey(tNumber,IPSIncidentHeaderCodeSigningTrustLevelKey);

			_trustLevel=tNumber.unsignedIntegerValue;
		}

		tNumber=inRepresentation[IPSIncidentHeaderCodeSigningAuxiliaryInfoKey];
		
		if (tNumber!=nil)
		{
			IPSClassCheckNumberValueForKey(tNumber,IPSIncidentHeaderCodeSigningAuxiliaryInfoKey);

			_auxiliaryInfo=tNumber.unsignedIntegerValue;
		}
	}

	return self;
}

#pragma mark -

- (NSDictionary *)representation
{
	if (self.identifier==nil && self.teamIdentifier==nil)
		return @{};

	NSMutableDictionary *tMutableRepresentation=[NSMutableDictionary dictionary];

	tMutableRepresentation[IPSIncidentHeaderCodeSigningIDKey]=self.identifier;
	tMutableRepresentation[IPSIncidentHeaderCodeSigningTeamIDKey]=self.teamIdentifier;
	tMutableRepresentation[IPSIncidentHeaderCodeSigningFlagsKey]=@(self.flags);
	tMutableRepresentation[IPSIncidentHeaderCodeSigningValidationCategoryKey]=@(self.validationCategory);
	tMutableRepresentation[IPSIncidentHeaderCodeSigningTrustLevelKey]=@(self.trustLevel);
	tMutableRepresentation[IPSIncidentHeaderCodeSigningAuxiliaryInfoKey]=@(self.auxiliaryInfo);

	return [tMutableRepresentation copy];
}

#pragma mark -

- (id)copyWithZone:(NSZone *)inZone
{
	IPSCodeSigningInfo * nCodeSigningInfo=[IPSCodeSigningInfo allocWithZone:inZone];
	
	if (nCodeSigningInfo!=nil)
	{
		nCodeSigningInfo->_identifier=[self.identifier copyWithZone:inZone];

		nCodeSigningInfo->_teamIdentifier=[self.teamIdentifier copyWithZone:inZone];

		nCodeSigningInfo->_flags=self.flags;

		nCodeSigningInfo->_validationCategory=self.validationCategory;

		nCodeSigningInfo->_trustLevel=self.trustLevel;

		nCodeSigningInfo->_auxiliaryInfo=self.auxiliaryInfo;
	}

	return nCodeSigningInfo;
}

@end

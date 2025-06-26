/*
 Copyright (c) 2021-2025, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "IPSSummary.h"

#import "IPSDateFormatter.h"

NSString * const IPSReportSummaryBugTypeKey=@"bug_type";

NSString * const IPSReportSummaryIncidentIDKey=@"incident_id";

NSString * const IPSReportSummaryOperatingSystemVersionKey=@"os_version";

NSString * const IPSReportSummaryTimestampKey=@"timestamp";

@interface IPSSummary ()

	@property (readwrite) IPSBugType bugType;

	@property (readwrite) NSUUID * incidentID;

	@property (readwrite,copy) NSString * operatingSystemVersion;

	@property (readwrite) NSDate * timeStamp;

@end


@implementation IPSSummary

- (instancetype)initWithSummary:(IPSSummary *)inSummary
{
	if ([inSummary isKindOfClass:IPSSummary.class]==NO)
		return nil;

	self=[super init];

	if (self!=nil)
	{
		_bugType=inSummary.bugType;

		_incidentID=inSummary.incidentID;

		_operatingSystemVersion=[inSummary.operatingSystemVersion copy];

		_timeStamp=inSummary.timeStamp;
	}

	return self;
}

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
		NSString * tString=inRepresentation[IPSReportSummaryBugTypeKey];

		 IPSFullCheckStringValueForKey(tString,IPSReportSummaryBugTypeKey);

		_bugType=[tString integerValue];
		
		tString=inRepresentation[IPSReportSummaryIncidentIDKey];

		IPSFullCheckStringValueForKey(tString,IPSReportSummaryIncidentIDKey);

		_incidentID=[[NSUUID alloc] initWithUUIDString:tString];

		tString=inRepresentation[IPSReportSummaryOperatingSystemVersionKey];

		IPSFullCheckStringValueForKey(tString,IPSReportSummaryOperatingSystemVersionKey);

		_operatingSystemVersion=[tString copy];

		tString=inRepresentation[IPSReportSummaryTimestampKey];

		IPSFullCheckStringValueForKey(tString,IPSReportSummaryTimestampKey);

		_timeStamp=[[IPSDateFormatter sharedFormatter] dateFromString:tString];
	}

	return self;
}

#pragma mark -

- (NSDictionary *)representation
{
	return @{
			 IPSReportSummaryBugTypeKey: [NSString stringWithFormat:@"%ld",self.bugType],
			 IPSReportSummaryIncidentIDKey:self.incidentID,
			 IPSReportSummaryOperatingSystemVersionKey:self.operatingSystemVersion,
			 IPSReportSummaryTimestampKey:[[IPSDateFormatter sharedFormatter] stringFromDate:self.timeStamp]
			 };
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)inZone
{
	return [[IPSSummary allocWithZone:inZone] initWithSummary:self];
}

@end

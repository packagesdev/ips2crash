/*
 Copyright (c) 2021-2025, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>

#import "IPSObjectProtocol.h"

#import "IPSBundleInfo.h"

#import "IPSOperatingSystemVersion.h"

@interface IPSCodeSigningInfo : NSObject <IPSObjectProtocol,NSCopying>

	@property (readonly,copy) NSString * identifier;	// can be nil

	@property (readonly,copy) NSString * teamIdentifier;	// can be nil

	@property (readonly) NSUInteger flags;

	@property (readonly) NSUInteger validationCategory;

	@property (readonly) NSUInteger trustLevel;

	@property (readonly) NSUInteger auxiliaryInfo;

@end

@interface IPSIncidentHeader : NSObject <IPSObjectProtocol,NSCopying>

	@property (readonly,copy) NSString * processName;

	@property (readonly) pid_t processID;

	@property (readonly,copy) NSString * processPath;

	@property (readonly) IPSBundleInfo * bundleInfo;

	@property (readonly,copy) NSString * cpuType;

	@property (readonly) BOOL translated;

	@property (readonly,copy) NSString * parentProcessName;

	@property (readonly) pid_t parentProcessID;

	@property (readonly,copy) NSString * responsibleProcessName;	// can be nil

	@property (readonly) pid_t responsibleProcessID;

	@property (readonly) IPSCodeSigningInfo * codeSigningInfo;

	@property (readonly) uid_t userID;


	@property (readonly) NSDate * captureTime;

	@property (readonly) IPSOperatingSystemVersion * operatingSystemVersion;

	@property (readonly) NSUInteger reportVersion;

	@property (readonly) NSUUID * crashReporterKey;


	@property (readonly) NSUUID * sleepWakeUUID;


	@property (readonly) NSUInteger uptime;



	@property (readonly) BOOL systemIntegrityProtectionEnable;

@end

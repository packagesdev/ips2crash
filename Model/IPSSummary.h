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

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, IPSBugType)
{									// 2nd part format:
	IPSBugTypeReserved1=58,			// tar.gz
	IPSBugTypeReserved2=193,		// XML plist
	IPSBugTypeKernelPanic=210,		// JSON
	IPSBugTypeReserved3=211,
	IPSBugTypeCrash=309,			// JSON
};

@interface IPSSummary : NSObject <IPSObjectProtocol,NSCopying>

	@property (readonly) IPSBugType bugType;

	@property (readonly) NSUUID * incidentID;

	@property (readonly,copy) NSString * operatingSystemVersion;

	@property (readonly) NSDate * timeStamp;

- (nullable instancetype)initWithSummary:(IPSSummary *)inSummary;

@end

NS_ASSUME_NONNULL_END

/*
 Copyright (c) 2021-2025, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "IPSReport+CrashRepresentation.h"

#import "IPSImage+UserCode.h"
#import "IPSIncident+ApplicationSpecificInformation.h"
#import "IPSThreadState+RegisterDisplayName.h"

#import "IPSDateFormatter.h"

#define BINARYIMAGENAME_AND_SPACE_MAXLEN	34

@implementation IPSReport (CrashRepresentation)

+ (NSString *)binaryImageStringForAddress:(NSUInteger)inAddress
{
	NSString * tString=[NSString stringWithFormat:@"0x%lx",inAddress];
	
	NSUInteger tLength=tString.length;
	
	NSString * tSpaceString=@"                  ";
	
	return [[tSpaceString substringFromIndex:tLength] stringByAppendingString:tString];
}

+ (NSString *)externalModificationStatisticsStringFromObject:(IPSExternalModificationStatistics *)inObject
{
	NSMutableString * tMutableString=[NSMutableString string];
	
	[tMutableString appendFormat:@"    task_for_pid: %ld\n",(long)inObject.taskForPid];
	[tMutableString appendFormat:@"    thread_create: %ld\n",(long)inObject.threadCreate];
	[tMutableString appendFormat:@"    thread_set_state: %ld\n",(long)inObject.threadSetState];
	
	return [tMutableString copy];
}

+ (NSString *)representationForThreadState:(IPSThreadState *)inThreadState
{
	if (inThreadState==nil)
		return @"";
	
	NSArray * tRegistersOrder;
	
	if ([inThreadState.flavor isEqualToString:@"x86_THREAD_STATE"]==YES)
	{
		tRegistersOrder=@[@"rax",@"rbx",@"rcx",@"rdx",
						  @"rdi",@"rsi",@"rbp",@"rsp",
						  @"r8",@"r9",@"r10",@"r11",
						  @"r12",@"r13",@"r14",@"r15",
						  @"rip",@"rflags",@"cr2"
						  ];
	}
	else
	{
		tRegistersOrder=@[@"x0",@"x1",@"x2",@"x3",
						  @"x4",@"x5",@"x6",@"x7",
						  @"x8",@"x9",@"x10",@"x11",
						  @"x12",@"x13",@"x14",@"x15",
						  @"x16",@"x17",@"x18",@"x19",
						  @"x20",@"x21",@"x22",@"x23",
						  @"x24",@"x25",@"x26",@"x27",
						  @"x28",@"fp",@"lr",@".",
						  @"sp",@"pc",@"cpsr",
						  @"far",@"esr"
						  ];
	}
	
	NSMutableString * tMutableString=[NSMutableString string];
	
	[tRegistersOrder enumerateObjectsUsingBlock:^(NSString * bRegisterName, NSUInteger bIndex, BOOL * bOutStop) {
		
		IPSRegisterState * tRegisterState=inThreadState.registersStates[bRegisterName];
		
		if (tRegisterState!=nil)
		{
			NSString * tTranslatedName=[IPSThreadState displayNameForRegisterName:bRegisterName];
			
			if (tTranslatedName.length<5)
				for(NSUInteger tWhitespace=0;tWhitespace<(5-tTranslatedName.length);tWhitespace++)
					[tMutableString appendString:@" "];
			
			IPSRegisterState * tRegisterState=inThreadState.registersStates[bRegisterName];
			
			if (tRegisterState!=nil)
				[tMutableString appendFormat:@"%@: 0x%016lx",tTranslatedName,tRegisterState.value];
		}
		
		if ((bIndex%4)==3)
			[tMutableString appendString:@"\n"];
		
	}];
	
	return [tMutableString copy];
}

- (NSString *)representationForThreadFrames:(NSArray <IPSThreadFrame *> *)inThreadFrames WithBinaryImages:(NSArray<IPSImage *> *)inBinaryImages
{
	NSMutableString * tMutableString = [NSMutableString string];
	
	[inThreadFrames enumerateObjectsUsingBlock:^(IPSThreadFrame * bFrame, NSUInteger bFrameIndex, BOOL * _Nonnull stop) {
		
		NSString * tFrameIndexString=[NSString stringWithFormat:@"%lu",(unsigned long)bFrameIndex];
		
		NSString * tIndexSpace=[@"    " substringFromIndex:tFrameIndexString.length];
		
		[tMutableString appendFormat:@"%@%@",tFrameIndexString,tIndexSpace];
		
		IPSImage * tBinaryImage=inBinaryImages[bFrame.imageIndex];
		
		NSUInteger tAddress=tBinaryImage.loadAddress+bFrame.imageOffset;
		
		NSString * tImageIdentifier=(tBinaryImage.bundleIdentifier!=nil) ? tBinaryImage.bundleIdentifier : tBinaryImage.name;
		
		if (tImageIdentifier.length==0)
			tImageIdentifier=@"???";
		
		NSUInteger tImageNameLength=tImageIdentifier.length;
		
		if ((tImageNameLength+4)>BINARYIMAGENAME_AND_SPACE_MAXLEN)
		{
			[tMutableString appendFormat:@"%@    ",tImageIdentifier];
		}
		else
		{
			NSString * tImageSpace=[@"                                  " substringFromIndex:tImageNameLength];
			
			[tMutableString appendFormat:@"%@%@",tImageIdentifier,tImageSpace];
		}
		
		if (bFrame.symbol!=nil)
		{
			[tMutableString appendFormat:@"0x%016lx %@ + %lu",(unsigned long)tAddress,bFrame.symbol,(unsigned long)bFrame.symbolLocation];
		}
		else
		{
			[tMutableString appendFormat:@"0x%016lx 0x%lx + %lu",(unsigned long)tAddress,(unsigned long)tBinaryImage.loadAddress,(unsigned long)(tAddress-tBinaryImage.loadAddress)];
		}
		
		if (bFrame.sourceFile!=nil)
			[tMutableString appendFormat:@" (%@:%lu)",bFrame.sourceFile,(unsigned long)bFrame.sourceLine];
		
		[tMutableString appendString:@"\n"];
	}];
	
	return tMutableString;
}

- (NSString *)crashTextualRepresentation
{
	IPSIncident * tIncident=self.incident;
	
	NSMutableString * tMutableString=[NSMutableString string];
	
	// Header
	
	IPSIncidentHeader * tHeader=tIncident.header;
	
	[tMutableString appendFormat:@"Process:               %@ [%d]\n",tHeader.processName,tHeader.processID];
	
	[tMutableString appendFormat:@"Path:                  %@\n",tHeader.processPath];
	
	IPSBundleInfo * tBundleInfo=tHeader.bundleInfo;
	
	if (tBundleInfo.bundleIdentifier!=nil)
	{
		[tMutableString appendFormat:@"Identifier:            %@\n",tBundleInfo.bundleIdentifier];
	}
	else
	{
		[tMutableString appendFormat:@"Identifier:            %@\n",tHeader.processName];
	}
	
	if (tBundleInfo.bundleShortVersionString!=nil)
	{
		[tMutableString appendFormat:@"Version:			   %@",tBundleInfo.bundleShortVersionString];
	}
	else
	{
		[tMutableString appendFormat:@"Version:               %@",@"???"];
	}
	
	if (tBundleInfo.bundleVersion!=nil)
	{
		[tMutableString appendFormat:@" (%@)\n",tBundleInfo.bundleVersion];
	}
	else
	{
		[tMutableString appendString:@"\n"];
	}
	
	[tMutableString appendFormat:@"Code Type:             %@ (%@)\n",tHeader.cpuType,(tHeader.translated==NO) ? @"Native" : @"Translated"];
	
	[tMutableString appendFormat:@"Parent Process:        %@ [%d]\n",tHeader.parentProcessName,tHeader.parentProcessID];
	
	if (tHeader.responsibleProcessName!=nil)
		[tMutableString appendFormat:@"Responsible:           %@ [%d]\n",tHeader.responsibleProcessName,tHeader.responsibleProcessID];
	
	[tMutableString appendFormat:@"User ID:               %d\n",tHeader.userID];
	
	[tMutableString appendString:@"\n"];
	
	
	[tMutableString appendFormat:@"Date/Time:             %@\n",[[IPSDateFormatter sharedFormatter] stringFromDate:tHeader.captureTime]];
	
	[tMutableString appendFormat:@"OS Version:            %@ (%@)\n",tHeader.operatingSystemVersion.train,tHeader.operatingSystemVersion.build];
	
	[tMutableString appendString:@"Report Version:        12\n"];
	
	[tMutableString appendFormat:@"Anonymous UUID:        %@\n",tHeader.crashReporterKey];
	
	[tMutableString appendString:@"\n"];
	
	if (tHeader.sleepWakeUUID!=nil)
	{
		[tMutableString appendFormat:@"Sleep/Wake UUID:       %@\n",tHeader.sleepWakeUUID];
		[tMutableString appendString:@"\n"];
	}
	
	[tMutableString appendFormat:@"Time Awake Since Boot: %lu seconds\n",(unsigned long)tHeader.uptime];
	
	[tMutableString appendString:@"\n"];
	
	[tMutableString appendFormat:@"System Integrity Protection: %@\n",(tHeader.systemIntegrityProtectionEnable==YES) ? @"enabled" : @"disabled"];
	
	[tMutableString appendString:@"\n"];
	
	// Exception Information
	
	IPSIncidentExceptionInformation * tExceptionInformation=tIncident.exceptionInformation;
	
	[tMutableString appendFormat:@"Crashed Thread:        %lu",(unsigned long)tExceptionInformation.faultingThread];
	
	IPSLegacyInfo * tLegacyInfo=tExceptionInformation.legacyInfo;
	
	if (tLegacyInfo!=nil && tLegacyInfo.threadTriggered.queue!=nil)
	{
		[tMutableString appendFormat:@"  Dispatch queue: %@\n",tLegacyInfo.threadTriggered.queue];
	}
	else
	{
		[tMutableString appendString:@"\n"];
	}
	
	IPSException * tException=tExceptionInformation.exception;
	
	[tMutableString appendString:@"\n"];
	
	[tMutableString appendFormat:@"Exception Type:        %@",tException.type];
	
	if (tException.signal!=nil)
	{
		[tMutableString appendFormat:@" (%@)",tException.signal];
	}
	
	[tMutableString appendString:@"\n"];
	
	if (tException.subtype!=nil)
	{
		[tMutableString appendFormat:@"Exception Codes:       %@\n",tException.subtype];
	}
	else
	{
		[tMutableString appendFormat:@"Exception Codes:       %@\n",tException.codes];
	}
	
	
	
	if (tExceptionInformation.isCorpse==YES)
		[tMutableString appendString:@"Exception Note:        EXC_CORPSE_NOTIFY\n"];
	
	[tMutableString appendString:@"\n"];
	
	IPSTermination * tTermination=tExceptionInformation.termination;
	
	if (tTermination!=nil)
	{
		[tMutableString appendFormat:@"Termination Reason:    Namespace %@, Code 0x%lx\n",tTermination.namespace,(unsigned long)tTermination.code];
		
		if (tTermination.byProc!=nil)
			[tMutableString appendFormat:@"Terminating Process:   %@ [%d]\n",tTermination.byProc,tTermination.byPid];
		
		[tMutableString appendString:@"\n"];
	}
	
	// Diagnostic Message + Exception Reason + Last Exception Backtrace
	
	IPSIncidentDiagnosticMessage * tDiagnosticMessage=tIncident.diagnosticMessage;
	
	if (tDiagnosticMessage.vmregioninfo!=nil)
	{
		[tMutableString appendFormat:@"VM Region Info: %@\n",tDiagnosticMessage.vmregioninfo];
		
		[tMutableString appendString:@"\n"];
	}
	
	NSArray<NSString *> * tApplicationSpecificInformationMessage = [tIncident applicationSpecificInformationMessage];
	
	if (tApplicationSpecificInformationMessage.count>0)
	{
		[tMutableString appendString:@"Application Specific Information:\n"];
		
		for(NSString *tString in tApplicationSpecificInformationMessage)
			[tMutableString appendFormat:@"%@\n",tString];
		
		[tMutableString appendString:@"\n"];
	}
	
	NSArray<NSString *> * tSignatures = tDiagnosticMessage.asi.signatures;
	
	if (tSignatures!=nil)
	{
		[tMutableString appendString:@"Application Specific Signatures:\n"];
		
		for(NSString * tSignature in tSignatures)
			[tMutableString appendFormat:@"%@\n",tSignature];
		
		[tMutableString appendString:@"\n"];
	}
	
	[tMutableString appendString:@"\n"];
	
	// Application Specific Backtrace (last exception backtrace or asi)
	
	NSArray<IPSThreadFrame *> * tLastExceptionBacktrace = tExceptionInformation.lastExceptionBacktrace;
	
	if (tLastExceptionBacktrace.count > 0)
	{
		[tMutableString appendString:@"Application Specific Backtrace 1:\n"];
		
		[tMutableString appendString:[self representationForThreadFrames:tLastExceptionBacktrace WithBinaryImages:tIncident.binaryImages]];
		
		[tMutableString appendString:@"\n"];
	}
	else
	{
		if (tDiagnosticMessage.asi.backtraces!=nil)
		{
			[tDiagnosticMessage.asi.backtraces enumerateObjectsUsingBlock:^(NSString * bBacktrace, NSUInteger bIndex, BOOL * bOutStop) {
				
				[tMutableString appendFormat:@"Application Specific Backtrace %lu:\n",bIndex+1];
				
				[tMutableString appendFormat:@"%@\n",bBacktrace];
			}];
			
			[tMutableString appendString:@"\n"];
		}
	}
	
	// Threads
	
	[tIncident.threads enumerateObjectsUsingBlock:^(IPSThread * bThread, NSUInteger bThreadIndex, BOOL * bOutStop) {
		
		NSString * tCrashedString=(bThread.triggered==YES) ? @" Crashed":@"";
		
		[tMutableString appendFormat:@"Thread %lu%@:",(unsigned long)bThreadIndex,tCrashedString];
		
		if (bThread.name!=nil || bThread.queue!=nil)
		{
			[tMutableString appendString:@": "];
			
			if (bThread.name!=nil)
				[tMutableString appendString:bThread.name];
			
			if (bThread.queue!=nil)
				[tMutableString appendFormat:@"%@Dispatch queue: %@",(bThread.name!=nil) ? @"  ": @"",bThread.queue];
		}
		
		[tMutableString appendString:@"\n"];
		
		[tMutableString appendString:[self representationForThreadFrames:bThread.frames WithBinaryImages:tIncident.binaryImages]];
		
		[tMutableString appendString:@"\n"];
	}];
	
	IPSThreadState * tCrashedThreadState=nil;
	
	IPSThreadInstructionState * tCrashThreadInstructionState=nil;
	
	if (tExceptionInformation.faultingThread<tIncident.threads.count)
	{
		IPSThread * tThread=tIncident.threads[tExceptionInformation.faultingThread];
		
		tCrashedThreadState=tThread.threadState;
		
		tCrashThreadInstructionState=tThread.instructionState;
	}
	
	if (tCrashedThreadState!=nil)
	{
		NSDictionary * tCPUFamiliesRegistry=@{
											  @"X86-64":@"X86",
											  @"ARM-64":@"ARM"
											  };
		
		NSString * tCPUFamily=tCPUFamiliesRegistry[tHeader.cpuType];
		
		if (tCPUFamily==nil)
			tCPUFamily=@"-";
		
		NSDictionary * tCPUSizeRegistry=@{
										  @"X86-64":@"64-bit",
										  @"ARM-64":@"64-bit"
										  };
		
		NSString * tCPUSize=tCPUSizeRegistry[tHeader.cpuType];
		
		if (tCPUSize==nil)
			tCPUSize=@"-";
		
		[tMutableString appendFormat:@"Thread %lu crashed with %@ Thread State (%@):\n",tExceptionInformation.faultingThread,tCPUFamily,tCPUSize];
		
		[tMutableString appendString:[IPSReport representationForThreadState:tCrashedThreadState]];
		[tMutableString appendString:@"\n"];
		
		IPSRegisterState * tRegisterState=tCrashedThreadState.registersStates[IPSThreadStateCpuKey];
		
		if (tRegisterState!=nil)
		{
			[tMutableString appendString:@"\n"];
			
			[tMutableString appendFormat:@"Logical CPU:     %lu\n",tRegisterState.value];
			
			tRegisterState=tCrashedThreadState.registersStates[IPSThreadStateErrKey];
			
			[tMutableString appendFormat:@"Error Code:      %08lx",tRegisterState.value];
			
			tRegisterState=tCrashedThreadState.registersStates[IPSThreadStateTrapKey];
			
			if (tRegisterState.r_description!=nil)
				[tMutableString appendFormat:@" %@",tRegisterState.r_description];
			
			[tMutableString appendString:@"\n"];
			
			[tMutableString appendFormat:@"Trap Number:     %lu\n",tRegisterState.value];
		}
		
		[tMutableString appendString:@"\n"];
	}
	else
	{
	}
	
	if (tCrashThreadInstructionState!=nil)
	{
		IPSThreadInstructionStream * tStream=tCrashThreadInstructionState.instructionStream;
		
		if (tStream!=nil)
		{
			[tMutableString appendFormat:@"Thread %lu instruction stream:\n",tExceptionInformation.faultingThread];
			
			uint8_t * tBytes=tStream.bytes;
			NSUInteger tBytesCount=tStream.bytesCount;
			
			NSUInteger tOffset=tStream.offset;
			
			for(NSUInteger tByteIndex=0;tByteIndex<tBytesCount;tByteIndex+=16)
			{
				unsigned char tASCIIRepresentation[17];
				memset(tASCIIRepresentation, '.',16);
				tASCIIRepresentation[16]='\0';
				
				// Display line by line
				
				if (tByteIndex==tOffset)
				{
					[tMutableString appendFormat:@" [%02x]",tBytes[tByteIndex]];
				}
				else
				{
					[tMutableString appendFormat:@"  %02x ",tBytes[tByteIndex]];
				}
				
				[tMutableString appendFormat:@"%02x %02x %02x %02x %02x %02x %02x",tBytes[tByteIndex+1],tBytes[tByteIndex+2],tBytes[tByteIndex+3],tBytes[tByteIndex+4],tBytes[tByteIndex+5],tBytes[tByteIndex+6],tBytes[tByteIndex+7]];
				
				if ((tByteIndex+8)<tBytesCount)
				{
					[tMutableString appendFormat:@"-%02x %02x %02x %02x %02x %02x %02x %02x",tBytes[tByteIndex+8],tBytes[tByteIndex+9],tBytes[tByteIndex+10],tBytes[tByteIndex+11],tBytes[tByteIndex+12],tBytes[tByteIndex+13],tBytes[tByteIndex+14],tBytes[tByteIndex+15]];
				}
				
				
				
				for(NSUInteger tASCIIIndex=0;(tByteIndex+tASCIIIndex)<tBytesCount && tASCIIIndex<16;tASCIIIndex++)
				{
					uint8_t tByteValue=tBytes[tByteIndex+tASCIIIndex];
					
					if (tByteValue>=32 && tByteValue<127)
						tASCIIRepresentation[tASCIIIndex]=tByteValue;
				}
				
				[tMutableString appendFormat:@"  %s",tASCIIRepresentation];
				
				if (tByteIndex==tOffset)
					[tMutableString appendString:@"    <=="];
				
				[tMutableString appendString:@"\n"];
				
			}
			
			[tMutableString appendString:@"\n"];
		}
	}
	
	// Binary Images
	
	if (tIncident.binaryImages.count>0)
	{
		[tMutableString appendString:@"Binary Images:\n"];
		
		[[tIncident.binaryImages sortedArrayUsingSelector:@selector(compare:)] enumerateObjectsUsingBlock:^(IPSImage * bImage, NSUInteger bIndex, BOOL * bOutStop) {
			
			if ([bImage.source isEqualToString:@"A"]==YES)
				return;
			
			[tMutableString appendFormat:@"%@ - %@ ",[IPSReport binaryImageStringForAddress:bImage.loadAddress],[IPSReport binaryImageStringForAddress:bImage.loadAddress+bImage.size]];
			
			if (bImage.isUserCode==YES)
				[tMutableString appendString:@"+"];
			
			if (bImage.bundleIdentifier!=nil)
				[tMutableString appendFormat:@"%@ ",bImage.bundleIdentifier];
			else
				[tMutableString appendFormat:@"%@ ",bImage.name];
			
			if (bImage.bundleShortVersionString!=nil || bImage.bundleVersion!=nil)
			{
				[tMutableString appendFormat:@"(%@ - %@) ",(bImage.bundleShortVersionString!=nil) ? bImage.bundleShortVersionString : @"???",
				 (bImage.bundleVersion!=nil) ? bImage.bundleVersion : @"???"];
			}
			else
			{
				[tMutableString appendString:@"(???) "];
			}
			
			[tMutableString appendFormat:@"<%@> %@",bImage.UUID,bImage.path];
			
			[tMutableString appendString:@"\n"];
		}];
		
		[tMutableString appendString:@"\n"];
	}
	
	// External Modification Summary
	
	if (tIncident.extMods!=nil)
	{
		[tMutableString appendString:@"External Modification Summary:\n"];
		
		[tMutableString appendString:@" Calls made by other processes targeting this process:\n"];
		
		[tMutableString appendString:[IPSReport externalModificationStatisticsStringFromObject:tIncident.extMods.targeted]];
		
		[tMutableString appendString:@" Calls made by this process:\n"];
		
		[tMutableString appendString:[IPSReport externalModificationStatisticsStringFromObject:tIncident.extMods.caller]];
		
		[tMutableString appendString:@" Calls made by all processes on this machine:\n"];
		
		[tMutableString appendString:[IPSReport externalModificationStatisticsStringFromObject:tIncident.extMods.system]];
		
		[tMutableString appendString:@"\n"];
	}
	
	// VM Summary
	
	if (tIncident.vmSummary!=nil)
	{
		[tMutableString appendString:@"VM Region Summary:\n"];
		[tMutableString appendString:tIncident.vmSummary];
	}
	
	return [tMutableString copy];
}

@end

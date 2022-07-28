/*
 Copyright (c) 2021-2022, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "IPSExternalModificationStatistics.h"

NSString * const IPSExternalModificationStatisticsTaskForPidKey=@"taskForPid";

NSString * const IPSExternalModificationStatisticsThreadCreateKey=@"threadCreate";

NSString * const IPSExternalModificationStatisticsThreadSetStateKey=@"threadSetState";

@interface IPSExternalModificationStatistics ()

    @property (readwrite) NSInteger taskForPid;

    @property (readwrite) NSInteger threadCreate;

    @property (readwrite) NSInteger threadSetState;

@end


@implementation IPSExternalModificationStatistics

- (instancetype)initWithRepresentation:(NSDictionary *)inRepresentation error:(out NSError **)outError
{
    if (inRepresentation==nil)
    {
        if (outError!=NULL)
            *outError=[NSError errorWithDomain:IPSErrorDomain code:IPSRepresentationNilRepresentationError userInfo:nil];
        
        return nil;
    }
    
    if ([inRepresentation isKindOfClass:[NSDictionary class]]==NO)
    {
        if (outError!=NULL)
            *outError=[NSError errorWithDomain:IPSErrorDomain code:IPSRepresentationInvalidTypeOfValueError userInfo:nil];
        
        return nil;
    }
    
    self=[super init];
    
    if (self!=nil)
    {
        NSNumber * tNumber=inRepresentation[IPSExternalModificationStatisticsTaskForPidKey];
        
        IPSFullCheckNumberValueForKey(tNumber,IPSExternalModificationStatisticsTaskForPidKey);
        
        _taskForPid=[tNumber integerValue];
        
        tNumber=inRepresentation[IPSExternalModificationStatisticsThreadCreateKey];
        
        IPSFullCheckNumberValueForKey(tNumber,IPSExternalModificationStatisticsThreadCreateKey);
        
        _threadCreate=[tNumber integerValue];
        
        tNumber=inRepresentation[IPSExternalModificationStatisticsThreadSetStateKey];
        
        IPSFullCheckNumberValueForKey(tNumber,IPSExternalModificationStatisticsThreadSetStateKey);
        
        _threadSetState=[tNumber integerValue];
    }
    
    return self;
}

#pragma mark -

- (NSDictionary *)representation
{
    return @{
             IPSExternalModificationStatisticsTaskForPidKey:@(self.taskForPid),
             IPSExternalModificationStatisticsThreadCreateKey:@(self.threadCreate),
             IPSExternalModificationStatisticsThreadSetStateKey:@(self.threadSetState)
             };
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)inZone
{
    IPSExternalModificationStatistics * nExternalModificationStatistics=[IPSExternalModificationStatistics allocWithZone:inZone];
    
    if (nExternalModificationStatistics!=nil)
    {
        nExternalModificationStatistics->_taskForPid=self.taskForPid;
        
        nExternalModificationStatistics->_threadCreate=self.threadCreate;
        
        nExternalModificationStatistics->_threadSetState=self.threadSetState;
    }
    
    return nExternalModificationStatistics;
}

@end

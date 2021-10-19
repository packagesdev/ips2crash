/*
 Copyright (c) 2021, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#import <Foundation/Foundation.h>

#import "IPSError.h"

#define IPSFullCheckObjectValueForKey(class,object,key) if ((object)==nil)\
{\
    if (outError!=NULL)\
        *outError=[NSError errorWithDomain:IPSErrorDomain\
                                      code:IPSRepresentationInvalidValueError\
                                  userInfo:@{IPSKeyPathErrorKey:(key)}];\
\
    return nil;\
}\
\
if ([(object) isKindOfClass:class]==NO)\
{\
    if (outError!=NULL)\
        *outError=[NSError errorWithDomain:IPSErrorDomain\
                                      code:IPSRepresentationInvalidTypeOfValueError\
                                  userInfo:@{IPSKeyPathErrorKey:(key)}];\
\
    return nil;\
}\


#define IPSFullCheckStringValueForKey(string,key) IPSFullCheckObjectValueForKey(NSString.class,string,key)
#define IPSFullCheckNumberValueForKey(number,key) IPSFullCheckObjectValueForKey(NSNumber.class,number,key)
#define IPSFullCheckArrayValueForKey(array,key) IPSFullCheckObjectValueForKey(NSArray.class,array,key)
#define IPSFullCheckDictionaryValueForKey(dictionary,key) IPSFullCheckObjectValueForKey(NSDictionary.class,dictionary,key)


#define IPSClassCheckObjectValueForKey(class,object,key) if ((object)!=nil && [(object) isKindOfClass:class]==NO)\
{\
    if (outError!=NULL)\
        *outError=[NSError errorWithDomain:IPSErrorDomain\
                                      code:IPSRepresentationInvalidTypeOfValueError\
                                  userInfo:@{IPSKeyPathErrorKey:(key)}];\
\
    return nil;\
}\

#define IPSClassCheckStringValueForKey(string,key) IPSClassCheckObjectValueForKey(NSString.class,string,key)
#define IPSClassCheckNumberValueForKey(number,key) IPSClassCheckObjectValueForKey(NSNumber.class,number,key)

@protocol IPSObjectProtocol <NSObject>

- (instancetype)initWithRepresentation:(NSDictionary *)inRepresentation error:(out NSError **)outError;

- (NSDictionary *)representation;

@end

/*
 Copyright (c) 2022, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "IPSThreadState+Obfuscating.h"

#import "IPSRegisterState+Obfuscating.h"

#import "NSDictionary+WBExtensions.h"

@interface IPSThreadState (Private)

- (void)setFlavor:(NSString *)inFlavor;
- (void)setRegistersStates:(NSDictionary<NSString *,IPSRegisterState *> *)inRegistersStates;

@end

@implementation IPSThreadState (Obfuscating)

- (id)obfuscateWithObfuscator:(IPSObfuscator *)inObfuscator
{
    IPSThreadState * nThreadState=[IPSThreadState alloc];
    
    if (nThreadState!=nil)
    {
        nThreadState.flavor=[self.flavor copy];
        
        nThreadState.registersStates=[self.registersStates WB_dictionaryByMappingObjectsUsingBlock:^id(id bKey, IPSRegisterState * bRegisterState) {
            
            return [bRegisterState obfuscateWithObfuscator:inObfuscator];
        }];
    }
    
    return nThreadState;
}

@end

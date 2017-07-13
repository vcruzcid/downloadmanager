//
//  NSData+ACSharedSecureFile.h
//  Category of NSData adding AppConnect Shared Secure File IO
//
//  Copyright (c) 2013-2017 MobileIron. All rights reserved.
//
//  YOUR USE AND DISTRIBUTION OF THIS SOFTWARE IS SUBJECT TO THE SOFTWARE DEVELOPMENT KIT (SDK) AGREEMENT BETWEEN
//  YOU AND MOBILE IRON, INC. (“MI”).  USE OR DISTRIBUTION NOT IN STRICT ACCORDANCE WITH THE AGREEMENT IS PROHIBITED.
//

#import <Foundation/Foundation.h>

@interface NSData (ACSharedSecureFile)

+ (id)dataWithContentsOfSecureFile:(NSString *)path
                 encryptionGroupId:(NSString *)groupId;

+ (id)dataWithContentsOfSecureFile:(NSString *)path
                 encryptionGroupId:(NSString *)groupId
                           options:(NSDataReadingOptions)mask
                             error:(NSError **)errorPtr;

+ (id)dataWithContentsOfSecureURL:(NSURL *)url
                encryptionGroupId:(NSString *)groupId;

+ (id)dataWithContentsOfSecureURL:(NSURL *)url
                encryptionGroupId:(NSString *)groupId
                          options:(NSDataReadingOptions)mask
                            error:(NSError **)errorPtr;

- (id)initWithContentsOfSecureFile:(NSString *)path
                 encryptionGroupId:(NSString *)groupId;

- (id)initWithContentsOfSecureFile:(NSString *)path
                 encryptionGroupId:(NSString *)groupId
                           options:(NSDataReadingOptions)mask
                             error:(NSError **)errorPtr;

- (id)initWithContentsOfSecureURL:(NSURL *)url
                encryptionGroupId:(NSString *)groupId;

- (id)initWithContentsOfSecureURL:(NSURL *)url
                encryptionGroupId:(NSString *)groupId
                          options:(NSDataReadingOptions)mask
                            error:(NSError **)errorPtr;

- (BOOL)writeToSecureFile:(NSString *)path
        encryptionGroupId:(NSString *)groupId
               atomically:(BOOL)flag;

- (BOOL)writeToSecureFile:(NSString *)path encryptionGroupId:(NSString *)groupId
                  options:(NSDataWritingOptions)mask
                    error:(NSError **)errorPtr;

- (BOOL)writeToSecureURL:(NSURL *)aURL
       encryptionGroupId:(NSString *)groupId
              atomically:(BOOL)atomically;

- (BOOL)writeToSecureURL:(NSURL *)aURL
       encryptionGroupId:(NSString *)groupId
                 options:(NSDataWritingOptions)mask
                   error:(NSError **)errorPtr;

@end

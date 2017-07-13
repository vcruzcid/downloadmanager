//
//  ACDerivedCredential.h
//  AppConnect
//
//  Copyright (c) 2017 MobileIron. All rights reserved.
//

#import <Foundation/Foundation.h>

// Certificate sending constants
extern NSString *const kACDerivedCredentialPayloadTagKey;
extern NSString *const kACDerivedCredentialPayloadCertKey;
extern NSString *const kACDerivedCredentialPayloadPrivateKeyKey;

// Certificate tags
extern NSString *const kACDerivedCredentialAuthenticationTag;
extern NSString *const kACDerivedCredentialSigningTag;
extern NSString *const kACDerivedCredentialEncryptionTag;

@interface ACDerivedCredential : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *serialNumber;
@property (nonatomic, readonly) NSDate *expirationDate;
@property (nonatomic, readonly) NSArray *certificates;

// Default contructors are not available
// Use designated initializer defined below.
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/**
 *  Creates ACDerivedCredential suitable for sending to the MobileIron client app
 *
 *  @param name String to be used as the human readable name for this derived credentials payload.
 *  @param serialNumber String to be used as the identifier for this derived credentials payload.
 *  @param expirationDate Expiration date for this derived credentials payload.
 *  @param certificates array of dictionaries representing certificates associated with this derived credentials payload.
 *          Each dictionary MUST have values for all keys defined in Certificate sending constants:
 *          kACDerivedCredentialPayloadTagKey - value is typically one of the predefined constants from Certificate tags, 
 *              but can be any string if you have other uses for certificates.
 *          kACDerivedCredentialPayloadCertKey - value MUST be DER encoded certificate data.
 *          kACDerivedCredentialPayloadPrivateKeyKey - value MUST be DER encoded private key data.
 *  @return ACDerivedCredential suitable for sending to the MobileIron client app or nil if any parameter is nil or empty.
 */
- (instancetype)initWithName:(NSString *)name
                serialNumber:(NSString *)serialNumber
              expirationDate:(NSDate *)expirationDate
                certificates:(NSArray *)certificates NS_DESIGNATED_INITIALIZER;

@end

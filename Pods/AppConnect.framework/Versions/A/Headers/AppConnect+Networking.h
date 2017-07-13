//
//  AppConnect+Networking.h
//  AppConnect networking functions
//
//  Copyright (c) 2015-2016 MobileIron. All rights reserved.
//
//  YOUR USE AND DISTRIBUTION OF THIS SOFTWARE IS SUBJECT TO THE SOFTWARE DEVELOPMENT KIT (SDK) AGREEMENT BETWEEN
//  YOU AND MOBILE IRON, INC. (“MI”).  USE OR DISTRIBUTION NOT IN STRICT ACCORDANCE WITH THE AGREEMENT IS PROHIBITED.
//

#import "AppConnect.h"


// AppConnectNetworkingDelegate protocol defines a protocol for an optional delegate that allows the AppConnect SDK to
// notify the app of networking events when using the AppTunnel feature.
//
// If your app implements the NSURLConnectionDataDelegate method
// connection:didSendBodyData:totalBytesWritten:totalBytesExpectedToWrite: implement this delegate.
//
// Use the setNetworkingDelegate: method to set the delegate that will receive these notifications.
@protocol AppConnectNetworkingDelegate <NSObject>

// Notification of progress as the body of a request is sent when a connection is tunneled using the AppTunnel feature.
//
// When a connection is tunneled, iOS will not call the NSURLConnectionDataDelegate method
// connection:didSendBodyData:totalBytesWritten:totalBytesExpectedToWrite: to notify the app of upload progress.
// Instead, AppConnect will call this method on the networking delegate. If your app implements the
// connection:didSendBodyData:totalBytesWritten:totalBytesExpectedToWrite: method, implement this method
// for upload updates.
//
// The request argument is the NSURLRequest that started the upload. The remaining arguments match the equivalent
// NSURLConnectionDataDelegate method.
-(void) uploadProgressForConnectionWithURLRequest:(NSURLRequest *)request
                                     bytesWritten:(NSInteger)bytesWritten
                                totalBytesWritten:(NSInteger)totalBytesWritten
                        totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;
@end


// Codes describing different tunneling diagnostic result types.
typedef NS_ENUM(NSUInteger, ACTunnelingDiagnosticResultCode) {
    // Run life cycle
    ACTDR_RUN_STARTED            = 0,   // The run started properly. Always succeeds.
    ACTDR_REDIRECT               = 1,   // The server redirected to a new URL. Always succeeds.
    ACTDR_COMPLETED              = 2,   // Fails if the session completed with an error, succeeds otherwise.
    ACTDR_ABORT_UNSUPPORTED_AUTH = 3,   // The diagnostic is aborted because the server issued an auth challenge that
                                        // the diagnostic does not support. Always succeeds.

    // Policy integrity
    ACTDR_RULE_MATCH             = 100, // Succeeds if an initial or redirected request matched a tunneling rule, fails
                                        // otherwise.
    ACTDR_POLICY_SERVER_CERT     = 101, // Succeeds if the policy contains a valid server certificate, fails otherwise.
    ACTDR_POLICY_CLIENT_IDENTITY = 102, // Succeeds if the policy contains a valid client identity, fails otherwise.
    
    // Certificate challenges
    ACTDR_SEND_CLIENT_CERT       = 200, // Succeeds if the client-side authenticated with the identity, fails otherwise.
    ACTDR_EVALUATE_SENTRY_CERT   = 201, // Succeeds if the sentry's server-side certificate matches the pinned Sentry
                                        // cert, fails otherwise.

    // Networking
    ACTDR_DNSLOOKUP_SENTRY       = 300, // Succeeds if DNS lookup for the Sentry host succeeded, fails otherwise
    
    // Connection result
    ACTDR_RESPONSE               = 400, // Received a response. Succeeds if the server returned HTTP status code 1xx,
                                        // 2xx or 3xx. Fails if the AppTunnel is blocked, or the server returned HTTP
                                        // status code 4xx or 5xx.
    ACTDR_RECEIVED_DATA          = 401, // Received data. Always succeeds.
};

// A result of a tunneling diagnostic test performed by diagnoseTunnelingForURL:delegate:
@interface ACTunnelingDiagnosticResult : NSObject {
}

// Code identifying the type of result. See the ACTunnelingDiagnosticResultCode for descriptions of the individual codes
@property (nonatomic, readonly) ACTunnelingDiagnosticResultCode resultCode;

// Indicates whether the diagnostic result was successful or failed
@property (nonatomic, readonly, getter=isSuccessful) BOOL successful;

// Timestamp for when the result occurred
@property (nonatomic, readonly) NSDate *timestamp;

// Human-readable description of the result
@property (nonatomic, readonly) NSString *resultDescription;

@end

// Additional methods on the AppConnect object for networking
@interface AppConnect (Networking)

// Sets the optional networking delegate, which will receive the notifications described in the
// AppConnectNetworkingDelegate protocol.
-(void) setNetworkingDelegate:(id<AppConnectNetworkingDelegate>)delegate;

// Starts a diagnostic run for a tunneled request.
//
// This makes a request for testURL, gathers diagnostic information until the request completes, compiles the results in
// a human-readable form, calls resultHandler for each result as it occurs, and calls resultHandler with a nil result to
// indicate that the run has completed. See ACTunnelingDiagnosticResultCode for a list of results that may be generated.
// Only applicable result codes are generated for a diagnostic run.
//
// If the request is successful, the destination server will receive the request, but the app will not receive the
// response. testURL should be a URL that has no unintended side-effects, such as modifying user data.
//
// Returns a unique runID that matches the second parameter to the resultHandler. Multiple simultaneous diagnostic runs
// are supported, and the runID distinguishes which result corresponds to a diagnostic run.
-(NSInteger)diagnoseTunnelingForURL:(NSURL *)url
                      resultHandler:(void (^)(ACTunnelingDiagnosticResult *result,
                                              NSInteger runID))resultHandler;
@end

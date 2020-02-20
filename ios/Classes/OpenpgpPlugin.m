#import "OpenpgpPlugin.h"
#import "Openpgp/Openpgp.h"

@implementation OpenpgpPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"openpgp"
            binaryMessenger:[registrar messenger]];
  OpenpgpPlugin* instance = [[OpenpgpPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
   
  if ([@"encrypt" isEqualToString:call.method]) {
      
      [self encrypt:[call valueForKey:@"message"] publicKey:[call valueForKey:@"publicKey"] result:result];
      
  } else if ([@"decrypt" isEqualToString:call.method]) {
      
      [self decrypt:[call valueForKey:@"message"] privateKey:[call valueForKey:@"privateKey"] passphrase:[call valueForKey:@"passphrase"] result:result];
      
  } else if ([@"sign" isEqualToString:call.method]) {
      
      [self sign:[call valueForKey:@"message"] publicKey:[call valueForKey:@"publicKey"] privateKey:[call valueForKey:@"privateKey"] passphrase:[call valueForKey:@"passphrase"] result:result];
      
  } else if ([@"verify" isEqualToString:call.method]) {
      
      [self verify:[call valueForKey:@"signature"] message:[call valueForKey:@"message"] publicKey:[call valueForKey:@"publicKey"] result:result];
      
  } else if ([@"decryptSymmetric" isEqualToString:call.method]) {
      
      [self decryptSymmetric:[call valueForKey:@"message"] passphrase:[call valueForKey:@"passphrase"] options:nil result:result];
      
  } else if ([@"encryptSymmetric" isEqualToString:call.method]) {
      
      [self encryptSymmetric:[call valueForKey:@"message"] passphrase:[call valueForKey:@"passphrase"] options:nil result:result];
      
  } else if ([@"generate" isEqualToString:call.method]) {
      
      [self generate:nil result:result];
      
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)encrypt:(NSString *)message publicKey: (NSString *)publicKey result:(FlutterResult)result {
    
     NSError *error;
     NSString * output = [OpenpgpNewFastOpenPGP() encrypt:message publicKey:publicKey error:&error];
    
     if(error!=nil){
         result(error);
     }else{
         result(output);
     }
}

- (void)decrypt:(NSString *)message privateKey: (NSString *)privateKey passphrase: (NSString *)passphrase result:(FlutterResult)result {
    
     NSError *error;
     NSString * output = [OpenpgpNewFastOpenPGP() decrypt:message privateKey:privateKey passphrase:passphrase error:&error];
     
     if(error!=nil){
         result(error);
     }else{
         result(output);
     }
}

- (void)sign:(NSString *)message publicKey: (NSString *)publicKey privateKey: (NSString *)privateKey passphrase: (NSString *)passphrase result:(FlutterResult)result {
    
     NSError *error;
     NSString * output = [OpenpgpNewFastOpenPGP() sign:message publicKey:publicKey privateKey:privateKey passphrase:passphrase error:&error];
     
     if(error!=nil){
         result(error);
     }else{
         result(output);
     }
}

- (void)verify:(NSString *)signature message: (NSString *)message publicKey: (NSString *)publicKey result:(FlutterResult)result {
    
    NSError *error;
    BOOL ret0_;
    BOOL output = [OpenpgpNewFastOpenPGP() verify:signature message:message publicKey:publicKey ret0_:&ret0_ error:&error];
    
    if(error!=nil){
        result(error);
    }else{
        if(output){
            result(@"1");
        }else{
            result(NULL);
        }
    }
}

- (void)decryptSymmetric:(NSString *)message passphrase: (NSString *)passphrase options:(NSDictionary *)map result:(FlutterResult)result {
    
    OpenpgpKeyOptions *options = [self getKeyOptions:map];
    NSError *error;
    NSString * output = [OpenpgpNewFastOpenPGP() decryptSymmetric:message passphrase:passphrase options:options error:&error];
    
    if(error!=nil){
        result(error);
    }else{
        result(output);
    }
}

- (void)encryptSymmetric:(NSString *)message passphrase: (NSString *)passphrase options:(NSDictionary *)map result:(FlutterResult)result {
    
    OpenpgpKeyOptions *options = [self getKeyOptions:map];
    NSError *error;
    NSString * output = [OpenpgpNewFastOpenPGP() encryptSymmetric:message passphrase:passphrase options:options error:&error];
    
    if(error!=nil){
        result(error);
    }else{
        result(output);
    }
}

- (void)generate:(NSDictionary *)map result:(FlutterResult)result {
    
    OpenpgpOptions * options = [self getOptions:map];
    NSError *error;
    OpenpgpKeyPair * output = [OpenpgpNewFastOpenPGP() generate:options error:&error];
    
    if(error!=nil){
        result(error);
    }else{
        result(@{
                  @"publicKey":output.publicKey,
                  @"privateKey":output.privateKey,
                });
    }
}

- (OpenpgpKeyOptions *)getKeyOptions:(NSDictionary *)map
{
    OpenpgpKeyOptions * options = [[OpenpgpKeyOptions alloc] init];
    if (map == nil){
        return options;
    }
    if(map[@"cipher"]){
        [options setCipher:map[@"cipher"]];
    }
    if(map[@"compression"]){
        [options setCompression:map[@"compression"]];
    }
    if(map[@"hash"]){
        [options setHash:map[@"hash"]];
    }
    if(map[@"RSABits"]){
        [options setRsaBits:[map[@"RSABits"] longValue]];
    }
    if(map[@"compressionLevel"]){
        [options setCompressionLevel:[map[@"compressionLevel"] longValue]];
    }
    return options;
}

- (OpenpgpOptions *)getOptions:(NSDictionary *)map
{
    OpenpgpOptions * options = [[OpenpgpOptions alloc] init];
    if (map == nil){
        return options;
    }
    if(map[@"name"]){
        [options setName:map[@"name"]];
    }
    if(map[@"email"]){
        [options setEmail:map[@"email"]];
    }
    if(map[@"comment"]){
        [options setComment:map[@"comment"]];
    }
    if(map[@"passphrase"]){
        [options setPassphrase:map[@"passphrase"]];
    }
    if(map[@"keyOptions"]){
        [options setKeyOptions:[self getKeyOptions:map[@"keyOptions"]]];
    }
    
    return options;
}

@end
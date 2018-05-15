
#import "DataStack.h"
#import "CommonUI.h"
#import "NSFileManager+RFKit.h"

static BOOL MBDataStackRealmResetAlertShow;

@interface MBDataStack () <
    UIApplicationDelegate
>
@property (nonatomic, readwrite, strong) RLMRealm *sharedStorage;
@end

@implementation MBDataStack
RFInitializingRootForNSObject

- (void)onInit {
}

- (void)afterInit {
    [AppDelegate() addAppEventListener:self];
}

- (RLMRealm *)sharedStorage {
    if (!_sharedStorage) {
        _sharedStorage = [self realmWithURL:[[self realmDirURL] URLByAppendingPathComponent:@"main.db"]];
    }
    return _sharedStorage;
}

- (NSURL *)realmDirURL {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *supportDirURL = [fm subDirectoryURLWithPathComponent:@"cc.feelapp.storage" inDirectory:NSApplicationSupportDirectory createIfNotExist:YES error:nil];
    [fm setAttributes:@{ NSFileProtectionKey: NSFileProtectionNone } ofItemAtPath:supportDirURL.path error:nil];
    RFAssert(supportDirURL, @"不能获取存储目录？");
    return supportDirURL;
}

- (RLMRealm *)realmWithURL:(NSURL *)url {
    if (!RFAssertIsMainThread()) return nil;

    NSError __autoreleasing *e = nil;
    RLMRealm *s = [RLMRealm realmWithConfiguration:[self realmConfigurationWithPath:url] error:&e];
    if (s) return s;

    if (!MBDataStackRealmResetAlertShow) {
        MBDataStackRealmResetAlertShow = YES;
        NSString *msg = e.localizedDescription;
        if ([msg containsString:@"is less than last set version"]) {
            msg = @"Feel 不支持从高版本降级到低版本";
        }
        msg = [msg stringByAppendingString:@"\n重置会导致未同步的数据丢失"];
//  @TODO
//        PSTAlertController *ac = [PSTAlertController alertWithTitle:@"数据不兼容" message:msg];
//        [ac addAction:[PSTAlertAction actionWithTitle:@"重置数据" style:PSTAlertActionStyleDefault handler:^(PSTAlertAction *action) {
//            [[NSFileManager defaultManager] removeItemAtURL:[self realmDirURL] error:nil];
//            MBDataStackRealmResetAlertShow = NO;
//        }]];
//        [ac addCancelActionWithHandler:^(PSTAlertAction *action) {
//            MBDataStackRealmResetAlertShow = NO;
//        }];
//        [ac showWithSender:nil controller:nil animated:NO completion:nil];
    }
    return nil;
}

- (RLMRealmConfiguration *)realmConfigurationWithPath:(NSURL *)path {
    RLMRealmConfiguration *conf = [[RLMRealmConfiguration alloc] init];;
    conf.schemaVersion = 20;
    conf.fileURL = path;
    [conf setMigrationBlock:^(RLMMigration *migration, uint64_t oldSchemaVersion){
//        if (oldSchemaVersion == 0) {
//            [migration deleteDataForClassName:[ToolResultModel className]];
//        }
//        if (oldSchemaVersion < 2) {
//            // 把数据库中旧的轨迹数据变为新的
//            [migration enumerateObjects:[ToolResultModel className] block:^(RLMObject * _Nullable oldObject, RLMObject * _Nullable newObject) {
//                if ([oldObject[@"toolIdentifier"] isEqualToString:ToolTypeIdentifierRunTrackOld]) {
//                    newObject[@"toolIdentifier"] = ToolTypeIdentifierRunTrack;
//                }
//            }];
//        }
    }];
    return conf;
}

+ (void)writeToSharedStorageWithBlock:(void (^)(RLMRealm * _Nonnull))block {
    NSParameterAssert(block);
    dispatch_sync_on_main(^{
        MBDataStack *ds = [MBApp status].dataStack;
        RLMRealm *s = ds.sharedStorage;
        if (s.inWriteTransaction) {
            block(s);
        }
        else {
            [s beginWriteTransaction];
            block(s);
            NSError __autoreleasing *e = nil;
            [s commitWriteTransaction:&e];
            if (e) dout_error(@"%@", e);
        }
    });
}

#pragma mark -

- (void)applicationDidEnterBackground:(UIApplication *)application {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self removeFileProtection];
    });
}

/// 把所有 Realm 文件的 data protection 去掉，防止崩溃
- (void)removeFileProtection {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *storageDirURL = self.realmDirURL;
    NSDirectoryEnumerator *dirEnumerator = [fm enumeratorAtURL:storageDirURL includingPropertiesForKeys:nil options:0 errorHandler:nil];
    for (NSURL *fileURL in dirEnumerator) {
        [fm setAttributes:@{ NSFileProtectionKey: NSFileProtectionNone } ofItemAtPath:fileURL.path error:nil];
    }
}

@end

@implementation RLMResults (App)

- (RLMResults *)objectsWithPredicateFormat:(NSString *)predicateFormat, ... {
    va_list args;
    va_start(args, predicateFormat);
    NSPredicate *pd = [NSPredicate predicateWithFormat:predicateFormat arguments:args];
    va_end(args);
    RLMResults *result = [self objectsWithPredicate:pd];
    return result;
}

@end


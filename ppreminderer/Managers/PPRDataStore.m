#import "PPRDataStore.h"

#define kDataStoreKey @"database"
#define kDataFile @"pprreminder"

@implementation PPRDataStore

- (id) init {
    self = [super init];
    if (self) {
        _documentsDirectoryName = [self getPrivateDocsDir];
    }
    return self;
}

- (id)loadObjectForKey:(NSString *)key {
    NSString *dataPath = [self.documentsDirectoryName stringByAppendingPathComponent:kDataFile];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    if (codedData == nil) return nil;
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    NSDictionary *dataStore = [unarchiver decodeObjectForKey:kDataStoreKey];
    [unarchiver finishDecoding];
    return dataStore[key];
}

- (void)saveObject:(id)object forKey:(NSString *)key {
    NSString *dataPath = [self.documentsDirectoryName stringByAppendingPathComponent:kDataFile];
    
    // load existing data
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    NSDictionary *database = [unarchiver decodeObjectForKey:kDataStoreKey];
    NSMutableDictionary *mutableDatabase = database ? [database mutableCopy] : [[NSMutableDictionary alloc] init];
    
    // add / replace existing data
    [mutableDatabase setObject:object forKey:key];
    NSMutableData *updatedData = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:updatedData];
    [archiver encodeObject:mutableDatabase forKey:kDataStoreKey];
    [archiver finishEncoding];
    [updatedData writeToFile:dataPath atomically:YES];
}

- (NSString *)getPrivateDocsDir {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"PPReminderer Documents"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    return documentsDirectory;
}

- (NSString *)createPrivateDocsDirFor:(NSString *)directory {
    NSString *fullPath = [self privateDirectoryPath:directory];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:&error];
    
    return fullPath;
}

- (void)saveObject:(id)object objectId:(NSString *)objectId directory:(NSString *)directory {
    
    
    NSString *fullPath = [self filePathForObjectId:objectId directory:directory];
    
    [NSKeyedArchiver archiveRootObject:object  toFile:fullPath];
}

- (void)removeObjectId:(NSString *)objectId directory:(NSString *)directory {
    NSString *fullPath = [self filePathForObjectId:objectId directory:directory];
    NSError *deleteError;
    NSLog(@"Removing document %@", fullPath);
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:fullPath error:&deleteError];
    if (!success) {
        NSLog(@"Error removing document path: %@", deleteError.localizedDescription);
    }
}


- (NSArray *)loadObjectsFromDirectory:(NSString *)directory {
    
    NSString *fullPath = [self.documentsDirectoryName stringByAppendingPathComponent:directory];
    
    NSError *error;
    NSArray *filesToLoad = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fullPath error:&error];
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    
    for (NSString *fileName in filesToLoad) {
        if ([fileName hasSuffix:@".plist"]) {
            [objects addObject: [NSKeyedUnarchiver unarchiveObjectWithFile:[fullPath stringByAppendingPathComponent:fileName]]];
        }
    }
    return objects;
}

- (NSString *)privateDirectoryPath:(NSString *)directory {
    return  [self.documentsDirectoryName stringByAppendingPathComponent:directory];
}

- (NSString *)filePathForObjectId:(NSString *)objectId directory:(NSString *)directory {
    return [[self privateDirectoryPath:directory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", objectId]];
}

@end
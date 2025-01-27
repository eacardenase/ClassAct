//
//  main.m
//  ClassAct
//
//  Created by Edwin Cardenas on 26/01/25.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        unsigned int classCount = 0;
        
        Class *classList = objc_copyClassList(&classCount);
        
        for (int i = 0; i < classCount; i++) {
            Class currentClass = classList[i];
            NSString *className = NSStringFromClass(currentClass);
            
            NSLog(@"%@", className);
        }
        
        free(classList);
    }
    return 0;
}

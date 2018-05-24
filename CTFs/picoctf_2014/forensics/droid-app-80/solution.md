## Solution
Decompile and extract all data from APK file.
In file picoapp453/picoctf/com/picoapp/ToasterActivity.java you'll find the flag.
```java
 21     public ToasterActivity()
 22     {
 23         mystery = new String(new char[] {
 24             'f', 'l', 'a', 'g', ' ', 'i', 's', ':', ' ', 'w',
 25             'h', 'a', 't', '_', 'd', 'o', 'e', 's', '_', 't',
 26             'h', 'e', '_', 'l', 'o', 'g', 'c', 'a', 't', '_',
 27             's', 'a', 'y'
 28         });
 29     }
 30
```

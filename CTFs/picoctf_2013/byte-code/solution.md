## Solution
Unzip file and open the Authenticator.class using radare2.
```bash
$ r2 Authenticator.class
syntax error: error in error handling
syntax error: error in error handling
syntax error: error in error handling
[X] r_bin_java_code_attr_new: Error unable to parse remainder of classfile after Method's Code Attribute: 1.
 -- License server overloaded (ETOOMANYCASH)
[0x000002a4]> aa
[x] Analyze all flags starting with sym. and entry0 (aa)
[0x000002a4]> afl
0x000002a4    3 5            entry0
0x000002cf   75 147          sym.Authenticator.main
[0x000002cf]> pdf @ sym.Authenticator.main
            ;-- main:
            ;-- entry1:
            ;-- method.Authenticator.main:
            ;-- eip:
┌ (fcn) sym.Authenticator.main 147
│   sym.Authenticator.main ();
│           0x000002cf      100a           bipush 10
│           0x000002d1      bc05           newarray 5
│           0x000002d3      b30002         putstatic Authenticator/key [C
│           0x000002d6      b20002         getstatic Authenticator/key [C
│           0x000002d9      03             iconst_0
│           0x000002da      1041           bipush 65
│           0x000002dc      55             castore
│           0x000002dd      b20002         getstatic Authenticator/key [C
│           0x000002e0      04             iconst_1
│           0x000002e1      106f           bipush 111
│           0x000002e3      55             castore
│           0x000002e4      b20002         getstatic Authenticator/key [C
│           0x000002e7      05             iconst_2
│           0x000002e8      104a           bipush 74
│           0x000002ea      55             castore
│           0x000002eb      b20002         getstatic Authenticator/key [C
│           0x000002ee      06             iconst_3
│           0x000002ef      106b           bipush 107
│           0x000002f1      55             castore
│           0x000002f2      b20002         getstatic Authenticator/key [C
│           0x000002f5      07             iconst_4
│           0x000002f6      1056           bipush 86
│           0x000002f8      55             castore
│           0x000002f9      b20002         getstatic Authenticator/key [C
│           0x000002fc      08             iconst_5
│           0x000002fd      1068           bipush 104
│           0x000002ff      55             castore
│           0x00000300      b20002         getstatic Authenticator/key [C
│           0x00000303      1006           bipush 6
│           0x00000305      104c           bipush 76
│           0x00000307      55             castore
│           0x00000308      b20002         getstatic Authenticator/key [C
│           0x0000030b      1007           bipush 7
│           0x0000030d      1077           bipush 119
│           0x0000030f      55             castore
│           0x00000310      b20002         getstatic Authenticator/key [C
│           0x00000313      1008           bipush 8
│           0x00000315      1055           bipush 85
│           0x00000317      55             castore
│           0x00000318      b20002         getstatic Authenticator/key [C
│           0x0000031b      1009           bipush 9
│           0x0000031d      1052           bipush 82
│           0x0000031f      55             castore
│           0x00000320      b80003         invokestatic java/lang/System/console()Ljava/io/Console;
│           0x00000323      4c             astore_1
│           0x00000324      1204           ldc ""
│           0x00000326      4d             astore_2
│       ┌─> 0x00000327      2c             aload_2
│       ⁝   0x00000328      1205           ldc "ThisIsth3mag1calString4458"
│       ⁝   0x0000032a      b60006         invokevirtual java/lang/String/equals(Ljava/lang/Object;)Z
│      ┌──< 0x0000032d      9a0011         ifne 0x033e
│      │⁝   0x00000330      2b             aload_1
│      │⁝   0x00000331      1207           ldc "Enter password:"
│      │⁝   0x00000333      03             iconst_0
│      │⁝   0x00000334      bd0008         anewarray java/lang/Object
│      │⁝   0x00000337      b60009         invokevirtual java/io/Console/readLine(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;
│      │⁝   0x0000033a      4d             astore_2
│      │└─< 0x0000033b      a7ffec         goto 0x0327
│      └──> 0x0000033e      03             iconst_0
│           0x0000033f      3e             istore_3
│       ┌─> 0x00000340      1d             iload_3
│       ⁝   0x00000341      b20002         getstatic Authenticator/key [C
│       ⁝   0x00000344      be             arraylength
│      ┌──< 0x00000345      a20014         if_icmpge 0x0359
│      │⁝   0x00000348      b2000a         getstatic java/lang/System/out Ljava/io/PrintStream;
│      │⁝   0x0000034b      b20002         getstatic Authenticator/key [C
│      │⁝   0x0000034e      1d             iload_3
│      │⁝   0x0000034f      34             caload
│      │⁝   0x00000350      b6000b         invokevirtual java/io/PrintStream/print(C)V
│      │⁝   0x00000353      840301         iinc 3 1
│      │└─< 0x00000356      a7ffea         goto 0x0340
│      └──> 0x00000359      b2000a         getstatic java/lang/System/out Ljava/io/PrintStream;
│           0x0000035c      1204           ldc ""
│           0x0000035e      b6000c         invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
└           0x00000361      b1             return
[0x000002cf]>
```
Each `bipush` instruction is a int push (chars) to the stack after the __key__ array was created.
```bash
$ perl -e '@a=qw(65 111 74 107 86 104 76 119 85 82);foreach(@a){print chr ;}'; echo
AoJkVhLwUR
```

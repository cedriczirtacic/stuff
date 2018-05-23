## Solution
```bash
$ zsteg -a steg.png
meta date:create    .. text: "2013-01-17T17:35:32-05:00"
meta date:modify    .. [same as "meta date:create"]
imagedata           .. text: "\"&&\"4&$>8:"
b1,rgb,lsb,xy       .. text: "Hey I think we can write safely in this file without anyone seeing it. Anyway, the secret key is: st3g0_saurus_wr3cks"
b2,r,msb,xy         .. text: ["U" repeated 178 times]
b2,g,msb,xy         .. text: ["U" repeated 178 times]
b2,b,msb,xy         .. text: ["U" repeated 178 times]
...
```

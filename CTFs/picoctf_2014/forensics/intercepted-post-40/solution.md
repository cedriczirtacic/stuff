## Solution
Hint says that login data is transfered via POST requests, so we check those:
```bash
$ tshark -Q -r intercept.pcap -T json -Y "http && http.request.method == POST"
...
        "urlencoded-form": {
          "Form item: \"username\" = \"claudio\"": {
            "urlencoded-form.key": "username",
            "urlencoded-form.value": "claudio"
          },
          "Form item: \"password\" = \"flag{pl$_$$l_y0ur_l0g1n_form$}\"": {
            "urlencoded-form.key": "password",
            "urlencoded-form.value": "flag{pl$_$$l_y0ur_l0g1n_form$}"
          }
        }
...
```

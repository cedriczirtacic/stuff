/* cedric @ github.com/cedriczirtacic
 * gcc-o bsm_uid_audit -Wall -lbsm bsm_uid_audit.c
 * Check OpenBSM events in case of a users' actions or all users (use praudit
 * in this case),
 */
#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>

/* user info */
#include <pwd.h>

/* bsm library */
#include <bsm/libbsm.h>

#define SEPARATOR       ", "

typedef struct {
    uid_t ruid;
    uid_t euid;
} event_ids;

void println() { putchar('\n'); }

int print_tok_info(tokenstr_t *tok, unsigned char *buf, int len, uid_t uid) {
    short int tok_len = 0;

    if (uid == -1)
        /* no uid specified then jmp to print_token */
        goto print_token;

    event_ids e_ids = {-1, -1};
    while (tok_len < len) {
        au_fetch_tok(tok, buf + tok_len , len - tok_len);
#ifdef DEBUG
        printf("token id: %x\n", tok->id);
#endif
        /* these are the audit types that contain some kind of user id */
        switch (tok->id) {
            case(AUT_SUBJECT32):
                e_ids.ruid = tok->tt.subj32.ruid;
                e_ids.euid = tok->tt.subj32.euid;
                break;
            case(AUT_SUBJECT64):
                e_ids.ruid = tok->tt.subj64.ruid;
                e_ids.euid = tok->tt.subj64.euid;
                break;
            case(AUT_SUBJECT32_EX):
                e_ids.ruid = tok->tt.subj32_ex.ruid;
                e_ids.euid = tok->tt.subj32_ex.euid;
                break;
            case(AUT_SUBJECT64_EX):
                e_ids.ruid = tok->tt.subj64_ex.ruid;
                e_ids.euid = tok->tt.subj64_ex.euid;
                break;
            case(AUT_PROCESS32):
                e_ids.ruid = tok->tt.proc32.ruid;
                e_ids.euid = tok->tt.proc32.euid;
                break;
            case(AUT_PROCESS64):
                e_ids.ruid = tok->tt.proc64.ruid;
                e_ids.euid = tok->tt.proc64.euid;
                break;
            case(AUT_PROCESS32_EX):
                e_ids.ruid = tok->tt.proc32_ex.ruid;
                e_ids.euid = tok->tt.proc32_ex.euid;
                break;
            case(AUT_PROCESS64_EX):
                e_ids.ruid = tok->tt.proc64_ex.ruid;
                e_ids.euid = tok->tt.proc64_ex.euid;
                break;
            case(AUT_ATTR32):
                e_ids.ruid = tok->tt.attr32.uid;
                break;
            case(AUT_ATTR64):
                e_ids.ruid = tok->tt.attr64.uid;
                break;
            /* no euid or ruid but gonna reuse those... */
            case(AUT_IPC_PERM):
                e_ids.ruid = tok->tt.ipcperm.uid;
                e_ids.euid = tok->tt.ipcperm.puid;
                break;
            default:
                break;
        }

#ifdef DEBUG
        printf("real uid: %d\n", e_ids.ruid);
        printf("effective uid: %d\n", e_ids.euid);
#endif
        if (e_ids.ruid != -1 || e_ids.euid != -1)
            break;

        tok_len += tok->len;
    }

    if (e_ids.ruid != uid && e_ids.euid != uid)
        return (1);

print_token:
    tok_len = 0;
    while (tok_len < len) {
        au_fetch_tok(tok, buf + tok_len , len - tok_len);
        
        /* first cycle? */
        if (tok_len == 0) {
            au_event_t e = tok->tt.hdr64.e_type;
            struct au_event_ent *ev_ent = getauevnum(e);

            printf("[+] Event type: %s\n", ev_ent->ae_name);
        }
        au_print_tok(stdout, tok, SEPARATOR, 0, 0);
        println();
        tok_len += tok->len;
    }

    return (0);
}

int main(int argc, char *argv[]) {
    FILE *audit_fd;
    char *user;
    struct passwd *user_pwd;

    audit_fd = fopen("/dev/auditpipe", "r");
    if (audit_fd == NULL) {
        perror("fopen");
        if (errno == EACCES)
            fprintf(stderr, "Hint: starts with 'r' and rhymes with 'boot'.\n");
        return (1);
    }

    if (argc == 2) {
        --argc;
        /* help/usage */
        if ( argv[argc][0] == '-' &&
                argv[argc][1] == 'h') {
            fprintf(stderr, "Usage: %s [-h] (username)\n",
                    argv[0]);
            return (1);
        }
        user = argv[argc];
        user_pwd = getpwnam(user);
        if (user_pwd == NULL) {
            perror("getpwnam");
            return (2);
        }

        printf("[i] Checking for user: %s (%d)\n",
                user, user_pwd->pw_uid
              );
    } else if (argc > 1) {
        return (1);
    } else {
        printf("[i] Checking for all users.\n");
    }
    
    unsigned char *buf;
    while(1) {
        tokenstr_t tokstr;
        int rec_len = au_read_rec (audit_fd, &buf);
        if (rec_len > 0) {
            //printf("[i] Action detected!\n");
            if (user_pwd != NULL)
                print_tok_info(&tokstr, buf, rec_len, user_pwd->pw_uid);
            else
                print_tok_info(&tokstr, buf, rec_len, -1);
        }

        free(buf);
    }

    fclose(audit_fd);

    return (0);
}

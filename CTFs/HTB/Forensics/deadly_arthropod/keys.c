#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdbool.h>

#include "usb_hid_keys.h"

int get_key (unsigned long k, int p) {
    bool shift = false;
    int ch;
    char c;

    if (k&0x2)
        shift = true;

    ch = (k>>0x10);
    if (ch < KEY_A) goto bail;
    //printf("shift = %s, key = %x, pos = %d\n",
    //        (shift?"true":"false"), ch, p);

    switch (ch) {
		case (KEY_A): (shift?(c = 'A'):(c = 'a'));
			break;

		case (KEY_B): (shift?(c = 'B'):(c = 'b'));
			break;

		case (KEY_C): (shift?(c = 'C'):(c = 'c'));
			break;

		case (KEY_D): (shift?(c = 'D'):(c = 'd'));
			break;

		case (KEY_E): (shift?(c = 'E'):(c = 'e'));
			break;

		case (KEY_F): (shift?(c = 'F'):(c = 'f'));
			break;

		case (KEY_G): (shift?(c = 'G'):(c = 'g'));
			break;

		case (KEY_H): (shift?(c = 'H'):(c = 'h'));
			break;

		case (KEY_I): (shift?(c = 'I'):(c = 'i'));
			break;

		case (KEY_J): (shift?(c = 'J'):(c = 'j'));
			break;

		case (KEY_K): (shift?(c = 'K'):(c = 'k'));
			break;

		case (KEY_L): (shift?(c = 'L'):(c = 'l'));
			break;

		case (KEY_M): (shift?(c = 'M'):(c = 'm'));
			break;

		case (KEY_N): (shift?(c = 'N'):(c = 'n'));
			break;

		case (KEY_O): (shift?(c = 'O'):(c = 'o'));
			break;

		case (KEY_P): (shift?(c = 'P'):(c = 'p'));
			break;

		case (KEY_Q): (shift?(c = 'Q'):(c = 'q'));
			break;

		case (KEY_R): (shift?(c = 'R'):(c = 'r'));
			break;

		case (KEY_S): (shift?(c = 'S'):(c = 's'));
			break;

		case (KEY_T): (shift?(c = 'T'):(c = 't'));
			break;

		case (KEY_U): (shift?(c = 'U'):(c = 'u'));
			break;

		case (KEY_V): (shift?(c = 'V'):(c = 'v'));
			break;

		case (KEY_W): (shift?(c = 'W'):(c = 'w'));
			break;

		case (KEY_X): (shift?(c = 'X'):(c = 'x'));
			break;

		case (KEY_Y): (shift?(c = 'Y'):(c = 'y'));
			break;

		case (KEY_Z): (shift?(c = 'Z'):(c = 'z'));
			break;

		case (KEY_1): (shift?(c = '!'):(c = '1'));
			break;

		case (KEY_2): (shift?(c = '@'):(c = '2'));
			break;

		case (KEY_3): (shift?(c = '#'):(c = '3'));
			break;

		case (KEY_4): (shift?(c = '$'):(c = '4'));
			break;

		case (KEY_5): (shift?(c = '%'):(c = '5'));
			break;

		case (KEY_6): (shift?(c = '^'):(c = '6'));
			break;

		case (KEY_7): (shift?(c = '&'):(c = '7'));
			break;

		case (KEY_8): (shift?(c = '*'):(c = '8'));
			break;

		case (KEY_9): (shift?(c = '('):(c = '9'));
			break;

		case (KEY_0): (shift?(c = ')'):(c = '0'));
			break;

		case (KEY_MINUS): (shift?(c = '_'):(c = '-'));
			break;

		case (KEY_EQUAL): (shift?(c = '+'):(c = '='));
			break;

		case (KEY_LEFTBRACE): (shift?(c = '{'):(c = '['));
			break;

		case (KEY_RIGHTBRACE): (shift?(c = '}'):(c = ']'));
			break;

		case (KEY_BACKSLASH): (shift?(c = '|'):(c = '\\'));
			break;

		case (KEY_HASHTILDE): (shift?(c = '~'):(c = '#'));
			break;

		case (KEY_SEMICOLON): (shift?(c = ':'):(c = ';'));
			break;

		case (KEY_APOSTROPHE): (shift?(c = '"'):(c = '\''));
			break;

		case (KEY_GRAVE): (shift?(c = '~'):(c = '`'));
			break;

		case (KEY_COMMA): (shift?(c = '<'):(c = ','));
			break;

		case (KEY_DOT): (shift?(c = '>'):(c = '.'));
			break;

		case (KEY_SLASH): (shift?(c = '?'):(c = '/'));
			break;
		
        case (KEY_ENTER): c = '\n'; break;
        //case (KEY_ENTER): p = -1;break;
			break;
		case (KEY_RIGHT): printf("->");/*printf("%c%c%c" ,0x1b, 0x5b, 0x43);*/ goto bail; break;
		case (KEY_LEFT): printf("<-");/*printf("%c%c%c" ,0x1b, 0x5b, 0x44);*/ goto bail; break;
        default: printf("unknown: 0x%x\n", ch); goto bail;
    }

    p++;
    printf("%c", c);
bail:
    //printf("full = %.16x\n========\n", k);
    return (p);
}

int main(int argc, char *argv[]) {
    char *in;
    int datafd;

    argc--; argv++;
    if (argc == 0)
        return (1);
    in = *argv;

    datafd = open(in, O_RDONLY);
    if (datafd == -1) {
        perror("open");
        return (1);
    }

    unsigned long key;
    int pos = 0;
    while ((read(datafd, &key, 8)) > 0) {
        pos = get_key(key, pos);
    }
    printf("\n");

    return (0);
}

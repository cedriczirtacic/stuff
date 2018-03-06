package main

import (
	"fmt"
	"io"
	"os"
	"strings"
)

var (
	filename string
)

const (
	TAB = "    " // tabs == 4 spaces :)

	BRAINFUCK_TOKEN_PLUS        = '+'
	BRAINFUCK_TOKEN_PLUS_C      = "++*ptr;"
	BRAINFUCK_TOKEN_PLUS_C_MORE = "*ptr += %d;"

	BRAINFUCK_TOKEN_MINUS        = '-'
	BRAINFUCK_TOKEN_MINUS_C      = "--*ptr;"
	BRAINFUCK_TOKEN_MINUS_C_MORE = "*ptr -= %d;"

	BRAINFUCK_TOKEN_PREVIOUS        = '<'
	BRAINFUCK_TOKEN_PREVIOUS_C      = "++ptr;"
	BRAINFUCK_TOKEN_PREVIOUS_C_MORE = "ptr += %d;"

	BRAINFUCK_TOKEN_NEXT        = '>'
	BRAINFUCK_TOKEN_NEXT_C      = "--ptr;"
	BRAINFUCK_TOKEN_NEXT_C_MORE = "ptr -= %d;"

	BRAINFUCK_TOKEN_OUTPUT   = '.'
	BRAINFUCK_TOKEN_OUTPUT_C = "putchar(*ptr);"

	BRAINFUCK_TOKEN_INPUT   = ','
	BRAINFUCK_TOKEN_INPUT_C = "*ptr = getchar();"

	BRAINFUCK_TOKEN_LOOP_START   = '['
	BRAINFUCK_TOKEN_LOOP_START_C = "while (*ptr) {"

	BRAINFUCK_TOKEN_LOOP_END   = ']'
	BRAINFUCK_TOKEN_LOOP_END_C = "}"
)

func init() {
	if len(os.Args) != 2 {
		fmt.Fprintf(os.Stderr, "Usage: %s <bf_file>\n", os.Args[0])
		os.Exit(1)
	}

	filename = os.Args[1]
}

func main() {
	var (
		fd, out_fd *os.File
		out        string
		err        error
		indent     int = 1
	)
	fd, err = os.Open(filename)
	if err != nil {
		fmt.Fprintf(os.Stderr, "%s\n", err)
		return
	}
	defer fd.Close()

	if index := strings.LastIndex(filename, "."); index > -1 {
		out = filename[:index] + ".c"
	} else {
		out = filename + ".c"
	}
	out_fd, err = os.OpenFile(out, os.O_RDWR|os.O_CREATE, 0744)
	if err != nil {
		fmt.Fprintf(os.Stderr, "%s\n", err)
		return
	}
	defer out_fd.Close()

	_writeln("int main() {\n" + TAB + "char c[3000];\n" + TAB + "char *ptr = c;\n", 0, out_fd)
	c := make([]byte, 1)
	for err != io.EOF {
		_, err = fd.Read(c)

		// ignore blank data
		if c[0] == '\r' || c[0] == '\n' || c[0] == ' ' || c[0] == '\t' {
			continue
		}
		// check for instructions
		switch c[0] {
		case BRAINFUCK_TOKEN_PLUS:
			if n := count_instructions(c, fd); n > 1 {
				_writeln(fmt.Sprintf(BRAINFUCK_TOKEN_PLUS_C_MORE, n), indent, out_fd)
			} else {
				_writeln(BRAINFUCK_TOKEN_PLUS_C, indent, out_fd)
			}
		case BRAINFUCK_TOKEN_MINUS:
			if n := count_instructions(c, fd); n > 1 {
				_writeln(fmt.Sprintf(BRAINFUCK_TOKEN_MINUS_C_MORE, n), indent, out_fd)
			} else {
				_writeln(BRAINFUCK_TOKEN_MINUS_C, indent, out_fd)
			}
		case BRAINFUCK_TOKEN_PREVIOUS:
			if n := count_instructions(c, fd); n > 1 {
				_writeln(fmt.Sprintf(BRAINFUCK_TOKEN_PREVIOUS_C_MORE, n), indent, out_fd)
			} else {
				_writeln(BRAINFUCK_TOKEN_PREVIOUS_C, indent, out_fd)
			}
		case BRAINFUCK_TOKEN_NEXT:
			if n := count_instructions(c, fd); n > 1 {
				_writeln(fmt.Sprintf(BRAINFUCK_TOKEN_NEXT_C_MORE, n), indent, out_fd)
			} else {
				_writeln(BRAINFUCK_TOKEN_NEXT_C, indent, out_fd)
			}
		case BRAINFUCK_TOKEN_OUTPUT:
			_writeln(BRAINFUCK_TOKEN_OUTPUT_C, indent, out_fd)
		case BRAINFUCK_TOKEN_INPUT:
			_writeln(BRAINFUCK_TOKEN_INPUT_C, indent, out_fd)
		case BRAINFUCK_TOKEN_LOOP_START:
			_writeln(BRAINFUCK_TOKEN_LOOP_START_C, indent, out_fd)
			indent++
		case BRAINFUCK_TOKEN_LOOP_END:
			indent--
			_writeln(BRAINFUCK_TOKEN_LOOP_END_C, indent, out_fd)
		default:
			pos, _ := fd.Seek(0, io.SeekCurrent)
			fmt.Fprintf(os.Stderr, "error: unknown token %c at position %d\n", c[0], pos)
			goto bail
		}
	}
	_writeln("}\n", 0, out_fd)
	fmt.Printf("Success: %s\n", out)
bail:
}

func count_instructions(i []byte, f *os.File) int {
	var (
		ret         int = 1
		current_pos int64
		err         error
	)
	ch := make([]byte, 1)
	current_pos, _ = f.Seek(0, io.SeekCurrent)

	for err != io.EOF {
		_, err = f.Read(ch)
		if ch[0] != i[0] {
			break
		}
		ret++
		current_pos++
	}
	_, _ = f.Seek(current_pos, io.SeekStart)
	return ret
}

func _writeln(c string, in int, f *os.File) {
	// indentation
	if in > 0 {
		for i := 0; i < in; i++ {
			fmt.Fprintf(f, TAB)
		}
	}
	fmt.Fprintf(f, "%s\n", c)
}

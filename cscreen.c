/* cscreen.c */

#include <ncurses.h>

void init_curses() {
    initscr();
    keypad(stdscr, 1);
}

void end_curses() {
    keypad(stdscr, 0);
    endwin();
}

int get_width() {
    return getmaxx(stdscr);
}

int get_height() {
    return getmaxy(stdscr);
}

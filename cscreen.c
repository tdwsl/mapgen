/* cscreen.c */

#include <ncurses.h>

void init_curses() {
    initscr();
    keypad(stdscr, 1);
    noecho();
}

void end_curses() {
    echo();
    keypad(stdscr, 0);
    endwin();
}

int get_width() {
    return getmaxx(stdscr);
}

int get_height() {
    return getmaxy(stdscr);
}

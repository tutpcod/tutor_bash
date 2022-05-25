#include <ncurses.h>
#define DX 3

int main() {
        WINDOW *win;
        int c = 0;

        initscr();
        noecho();
        cbreak();
        printw("Window:");
        refresh();

        win = newwin(LINES-2*DX, COLS-2*DX, DX, DX);
        keypad(win, TRUE);
        scrollok (win, TRUE);
        do {
                wprintw(win, "  Key: %d, Name: %s\n", c, keyname(c));
                box(win, 0, 0);
                wrefresh(win);
        } while((c = wgetch(win)) != 27);

        endwin();
	return 0;
}

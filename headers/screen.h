#ifndef SCREEN_H
#define SCREEN_H

bool screen_size_in_range(QScreen* screen);
void screen_window_show(QQuickWindow *window, QScreen* screen);

#endif // SCREEN_H



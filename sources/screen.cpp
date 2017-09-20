#include <QScreen>
#include <QQuickWindow>
#include "QScreen.h"

//LandscapeOrientation & InvertedLandscapeOrientation
#define MIN_WINDOW_WIDTH    800
#define MIN_WINDOW_HEIGHT   600

static int get_screen_width(QScreen* screen)
{
    return screen->size().width();
}

static int get_screen_height(QScreen* screen)
{
    return screen->size().height();
}

bool screen_size_in_range(QScreen* screen)
{
    //LandscapeOrientation & InvertedLandscapeOrientation
    if (screen->isLandscape(screen->orientation()))
       return (get_screen_width(screen) >= MIN_WINDOW_WIDTH
               && get_screen_height(screen) >= MIN_WINDOW_HEIGHT);
    else
        return (get_screen_height(screen) >= MIN_WINDOW_WIDTH
                && get_screen_width(screen) >= MIN_WINDOW_HEIGHT);

    return true;
}

void screen_window_show(QQuickWindow *window, QScreen* screen)
{
    if (screen->isLandscape(screen->orientation()))
    {
        window->setMinimumWidth(MIN_WINDOW_WIDTH);
        window->setMinimumHeight(MIN_WINDOW_HEIGHT);
    }
    else
    {
        window->setMinimumWidth(MIN_WINDOW_HEIGHT);
        window->setMinimumHeight(MIN_WINDOW_WIDTH);
    }
    window->showMaximized();
}

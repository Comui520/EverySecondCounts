#include "MyTime.h"

MyTime::MyTime(const int h, const int m, const int s, QString title, QObject *parent)
    : QObject{parent}
{
    m_time = new QTime(h, m, s);
    m_timeTitle = title;
}

QTime *MyTime::time() const
{
    return m_time;
}

void MyTime::setTime(QTime *newTime)
{
    if (m_time == newTime)
        return;
    m_time = newTime;
    emit timeChanged();
}

QString MyTime::timeTitle() const
{
    return m_timeTitle;
}

void MyTime::setTimeTitle(const QString &newTimeTitle)
{
    if (m_timeTitle == newTimeTitle)
        return;
    m_timeTitle = newTimeTitle;
    emit timeTitleChanged();
}

#include "TimeController.h"

TimeController::TimeController(QObject *parent)
    : QAbstractListModel{parent}
{
    m_currentTime = new QTime(0, 0, 0);
    m_timer.setInterval(1000);
    m_timer.setSingleShot(false);
    connect(&m_timer, &QTimer::timeout, this, &TimeController::updateTime);
}

int TimeController::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_timeList.length();
}

QVariant TimeController::data(const QModelIndex &index, int role) const
{
    if (index.isValid() && index.row() >= 0 && index.row() < m_timeList.length()){
        QTime* result = m_timeList[index.row()];
        switch(Role(role)){
        case TimeHoursRole:
            return result->hour();
        case TimeMinutesRole:
            return result->minute();
        case TimeSecondsRole:
            return result->second();
        }
    }
    return {};
}

QHash<int, QByteArray> TimeController::roleNames() const
{
    // TimeTotalTimeRole = Qt::UserRole + 1,
    // TimeHoursRole,
    // TimeMinutesRole,
    // TimeSecondsRole
    QHash<int, QByteArray> result;
    result[TimeHoursRole] = "hours";
    result[TimeMinutesRole] = "minutes";
    result[TimeSecondsRole] = "seconds";
    return result;
}

void TimeController::addNewTime(int h, int m, int s)
{
    beginInsertRows(QModelIndex(), m_timeList.length(), m_timeList.length());
    QTime* newTime = new QTime;
    newTime->setHMS(h, m, s);
    m_timeList << newTime;
    endInsertRows();
}

void TimeController::setCurrentTime(int h, int m, int s)
{
    m_currentTime->setHMS(h, m, s);
}

int TimeController::showCurrentTimeH()
{
    return m_currentTime->hour();
}

int TimeController::showCurrentTimeM()
{
    return m_currentTime->minute();
}

int TimeController::showCurrentTimeS()
{
    return m_currentTime->second();
}

void TimeController::start()
{
    m_timer.start();
}

void TimeController::stop()
{
    m_timer.stop();
}

void TimeController::updateTime()
{
    if (!m_currentTime) return;
    if (*m_currentTime == QTime(0, 0, 0)) {
        stop();
        emit timeShouldUpdate(); // 通知QML倒计时结束
        return;
    }

    *m_currentTime = m_currentTime->addSecs(-1);
    emit currentTimeChanged();
}


QTime *TimeController::currentTime() const
{
    return m_currentTime;
}

void TimeController::setCurrentTime(QTime *newCurrentTime)
{
    if (m_currentTime == newCurrentTime)
        return;
    m_currentTime = newCurrentTime;
    emit currentTimeChanged();
}

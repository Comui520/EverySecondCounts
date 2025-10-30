#include "TimeController.h"
#include <QDebug>

TimeController::TimeController(QObject *parent)
    : QAbstractListModel{parent}
{
    m_currentTime = new QTime(0, 0, 0);
    m_timer.setInterval(200);
    m_timer.setSingleShot(false);
    player->setAudioOutput(audioOutput);
    player->setSource(QUrl("qrc:/qt/qml/EverySecondCounts/assets/audios/ring.mp3"));
    audioOutput->setVolume(1.0);


    connect(&m_timer, &QTimer::timeout, this, &TimeController::updateTime);
    connect(this, &TimeController::timeUp, this, &TimeController::ring);
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

void TimeController::removeTime(const int index)
{
    if (index >= 0 && index < m_timeList.length()){
        beginRemoveRows(QModelIndex(), index, index);
        m_timeList.removeAt(index);
        endRemoveRows();
    }
}

void TimeController::setCurrentTime(const int h, const int m, const int s)
{
    m_currentTime->setHMS(h, m, s, 0);
    emit currentTimeChanged();
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
    if(*m_currentTime == QTime(0, 0, 0)){
        return;
    }
    m_timer.start();
    setIsCount(true);
}

void TimeController::stop()
{
    m_timer.stop();
    setIsCount(false);
}

void TimeController::reset()
{
    this->stop();
    setCurrentTime(0, 0, 0);
}

void TimeController::updateTime()
{
    if (!m_currentTime) return;
    if (*m_currentTime == QTime(0, 0, 0)) {
        this->stop();
        emit timeUp(); // 通知QML倒计时结束
        return;
    }
    *m_currentTime = m_currentTime->addMSecs(-200);
    emit currentTimeChanged();
}

void TimeController::ring(){
    player->play();
    this->stop();
    setCurrentTime(0, 0, 0);
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

bool TimeController::isCount() const
{
    return m_isCount;
}

void TimeController::setIsCount(bool newIsCount)
{
    if (m_isCount == newIsCount)
        return;
    m_isCount = newIsCount;
    emit isCountChanged();
}

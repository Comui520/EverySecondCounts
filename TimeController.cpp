#include "TimeController.h"
#include <QDebug>

TimeController::TimeController(QObject *parent)
    : QAbstractListModel{parent}
{
    m_currentTime = new QTime;
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
        MyTime* result = m_timeList[index.row()];
        QTime* time = result->time();
        QString timeTitle = result->timeTitle();
        switch(Role(role)){
        case TimeHoursRole:
            return time->hour();
        case TimeMinutesRole:
            return time->minute();
        case TimeSecondsRole:
            return time->second();
        case TimeTitleRole:
            return timeTitle;
        }
    }
    return {};
}

QHash<int, QByteArray> TimeController::roleNames() const
{
    // TimeTotalTimeRole = Qt::UserRole + 1,
    // TimeHoursRole,
    // TimeMinutesRole,
    // TimeSecondsRole,
    // TimeTitleRole
    QHash<int, QByteArray> result;
    result[TimeHoursRole] = "hours";
    result[TimeMinutesRole] = "minutes";
    result[TimeSecondsRole] = "seconds";
    result[TimeTitleRole] = "timeTitle";
    return result;
}

void TimeController::addNewTime(int h, int m, int s, QString title)
{
    beginInsertRows(QModelIndex(), m_timeList.length(), m_timeList.length());
    MyTime* newTime = new MyTime;

    newTime->time()->setHMS(h, m, s);
    newTime->setTimeTitle(title);
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

void TimeController::saveCommonCountdowns()
{
    QSettings settings("Comui520", "EverySecondCounts");
    settings.remove("CommonCountdowns");
    settings.beginWriteArray("CommonCountdowns");
    for (int i = 0; i < m_timeList.size(); ++i){
        QTime* time = m_timeList[i]->time();
        QString timeTitle = m_timeList[i]->timeTitle();
        settings.setArrayIndex(i);
        settings.setValue("hours", time->hour());
        settings.setValue("minutes", time->minute());
        settings.setValue("seconds", time->second());
        settings.setValue("timeTitle", timeTitle);
    }
    settings.endArray();

}

void TimeController::loadCommonCountdowns()
{
    QSettings settings("Comui520", "EverySecondCounts");
    int size = settings.beginReadArray("CommonCountdowns");
    for (int i = 0; i < size; ++i){
        settings.setArrayIndex(i);
        int h = settings.value("hours").toInt();
        int m = settings.value("minutes").toInt();
        int s = settings.value("seconds").toInt();
        QString timeTitle = settings.value("timeTitle").toString();
        addNewTime(h, m, s, timeTitle);
    }
    settings.endArray();

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

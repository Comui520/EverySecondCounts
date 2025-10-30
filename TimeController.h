#ifndef TIMECONTROLLER_H
#define TIMECONTROLLER_H

#include <QObject>
#include <QAbstractListModel>
#include <QTime>
#include <QTimer>
#include <QMediaPlayer>
#include <QAudioOutput>

class TimeController : public QAbstractListModel
{
    Q_OBJECT
public:
    Q_PROPERTY(QTime* currentTime READ currentTime WRITE setCurrentTime NOTIFY currentTimeChanged FINAL)
    Q_PROPERTY(bool isCount READ isCount WRITE setIsCount NOTIFY isCountChanged FINAL)

    enum Role{
        TimeHoursRole = Qt::UserRole + 1,
        TimeMinutesRole,
        TimeSecondsRole,
    };
    explicit TimeController(QObject *parent = nullptr);
    virtual int rowCount(const QModelIndex &parent) const override;
    virtual QVariant data(const QModelIndex &index, int role) const override;
    virtual QHash<int, QByteArray> roleNames() const override;
    QTime *currentTime() const;
    void setCurrentTime(QTime *newCurrentTime);

    bool isCount() const;
    void setIsCount(bool newIsCount);

signals:
    void timeUp();
    void currentTimeChanged();
    void isCountChanged();

public slots:
    int showCurrentTimeH();
    int showCurrentTimeM();
    int showCurrentTimeS();
    void addNewTime(int h, int m, int s);
    void removeTime(const int index);
    void setCurrentTime(const int h, const int m, const int s);
    void start();
    void stop();
    void reset();
    void updateTime();
    void ring();
private:
    QList<QTime*> m_timeList;
    QTimer m_timer;
    QTime *m_currentTime = nullptr;
    QMediaPlayer* player = new QMediaPlayer;
    QAudioOutput* audioOutput = new QAudioOutput;
    bool m_isCount = false;
};

#endif // TIMECONTROLLER_H

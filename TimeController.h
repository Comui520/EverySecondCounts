#ifndef TIMECONTROLLER_H
#define TIMECONTROLLER_H

#include <QObject>
#include <QAbstractListModel>
#include <QTime>
#include <QTimer>

class TimeController : public QAbstractListModel
{
    Q_OBJECT
public:
    Q_PROPERTY(QTime* currentTime READ currentTime WRITE setCurrentTime NOTIFY currentTimeChanged FINAL)

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

signals:
    void timeShouldUpdate();
    void currentTimeChanged();

public slots:
    void addNewTime(int h, int m, int s);
    void setCurrentTime(int h, int m, int s);
    int showCurrentTimeH();
    int showCurrentTimeM();
    int showCurrentTimeS();
    void start();
    void stop();
    void updateTime();
private:
    QList<QTime*> m_timeList;
    QTimer m_timer;
    QTime *m_currentTime = nullptr;
};

#endif // TIMECONTROLLER_H

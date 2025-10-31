#ifndef MYTIME_H
#define MYTIME_H

#include <QObject>
#include <QTime>

class MyTime : public QObject
{
    Q_OBJECT
public:
    explicit MyTime(const int h = 0, const int m = 0, const int s = 0, QString title = "Countdown" ,QObject *parent = nullptr);
    Q_PROPERTY(QTime* time READ time WRITE setTime NOTIFY timeChanged FINAL)
    Q_PROPERTY(QString timeTitle READ timeTitle WRITE setTimeTitle NOTIFY timeTitleChanged FINAL)

    QTime *time() const;
    void setTime(QTime *newTime);

    QString timeTitle() const;
    void setTimeTitle(const QString &newTimeTitle);

signals:
    void timeChanged();
    void timeTitleChanged();

private:
    QTime *m_time = nullptr;
    QString m_timeTitle;
};

#endif // MYTIME_H

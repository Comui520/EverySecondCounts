#ifndef REDIRECTINFOPROVIDER_H
#define REDIRECTINFOPROVIDER_H

#include <QObject>
#include <QUrl>

class RedirectInfoProvider : public QObject
{
    Q_OBJECT
public:
    explicit RedirectInfoProvider(QObject *parent = nullptr);
    Q_PROPERTY(QUrl redirectSource READ redirectSource WRITE setRedirectSource NOTIFY redirectSourceChanged FINAL)
    Q_PROPERTY(QUrl iconSource READ iconSource WRITE setIconSource NOTIFY iconSourceChanged FINAL)
    Q_PROPERTY(QString functionName READ functionName WRITE setFunctionName NOTIFY functionNameChanged FINAL)

    QUrl redirectSource() const;
    void setRedirectSource(const QUrl &newRedirectSource);

    QUrl iconSource() const;
    void setIconSource(const QUrl &newIconSource);

    QString functionName() const;
    void setFunctionName(const QString &newFunctionName);

signals:
    void redirectSourceChanged();
    void iconSourceChanged();
    void functionNameChanged();

private:
    QUrl m_redirectSource;
    QUrl m_iconSource;
    QString m_functionName;
};

#endif // REDIRECTINFOPROVIDER_H

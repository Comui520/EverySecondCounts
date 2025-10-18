#ifndef MAINPAGEBUTTONCONTROLLER_H
#define MAINPAGEBUTTONCONTROLLER_H

#include "RedirectInfoProvider.h"

#include <QObject>
#include <QAbstractListModel>

class MainPageButtonController : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit MainPageButtonController(QObject *parent = nullptr);

    enum Role{
        ButtonFunctionNameRole = Qt::UserRole + 1,
        ButtonRedirectSourceRole,
        ButtonIconSourceRole,
    };
    virtual int rowCount(const QModelIndex &parent) const override;
    virtual QVariant data(const QModelIndex &index, int role) const override;
    virtual QHash<int, QByteArray> roleNames() const override;

signals:

public slots:
    void addNewButton(const QUrl& iconSource, const QUrl& redirectSource, const QString& functionName);

private:
    QList<RedirectInfoProvider*> m_buttonInfoList;
};

#endif // MAINPAGEBUTTONCONTROLLER_H

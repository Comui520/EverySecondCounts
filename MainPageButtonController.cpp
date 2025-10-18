#include "MainPageButtonController.h"
#include <QDebug>

MainPageButtonController::MainPageButtonController(QObject *parent)
    : QAbstractListModel{parent}
{
    addNewButton(
        QUrl("qrc:/qt/qml/EverySecondCounts/assets/icons/countdown_ico.png"),
        QUrl("qrc:/qt/qml/EverySecondCounts/CountDown.qml"),
        "倒计时"
    );
}

int MainPageButtonController::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_buttonInfoList.length();
}

QVariant MainPageButtonController::data(const QModelIndex &index, int role) const
{
    if (index.isValid() && index.row() >= 0 && index.row() < m_buttonInfoList.length()){
        RedirectInfoProvider* result = m_buttonInfoList[index.row()];
        switch ((Role) role) {
        case ButtonFunctionNameRole:
            return result->functionName();
        case ButtonRedirectSourceRole:
            return result->redirectSource();
        case ButtonIconSourceRole:
            return result->iconSource();
        }
    }
    return {};
}

QHash<int, QByteArray> MainPageButtonController::roleNames() const
{
    // ButtonFunctionNameRole = Qt::UserRole + 1,
    // ButtonRedirectSourceRole,
    // ButtonIconSourceRole,
    QHash<int, QByteArray> result;
    result[ButtonFunctionNameRole] = "buttonText";
    result[ButtonRedirectSourceRole] = "redirectSource";
    result[ButtonIconSourceRole] = "iconSource";
    return result;
}

void MainPageButtonController::addNewButton(const QUrl& iconSource, const QUrl& redirectSource, const QString& functionName)
{
    RedirectInfoProvider* newButton = new RedirectInfoProvider(this);
    beginInsertRows(QModelIndex(), m_buttonInfoList.length(), m_buttonInfoList.length());
    newButton->setRedirectSource(redirectSource);
    newButton->setIconSource(iconSource);
    newButton->setFunctionName(functionName);
    m_buttonInfoList << newButton;
    endInsertRows();
}

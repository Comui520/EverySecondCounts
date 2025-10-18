#include "RedirectInfoProvider.h"

RedirectInfoProvider::RedirectInfoProvider(QObject *parent)
    : QObject{parent}
{}

QUrl RedirectInfoProvider::redirectSource() const
{
    return m_redirectSource;
}

QString RedirectInfoProvider::functionName() const
{
    return m_functionName;
}

QUrl RedirectInfoProvider::iconSource() const
{
    return m_iconSource;
}

void RedirectInfoProvider::setIconSource(const QUrl &newIconSource)
{
    if (m_iconSource == newIconSource)
        return;
    m_iconSource = newIconSource;
    emit iconSourceChanged();
}

void RedirectInfoProvider::setRedirectSource(const QUrl &newRedirectSource)
{
    if (m_redirectSource == newRedirectSource)
        return;
    m_redirectSource = newRedirectSource;
    emit redirectSourceChanged();
}


void RedirectInfoProvider::setFunctionName(const QString &newFunctionName)
{
    if (m_functionName == newFunctionName)
        return;
    m_functionName = newFunctionName;
    emit functionNameChanged();
}

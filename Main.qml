import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Universal
import QtQuick.Layouts

ApplicationWindow {
  id: root

  visible: true
  width: 450
  height: 800
  Universal.theme: Theme.darkMode ? Universal.Dark : Universal.Light
  Universal.accent: Theme.accentColor
  Universal.foreground: Theme.textColor
  Universal.background: Theme.backgroundColor

  title: qsTr("EveryMinuteCounts")

  StackView {
    id: stackView
    anchors.fill: parent
    initialItem: MainPage {
      backVisibility: false
    }
  }
}

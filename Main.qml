import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Universal
import QtQuick.Layouts

ApplicationWindow {
  id: root

  visible: true
  width: 450
  height: 800
  Universal.theme: Universal.Light
  Universal.accent: "#4361EE"
  Universal.foreground: "#1E3A5F"
  Universal.background: "#F4F5F7"

  title: qsTr("EveryMinuteCounts")

  StackView {
    id: stackView
    anchors.fill: parent
    initialItem: MainPage {
      backVisibility: false
    }
  }
}

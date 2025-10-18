import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Universal
import QtQuick.Layouts

Page {
  id: root
  property string pageLabel: "逝者如斯夫"
  property bool backVisibility: true
  header: ToolBar {
    id: topbar
    height: 50
    RowLayout {
      id: toolRow
      anchors.fill: parent
      ToolButton {
        visible: root.backVisibility
        text: qsTr("<返回")
        font.pixelSize: 25
        onClicked: {
          stackView.pop()
        }
      }
    }

    Label {
      text: root.pageLabel
      font.pixelSize: 25
      elide: Label.ElideRight
      anchors.centerIn: toolRow
    }
  }
}

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Universal
import com.Comui520.MainPageButtonController 1.0

CommonPage {
  MainSection {
    ListView {
      id: listView
      anchors {
        fill: parent
        margins: 10
      }
      spacing: 10

      clip: true

      model: MainPageButtonController

      delegate: ImageButton {
        id: delegateid
        required property url iconSource
        required property url redirectSource
        required property string buttonText
        iconS: delegateid.iconSource
        text: delegateid.buttonText
        onClicked: {
          stackView.push(delegateid.redirectSource)
        }
      }
    }
  }
}

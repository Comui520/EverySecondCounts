import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Universal
import QtQuick.Layouts
import com.Comui520.TimeController

CommonPage {
  id: root
  pageLabel: "倒计时"
  MainSection {
    id: mainSection

    //展示时间区域
    Rectangle {
      id: displayTime

      anchors {
        top: parent.top
        left: parent.left
        right: parent.right
        margins: 5
      }

      color: "#F4F5F7"

      //160 + 100
      height: 260

      //滑动选择时间区域, 包裹三个滚轮
      Rectangle {
        id: rollingArea

        anchors {
          top: parent.top
          left: parent.left
          right: parent.right
          margins: 5
        }
        height: 160

        color: "#AAB6C4"

        RowLayout {
          anchors.fill: parent
          anchors.margins: 5
          spacing: 10

          RollingBlock {
            id: hours
            upper: 23
            lower: 0
          }

          Text {
            text: "H"
          }

          RollingBlock {
            id: minutes
            upper: 59
            lower: 0
          }

          Text {
            text: "M"
          }

          RollingBlock {
            id: seconds
            upper: 59
            lower: 0
          }

          Text {
            text: "S"
          }
        }
      }

      //控制
      Rectangle {
        id: controller

        property bool isPlaying: false
        signal secondChanged
        signal minuteChanged
        signal hourChanged

        anchors {
          top: rollingArea.bottom
          left: parent.left
          right: parent.right
          bottom: parent.bottom
          margins: 10
        }

        color: "#AAB6C4"

        RowLayout {
          anchors.fill: parent
          anchors.margins: 5
          ImageButton {
            id: startPauseButton

            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
            Layout.fillWidth: true

            iconSource: !controller.isPlaying ? "qrc:/qt/qml/EverySecondCounts/assets/icons/start_ico.png" : "qrc:/qt/qml/EverySecondCounts/assets/icons/pause_ico.png"

            onPressed: {
              controller.isPlaying = !controller.isPlaying
              if (controller.isPlaying) {
                TimeController.start()
                timer.running = true
              } else {
                TimeController.stop()
                timer.running = false
              }
            }
          }

          ImageButton {
            id: cancel
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
            iconSource: "qrc:/qt/qml/EverySecondCounts/assets/icons/cancel_ico.png"
            onPressed: {
              controller.isPlaying = false
              controller.reset()
            }
          }
        }

        Timer {
          id: timer

          interval: 250
          repeat: true
          onTriggered: {
            if (seconds.currentTime !== TimeController.showCurrentTimeS()) {
              controller.secondChanged()
            }
            if (minutes.currentTime !== TimeController.showCurrentTimeM()) {
              controller.minuteChanged()
            }
            if (hours.currentTime !== TimeController.showCurrentTimeH())
              controller.hourChanged()
          }
        }

        onSecondChanged: {
          seconds.changeY(40, false)
          seconds.currentTime = TimeController.showCurrentTimeS()
          seconds.changeY(0, true)
        }

        onMinuteChanged: {
          minutes.changeY(40, false)
          minutes.currentTime = TimeController.showCurrentTimeM()
          minutes.changeY(0, true)
        }

        onHourChanged: {
          hours.changeY(40, false)
          hours.currentTime = TimeController.showCurrentTimeH()
          hours.changeY(0, true)
        }
        function reset() {
          hours.currentTime = 0
          minutes.currentTime = 0
          seconds.currentTime = 0
          totalTime = 0
        }
      }
    }
  }
}

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
          anchors.leftMargin: 5
          anchors.rightMargin: 5
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

        anchors {
          top: rollingArea.bottom
          left: parent.left
          right: parent.right
          bottom: parent.bottom
          margins: 5
          topMargin: 10
        }

        color: "#AAB6C4"

        RowLayout {
          anchors.fill: parent
          ImageButton {
            id: startPauseButton

            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 70
            Layout.preferredWidth: 70

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
            Layout.preferredHeight: 70
            Layout.preferredWidth: 70
            iconSource: "qrc:/qt/qml/EverySecondCounts/assets/icons/cancel_ico.png"
            onPressed: {
              controller.isPlaying = false
              controller.reset()
            }
          }
        }

        Timer {
          id: timer
          interval: 1000
          repeat: true
          running: false
          onTriggered: {
            hours.currentTime = TimeController.showCurrentTimeH()
            minutes.currentTime = TimeController.showCurrentTimeM()
            seconds.currentTime = TimeController.showCurrentTimeS()
          }
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

  component RollingBlock: Rectangle {
    id: rollingBlock
    Layout.fillWidth: true
    Layout.preferredHeight: 150
    color: "#F4F5F7"

    required property int upper
    required property int lower
    property int currentTime: lower
    property bool canRolling: !controller.isPlaying

    property real startY: 0
    property real currentOffset: 0
    property bool isDragging: false

    ColumnLayout {
      id: layout
      anchors.centerIn: parent
      spacing: 5

      Rectangle {
        id: up
        Layout.fillHeight: true
        Layout.preferredHeight: 40
        Text {
          anchors.centerIn: parent

          font {
            pixelSize: 20
          }

          text: (rollingBlock.currentTime + 1
                 > rollingBlock.upper ? lower : rollingBlock.currentTime + 1).toString()
        }
      }

      Rectangle {
        id: current
        Layout.fillHeight: true
        Layout.preferredHeight: 40

        Text {
          anchors.centerIn: parent

          font {
            pixelSize: 25
            bold: true
          }

          text: rollingBlock.currentTime.toString()
        }
      }

      Rectangle {
        id: down
        Layout.fillHeight: true
        Layout.preferredHeight: 40

        Text {
          anchors.centerIn: parent

          font {
            pixelSize: 20
          }

          text: (rollingBlock.currentTime - 1
                 < rollingBlock.lower ? upper : rollingBlock.currentTime - 1).toString()
        }
      }
    }

    MouseArea {
      id: mouse
      anchors.fill: parent
      enabled: !controller.isPlaying
      onPressed: {
        rollingBlock.startY = mouseY
        rollingBlock.currentOffset = 0 // 重置偏移
      }
      onMouseYChanged: {
        const delta = mouseY - rollingBlock.startY
        let steps = (delta > 0) ? Math.floor(delta / 40) : Math.ceil(delta / 40)
        let newTime = rollingBlock.currentTime + steps
        if (newTime < rollingBlock.lower) {
          newTime = rollingBlock.upper
        }
        if (newTime > rollingBlock.upper) {
          newTime = rollingBlock.lower
        }

        if (steps >= 1 || steps <= -1) {
          rollingBlock.currentTime = newTime
          rollingBlock.startY = mouseY
        }
      }

      onReleased: {
        //当松开时, 更新时间
        TimeController.setCurrentTime(hours.currentTime, minutes.currentTime,
                                      seconds.currentTime)
      }
    }
  }
}

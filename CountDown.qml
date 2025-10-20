import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Universal
import QtQuick.Layouts

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

      //滑动选择时间区域
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
            upper: 24
            lower: 0
          }

          RollingBlock {
            upper: 60
            lower: 0
          }

          RollingBlock {
            upper: 60
            lower: 0
          }
        }
      }

      //控制
      Rectangle {
        id: controller

        anchors {
          top: rollingArea.bottom
          left: parent.left
          right: parent.right
          bottom: parent.bottom
          margins: 5
          topMargin: 10
        }

        color: "#AAB6C4"
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
    }
  }
}

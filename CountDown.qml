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
            id: rollingHours
            upper: 23
            lower: 0
          }

          Text {
            text: "H"
          }

          RollingBlock {
            id: rollingMinutes
            upper: 59
            lower: 0
          }

          Text {
            text: "M"
          }

          RollingBlock {
            id: rollingSeconds
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

            iconS: !TimeController.isCount ? "qrc:/qt/qml/EverySecondCounts/assets/icons/start_ico.png" : "qrc:/qt/qml/EverySecondCounts/assets/icons/pause_ico.png"

            onPressed: {
              if (!TimeController.isCount) {
                //当按下按钮时, 更新时间
                TimeController.setCurrentTime(rollingHours.currentTime,
                                              rollingMinutes.currentTime,
                                              rollingSeconds.currentTime)
                if (!(TimeController.showCurrentTimeS() !== 0
                      || TimeController.showCurrentTimeM() !== 0
                      || TimeController.showCurrentTimeH() !== 0)) {
                  return
                }
                TimeController.start()
              } else {
                TimeController.stop()
              }
            }
          }

          ImageButton {
            id: cancel
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
            iconS: "qrc:/qt/qml/EverySecondCounts/assets/icons/cancel_ico.png"
            onPressed: {
              controller.reset()
            }
          }

          ImageButton {
            id: addCommonCountdown
            opacity: (rollingHours.currentTime !== 0
                      || rollingMinutes.currentTime !== 0
                      || rollingSeconds.currentTime !== 0)
                     && !TimeController.isCount ? 1 : 0
            visible: opacity > 0 // 优化性能，完全透明时不响应鼠标
            scale: opacity

            Layout.fillHeight: true
            Layout.fillWidth: true
            iconS: "qrc:/qt/qml/EverySecondCounts/assets/icons/addCommonCountdown_ico.png"
            onPressed: {
              TimeController.addNewTime(rollingHours.currentTime,
                                        rollingMinutes.currentTime,
                                        rollingSeconds.currentTime)
            }
            Behavior on opacity {
              PropertyAnimation {
                duration: 300
                easing.type: Easing.InOutQuad
              }
            }
          }
        }

        Timer {
          id: timer

          interval: 250
          repeat: true

          running: TimeController.isCount
          onTriggered: {
            if (rollingSeconds.currentTime !== TimeController.showCurrentTimeS(
                  )) {
              controller.secondChanged()
            }
            if (rollingMinutes.currentTime !== TimeController.showCurrentTimeM(
                  )) {
              controller.minuteChanged()
            }
            if (rollingHours.currentTime !== TimeController.showCurrentTimeH())
              controller.hourChanged()
          }
        }

        onSecondChanged: {
          rollingSeconds.changeY(40, false)
          rollingSeconds.currentTime = TimeController.showCurrentTimeS()
          rollingSeconds.changeY(0, true)
        }

        onMinuteChanged: {
          rollingMinutes.changeY(40, false)
          rollingMinutes.currentTime = TimeController.showCurrentTimeM()
          rollingMinutes.changeY(0, true)
        }

        onHourChanged: {
          rollingHours.changeY(40, false)
          rollingHours.currentTime = TimeController.showCurrentTimeH()
          rollingHours.changeY(0, true)
        }
        function reset() {
          rollingHours.currentTime = 0
          rollingMinutes.currentTime = 0
          rollingSeconds.currentTime = 0
          TimeController.setCurrentTime(0, 0, 0)
          TimeController.reset()
        }
      }
    }

    Rectangle {
      id: commonCountdown
      anchors {
        top: displayTime.bottom
        bottom: parent.bottom
        left: parent.left
        right: parent.right
        margins: 6
      }

      color: "#F4F5F7"

      Text {
        id: commoncountdown
        anchors {
          top: parent.top
          horizontalCenter: parent.horizontalCenter
        }

        text: "常用倒计时"
        font.pixelSize: 20
      }

      Rectangle {
        anchors {
          top: commoncountdown.bottom
          left: parent.left
          right: parent.right
          bottom: parent.bottom
          margins: 5
        }
        color: "#AAB6C4"

        ListView {
          anchors {
            fill: parent
            margins: 5
          }
          spacing: 10

          model: TimeController

          clip: true

          delegate: Rectangle {
            id: delegate
            required property int hours
            required property int minutes
            required property int seconds
            required property int index

            color: "#F4F5F7"

            border.color: "white"
            border.width: 1

            height: 40
            anchors {
              left: parent.left
              right: parent.right
              margins: 5
            }

            RowLayout {
              id: layout
              anchors.fill: parent
              spacing: 5

              Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                ImageButton {
                  anchors.fill: parent
                  iconS: "qrc:/qt/qml/EverySecondCounts/assets/icons/delete_ico.png"
                  onPressed: {
                    TimeController.removeTime(delegate.index)
                  }
                }
              }

              Rectangle {
                id: h
                Layout.fillHeight: true
                Layout.fillWidth: true
                Text {
                  anchors.centerIn: parent
                  text: delegate.hours
                  font.pixelSize: 20
                }
              }

              Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Text {
                  anchors.centerIn: parent
                  font.pixelSize: 20
                  text: "H"
                }
              }

              Rectangle {
                id: m
                Layout.fillHeight: true
                Layout.fillWidth: true
                Text {
                  anchors.centerIn: parent
                  text: delegate.minutes
                  font.pixelSize: 20
                }
              }

              Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Text {
                  anchors.centerIn: parent
                  font.pixelSize: 20
                  text: "M"
                }
              }

              Rectangle {
                id: s
                Layout.fillHeight: true
                Layout.fillWidth: true
                Text {
                  anchors.centerIn: parent
                  text: delegate.seconds
                  font.pixelSize: 20
                }
              }

              Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Text {
                  anchors.centerIn: parent
                  font.pixelSize: 20
                  text: "S"
                }
              }

              Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                ImageButton {
                  anchors.fill: parent
                  iconS: "qrc:/qt/qml/EverySecondCounts/assets/icons/confirm_ico.png"
                  onPressed: {
                    rollingHours.currentTime = delegate.hours
                    rollingMinutes.currentTime = delegate.minutes
                    rollingSeconds.currentTime = delegate.seconds
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

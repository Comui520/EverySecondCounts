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
        margins: Theme.marginPixel
      }

      color: Theme.backgroundColor

      //160 + 100
      height: 260

      //滑动选择时间区域, 包裹三个滚轮
      Rectangle {
        id: rollingArea

        anchors {
          top: parent.top
          left: parent.left
          right: parent.right
          margins: Theme.marginPixel
        }
        height: 160

        color: Theme.secondaryBackground

        RowLayout {
          anchors.fill: parent
          anchors.margins: Theme.marginPixel
          spacing: Theme.itemSpace

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
          margins: Theme.marginPixel
        }

        color: Theme.secondaryBackground

        RowLayout {
          anchors.fill: parent
          anchors.margins: 5

          ImageButton {
            id: startPauseButton

            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
            Layout.fillWidth: true

            iconS: !TimeController.isCount ? Theme.assetsPath
                                             + "icons/start_ico.png" : Theme.assetsPath
                                             + "icons/pause_ico.png"

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
            iconS: Theme.assetsPath + "icons/cancel_ico.png"
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
            iconS: Theme.assetsPath + "icons/addCommonCountdown_ico.png"
            onPressed: {
              // TimeController.addNewTime(rollingHours.currentTime,
              //                           rollingMinutes.currentTime,
              //                           rollingSeconds.currentTime)
              nameDialog.open()
            }
            Behavior on opacity {
              PropertyAnimation {
                duration: 300
                easing.type: Easing.InOutQuad
              }
            }
          }

          Dialog {
            id: nameDialog

            property string enteredName: "Countdown"

            title: "命名常用倒计时"
            modal: true
            standardButtons: Dialog.Ok | Dialog.Cancel | Dialog.exit
            anchors.centerIn: parent
            visible: false

            width: 400
            height: 272

            contentItem: Rectangle {
              anchors.fill: parent
              anchors.margins: Theme.marginPixel
              color: Theme.secondaryBackground

              TextField {
                id: nameInput
                placeholderText: "请输入标题"
                text: nameDialog.enteredName
                color: Theme.textColor
                font {
                  pixelSize: Theme.titleSize
                  family: Theme.fontFamily
                }
                height: 60
                anchors {
                  left: parent.left
                  right: parent.right
                  bottom: parent.verticalCenter
                  margins: Theme.marginPixel
                }

                onTextChanged: nameDialog.enteredName = text
              }

              Rectangle {
                height: 20
                anchors {
                  top: nameInput.bottom
                  left: parent.left
                  right: parent.right
                  margins: Theme.marginPixel
                }
                color: Theme.secondaryBackground
                Text {
                  text: "例如：午休、学习间隔、泡面时间..."
                  color: Theme.textColor
                  font {
                    pixelSize: Theme.smallTextSize
                    family: Theme.fontFamily
                  }
                  anchors.centerIn: parent
                }
              }
            }

            onAccepted: {
              // 如果用户没有输入标题，就使用默认名称
              var title = nameDialog.enteredName.length > 0 ? nameDialog.enteredName : "Countdown"
              TimeController.addNewTime(rollingHours.currentTime,
                                        rollingMinutes.currentTime,
                                        rollingSeconds.currentTime, title)
              nameDialog.enteredName = ""
            }

            onRejected: {
              nameDialog.enteredName = ""
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
        margins: Theme.marginPixel
      }

      color: Theme.backgroundColor

      Text {
        id: commoncountdown
        anchors {
          top: parent.top
          horizontalCenter: parent.horizontalCenter
        }

        text: "常用倒计时"
        font {
          pixelSize: Theme.textSize
          family: Theme.fontFamily
        }
      }

      Rectangle {
        anchors {
          top: commoncountdown.bottom
          left: parent.left
          right: parent.right
          bottom: parent.bottom
          margins: Theme.marginPixel
        }
        color: Theme.secondaryBackground

        ListView {
          anchors {
            fill: parent
            margins: Theme.marginPixel
          }
          spacing: Theme.itemSpace

          model: TimeController

          clip: true

          delegate: Rectangle {
            id: delegate
            required property int hours
            required property int minutes
            required property int seconds
            required property string timeTitle
            required property int index

            color: Theme.backgroundColor

            border.color: "white"
            border.width: 1

            height: 70
            anchors {
              left: parent.left
              right: parent.right
            }

            Rectangle {
              id: timeName
              color: Theme.secondaryBackground
              anchors {
                top: parent.top
                left: parent.left
                right: parent.right
              }

              height: 30

              Text {
                elide: Text.ElideRight
                clip: true
                width: 272
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                font {
                  pixelSize: Theme.textSize
                  family: Theme.fontFamily
                }
                color: Theme.textColor
                text: delegate.timeTitle
              }
            }

            RowLayout {
              id: layout
              anchors {
                top: timeName.bottom
                left: timeName.left
                right: timeName.right
                bottom: parent.bottom
              }

              spacing: Theme.itemSpace

              Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                ImageButton {
                  anchors.fill: parent
                  iconS: Theme.assetsPath + "icons/delete_ico.png"
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
                  font {
                    pixelSize: Theme.textSize
                    family: Theme.fontFamily
                  }
                }
              }

              Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Text {
                  anchors.centerIn: parent
                  font {
                    pixelSize: Theme.textSize
                    family: Theme.fontFamily
                  }
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
                  font {
                    pixelSize: Theme.textSize
                    family: Theme.fontFamily
                  }
                }
              }

              Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Text {
                  anchors.centerIn: parent
                  font {
                    pixelSize: Theme.textSize
                    family: Theme.fontFamily
                  }
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
                  font {
                    pixelSize: Theme.textSize
                    family: Theme.fontFamily
                  }
                }
              }

              Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Text {
                  anchors.centerIn: parent
                  font {
                    pixelSize: Theme.textSize
                    family: Theme.fontFamily
                  }
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
  onClosed: {
    TimeController.reset()
    controller.reset()
  }
}

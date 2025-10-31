import QtQuick
import QtQuick.Layouts
import com.Comui520.TimeController

Rectangle {
  id: rollingBlock

  required property int upper
  required property int lower
  property int currentTime: lower
  property bool canRolling: !controller.isPlaying

  property real startY: 0
  property bool isDragging: false
  property bool enableAnimate: false

  property int rollingCenterY: 48

  Layout.fillWidth: true
  Layout.fillHeight: true

  Rectangle {
    id: wrap

    color: "#F4F5F7"

    anchors.fill: parent
    anchors.margins: Theme.marginPixel

    clip: true

    component RollingItem: Rectangle {
      id: item
      required property bool isCenter
      property alias time: timeText.text
      anchors.horizontalCenter: wrap.horizontalCenter
      height: 30
      Text {
        id: timeText
        anchors.horizontalCenter: parent.horizontalCenter

        font {
          pixelSize: Theme.textSize
          family: Theme.fontFamily
          bold: true
        }
        color: item.isCenter ? "red" : "black"
      }

      Behavior on y {
        enabled: rollingBlock.enableAnimate
        PropertyAnimation {
          duration: 200
          easing.type: Easing.InOutQuad
        }
      }
    }
    RollingItem {
      id: uup
      y: rollingBlock.rollingCenterY - 40 * 2
      isCenter: false
      time: (rollingBlock.currentTime + 2
             > rollingBlock.upper ? lower + (rollingBlock.currentTime - rollingBlock.upper
                                             + 1) : rollingBlock.currentTime + 2).toString()
    }

    RollingItem {
      id: up
      y: rollingBlock.rollingCenterY - 40
      isCenter: false
      time: (rollingBlock.currentTime + 1
             > rollingBlock.upper ? lower : rollingBlock.currentTime + 1).toString()
    }

    RollingItem {
      id: current
      y: rollingBlock.rollingCenterY
      isCenter: true
      time: rollingBlock.currentTime.toString()
    }

    RollingItem {
      id: down
      y: rollingBlock.rollingCenterY + 40
      isCenter: false
      time: (rollingBlock.currentTime - 1
             < rollingBlock.lower ? upper : rollingBlock.currentTime - 1).toString()
    }

    RollingItem {
      id: ddown
      y: rollingBlock.rollingCenterY + 40 * 2
      isCenter: false
      time: (rollingBlock.currentTime - 2
             < rollingBlock.lower ? upper - (rollingBlock.lower + 1
                                             - rollingBlock.currentTime) : rollingBlock.currentTime
                                    - 2).toString()
    }
  }

  MouseArea {
    //核心的计算
    id: mouseArea

    property real currentY: rollingBlock.rollingCenterY
    property real uupY: 0
    property real upY: 0
    property real downY: 0
    property real ddownY: 0

    anchors.fill: parent
    enabled: !TimeController.isCount
    onPressed: {
      rollingBlock.startY = mouseY
    }
    onMouseYChanged: {
      const delta = mouseY - rollingBlock.startY
      let steps = (delta > 0) ? Math.floor(delta / 35) : Math.ceil(delta / 35)
      let newTime = rollingBlock.currentTime + steps
      if (newTime < rollingBlock.lower) {
        newTime = rollingBlock.upper
      }
      if (newTime > rollingBlock.upper) {
        newTime = rollingBlock.lower
      }
      //开始配合动画
      changeY(delta, false)
      if (steps >= 1 || steps <= -1) {
        rollingBlock.currentTime = newTime
        changeY(0, false)
        rollingBlock.startY = mouseY
      }
    }

    onReleased: {
      rollingBlock.startY = mouseY
      changeY(0, true)
    }
  }

  function changeY(delta, enable) {
    rollingBlock.enableAnimate = enable
    uup.y = mouseArea.uupY + delta
    up.y = mouseArea.upY + delta
    current.y = mouseArea.currentY + delta
    down.y = mouseArea.downY + delta
    ddown.y = mouseArea.ddownY + delta
  }

  Component.onCompleted: {
    mouseArea.uupY = mouseArea.currentY - 40 * 2
    mouseArea.upY = mouseArea.currentY - 40
    mouseArea.downY = mouseArea.currentY + 40
    mouseArea.ddownY = mouseArea.currentY + 40 * 2
    changeY(1, false)
    changeY(0, true)
  }
}

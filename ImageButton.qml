import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Button {
  id: root

  hoverEnabled: true

  property url iconS
  //正方形
  property int size: 150

  icon.source: root.iconS

  width: Math.max(parent.width, size)
  height: size

  icon.width: root.width * 0.7
  icon.height: root.height * 0.7

  display: AbstractButton.TextUnderIcon

  font {
    pixelSize: 20
  }
}

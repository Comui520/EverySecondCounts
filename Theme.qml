import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Universal
pragma Singleton

QtObject {
  id: theme

  // ===== 基础主题配置 =====
  property bool darkMode: false

  // ===== 色彩系统 =====
  // 主色调（Accent）
  property color accentColor: darkMode ? "#4361EE" : "#4361EE"
  // 背景色
  property color backgroundColor: darkMode ? "#1E1E1E" : "#F4F5F7"
  // 二级背景
  property color secondaryBackground: darkMode ? "#2A2A2A" : "#AAB6C4"
  // 文字颜色
  property color textColor: darkMode ? "#E0E0E0" : "#1E3A5F"
  // 警示色
  property color warningColor: "#FF6B6B"
  // 成功色
  property color successColor: "#4CAF50"

  // ===== 字体系统 =====
  property string fontFamily: "Microsoft YaHei"
  property int titleSize: 24
  property int textSize: 20
  property int smallTextSize: 14

  //布局
  property int itemSpace: 5
  property int marginPixel: 10

  //url路径
  property string appName: "EverySecondCounts"
  property string assetsPath: "qrc:/qt/qml/" + appName + "/assets/"

  // ===== 全局函数（切换主题） =====
  function toggleMode() {
    darkMode = !darkMode
  }
}

import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Commons as Commons
import qs.Ui

BarIconButton {
  id: root
  property bool panelOpen: false
  readonly property bool expanded: panelOpen
  readonly property bool revealInactiveIndicators: true
  readonly property var controls: [
    { name: "NightLight", label: "Night Light" },
    { name: "Dnd", label: "Do Not Disturb" },
    { name: "StayAwake", label: "Stay Awake" },
    { name: "ScreenRecording", label: "Screen Recording" },
    { name: "Dictation", label: "Dictation" },
    { name: "Reminder", label: "Reminders" }
  ]
  signal refreshRequested()

  text: "\uf1de"
  tooltipText: "Controls"
  onPressed: function(button) {
    if (button === Qt.LeftButton) panelOpen = !panelOpen
  }
  function close() { panelOpen = false }

  PopupCard {
    id: panel
    anchorItem: root
    owner: root
    bar: root.bar
    open: root.panelOpen
    contentWidth: panel.fittedContentWidth(Style.space(270))
    contentHeight: panel.fittedContentHeight(panelColumn.implicitHeight)

    Column {
      id: panelColumn
      anchors.fill: parent
      spacing: Style.space(4)

      Text {
        text: "Controls"
        color: root.bar ? root.bar.foreground : Commons.Color.foreground
        font.family: root.bar ? root.bar.fontFamily : Style.font.family
        font.pixelSize: Style.font.body
        font.bold: true
        bottomPadding: Style.space(5)
      }

      Repeater {
        model: root.controls
        delegate: Item {
          id: row
          required property var modelData
          width: panelColumn.width
          height: Style.space(36)

          Rectangle {
            anchors.fill: parent
            radius: Style.cornerRadius
            color: hit.containsMouse
              ? Style.hoverFillFor(root.bar ? root.bar.foreground : Commons.Color.foreground,
                                   root.bar ? root.bar.foreground : Commons.Color.foreground)
              : "transparent"
          }

          TrayIndicator {
            id: control
            indicatorName: row.modelData.name
            bar: root.bar
            indicatorHost: root
            anchors.verticalCenter: parent.verticalCenter
          }

          Text {
            anchors.left: control.right
            anchors.leftMargin: Style.space(10)
            anchors.verticalCenter: parent.verticalCenter
            text: row.modelData.label
            color: root.bar ? root.bar.foreground : Commons.Color.foreground
            font.family: root.bar ? root.bar.fontFamily : Style.font.family
            font.pixelSize: Style.font.bodySmall
          }

          MouseArea {
            id: hit
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: control.activate()
          }
        }
      }
    }
  }
}

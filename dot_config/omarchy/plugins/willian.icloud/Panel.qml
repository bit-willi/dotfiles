import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Commons as Commons
import qs.Ui

Panel {
  id: root
  moduleName: "willian.icloud"
  manageIpc: false

  property var anchorItem: null
  property var hostWidget: null
  readonly property var barIdentity: hostWidget || root
  readonly property color foreground: bar ? bar.foreground : Commons.Color.foreground
  readonly property color urgent: bar ? bar.urgent : Commons.Color.urgent
  readonly property string fontFamily: bar ? bar.fontFamily : Style.font.family
  readonly property string driveStatus: hostWidget ? hostWidget.driveStatus : "checking"
  readonly property string photosStatus: hostWidget ? hostWidget.photosStatus : "checking"
  readonly property string googleStatus: hostWidget ? hostWidget.googleStatus : "checking"
  readonly property bool healthy: hostWidget && hostWidget.healthy
  readonly property bool webApprovalNeeded: hostWidget && hostWidget.webApprovalNeeded

  function open() {
    root.controller.show()
    if (hostWidget) hostWidget.check()
  }

  function close() { root.controller.hide() }
  function toggle() { root.opened ? root.close() : root.open() }

  function switchPanel(direction) {
    if (bar && typeof bar.switchPanelFrom === "function")
      return bar.switchPanelFrom(barIdentity, direction)
    return false
  }

  KeyboardPanel {
    id: panel
    anchorItem: root.anchorItem
    owner: root.barIdentity
    bar: root.bar
    open: root.opened
    centerOnBar: false
    focusTarget: keyCatcher
    contentWidth: panel.fittedContentWidth(Style.space(390))
    contentHeight: panel.fittedContentHeight(content.implicitHeight)

    PanelKeyCatcher {
      id: keyCatcher
      anchors.fill: parent
      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.switchPanel(direction) }

      Column {
        id: content
        width: parent.width
        spacing: Style.space(14)

        PanelHero {
          title: "Cloud"
          meta: "iCloud and Google Drive"
          detail: root.healthy ? "ONLINE" : "ATTENTION"
          foreground: root.foreground
          fontFamily: root.fontFamily
          iconComponent: Component {
            Text {
              text: "☁"
              color: root.foreground
              font.family: root.fontFamily
              font.pixelSize: Style.font.display
            }
          }
        }

        PanelSeparator { foreground: root.foreground }

        PanelSectionHeader {
          text: "ICLOUD"
          foreground: root.foreground
          fontFamily: root.fontFamily
        }

        CloudStatusRow { label: "Drive"; status: root.driveStatus }
        CloudStatusRow { label: "Photos"; status: root.photosStatus }

        PanelSeparator { foreground: root.foreground }

        PanelSectionHeader {
          text: "GOOGLE"
          foreground: root.foreground
          fontFamily: root.fontFamily
        }

        CloudStatusRow { label: "Drive"; status: root.googleStatus }

        Text {
          visible: root.webApprovalNeeded
          width: parent.width
          wrapMode: Text.WordWrap
          text: "Approve iCloud web access on your trusted device, then reconnect."
          color: root.urgent
          font.family: root.fontFamily
          font.pixelSize: Style.font.bodySmall
        }

        PanelSeparator { foreground: root.foreground }

        RowLayout {
          width: parent.width
          spacing: Style.space(6)

          Button {
            text: "Reconnect iCloud"
            foreground: root.foreground
            fontFamily: root.fontFamily
            Layout.fillWidth: true
            onClicked: if (root.hostWidget) root.hostWidget.reconnect()
          }
          Button {
            text: "Save login"
            foreground: root.foreground
            fontFamily: root.fontFamily
            tooltipText: "Save the current iCloud session to Bitwarden"
            onClicked: if (root.hostWidget) root.hostWidget.saveLogin()
          }
          PanelActionButton {
            iconText: "\uf021"
            foreground: root.foreground
            fontFamily: root.fontFamily
            tooltipText: "Refresh all cloud statuses"
            onClicked: if (root.hostWidget) root.hostWidget.check()
          }
        }
      }
    }
  }

  component CloudStatusRow: RowLayout {
    property string label: ""
    property string status: "checking"
    width: parent ? parent.width : 0
    spacing: Style.space(8)

    Rectangle {
      width: Style.space(7)
      height: width
      radius: width / 2
      color: status === "online" ? Commons.Color.accent : root.urgent
      Layout.alignment: Qt.AlignVCenter
    }
    Text {
      text: label
      color: root.foreground
      font.family: root.fontFamily
      font.pixelSize: Style.font.body
      Layout.fillWidth: true
    }
    Text {
      text: status
      color: status === "online" ? Qt.darker(root.foreground, 1.4) : root.urgent
      font.family: root.fontFamily
      font.pixelSize: Style.font.body
    }
  }
}

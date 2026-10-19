import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "willian.icloud"

  property string driveStatus: "checking"
  property string photosStatus: "checking"
  property string googleStatus: "checking"
  readonly property string pluginPath: Quickshell.env("HOME") + "/.config/omarchy/plugins/willian.icloud"
  readonly property bool healthy: driveStatus === "online" && photosStatus === "online" && googleStatus === "online"
  readonly property bool webApprovalNeeded: driveStatus === "web approval needed" || photosStatus === "web approval needed"
  readonly property bool opened: panelLoader.item ? panelLoader.item.opened === true : false
  readonly property bool popoutSwitchClosing: panelLoader.item ? panelLoader.item.popoutSwitchClosing === true : false

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  function check() {
    if (statusProcess.running) return
    statusProcess.running = true
  }

  function reconnect() {
    Quickshell.execDetached(["omarchy", "launch", "terminal", root.pluginPath + "/reconnect.sh"])
  }

  function saveLogin() {
    Quickshell.execDetached(["omarchy", "launch", "terminal", root.pluginPath + "/reconnect.sh", "--save-only"])
  }

  function injectPanel() {
    var panel = panelLoader.item
    if (!panel) return
    panel.bar = root.bar
    panel.settings = root.settings
    panel.anchorItem = button
    panel.hostWidget = root
  }

  function open() { if (panelLoader.item) panelLoader.item.open() }
  function close() { if (panelLoader.item) panelLoader.item.close() }
  function togglePanel() { if (panelLoader.item) panelLoader.item.toggle() }
  function closeForPopoutSwitch() {
    if (panelLoader.item) panelLoader.item.closeForPopoutSwitch()
  }

  onBarChanged: injectPanel()
  onSettingsChanged: injectPanel()

  Loader {
    id: panelLoader
    active: true
    source: Qt.resolvedUrl("Panel.qml")
    visible: false
    onLoaded: {
      root.injectPanel()
      Qt.callLater(root.injectPanel)
    }
  }

  Timer {
    interval: 60000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.check()
  }

  Timer {
    interval: 10000
    running: root.opened
    repeat: true
    onTriggered: root.check()
  }

  Process {
    id: statusProcess
    command: [root.pluginPath + "/status.sh"]
    running: false
    stdout: StdioCollector { id: statusOutput; waitForEnd: true }
    onExited: function(exitCode) {
      if (exitCode !== 0) {
        root.driveStatus = "check failed"
        root.photosStatus = "check failed"
        root.googleStatus = "check failed"
        return
      }
      var lines = String(statusOutput.text || "").trim().split("\n")
      for (var i = 0; i < lines.length; i++) {
        var parts = lines[i].split("=")
        if (parts[0] === "drive") root.driveStatus = parts[1] || "unknown"
        if (parts[0] === "photos") root.photosStatus = parts[1] || "unknown"
        if (parts[0] === "google") root.googleStatus = parts[1] || "unknown"
      }
    }
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "☁"
    active: !root.healthy
    dimmed: root.driveStatus === "checking" || root.photosStatus === "checking" || root.googleStatus === "checking"
    tooltipText: "Cloud"
    onPressed: function(mouseButton) {
      if (mouseButton === Qt.RightButton) root.check()
      else if (mouseButton === Qt.MiddleButton) root.saveLogin()
      else root.togglePanel()
    }
  }
}

import QtQuick
import Quickshell.Io
import qs.Commons

// Stock indicator visuals with actions that work in a cloned tray plugin.
Item {
  id: root

  required property string indicatorName
  property var bar: null
  property var indicatorHost: null
  property bool on: false
  readonly property bool tooltipHovered: visible && opacity > 0 && mouseArea.containsMouse

  width: Style.bar.statusSlot
  height: indicatorHost ? indicatorHost.barSize : Style.bar.sizeHorizontal

  function tooltip() {
    var text = indicator.item ? String(indicator.item.tooltipText || "").trim() : ""
    if (text) return text
    if (indicatorName === "Reminder") return "Reminders"
    return indicatorName
  }

  function refresh() {
    if (indicatorName === "NightLight" || indicatorName === "Dnd" || indicatorName === "StayAwake") {
      if (!statusProbe.running) statusProbe.running = true
    }
  }

  function activate() {
    if (!bar) return
    switch (indicatorName) {
    case "ScreenRecording":
      if (!recordingProbe.running) recordingProbe.running = true
      break
    case "Reminder":
      bar.run(indicator.item && indicator.item.reminderCount > 0 ? "omarchy-reminder show" : "omarchy-reminder -i")
      break
    case "NightLight":
      bar.run("omarchy toggle nightlight")
      break
    case "Dnd":
      bar.run("omarchy toggle notification silencing")
      break
    case "StayAwake":
      bar.run("omarchy toggle idle")
      break
    }
    refreshAfterClick.restart()
  }

  Rectangle {
    anchors.fill: parent
    radius: Math.max(2, Style.cornerRadius)
    color: mouseArea.containsMouse
      ? Style.hoverFillFor(bar ? bar.barForeground : "white", bar ? bar.barForeground : "white")
      : "transparent"
  }

  Loader {
    id: indicator
    anchors.fill: parent
    source: "file:///usr/share/omarchy/shell/plugins/bar/indicators/" + root.indicatorName + ".qml"
    onLoaded: {
      item.bar = root.bar
      item.indicatorHost = root.indicatorHost
      item.interactive = false
      if (root.indicatorName === "NightLight" || root.indicatorName === "Dnd" || root.indicatorName === "StayAwake")
        item.activeOverride = Qt.binding(function() { return root.on })
    }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onEntered: {
      root.refresh()
      if (root.bar) root.bar.showTooltip(root, root.tooltip())
    }
    onExited: if (root.bar) root.bar.hideTooltip(root)
    onClicked: root.activate()
  }

  Process {
    id: statusProbe
    command: root.indicatorName === "NightLight"
      ? ["omarchy", "toggle", "nightlight", "--status"]
      : root.indicatorName === "Dnd"
        ? ["omarchy-shell", "notifications", "isDnd"]
        : ["omarchy", "toggle", "idle", "status"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        if (root.indicatorName === "Dnd") root.on = text.trim() === "on"
        else {
          try { root.on = JSON.parse(text).enabled === true } catch (error) {}
        }
      }
    }
  }

  Process {
    id: recordingProbe
    command: ["pgrep", "--quiet", "-f", "^gpu-screen-recorder"]
    onExited: function(exitCode) {
      if (root.bar) root.bar.run(exitCode === 0
        ? "omarchy-capture-screenrecording --stop-recording"
        : "omarchy-menu toggle trigger.capture.screenrecord")
    }
  }

  Timer {
    interval: 4000
    repeat: true
    running: !!root.indicatorHost && root.indicatorHost.expanded
    onTriggered: root.refresh()
  }

  Timer {
    id: refreshAfterClick
    interval: 800
    onTriggered: root.refresh()
  }

  Component.onCompleted: refresh()
}

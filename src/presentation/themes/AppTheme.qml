pragma Singleton
import QtQuick

QtObject {

    // === BACKGROUNDS ===
    readonly property color background: "#0F172A"      // main bg (dark blue)
    readonly property color surface: "#1E293B"         // cards / panels
    readonly property color surfaceLight: "#273449"    // hover / secondary

    // === PRIMARY COLORS ===
    readonly property color primary: "#3B82F6"         // blue (balance)
    readonly property color success: "#22C55E"         // green (income)
    readonly property color danger: "#EF4444"          // red (expenses)
    readonly property color warning: "#F59E0B"         // optional (charts)

    // === TEXT ===
    readonly property color textPrimary: "#F1F5F9"
    readonly property color textSecondary: "#94A3B8"
    readonly property color textMuted: "#64748B"

    // === BORDERS ===
    readonly property color border: "#334155"

    // === SIDEBAR ===
    readonly property color sidebar: "#111827"
    readonly property color sidebarItemHover: "#1F2937"
    readonly property color sidebarItemActive: "#3B82F6"

    // === RADIUS ===
    readonly property int radiusSmall: 6
    readonly property int radiusMedium: 10
    readonly property int radiusLarge: 14

    // === SPACING ===
    readonly property int spacingXS: 4
    readonly property int spacingSmall: 8
    readonly property int spacingMedium: 12
    readonly property int spacingLarge: 16
    readonly property int spacingXL: 24

    // === FONT SIZES ===
    readonly property int fontSmall: 12
    readonly property int fontBody: 14
    readonly property int fontMedium: 16
    readonly property int fontTitle: 20
    readonly property int fontHeading: 26

}
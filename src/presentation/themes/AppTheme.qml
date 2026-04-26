pragma Singleton
import QtQuick

QtObject {
    // === BACKGROUNDS ===
    readonly property color background: "#090c12"        // main app background
    readonly property color backgroundAlt: "#101319"     // slightly lighter bg
    readonly property color surface: "#121A27"           // cards / panels
    readonly property color surfaceLight: "#182334"      // hover / secondary panels
    readonly property color surfaceElevated: "#1B2638"   // inputs / raised cards

    // === PRIMARY COLORS ===
    readonly property color primary: "#2563EB"           // main blue
    readonly property color primaryLight: "#3B82F6"      // hover / highlights
    readonly property color primaryDark: "#1D4ED8"       // active / pressed

    // === STATUS COLORS ===
    readonly property color success: "#22C55E"           // income green
    readonly property color successSoft: "#123524"       // green badge bg

    readonly property color danger: "#EF4444"            // expense red
    readonly property color dangerSoft: "#3A1A1A"        // red badge bg

    readonly property color warning: "#F97316"           // orange chart / warning
    readonly property color warningSoft: "#3A2412"

    readonly property color purple: "#8B5CF6"            // goals / savings
    readonly property color purpleSoft: "#241A3A"

    // === TEXT ===
    readonly property color textPrimary: "#F8FAFC"
    readonly property color textSecondary: "#CBD5E1"
    readonly property color textMuted: "#94A3B8"
    readonly property color textDisabled: "#64748B"

    // === BORDERS / DIVIDERS ===
    readonly property color border: "#263244"
    readonly property color borderLight: "#334155"
    readonly property color divider: "#1F2937"

    // === SIDEBAR ===
    readonly property color sidebarBorder: "#1F2937"
    readonly property color sidebarItemHover: "#111827"
    readonly property color sidebarItemActive: "#132B4F"
    readonly property color sidebarItemActiveText: "#60A5FA"

    // === INPUTS ===
    readonly property color inputBackground: "#0E1623"
    readonly property color inputBorder: "#2A3A50"
    readonly property color inputPlaceholder: "#64748B"

    // === CHART COLORS ===
    readonly property color chartBlue: "#2563EB"
    readonly property color chartGreen: "#22C55E"
    readonly property color chartOrange: "#F97316"
    readonly property color chartPurple: "#8B5CF6"
    readonly property color chartGray: "#64748B"

    // === SHADOW / OVERLAY ===
    readonly property color overlay: "#000000"
    readonly property color shadow: "#000000"

    // === RADIUS ===
    readonly property int radiusSmall: 6
    readonly property int radiusMedium: 10
    readonly property int radiusLarge: 14
    readonly property int radiusXL: 18

    // === SPACING ===
    readonly property int spacingXS: 4
    readonly property int spacingSmall: 8
    readonly property int spacingMedium: 12
    readonly property int spacingLarge: 16
    readonly property int spacingXL: 24
    readonly property int spacingXXL: 32

    // === FONT SIZES ===
    readonly property int fontSmall: 12
    readonly property int fontBody: 14
    readonly property int fontMedium: 16
    readonly property int fontTitle: 20
    readonly property int fontHeading: 26
    readonly property int fontDisplay: 38
}
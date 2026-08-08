pragma Singleton
import QtQuick

QtObject {
    // Modern dark product palette: low contrast surfaces, clear accent, readable text.
    readonly property color background: "#070A12"
    readonly property color backgroundAlt: "#0B1020"
    readonly property color backgroundMainCard: "#111827"
    readonly property color surface: "#111827"
    readonly property color surfaceLight: "#172033"
    readonly property color surfaceElevated: "#1F2937"

    readonly property color tableSurface: "#0F172A"
    readonly property color tableHeaderSurface: "#111C31"
    readonly property color tableRowAlt: "#111B2F"
    readonly property color tableRowHover: "#18243A"

    readonly property color primary: "#4F8CFF"
    readonly property color primaryLight: "#6EA3FF"
    readonly property color primaryDark: "#2F6FE8"
    readonly property color primarySoft: "#18345E"
    readonly property color primarySubtle: "#12233D"
    readonly property color primaryBorder: "#486FA8"

    // Brighter green keeps positive amounts readable on the dark surfaces.
    readonly property color success: "#22C55E"
    readonly property color successSoft: "#123D2B"

    readonly property color danger: "#F87171"
    readonly property color dangerStrong: "#EF4444"
    readonly property color dangerSoft: "#3A1A1A"

    readonly property color warning: "#F59E0B"
    readonly property color warningSoft: "#3A2A12"

    readonly property color purple: "#A78BFA"
    readonly property color purpleSoft: "#241A3A"

    readonly property color textPrimary: "#F8FAFC"
    readonly property color textSecondary: "#CBD5E1"
    readonly property color textMuted: "#94A3B8"
    readonly property color textDisabled: "#64748B"

    readonly property color border: "#263244"
    readonly property color borderLight: "#334155"
    readonly property color divider: "#1E293B"

    readonly property color sidebarBorder: "#1E293B"
    readonly property color sidebarItemHover: "#131C2E"
    readonly property color sidebarItemActive: "#19365F"
    readonly property color sidebarItemActiveText: "#DDEBFF"

    readonly property color inputBackground: "#0B1220"
    readonly property color inputBorder: "#2A3A50"
    readonly property color inputPlaceholder: "#64748B"

    readonly property color incomeBadge: "#123D2B"
    readonly property color expenseBadge: "#3A1A1A"
    readonly property color rowHighlight: "#17243A"

    readonly property color chartBlue: "#4F8CFF"
    readonly property color chartGreen: "#22C55E"
    readonly property color chartOrange: "#F59E0B"
    readonly property color chartPurple: "#A78BFA"
    readonly property color chartGray: "#64748B"

    readonly property color overlay: "#000000"
    readonly property color shadow: "#000000"

    readonly property int radiusSmall: 6
    readonly property int radiusMedium: 10
    readonly property int radiusLarge: 14
    readonly property int radiusXL: 18
    readonly property int radiusXXL: 24

    readonly property int spacingXS: 4
    readonly property int spacingSmall: 8
    readonly property int spacingMedium: 12
    readonly property int spacingLarge: 16
    readonly property int spacingXL: 24
    readonly property int spacingXXL: 32

    readonly property int fontSmall: 12
    readonly property int fontBody: 14
    readonly property int fontMedium: 16
    readonly property int fontTitle: 20
    readonly property int fontHeading: 28
    readonly property int fontDisplay: 38

    readonly property url ricoRobotIcon: "../../images/rico_robot.png"
    readonly property url balanceIcon: "../../images/balance.png"
    readonly property url incomeIcon: "../../images/income.png"
    readonly property url expenseIcon: "../../images/expense.png"
    readonly property url rateIcon: "../../images/rate.png"

    function isIncome(transactionType) {
        return transactionType === "Income"
    }

    function formattedAmount(amount, transactionType) {
        const numericAmount = Number(amount)
        const value = isNaN(numericAmount) ? 0 : numericAmount
        return (isIncome(transactionType) ? "+" : "-") + " €" + value.toFixed(2)
    }
}

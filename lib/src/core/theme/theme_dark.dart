part of 'theme.dart';

final themeDark = ThemeData.dark().copyWith(
  // Color Scheme
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: clWhite,
    onPrimary: clIndigo600,
    secondary: clIndigo700,
    onSecondary: clWhite,
    error: clRed,
    onError: clYellow,
    background: clIndigo900,
    onBackground: clBlue,
    surface: clSurface,
    onSurface: clWhite,
  ),
  scaffoldBackgroundColor: clIndigo900,
  backgroundColor: clIndigo900,
  canvasColor: clIndigo900,
  // AppBar
  appBarTheme: AppBarTheme(
    backgroundColor: clIndigo900,
    centerTitle: true,
    titleTextStyle: textStylePoppins616,
    toolbarHeight: 68,
  ),
  // Bottom Navigation Bar
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: clIndigo900,
    selectedItemColor: clWhite,
    selectedLabelStyle: textStyleSourceSansPro612.copyWith(height: 2.5),
    unselectedLabelStyle: textStyleSourceSansPro412.copyWith(height: 2.5),
  ),
  // Bottom Sheet
  bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
    topLeft: radius8,
    topRight: radius8,
  ))),
  // Card
  cardTheme: CardTheme(
    color: clSurface,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: _shapeBorder,
  ),
  // Elevated Button
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    fixedSize: _fixedSizeHeight48,
    foregroundColor: _buttonForegroundColor,
    shape: _buttonShape,
    textStyle: MaterialStateProperty.all<TextStyle>(textStylePoppins616),
    backgroundColor: MaterialStateProperty.resolveWith<Color>((states) =>
        states.contains(MaterialState.disabled)
            ? const Color(0xFF320784)
            : clIndigo500),
  )),
  // Expansion Panel
  expansionTileTheme: const ExpansionTileThemeData(
    backgroundColor: clSurface,
    childrenPadding: paddingAll20,
    collapsedIconColor: clWhite,
    iconColor: clWhite,
  ),
  // Icon
  iconTheme: const IconThemeData(color: clWhite),
  // Input
  inputDecorationTheme: InputDecorationTheme(
    border: MaterialStateOutlineInputBorder.resolveWith(
      (states) {
        var borderWidth = 1.0;
        var borderColor = const Color(0x55E9F8FE);
        if (states.contains(MaterialState.focused)) {
          borderWidth = 2;
          borderColor = clBlue;
        }
        if (states.contains(MaterialState.error)) {
          borderColor = clRed;
        }
        return OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(width: borderWidth, color: borderColor),
        );
      },
    ),
    counterStyle: textStyleSourceSansPro412,
    helperStyle: textStyleSourceSansPro412,
    labelStyle: textStyleSourceSansPro412,
  ),
  // ListTile
  listTileTheme: ListTileThemeData(
    iconColor: clWhite,
    tileColor: clSurface,
    textColor: clWhite,
    shape: _shapeBorder,
  ),
  // Outlined Button
  outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
    fixedSize: _fixedSizeHeight48,
    foregroundColor: _buttonForegroundColor,
    side: MaterialStateProperty.resolveWith<BorderSide>(
      (states) => BorderSide(
          color: states.contains(MaterialState.disabled)
              ? const Color(0xFF2E4283)
              : clIndigo500),
    ),
    shape: _buttonShape,
    textStyle: MaterialStateProperty.all<TextStyle>(textStylePoppins616),
  )),
  // Radio
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.all<Color>(clWhite),
  ),
  // SnackBar
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: clGreen,
    behavior: SnackBarBehavior.floating,
    contentTextStyle: TextStyle(color: clGreenDark),
  ),
  // Switch
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.all<Color>(clWhite),
    trackColor: MaterialStateProperty.resolveWith<Color>((states) =>
        states.contains(MaterialState.selected) ? clBlue : clIndigo700),
  ),
  // TabBar
  tabBarTheme: TabBarTheme(
    indicator: const BoxDecoration(
      borderRadius: borderRadiusTop,
      color: clIndigo600,
    ),
    labelPadding: EdgeInsets.zero,
    labelColor: clWhite,
    labelStyle: textStyleSourceSansPro614,
    unselectedLabelColor: clWhite,
    unselectedLabelStyle: textStyleSourceSansPro614,
  ),
  // Text
  textTheme: TextTheme(
    caption: const TextStyle(
      color: clPurpleLight,
      fontSize: 10,
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
    ),
    headline6: textStylePoppins620,
    subtitle1: textStyleSourceSansPro614,
    bodyText2: textStyleSourceSansPro414,
  ),
  // Text Button
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
    foregroundColor: MaterialStateProperty.all<Color>(clWhite),
  )),
);
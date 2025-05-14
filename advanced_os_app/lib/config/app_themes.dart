import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const primaryColor = Color(0xFF4CAF50);
  static const primaryLightColor = Color(0xFF80E27E);
  static const primaryDarkColor = Color(0xFF087F23);
  
  // Secondary colors
  static const secondaryColor = Color(0xFF03A9F4);
  static const secondaryLightColor = Color(0xFF67DAFF);
  static const secondaryDarkColor = Color(0xFF007AC1);
  
  // Feedback colors
  static const errorColor = Color(0xFFF44336);
  static const successColor = Color(0xFF4CAF50);
  static const warningColor = Color(0xFFFFEB3B);
  static const infoColor = Color(0xFF2196F3);
  
  // Neutral colors
  static const backgroundColor = Color(0xFFF5F5F5);
  static const surfaceColor = Colors.white;
  static const cardColor = Colors.white;
  
  // Text colors
  static const textPrimaryColor = Color(0xFF212121);
  static const textSecondaryColor = Color(0xFF757575);
  static const textDisabledColor = Color(0xFFBDBDBD);
  
  // Border colors
  static const borderColor = Color(0xFFE0E0E0);
  static const dividerColor = Color(0xFFEEEEEE);
}

class AppTextStyles {
  static const headline1 = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryColor,
  );
  
  static const headline2 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryColor,
  );
  
  static const headline3 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryColor,
  );
  
  static const subtitle1 = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimaryColor,
  );
  
  static const subtitle2 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimaryColor,
  );
  
  static const bodyText1 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimaryColor,
  );
  
  static const bodyText2 = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimaryColor,
  );
  
  static const button = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  
  static const caption = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondaryColor,
  );
}

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    primaryColorLight: AppColors.primaryLightColor,
    primaryColorDark: AppColors.primaryDarkColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    // scaffoldBackgroundColor: AppColors.backgroundColor,
    cardColor: AppColors.cardColor,
    colorScheme: ColorScheme.fromSwatch().copyWith(error: AppColors.errorColor),
    dividerColor: AppColors.dividerColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: AppTextStyles.button,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        side: BorderSide(color: AppColors.primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: AppTextStyles.button.copyWith(color: AppColors.primaryColor),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.errorColor),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.headline1,
      displayMedium: AppTextStyles.headline2,
      displaySmall: AppTextStyles.headline3,
      titleLarge: AppTextStyles.subtitle1,
      titleMedium: AppTextStyles.subtitle2,
      bodyLarge: AppTextStyles.bodyText1,
      bodyMedium: AppTextStyles.bodyText2,
      labelLarge: AppTextStyles.button,
      bodySmall: AppTextStyles.caption,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    primaryColorLight: AppColors.primaryLightColor,
    primaryColorDark: AppColors.primaryDarkColor,
    scaffoldBackgroundColor: Color(0xFF121212),
    cardColor: Color(0xFF1E1E1E),
    colorScheme: ColorScheme.dark().copyWith(error: AppColors.errorColor),
    dividerColor: Color(0xFF323232),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: AppTextStyles.button,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        side: BorderSide(color: AppColors.primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: AppTextStyles.button.copyWith(color: AppColors.primaryColor),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF2C2C2C),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFF424242)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFF424242)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.errorColor),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.headline1.copyWith(color: Colors.white),
      displayMedium: AppTextStyles.headline2.copyWith(color: Colors.white),
      displaySmall: AppTextStyles.headline3.copyWith(color: Colors.white),
      titleLarge: AppTextStyles.subtitle1.copyWith(color: Colors.white),
      titleMedium: AppTextStyles.subtitle2.copyWith(color: Colors.white),
      bodyLarge: AppTextStyles.bodyText1.copyWith(color: Colors.white),
      bodyMedium: AppTextStyles.bodyText2.copyWith(color: Colors.white),
      labelLarge: AppTextStyles.button,
      bodySmall: AppTextStyles.caption.copyWith(color: Color(0xFFBDBDBD)),
    ),
  );
}

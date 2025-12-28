import Toybox.Application;
import Toybox.Lang;
import Toybox.System;

class Config {
  //var config as Array = [Storage.getValue(1),Storage.getValue(2),Storage.getValue(18),Storage.getValue(32),Storage.getValue(3),Storage.getValue(5),Storage.getValue(25),Storage.getValue(6),Storage.getValue(7),Storage.getValue(26),Storage.getValue(14),Storage.getValue(8),Storage.getValue(4),Storage.getValue(13),Storage.getValue(12),Storage.getValue(17),Storage.getValue(9),Storage.getValue(10),Storage.getValue(11),Storage.getValue(19),Storage.getValue(22),Storage.getValue(24),Storage.getValue(16),Storage.getValue(27),Storage.getValue(28),Storage.getValue(21)];
  //                          0=accent color  ,  1=accent index   ,  2=tickmark color  , 3=Dark/Light theme ,  4=garmin logo    ,   5=hour labels   , 6=Weather condition, 7=Temperature type,  8=Location name  ,   9=Battery Icon   ,     10=Font size   ,  11=Alarm toggle  ,12=Bluetooth toggle, 13=Hands Thickness , 14=Right bottom DF ,  15=Right top DF   ,   16=Left top DF  ,  17=Left middle DF ,  18=Left bottom DF , 19=Batt. Est. flag , 20=AOD color minute ,   21=Date Format  , 22=temperature unit,   23=Hour Labels   ,24=Gray Battery Icon, 25=Date Font Size
  //$.confi           g = [Storage.getValue(1),Storage.getValue(2),Storage.getValue(18),Storage.getValue(32),Storage.getValue(3),Storage.getValue(5),Storage.getValue(25),Storage.getValue(6),Storage.getValue(7),Storage.getValue(26),Storage.getValue(14),Storage.getValue(8),Storage.getValue(4),Storage.getValue(13),Storage.getValue(12),Storage.getValue(17),Storage.getValue(9),Storage.getValue(10),Storage.getValue(11),Storage.getValue(19),Storage.getValue(22),Storage.getValue(24),Storage.getValue(16),Storage.getValue(27),Storage.getValue(28),Storage.getValue(21)];
private static const KEY_ACCENT_COLOR = 1;
private static const KEY_ACCENT_INDEX = 2;
private static const KEY_TICKMARK_COLOR = 18;
private static const KEY_DARK_LIGHT_THEME = 32;
private static const KEY_GARMINLOGO = 3;
private static const KEY_HOUR_LABELS = 5;
private static const KEY_WEATHER_CONDITION = 25;
private static const KEY_TEMPERATURE_TYPE = 6;
private static const KEY_LOCATION_NAME = 7;
private static const KEY_BATTERY_ICON = 26;
private static const KEY_FONT_SIZE = 14;
private static const KEY_ALARM_TOGGLE = 8;
private static const KEY_BLUETOOTH_TOGGLE = 4;
private static const KEY_HANDS_THICKNESS = 13;
private static const KEY_RIGHT_BOTTOM_DF = 12;
private static const KEY_RIGHT_TOP_DF = 17;
private static const KEY_LEFT_TOP_DF = 9;
private static const KEY_LEFT_MIDDLE_DF = 10;
private static const KEY_LEFT_BOTTOM_DF = 11;
private static const KEY_BATTERY_EST_FLAG = 19;
private static const KEY_AOD_COLOR_MINUTE = 22;
private static const KEY_CURRENT_VERSION = 23;
private static const KEY_DATE_FORMAT = 24;
private static const KEY_TEMPERATURE_UNIT = 16;
private static const KEY_HOUR_LABELS2 = 27;
private static const KEY_GRAY_BATTERY_ICON = 28;
private static const KEY_DATE_FONT_SIZE = 21;
private static const KEY_SECOND_HAND = 33;

private static var mAccentColor = Storage.getValue(KEY_ACCENT_COLOR);
private static var mAccentIndex = Storage.getValue(KEY_ACCENT_INDEX);
private static var mTickmarkColor = Storage.getValue(KEY_TICKMARK_COLOR);
private static var mDarkLightTheme = Storage.getValue(KEY_DARK_LIGHT_THEME);
private static var mGarminlogo = Storage.getValue(KEY_GARMINLOGO);
private static var mHourLabels = Storage.getValue(KEY_HOUR_LABELS);
private static var mWeatherCondition = Storage.getValue(KEY_WEATHER_CONDITION);
private static var mTemperatureType = Storage.getValue(KEY_TEMPERATURE_TYPE);
private static var mLocationName = Storage.getValue(KEY_LOCATION_NAME);
private static var mBatteryIcon = Storage.getValue(KEY_BATTERY_ICON);
private static var mFontSize = Storage.getValue(KEY_FONT_SIZE);
private static var mAlarmToggle = Storage.getValue(KEY_ALARM_TOGGLE);
private static var mBluetoothToggle = Storage.getValue(KEY_BLUETOOTH_TOGGLE);
private static var mHandsThickness = Storage.getValue(KEY_HANDS_THICKNESS);
private static var mRightBottomDF = Storage.getValue(KEY_RIGHT_BOTTOM_DF);
private static var mRightTopDF = Storage.getValue(KEY_RIGHT_TOP_DF);
private static var mLeftTopDF = Storage.getValue(KEY_LEFT_TOP_DF);
private static var mLeftMiddleDF = Storage.getValue(KEY_LEFT_MIDDLE_DF);
private static var mLeftBottomDF = Storage.getValue(KEY_LEFT_BOTTOM_DF);
private static var mBatteryEstFlag = Storage.getValue(KEY_BATTERY_EST_FLAG);
private static var mAODColorMinute = Storage.getValue(KEY_AOD_COLOR_MINUTE);
private static var mDateFormat = Storage.getValue(KEY_DATE_FORMAT);
private static var mTemperatureUnit = Storage.getValue(KEY_TEMPERATURE_UNIT);
private static var mHourLabels2 = Storage.getValue(KEY_HOUR_LABELS2);
private static var mGrayBatteryIcon = Storage.getValue(KEY_GRAY_BATTERY_ICON);
private static var mDateFontSize = Storage.getValue(KEY_DATE_FONT_SIZE);
private static var mSecondHand = Storage.getValue(KEY_SECOND_HAND);
private static var mCurrentVersion = Storage.getValue(KEY_CURRENT_VERSION);

public static function init() as Void{
 	if (Config.get_0_AccentColor() == null or Config.get_1_AccentIndex() == null) {
            if (System.getDeviceSettings().screenWidth >= 360){ // AMOLED
                Config.set_1_AccentIndex(1);
                Config.set_0_AccentColor(0xAAFF00);
            } else {
                Config.set_1_AccentIndex(0);
                Config.set_0_AccentColor(0x55FF00);// Bright Green
            }
        }

        var currentVersion=534;
        var currentVersionStored=Config.getCurrentVersion();
        if (currentVersionStored==null or currentVersionStored<currentVersion){ // only runs at first install or watch face update
            Config.setCurrentVersion(currentVersion);
            if (Config.get_4_Garminlogo() == null){Config.set_4_Garminlogo(true);} // Garmin Logo
            if (Config.get_12_BluetoothToggle() == null){ Config.set_12_BluetoothToggle(true);} // Bluetooth Logo
            if (Config.get_7_TemperatureType() == null){ Config.set_7_TemperatureType(true);} // Temperature Type
            if (Config.get_8_LocationName() == null ){ Config.set_8_LocationName(true);} // Location Name
            if (Config.get_11_AlarmToggle() == null ){ Config.set_11_AlarmToggle(true);} // Alarm Icon
            if (Config.get_13_HandsThickness() == null ){ Config.set_13_HandsThickness(2);} // Hands Thickness - Thinner
            // //if (Storage.getValue(15) == null ){ Config.set_15, true); } // Wind Unit
            // if (Storage.getValue(15) == null or Storage.getValue(15) instanceof Boolean){ Storage.deleteValue(15); Storage.setValue(15, 0);}  // Wind Unit <---- This looks like an unused config?
            if (Config.get_22_TemperatureUnit() == null ){ Config.set_22_TemperatureUnit(false);} // Temperature Unit
            if (Config.get_2_TickmarkColor() == null ){ Config.set_2_TickmarkColor(false);} // Tickmark Color
            if (Config.get_19_BatteryEstFlag() == null ){ Config.set_19_BatteryEstFlag(false);} // Battery Estimate
            // if (Storage.getValue(20) == null ){ Storage.setValue(20, false); } // Pressure Type <---- This looks like an unused config?
            if (Config.get_20_AODColorMinute() == null ){ Config.set_20_AODColorMinute(false);} // AOD Colors
            if (Config.get_21_DateFormat() == null ){ Config.set_21_DateFormat(false);} // Date Format
            if (Config.get_6_WeatherCondition() == null ){ Config.set_6_WeatherCondition(true);} // Display Weather
            if (Config.get_9_BatteryIcon() == null ){ Config.set_9_BatteryIcon(true);} // Battery Icon 
            if (Config.get_24_GrayBatteryIcon() == null ){ Config.set_24_GrayBatteryIcon(true);} // Battery Color 
            if (Config.get_3_DarkLightTheme() == null ){ Config.set_3_DarkLightTheme(false);} // Theme - Default Dark
            if (System.SCREEN_SHAPE_ROUND == System.getDeviceSettings().screenShape) { // If not square display
                if (Config.get_5_HourLabels() == null ){ Config.set_5_HourLabels(true);} // Hour Labels
                if (Config.get_23_HourLabels2() == null ){ Config.set_23_HourLabels2(false);} // Labels Color
                if (Config.get_10_FontSize() == null ){ Config.set_10_FontSize(false);} // Bigger Font
                // if (Storage.getValue(33) == null ){ Config.set_33, false); } // Seconds Hand <---- This looks like an unused config?
            }
            if (Config.get_16_LeftTopDF() == null) { Config.set_16_LeftTopDF(27);} //big length data field 1
            if (Config.get_17_LeftMiddleDF() == null) { Config.set_17_LeftMiddleDF(27);} //big length data field 2
            if (Config.get_18_LeftBottomDF() == null) { Config.set_18_LeftBottomDF(23);} //small length data field 1
            if (Config.get_14_RightBottomDF() == null) { Config.set_14_RightBottomDF(23);} //small length data field 2
            if (Config.get_15_RightTopDF() == null) { Config.set_15_RightTopDF(23);} //small length data field 3
            if (Config.get_25_DateFontSize() == null or Config.get_25_DateFontSize() instanceof Array) { Storage.deleteValue(Config.KEY_DATE_FONT_SIZE); Config.set_25_DateFontSize(true);} //date font size
        }        
}

public static function set_0_AccentColor(value) {
    mAccentColor = value;
    Storage.setValue(KEY_ACCENT_COLOR, value);
}

public static function set_1_AccentIndex(value) {
    mAccentIndex = value;
    Storage.setValue(KEY_ACCENT_INDEX, value);
}

public static function set_2_TickmarkColor(value) {
    mTickmarkColor = value;
    Storage.setValue(KEY_TICKMARK_COLOR, value);
}

public static function set_3_DarkLightTheme(value) {
    mDarkLightTheme = value;
    Storage.setValue(KEY_DARK_LIGHT_THEME, value);
}

public static function set_4_Garminlogo(value) {
    mGarminlogo = value;
    Storage.setValue(KEY_GARMINLOGO, value);
}

public static function set_5_HourLabels(value) {
    mHourLabels = value;
    Storage.setValue(KEY_HOUR_LABELS, value);
}

public static function set_6_WeatherCondition(value) {
    mWeatherCondition = value;
    Storage.setValue(KEY_WEATHER_CONDITION, value);
}

public static function set_7_TemperatureType(value) {
    mTemperatureType = value;
    Storage.setValue(KEY_TEMPERATURE_TYPE, value);
}

public static function set_8_LocationName(value) {
    mLocationName = value;
    Storage.setValue(KEY_LOCATION_NAME, value);
}

public static function set_9_BatteryIcon(value) {
    mBatteryIcon = value;
    Storage.setValue(KEY_BATTERY_ICON, value);
}

public static function set_10_FontSize(value) {
    mFontSize = value;
    Storage.setValue(KEY_FONT_SIZE, value);
}

public static function set_11_AlarmToggle(value) {
    mAlarmToggle = value;
    Storage.setValue(KEY_ALARM_TOGGLE, value);
}

public static function set_12_BluetoothToggle(value) {
    mBluetoothToggle = value;
    Storage.setValue(KEY_BLUETOOTH_TOGGLE, value);
}

public static function set_13_HandsThickness(value) {
    mHandsThickness = value;
    Storage.setValue(KEY_HANDS_THICKNESS, value);
}

public static function set_14_RightBottomDF(value) {
    mRightBottomDF = value;
    Storage.setValue(KEY_RIGHT_BOTTOM_DF, value);
}

public static function set_15_RightTopDF(value) {
    mRightTopDF = value;
    Storage.setValue(KEY_RIGHT_TOP_DF, value);
}

public static function set_16_LeftTopDF(value) {
    mLeftTopDF = value;
    Storage.setValue(KEY_LEFT_TOP_DF, value);
}

public static function set_17_LeftMiddleDF(value) {
    mLeftMiddleDF = value;
    Storage.setValue(KEY_LEFT_MIDDLE_DF, value);
}

public static function set_18_LeftBottomDF(value) {
    mLeftBottomDF = value;
    Storage.setValue(KEY_LEFT_BOTTOM_DF, value);
}

public static function set_19_BatteryEstFlag(value) {
    mBatteryEstFlag = value;
    Storage.setValue(KEY_BATTERY_EST_FLAG, value);
}

public static function set_20_AODColorMinute(value) {
    mAODColorMinute = value;
    Storage.setValue(KEY_AOD_COLOR_MINUTE, value);
}

public static function set_21_DateFormat(value) {
    mDateFormat = value;
    Storage.setValue(KEY_DATE_FORMAT, value);
}

public static function set_22_TemperatureUnit(value) {
    mTemperatureUnit = value;
    Storage.setValue(KEY_TEMPERATURE_UNIT, value);
}

public static function set_23_HourLabels2(value) {
    mHourLabels2 = value;
    Storage.setValue(KEY_HOUR_LABELS2, value);
}

public static function set_24_GrayBatteryIcon(value) {
    mGrayBatteryIcon = value;
    Storage.setValue(KEY_GRAY_BATTERY_ICON, value);
}

public static function set_25_DateFontSize(value) {
    mDateFontSize = value;
    Storage.setValue(KEY_DATE_FONT_SIZE, value);
}

public static function set_33_SecondHand(value) {
    mSecondHand = value;
    Storage.setValue(KEY_SECOND_HAND, value);
}

private static function setCurrentVersion(value) {
    mCurrentVersion = value;
    Storage.setValue(KEY_CURRENT_VERSION, value);
}

  public static function get_0_AccentColor() {
    return mAccentColor;
  }

  public static function get_1_AccentIndex() {
    return mAccentIndex;
  }

  public static function get_2_TickmarkColor() {
    return mTickmarkColor;
  }

  public static function get_3_DarkLightTheme() {
    return mDarkLightTheme;
  }

  public static function get_4_Garminlogo() {
    return mGarminlogo;
  }

  public static function get_5_HourLabels() {
    return mHourLabels;
  }

  public static function get_6_WeatherCondition() {
    return mWeatherCondition;
  }

  public static function get_7_TemperatureType() {
    return mTemperatureType;
  }

  public static function get_8_LocationName() {
    return mLocationName;
  }

  public static function get_9_BatteryIcon() {
    return mBatteryIcon;
  }

  public static function get_10_FontSize() {
    return mFontSize;
  }

  public static function get_11_AlarmToggle() {
    return mAlarmToggle;
  }

  public static function get_12_BluetoothToggle() {
    return mBluetoothToggle;
  }

  public static function get_13_HandsThickness() {
    return mHandsThickness;
  }

  public static function get_14_RightBottomDF() {
    return mRightBottomDF;
  }

  public static function get_15_RightTopDF() {
    return mRightTopDF;
  }

  public static function get_16_LeftTopDF() {
    return mLeftTopDF;
  }

  public static function get_17_LeftMiddleDF() {
    return mLeftMiddleDF;
  }

  public static function get_18_LeftBottomDF() {
    return mLeftBottomDF;
  }

  public static function get_19_BatteryEstFlag() {
    return mBatteryEstFlag;
  }

  public static function get_20_AODColorMinute() {
    return mAODColorMinute;
  }

  public static function get_21_DateFormat() {
    return mDateFormat;
  }

  public static function get_22_TemperatureUnit() {
    return mTemperatureUnit;
  }

  public static function get_23_HourLabels2() {
    return mHourLabels2;
  }

  public static function get_24_GrayBatteryIcon() {
    return mGrayBatteryIcon;
  }

  public static function get_25_DateFontSize() {
    return mDateFontSize;
  }

  public static function get_33_SecondHand() {
    return mSecondHand;
  } 

  private static function getCurrentVersion() {
    return mCurrentVersion;
  } 

}

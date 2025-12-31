import Toybox.Application;
import Toybox.Lang;

class AppStorage {

  public static const KEY_1_CFG_ACCENT_COLOR = 1;
  public static const KEY_2_CFG_ACCENT_INDEX = 2;
  public static const KEY_3_CFG_GARMINLOGO = 3;
  public static const KEY_4_CFG_BLUETOOTH_TOGGLE = 4;
  public static const KEY_5_CFG_HOUR_LABELS = 5;
  public static const KEY_6_CFG_TEMPERATURE_TYPE = 6;
  public static const KEY_7_CFG_WEATHER_CONDITION_NAME = 7;
  public static const KEY_8_CFG_ALARM_TOGGLE = 8;
  public static const KEY_9_CFG_LEFT_TOP_DF = 9;
  public static const KEY_10_CFG_LEFT_MIDDLE_DF = 10;
  public static const KEY_11_CFG_LEFT_BOTTOM_DF = 11;
  public static const KEY_12_CFG_RIGHT_BOTTOM_DF = 12;
  public static const KEY_13_CFG_HANDS_THICKNESS = 13;
  public static const KEY_14_CFG_FONT_SIZE = 14;
  public static const KEY_16_CFG_TEMPERATURE_UNIT = 16;
  public static const KEY_17_CFG_RIGHT_TOP_DF = 17;
  public static const KEY_18_CFG_TICKMARK_ACCENT_COLOR = 18;
  public static const KEY_19_CFG_BATTERY_EST_FLAG = 19;
  public static const KEY_20_CFG_PRESSURE_TYPE = 20;
  public static const KEY_21_CFG_DATE_FONT_SIZE = 21;
  public static const KEY_22_CFG_AOD_COLOR_MINUTE = 22;
  public static const KEY_23_CFG_CURRENT_VERSION = 23;
  public static const KEY_24_CFG_DATE_FORMAT = 24;
  public static const KEY_25_CFG_WEATHER_CONDITION = 25;
  public static const KEY_26_CFG_BATTERY_ICON = 26;
  public static const KEY_27_CFG_HOUR_LABELS_ACCENT_COLOR = 27;
  public static const KEY_28_CFG_CONDITIONAL_BATTERY_ICON_COLOR = 28;
  public static const KEY_30_STAT_MAX_PERCENTAGE_WHEN_CHARGING = 30;
  public static const KEY_32_CFG_DARK_LIGHT_THEME = 32;
  public static const KEY_33_CFG_SECONDS_HAND = 33;

  public static function load(key as Integer) {
    return Storage.getValue(key);
  }

  public static function persist(key as Integer, value) {
    Storage.setValue(key, value);
  }
}

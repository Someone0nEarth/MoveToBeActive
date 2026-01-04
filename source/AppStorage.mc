import Toybox.Application;
import Toybox.Lang;

class AppStorage {

public static enum StorageKey {
    KEY_1_CFG_ACCENT_COLOR = 1,
    KEY_2_CFG_ACCENT_INDEX = 2,
    KEY_3_CFG_GARMINLOGO = 3,
    KEY_4_CFG_BLUETOOTH_TOGGLE = 4,
    KEY_5_CFG_HOUR_LABELS = 5,
    KEY_6_CFG_TEMPERATURE_TYPE = 6,
    KEY_7_CFG_WEATHER_CONDITION_NAME = 7,
    KEY_8_CFG_ALARM_TOGGLE = 8,
    KEY_9_CFG_LEFT_TOP_DF = 9,
    KEY_10_CFG_LEFT_MIDDLE_DF = 10,
    KEY_11_CFG_LEFT_BOTTOM_DF = 11,
    KEY_12_CFG_RIGHT_BOTTOM_DF = 12,
    KEY_13_CFG_HANDS_THICKNESS = 13,
    KEY_14_CFG_FONT_SIZE = 14,
    KEY_15_CFG_WINDSPEED_UNIT = 15,
    KEY_16_CFG_TEMPERATURE_UNIT = 16,
    KEY_17_CFG_RIGHT_TOP_DF = 17,
    KEY_18_CFG_TICKMARK_ACCENT_COLOR = 18,
    KEY_19_CFG_BATTERY_EST_FLAG = 19,
    KEY_20_CFG_PRESSURE_TYPE = 20,
    KEY_21_CFG_DATE_FONT_SIZE = 21,
    KEY_22_CFG_AOD_USE_ACCENT_COLOR = 22,
    KEY_23_CFG_CURRENT_VERSION = 23,
    KEY_24_CFG_DATE_FORMAT = 24,
    KEY_25_CFG_WEATHER_CONDITION = 25,
    KEY_26_CFG_BATTERY_ICON = 26,
    KEY_27_CFG_HOUR_LABELS_ACCENT_COLOR = 27,
    KEY_28_CFG_CONDITIONAL_BATTERY_ICON_COLOR = 28,
    KEY_29_STAT_LAST_TIME_CAHRGING = 29,
    KEY_30_STAT_MAX_PERCENTAGE_WHEN_CHARGING = 30,
    KEY_31_STAT_CHARGE_TEXT = 31,
    KEY_32_CFG_LIGHT_THEME = 32,
    KEY_33_CFG_SECONDS_HAND = 33
    }

  public static function load(key as StorageKey) {
    return Storage.getValue(key);
  }

  public static function persist(key as StorageKey, value) {
    Storage.setValue(key, value);
  }

  public static function delete(key as StorageKey) {
    Storage.deleteValue(key);
  }
}

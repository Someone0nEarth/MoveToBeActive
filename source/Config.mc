import Toybox.Application;
import Toybox.Lang;
import Toybox.System;

class Config {

  private static const CURRENT_APP_VERSION = 534;
  private static const SCREEN_IS_ROUND_SHAPED = System.SCREEN_SHAPE_ROUND == System.getDeviceSettings().screenShape;

  private static const COLOR_BRIGHT_LIME_GREEN = 0x55ff00;
  private static const COLOR_SATURATEDLIME_GREEN = 0xaaff000;

  private static var mAccentColor = AppStorage.load(AppStorage.KEY_1_CFG_ACCENT_COLOR);
  private static var mAccentIndex = AppStorage.load(AppStorage.KEY_2_CFG_ACCENT_INDEX);
  private static var mTickmarkAccentColor = loadOrSetDefault(AppStorage.KEY_18_CFG_TICKMARK_ACCENT_COLOR, false);
  private static var mDarkLightTheme as Boolean = loadOrSetDefault(AppStorage.KEY_32_CFG_DARK_LIGHT_THEME, false);
  private static var mGarminlogo = loadOrSetDefault(AppStorage.KEY_3_CFG_GARMINLOGO, true);
  // prettier-ignore
  private static var mHourLabels = loadOrSetDefault(AppStorage.KEY_5_CFG_HOUR_LABELS, SCREEN_IS_ROUND_SHAPED ? true : false);
  private static var mWeatherCondition = loadOrSetDefault(AppStorage.KEY_25_CFG_WEATHER_CONDITION, true);
  private static var mTemperatureType = loadOrSetDefault(AppStorage.KEY_6_CFG_TEMPERATURE_TYPE, true);
  private static var mShowWeatherConditionName = loadOrSetDefault(AppStorage.KEY_7_CFG_WEATHER_CONDITION_NAME, true);
  private static var mBatteryIcon = loadOrSetDefault(AppStorage.KEY_26_CFG_BATTERY_ICON, true);
  // prettier-ignore
  private static var mFontSize = loadOrSetDefault(AppStorage.KEY_14_CFG_FONT_SIZE, SCREEN_IS_ROUND_SHAPED ? false : true);
  private static var mAlarmToggle = loadOrSetDefault(AppStorage.KEY_8_CFG_ALARM_TOGGLE, true);
  private static var mBluetoothToggle = loadOrSetDefault(AppStorage.KEY_4_CFG_BLUETOOTH_TOGGLE, true);
  private static var mHandsThickness = loadOrSetDefault(AppStorage.KEY_13_CFG_HANDS_THICKNESS, 2);
  private static var mRightBottomDF = loadOrSetDefault(AppStorage.KEY_12_CFG_RIGHT_BOTTOM_DF, 23);
  private static var mRightTopDF = loadOrSetDefault(AppStorage.KEY_17_CFG_RIGHT_TOP_DF, 23);
  private static var mLeftTopDF = loadOrSetDefault(AppStorage.KEY_9_CFG_LEFT_TOP_DF, 27);
  private static var mLeftMiddleDF = loadOrSetDefault(AppStorage.KEY_10_CFG_LEFT_MIDDLE_DF, 27);
  private static var mLeftBottomDF = loadOrSetDefault(AppStorage.KEY_11_CFG_LEFT_BOTTOM_DF, 23);
  private static var mBatteryEstFlag = loadOrSetDefault(AppStorage.KEY_19_CFG_BATTERY_EST_FLAG, false);
  private static var mPressuretype = loadOrSetDefault(AppStorage.KEY_20_CFG_PRESSURE_TYPE, false);
  private static var mAODColorMinute = loadOrSetDefault(AppStorage.KEY_22_CFG_AOD_COLOR_MINUTE, false);
  private static var mDateFormat = loadOrSetDefault(AppStorage.KEY_24_CFG_DATE_FORMAT, false);
  private static var mTemperatureUnit = loadOrSetDefault(AppStorage.KEY_16_CFG_TEMPERATURE_UNIT, false);
  // prettier-ignore
  private static var mHourLabelAccentColor = loadOrSetDefault(AppStorage.KEY_27_CFG_HOUR_LABELS_ACCENT_COLOR, SCREEN_IS_ROUND_SHAPED ? false : true);
  private static var mConditionalBatteryIconColor = loadOrSetDefault(AppStorage.KEY_28_CFG_CONDITIONAL_BATTERY_ICON_COLOR, true);
  private static var mDateFontSize = loadOrSetDefault(AppStorage.KEY_21_CFG_DATE_FONT_SIZE, true);
  // prettier-ignore
  private static var mSecondsHand as Boolean = loadOrSetDefault(AppStorage.KEY_33_CFG_SECONDS_HAND, SCREEN_IS_ROUND_SHAPED ? false : true);
  private static var mAppStorageConfigVersion = loadOrSetDefault(AppStorage.KEY_23_CFG_CURRENT_VERSION, 0);

  public static function init() as Void {
    setAccentColorsIfNeeded();

    migrateStoredConfigIfNeeded();

    updateAppVersionNumberIfNeeded();
  }

  public static function setAccentColor(value) {
    mAccentColor = value;
    AppStorage.persist(AppStorage.KEY_1_CFG_ACCENT_COLOR, value);
  }

  public static function setAccentIndex(value) {
    mAccentIndex = value;
    AppStorage.persist(AppStorage.KEY_2_CFG_ACCENT_INDEX, value);
  }

  public static function setTickmarkAccentColor(value) {
    mTickmarkAccentColor = value;
    AppStorage.persist(AppStorage.KEY_18_CFG_TICKMARK_ACCENT_COLOR, value);
  }

  public static function setDarkLightTheme(value) {
    mDarkLightTheme = value;
    AppStorage.persist(AppStorage.KEY_32_CFG_DARK_LIGHT_THEME, value);
  }

  public static function setGarminlogo(value) {
    mGarminlogo = value;
    AppStorage.persist(AppStorage.KEY_3_CFG_GARMINLOGO, value);
  }

  public static function setHourLabels(value) {
    mHourLabels = value;
    AppStorage.persist(AppStorage.KEY_5_CFG_HOUR_LABELS, value);
  }

  public static function setShowWeatherCondition(value) {
    mWeatherCondition = value;
    AppStorage.persist(AppStorage.KEY_25_CFG_WEATHER_CONDITION, value);
  }

  public static function setTemperatureType(value) {
    mTemperatureType = value;
    AppStorage.persist(AppStorage.KEY_6_CFG_TEMPERATURE_TYPE, value);
  }

  public static function setShowWeatherConditionName(value as Boolean) {
    mShowWeatherConditionName = value;
    AppStorage.persist(AppStorage.KEY_7_CFG_WEATHER_CONDITION_NAME, value);
  }

  public static function setBatteryIcon(value) {
    mBatteryIcon = value;
    AppStorage.persist(AppStorage.KEY_26_CFG_BATTERY_ICON, value);
  }

  public static function setFontSize(value) {
    mFontSize = value;
    AppStorage.persist(AppStorage.KEY_14_CFG_FONT_SIZE, value);
  }

  public static function setAlarmToggle(value) {
    mAlarmToggle = value;
    AppStorage.persist(AppStorage.KEY_8_CFG_ALARM_TOGGLE, value);
  }

  public static function setBluetoothToggle(value) {
    mBluetoothToggle = value;
    AppStorage.persist(AppStorage.KEY_4_CFG_BLUETOOTH_TOGGLE, value);
  }

  public static function setHandsThickness(value) {
    mHandsThickness = value;
    AppStorage.persist(AppStorage.KEY_13_CFG_HANDS_THICKNESS, value);
  }

  public static function setRightBottomDF(value) {
    mRightBottomDF = value;
    AppStorage.persist(AppStorage.KEY_12_CFG_RIGHT_BOTTOM_DF, value);
  }

  public static function setRightTopDF(value) {
    mRightTopDF = value;
    AppStorage.persist(AppStorage.KEY_17_CFG_RIGHT_TOP_DF, value);
  }

  public static function setLeftTopDF(value) {
    mLeftTopDF = value;
    AppStorage.persist(AppStorage.KEY_9_CFG_LEFT_TOP_DF, value);
  }

  public static function setLeftMiddleDF(value) {
    mLeftMiddleDF = value;
    AppStorage.persist(AppStorage.KEY_10_CFG_LEFT_MIDDLE_DF, value);
  }

  public static function setLeftBottomDF(value) {
    mLeftBottomDF = value;
    AppStorage.persist(AppStorage.KEY_11_CFG_LEFT_BOTTOM_DF, value);
  }

  public static function setBatteryEstFlag(value) {
    mBatteryEstFlag = value;
    AppStorage.persist(AppStorage.KEY_19_CFG_BATTERY_EST_FLAG, value);
  }

  public static function setAODColorMinute(value) {
    mAODColorMinute = value;
    AppStorage.persist(AppStorage.KEY_22_CFG_AOD_COLOR_MINUTE, value);
  }

  public static function setDateFormat(value) {
    mDateFormat = value;
    AppStorage.persist(AppStorage.KEY_24_CFG_DATE_FORMAT, value);
  }

  public static function setTemperatureUnit(value) {
    mTemperatureUnit = value;
    AppStorage.persist(AppStorage.KEY_16_CFG_TEMPERATURE_UNIT, value);
  }

  public static function setHourLabelAccentColor(value) {
    mHourLabelAccentColor = value;
    AppStorage.persist(AppStorage.KEY_27_CFG_HOUR_LABELS_ACCENT_COLOR, value);
  }

  public static function setConditionalBatteryIconColor(value) {
    mConditionalBatteryIconColor = value;
    AppStorage.persist(AppStorage.KEY_28_CFG_CONDITIONAL_BATTERY_ICON_COLOR, value);
  }

  public static function setDateFontSize(value) {
    mDateFontSize = value;
    AppStorage.persist(AppStorage.KEY_21_CFG_DATE_FONT_SIZE, value);
  }

  public static function setSecondsHand(value) {
    mSecondsHand = value;
    AppStorage.persist(AppStorage.KEY_33_CFG_SECONDS_HAND, value);
  }

  private static function setPressureType(value as Boolean) {
    mPressuretype = value;
    AppStorage.persist(AppStorage.KEY_20_CFG_PRESSURE_TYPE, value);
  }

  public static function getAccentColor() {
    return mAccentColor;
  }

  public static function getAccentIndex() {
    return mAccentIndex;
  }

  public static function getTickmarkAccentColor() {
    return mTickmarkAccentColor;
  }

  public static function getDarkLightTheme() {
    return mDarkLightTheme;
  }

  public static function getGarminlogo() {
    return mGarminlogo;
  }

  public static function getHourLabels() {
    return mHourLabels;
  }

  public static function showWeatherCondition() {
    return mWeatherCondition;
  }

  public static function getTemperatureType() {
    return mTemperatureType;
  }

  public static function showWeatherConditionName() {
    return mShowWeatherConditionName;
  }

  public static function getBatteryIcon() {
    return mBatteryIcon;
  }

  public static function getFontSize() {
    return mFontSize;
  }

  public static function getAlarmToggle() {
    return mAlarmToggle;
  }

  public static function getBluetoothToggle() {
    return mBluetoothToggle;
  }

  public static function getHandsThickness() {
    return mHandsThickness;
  }

  public static function getRightBottomDF() {
    return mRightBottomDF;
  }

  public static function getRightTopDF() {
    return mRightTopDF;
  }

  public static function getLeftTopDF() {
    return mLeftTopDF;
  }

  public static function getLeftMiddleDF() {
    return mLeftMiddleDF;
  }

  public static function getLeftBottomDF() {
    return mLeftBottomDF;
  }

  public static function getBatteryEstFlag() {
    return mBatteryEstFlag;
  }

  public static function getAODColorMinute() {
    return mAODColorMinute;
  }

  public static function getDateFormat() {
    return mDateFormat;
  }

  public static function getTemperatureUnit() {
    return mTemperatureUnit;
  }

  public static function getHourLabelAccentColor() {
    return mHourLabelAccentColor;
  }

  public static function getConditionalBatteryIconColor() {
    return mConditionalBatteryIconColor;
  }

  public static function getDateFontSize() {
    return mDateFontSize;
  }

  public static function getSecondsHand() {
    return mSecondsHand;
  }

  public static function showWeather() as Boolean {
    if (Toybox has :Weather and Toybox.Weather has :getCurrentConditions){
        if(showWeatherCondition() || showWeatherConditionName()){
            return true;
        } 
    }
    return false;
  }


  private static function getCurrentVersion() as Numeric {
    return CURRENT_APP_VERSION;
  }

  private static function getPressureType() as Boolean {
    return mPressuretype;
  }

  private static function loadOrSetDefault(storageKey as Integer, defaultValue) {
    var value = AppStorage.load(storageKey);
    if (value == null) {
      AppStorage.persist(storageKey, defaultValue);
      return defaultValue;
    }
    return value;
  }

  private static function migrateStoredConfigIfNeeded() as Void {
    if (getDateFontSize() instanceof Array) {
      Storage.deleteValue(AppStorage.KEY_21_CFG_DATE_FONT_SIZE);
      setDateFontSize(true);
    }
  }

  private static function updateAppVersionNumberIfNeeded() as Void {
    if (CURRENT_APP_VERSION != mAppStorageConfigVersion) {
      mAppStorageConfigVersion = CURRENT_APP_VERSION;
      AppStorage.persist(AppStorage.KEY_23_CFG_CURRENT_VERSION, mAppStorageConfigVersion);
    }
  }

  private static function setAccentColorsIfNeeded() as Void {
    if (getAccentColor() == null or getAccentIndex() == null) {
      if (isAMOLEDDisplay()) {
        // AMOLED
        setAccentIndex(1);
        setAccentColor(COLOR_SATURATEDLIME_GREEN);
      } else {
        setAccentIndex(0);
        setAccentColor(COLOR_BRIGHT_LIME_GREEN); // Bright Green
      }
    }
  }

  private static function isAMOLEDDisplay() as Boolean {
    return System.getDeviceSettings().screenWidth >= 360;
  }
}

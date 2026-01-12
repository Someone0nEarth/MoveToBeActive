import Toybox.Application;
import Toybox.Lang;
import Toybox.System;
import Toybox.Graphics;

class Config {
  private static const CURRENT_APP_VERSION = 534;
  public static const SCREEN_IS_ROUND_SHAPED = System.SCREEN_SHAPE_ROUND == System.getDeviceSettings().screenShape;

  private static const COLOR_BRIGHT_LIME_GREEN = 0x55ff00;
  private static const COLOR_SATURATEDLIME_GREEN = 0xaaff000;

  private static var mAccentColor;
  private static var mAccentColorID;
  private static var mTickmarkAccentColor;
  private static var mLightTheme;
  private static var mGarminlogo;
  private static var mHourLabels;
  private static var mWeatherCondition;
  private static var mRealTemperatureType;
  private static var mShowWeatherConditionName;
  private static var mBatteryIcon;
  private static var mFontSize;
  private static var mAlarmToggle;
  private static var mBluetoothToggle;
  private static var mHandsThickness;
  private static var mRightBottomDF;
  private static var mRightTopDF;
  private static var mLeftTopDF;
  private static var mLeftMiddleDF;
  private static var mLeftBottomDF;
  private static var mBatteryEstFlag;
  private static var mPressuretype;
  private static var mAodUseAccentColor;
  private static var mDateFormat;
  private static var mWindSpeedUnit;
  private static var mTemperatureAlwaysCelsius;
  private static var mHourLabelAccentColor;
  private static var mConditionalBatteryIconColor;
  private static var mDateFontSize;
  private static var mSecondsHand;
  private static var mAppStorageConfigVersion;

  private static function init() {
    mAccentColor = AppStorage.load(AppStorage.KEY_1_CFG_ACCENT_COLOR);
    mAccentColorID = AppStorage.load(AppStorage.KEY_2_CFG_ACCENT_COLOR_ID);
    mTickmarkAccentColor = loadOrSetDefault(AppStorage.KEY_18_CFG_TICKMARK_ACCENT_COLOR, false);
    mLightTheme = loadOrSetDefault(AppStorage.KEY_32_CFG_LIGHT_THEME, false);
    mGarminlogo = loadOrSetDefault(AppStorage.KEY_3_CFG_GARMINLOGO, true);
    mHourLabels = loadOrSetDefault(AppStorage.KEY_5_CFG_HOUR_LABELS, SCREEN_IS_ROUND_SHAPED ? true : false);
    mWeatherCondition = loadOrSetDefault(AppStorage.KEY_25_CFG_WEATHER_CONDITION, true);
    mRealTemperatureType = loadOrSetDefault(AppStorage.KEY_6_CFG_REAL_TEMPERATURE_TYPE, true);
    mShowWeatherConditionName = loadOrSetDefault(AppStorage.KEY_7_CFG_WEATHER_CONDITION_NAME, true);
    mBatteryIcon = loadOrSetDefault(AppStorage.KEY_26_CFG_BATTERY_ICON, true);
    mFontSize = loadOrSetDefault(AppStorage.KEY_14_CFG_FONT_SIZE, SCREEN_IS_ROUND_SHAPED ? false : true);
    mAlarmToggle = loadOrSetDefault(AppStorage.KEY_8_CFG_ALARM_TOGGLE, true);
    mBluetoothToggle = loadOrSetDefault(AppStorage.KEY_4_CFG_BLUETOOTH_TOGGLE, true);
    mHandsThickness = loadOrSetDefault(AppStorage.KEY_13_CFG_HANDS_THICKNESS, HandsThicknessSettings.STANDARD);
    mRightBottomDF = loadOrSetDefault(AppStorage.KEY_12_CFG_RIGHT_BOTTOM_DF, 23);
    mRightTopDF = loadOrSetDefault(AppStorage.KEY_17_CFG_RIGHT_TOP_DF, 23);
    mLeftTopDF = loadOrSetDefault(AppStorage.KEY_9_CFG_LEFT_TOP_DF, 27);
    mLeftMiddleDF = loadOrSetDefault(AppStorage.KEY_10_CFG_LEFT_MIDDLE_DF, 27);
    mLeftBottomDF = loadOrSetDefault(AppStorage.KEY_11_CFG_LEFT_BOTTOM_DF, 23);
    mBatteryEstFlag = loadOrSetDefault(AppStorage.KEY_19_CFG_BATTERY_EST_FLAG, false);
    mPressuretype = loadOrSetDefault(AppStorage.KEY_20_CFG_PRESSURE_TYPE, false);
    mAodUseAccentColor = loadOrSetDefault(AppStorage.KEY_22_CFG_AOD_USE_ACCENT_COLOR, false);
    mDateFormat = loadOrSetDefault(AppStorage.KEY_24_CFG_DATE_FORMAT, false);
    mWindSpeedUnit = loadOrSetDefault(AppStorage.KEY_15_CFG_WINDSPEED_UNIT, WindSpeedUnitSettings.KPH_OR_MPH);
    mTemperatureAlwaysCelsius = loadOrSetDefault(AppStorage.KEY_16_CFG_TEMPERATURE_ALWAYS_CELSIUS, false);
    // prettier-ignore
    mHourLabelAccentColor = loadOrSetDefault(AppStorage.KEY_27_CFG_HOUR_LABELS_ACCENT_COLOR, SCREEN_IS_ROUND_SHAPED ? false : true); //TODO find better solution to set default when screen is rounded?
    mConditionalBatteryIconColor = loadOrSetDefault(AppStorage.KEY_28_CFG_CONDITIONAL_BATTERY_ICON_COLOR, true);
    mDateFontSize = loadOrSetDefault(AppStorage.KEY_21_CFG_DATE_FONT_SIZE, true);
    mSecondsHand = loadOrSetDefault(AppStorage.KEY_33_CFG_SECONDS_HAND, SCREEN_IS_ROUND_SHAPED ? false : true);
    mAppStorageConfigVersion = loadOrSetDefault(AppStorage.KEY_23_CFG_CURRENT_VERSION, 0);
  }

  public static function load() as Void {
    init();

    setAccentColorsIfNeeded();

    adjustAccentColorForThemesLegacy();

    migrateStoredConfigIfNeeded();

    adjustStoredConfigIfNeeded();

    updateAppVersionNumberIfNeeded();
  }

  public static function setAccentColor(value) {
    mAccentColor = value;
    AppStorage.persist(AppStorage.KEY_1_CFG_ACCENT_COLOR, value);
  }

  public static function setAccentColorID(value) {
    mAccentColorID = value;
    AppStorage.persist(AppStorage.KEY_2_CFG_ACCENT_COLOR_ID, value);
  }

  public static function setTickmarkAccentColor(value) {
    mTickmarkAccentColor = value;
    AppStorage.persist(AppStorage.KEY_18_CFG_TICKMARK_ACCENT_COLOR, value);
  }

  public static function setLightTheme(value) {
    mLightTheme = value;
    AppStorage.persist(AppStorage.KEY_32_CFG_LIGHT_THEME, value);
    adjustAccentColorForThemesLegacy();
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

  public static function setRealTemperatureType(value) {
    mRealTemperatureType = value;
    AppStorage.persist(AppStorage.KEY_6_CFG_REAL_TEMPERATURE_TYPE, value);
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

  public static function setHandsThickness(value as HandsThicknessSettings.HandsThicknessLevel) {
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

  public static function setAodUseAccentColor(value as Boolean) {
    mAodUseAccentColor = value;
    AppStorage.persist(AppStorage.KEY_22_CFG_AOD_USE_ACCENT_COLOR, value);
  }

  public static function setDateFormat(value) {
    mDateFormat = value;
    AppStorage.persist(AppStorage.KEY_24_CFG_DATE_FORMAT, value);
  }

  public static function setTemperatureAlwaysCelsius(value) {
    mTemperatureAlwaysCelsius = value;
    AppStorage.persist(AppStorage.KEY_16_CFG_TEMPERATURE_ALWAYS_CELSIUS, value);
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

  public static function setPressureType(value as Boolean) {
    mPressuretype = value;
    AppStorage.persist(AppStorage.KEY_20_CFG_PRESSURE_TYPE, value);
  }

  public static function setWindSpeedUnit(value as WindSpeedUnitSettings.WindSpeedUnit) as Void {
    mWindSpeedUnit = value;
    AppStorage.persist(AppStorage.KEY_15_CFG_WINDSPEED_UNIT, value);
  }

  public static function getAccentColor() {
    return mAccentColor;
  }

  public static function getAccentColorID() {
    return mAccentColorID;
  }

  public static function getTickmarkAccentColor() {
    return mTickmarkAccentColor;
  }

  public static function getLightTheme() {
    return mLightTheme;
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

  public static function getRealTemperatureType() {
    return mRealTemperatureType;
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

  public static function getHandsThickness() as HandsThicknessSettings.HandsThicknessLevel {
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

  public static function getAodUseAccentColor() as Boolean {
    return mAodUseAccentColor;
  }

  public static function getDateFormat() {
    return mDateFormat;
  }

  public static function getTemperatureAlwaysCelsius() {
    return mTemperatureAlwaysCelsius;
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

  public static function getWindSpeedUnit() as WindSpeedUnitSettings.WindSpeedUnit {
    return mWindSpeedUnit;
  }

  public static function showWeather() as Boolean {
    if (Toybox has :Weather and (Toybox.Weather has :getCurrentConditions)) {
      if (showWeatherCondition() || showWeatherConditionName()) {
        return true;
      }
    }
    return false;
  }

  private static function getCurrentVersion() as Numeric {
    return CURRENT_APP_VERSION;
  }

  public static function getPressureType() as Boolean {
    return mPressuretype;
  }

  public static function getFontColor() as Number {
    return (Config.getLightTheme() ? Graphics.COLOR_BLACK : Graphics.COLOR_WHITE);
  }

  private static function loadOrSetDefault(storageKey as AppStorage.StorageKey, defaultValue) {
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

  private static function adjustStoredConfigIfNeeded() as Void {
    if(!SCREEN_IS_ROUND_SHAPED){
        if(getHourLabels()){
            setHourLabels(false);
        }
    }    
  }

  private static function updateAppVersionNumberIfNeeded() as Void {
    if (CURRENT_APP_VERSION != mAppStorageConfigVersion) {
      mAppStorageConfigVersion = CURRENT_APP_VERSION;
      AppStorage.persist(AppStorage.KEY_23_CFG_CURRENT_VERSION, mAppStorageConfigVersion);
    }
  }

  private static function setAccentColorsIfNeeded() as Void {
    if (getAccentColor() == null or getAccentColorID() == null) {
      //TODO Figuring out, why AMOLED color is different (and is this chekced & set only here?)
      //TODO Should not light/dark theme to be considered?
      if (isAMOLEDDisplay()) {
        // AMOLED
        setAccentColorID(1);
        setAccentColor(COLOR_SATURATEDLIME_GREEN);
      } else {
        setAccentColorID(0);
        setAccentColor(COLOR_BRIGHT_LIME_GREEN); // Bright Green
      }
    }
  }

  private static function adjustAccentColorForThemesLegacy() {
    var accIndex = getAccentColorID();

    if (getLightTheme()) {
      var colors = Application.loadResource(Rez.JsonData.mColorsWhite) as Array;
      Config.setAccentColor(colors[accIndex]);
    } else {
      var colors = Application.loadResource(Rez.JsonData.mColors) as Array;
      Config.setAccentColor(colors[accIndex]);
    }
  }

  public static function isAMOLEDDisplay() as Boolean {
    return System.getDeviceSettings().screenWidth >= 360; //TODO get rid of magic number here and use a proper method to detect AMOLED displays (also reeplace it in the rest of the code)
  }
}

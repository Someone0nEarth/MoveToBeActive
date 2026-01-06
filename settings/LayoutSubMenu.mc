import Toybox.WatchUi;
import Toybox.Lang;

class SettingsLayoutMenu extends WatchUi.Menu2 {
  public function initialize() {
    Menu2.initialize({ :title => "Layout" });

    // prettier-ignore
    SettingsMainMenu.toggleItem(self, "Garmin Logo", "ON", "OFF", AppStorage.KEY_3_CFG_GARMINLOGO, Config.getGarminlogo());
    // prettier-ignore
    SettingsMainMenu.toggleItem(self, "Bluetooth Logo", "ON", "OFF", AppStorage.KEY_4_CFG_BLUETOOTH_TOGGLE , Config.getBluetoothToggle());
    // prettier-ignore
    SettingsMainMenu.toggleItem(self, "Alarm Icon", "ON", "OFF", AppStorage.KEY_8_CFG_ALARM_TOGGLE, Config.getAlarmToggle());
    // prettier-ignore
    SettingsMainMenu.toggleItem(self, "Battery Icon", "ON", "OFF", AppStorage.KEY_26_CFG_BATTERY_ICON, Config.getBatteryIcon());
    // prettier-ignore
    SettingsMainMenu.toggleItem(self, "Battery Color", "Conditional", "Always Gray", AppStorage.KEY_28_CFG_CONDITIONAL_BATTERY_ICON_COLOR, Config.getConditionalBatteryIconColor());

    if (System.SCREEN_SHAPE_ROUND == System.getDeviceSettings().screenShape) {
      // prettier-ignore
      SettingsMainMenu.toggleItem(self, "Hour Labels", "ON", "OFF", AppStorage.KEY_5_CFG_HOUR_LABELS, Config.getHourLabels());
      // prettier-ignore
      SettingsMainMenu.toggleItem(self, "Labels Color", "Accent", "Default", AppStorage.KEY_27_CFG_HOUR_LABELS_ACCENT_COLOR, Config.getHourLabelAccentColor());
    }

    // prettier-ignore
    SettingsMainMenu.toggleItem(self, "Tickmark Color", "Accent", "Default", AppStorage.KEY_18_CFG_TICKMARK_ACCENT_COLOR, Config.getTickmarkAccentColor());

    if (Toybox has :Weather and (Toybox.Weather has :getCurrentConditions)) {
      // has weather, doesn't show these for Fenix 5 Plus series
      // prettier-ignore
      SettingsMainMenu.toggleItem(self, "Weather Condition", "ON", "OFF", AppStorage.KEY_25_CFG_WEATHER_CONDITION, Config.showWeatherCondition());
      // prettier-ignore
      SettingsMainMenu.toggleItem(self, "Condition Name", "ON", "OFF", AppStorage.KEY_7_CFG_WEATHER_CONDITION_NAME, Config.showWeatherConditionName());
    }

    // allow these extra features only for LCD and AMOLED devices
    if (System.getDeviceSettings().requiresBurnInProtection) {
      // prettier-ignore
      SettingsMainMenu.toggleItem(self, "AOD Colors", "Accent", "Grayscale", AppStorage.KEY_22_CFG_AOD_USE_ACCENT_COLOR, Config.getAodUseAccentColor());
    }

    if (System.SCREEN_SHAPE_ROUND == System.getDeviceSettings().screenShape) {
      //check if rounded display
      // prettier-ignore
      SettingsMainMenu.toggleItem(self, "Seconds Hand", "On", "Off", AppStorage.KEY_33_CFG_SECONDS_HAND, Config.getSecondsHand());
    }

    SettingsMainMenu.iconMenuItem(self, "Hands Thickness", new HandsThicknessSettings());
  }

  function onBack() {
    WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
  }
}

class HandsThicknessSettings extends WatchUi.Drawable {
  public static enum HandsThicknessLevel {
    STANDARD = 0,
    THICKER = 1,
    THINNER = 2,
  }

  private var HAND_THICKNESS_LEVEL_LABELS = ["Standard", "Thicker", "Thinner"];

  function initialize() {
    Drawable.initialize({});
  }

  function currentSettingLabel() as String {
    return HAND_THICKNESS_LEVEL_LABELS[Config.getHandsThickness()];
  }

  function setNextSetting() as String {
    var nextSetting = Config.getHandsThickness() + 1;
    if (nextSetting >= HAND_THICKNESS_LEVEL_LABELS.size()) {
      nextSetting = HandsThicknessSettings.STANDARD;
    }
    Config.setHandsThickness(nextSetting);
    return currentSettingLabel();
  }

  public function getItemID() {
    return AppStorage.KEY_13_CFG_HANDS_THICKNESS;
  }

  public function getIcon() as WatchUi.Drawable {
    return self;
  }
}

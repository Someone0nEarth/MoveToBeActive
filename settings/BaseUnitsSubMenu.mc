import Toybox.WatchUi;
import Toybox.Lang;

class SettingsUnitsMenu extends WatchUi.Menu2 {
  public function initialize() {
    Menu2.initialize({ :title => "Units" });

    if (System.getSystemStats() has :batteryInDays) {
      // prettier-ignore
      SettingsMainMenu.toggleItem(self, "Battery Estimate", "ON", "OFF", AppStorage.KEY_19_CFG_BATTERY_EST_FLAG, Config.getBatteryEstFlag());
    }

    var today = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG);
    // prettier-ignore
    SettingsMainMenu.toggleItem(self, "Date Format", Lang.format("$2$ $1$", [today.month, today.day]), Lang.format("$1$ $2$", [today.month, today.day]), AppStorage.KEY_24_CFG_DATE_FORMAT, Config.getDateFormat());
    // prettier-ignore
    SettingsMainMenu.toggleItem(self, "Date Size", "Standard", "Small", AppStorage.KEY_21_CFG_DATE_FONT_SIZE, Config.getDateFontSize());

    // prettier-ignore
    if (Toybox has :Weather && Toybox.Weather has :getCurrentConditions && Toybox.Weather.getCurrentConditions()!=null){
                if (Activity.getActivityInfo() has :rawAmbientPressure){
                    // prettier-ignore
                    SettingsMainMenu.toggleItem(self, "Atm. Pres. Unit", "hPa", "inHg", AppStorage.KEY_20_CFG_PRESSURE_TYPE, Config.getPressureType()); 
                }

                // prettier-ignore
                SettingsMainMenu.toggleItem(self, "Temp. Type", "Real Temperature", "Feels Like", AppStorage.KEY_6_CFG_TEMPERATURE_TYPE, Config.getTemperatureType());
                // prettier-ignore
                SettingsMainMenu.toggleItem(self, "Temp. Unit", "Always Celsius", "User Settings", AppStorage.KEY_16_CFG_TEMPERATURE_UNIT, Config.getTemperatureUnit());

                SettingsMainMenu.iconMenuItem(self, "Wind Speed Unit", new WindSpeedUnitSettings());
            }
  }
}

(:weather)
class WindSpeedUnitSettings extends WatchUi.Drawable {
  public static enum WindSpeedUnit {
    KPH_OR_MPH = 0,
    METER_PER_SECONDS = 1,
    KNOTS = 2,
  }

  private var WIND_SPEED_LABELS = ["km/h or mph", "m/s", "knots"];

  function initialize() {
    Drawable.initialize({});
  }

  public function currentSettingLabel() as String {
    return WIND_SPEED_LABELS[Config.getWindSpeedUnit()];
  }

  public function setNextSetting() as String {
    var nextSetting = Config.getWindSpeedUnit() + 1;
    if (nextSetting >= WIND_SPEED_LABELS.size()) {
      nextSetting = WindSpeedUnitSettings.KPH_OR_MPH;
    }
    Config.setWindSpeedUnit(nextSetting);

    return currentSettingLabel();
  }

  public function getItemID() {
    return AppStorage.KEY_15_CFG_WINDSPEED_UNIT;
  }

  public function getIcon() as WatchUi.Drawable {
    return self;
  }
}

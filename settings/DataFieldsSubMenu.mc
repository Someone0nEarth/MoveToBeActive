import Toybox.WatchUi;
import Toybox.Lang;

class SettingsDataFieldsMenu extends WatchUi.Menu2 {

    public function initialize() {
        Menu2.initialize({:title=>"Data"});

            SettingsMainMenu.iconMenuItem(self, "Left Top", DataPointSettings.big(AppStorage.KEY_9_CFG_LEFT_TOP_DF));

            SettingsMainMenu.iconMenuItem(self, "Left Middle", DataPointSettings.big(AppStorage.KEY_10_CFG_LEFT_MIDDLE_DF));

            SettingsMainMenu.iconMenuItem(self, "Left Bottom", DataPointSettings.small(AppStorage.KEY_11_CFG_LEFT_BOTTOM_DF));

            SettingsMainMenu.iconMenuItem(self, "Right Top", DataPointSettings.small(AppStorage.KEY_17_CFG_RIGHT_TOP_DF));
            
            SettingsMainMenu.iconMenuItem(self, "Right Bottom", DataPointSettings.small(AppStorage.KEY_12_CFG_RIGHT_BOTTOM_DF));

		   	if (System.SCREEN_SHAPE_ROUND == System.getDeviceSettings().screenShape) { //check if rounded display
                SettingsMainMenu.toggleItem(self, "Font Size", "Bigger", "Standard", AppStorage.KEY_14_CFG_FONT_SIZE, Config.getFontSize());
            }
    }
}

class DataPointSettings extends WatchUi.Drawable {

   private var mConfigID as AppStorage.StorageKey;

   private var mSettingsLabels;
   private var mSettingsIconsRessourceName;

   private function initialize(settingID as AppStorage.StorageKey) {
        Drawable.initialize({});
        mConfigID=settingID;
    }

    public static function small(configID as AppStorage.StorageKey) as DataPointSettings {
        var datapoint = new DataPointSettings(configID);
        datapoint.useSmall();
        return datapoint;
    }

    public static function big(configID as AppStorage.StorageKey) as DataPointSettings {
        var datapoint = new DataPointSettings(configID);
        datapoint.useBig();
        return datapoint;
    }

    //TODO extract duplicated strings into vars
    //TODO Try to set Lables via constructor parameter (maybe proving the weather capability through the caller)

    public function useSmall(){
        mSettingsLabels = ["Steps", (Toybox has :Weather and Toybox.Weather has :getCurrentConditions)?"Humidity":"Not Available", (Toybox has :Weather and Toybox.Weather has :getCurrentConditions)?"Precipitation":"Not Available", (Activity.getActivityInfo() has :rawAmbientPressure) ? "Atm. Pressure" : "Not available", "Calories Total", "Calories Active", (ActivityMonitor.getInfo() has :floorsClimbed)?"Floors Climbed":"Not Available", (Activity.getActivityInfo() has :currentOxygenSaturation)?"Pulse Ox":"Not available" , "Heart Rate", "Notifications", (System.getSystemStats() has :solarIntensity and System.getSystemStats().solarIntensity != null) ? "Solar Intensity" : "Not available", "Seconds", "Digital Clock", "Intensity Min.", ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getBodyBatteryHistory))?"Body Battery":"Not Available", ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getStressHistory))?"Stress":"Not Available", (ActivityMonitor.getInfo() has :respirationRate)?"Respiration Rate":"Not Available", (ActivityMonitor.getInfo() has :timeToRecovery)?"Recovery Time":"Not Available", (UserProfile.getProfile() has :vo2maxRunning)?"VO2 Max Run":"Not Available", (UserProfile.getProfile() has :vo2maxCycling)?"VO2 Max Cycle":"Not Available", ((Toybox has :Weather) && (Weather has :getSunset and Weather has :getSunrise))?"Next Sun Event":"Not Available", "Battery %/day", (Toybox has :Weather and Toybox.Weather has :getHourlyForecast)?"2h Forecast":"Not Available", "None"];
        mSettingsIconsRessourceName = Rez.JsonData.mIcons9;
    }

    public function useBig(){
        mSettingsLabels=["Steps", "Distance", "Elevation", (Toybox has :Weather and Toybox.Weather has :getCurrentConditions)?"Wind Speed":"Not Available", (Toybox has :Weather and Toybox.Weather has :getCurrentConditions)?"Min/Max Temp.":"Not Available", (Toybox has :Weather and Toybox.Weather has :getCurrentConditions)?"Humidity":"Not Available", (Toybox has :Weather and Toybox.Weather has :getCurrentConditions)?"Precipitation":"Not Available", (Activity.getActivityInfo() has :rawAmbientPressure) ? "Atm. Pressure" : "Not available", "Calories Total", "Calories Active",  (ActivityMonitor.getInfo() has :floorsClimbed)?"Floors Climbed":"Not Available", (Activity.getActivityInfo() has :currentOxygenSaturation)?"Pulse Ox":"Not available", "Heart Rate", "Notifications",(System.getSystemStats() has :solarIntensity and System.getSystemStats().solarIntensity != null) ? "Solar Intensity" : "Not available", "Seconds", "Digital Clock", "Intensity Min.", ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getBodyBatteryHistory))?"Body Battery":"Not Available", ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getStressHistory))?"Stress":"Not Available", (ActivityMonitor.getInfo() has :respirationRate)?"Respiration Rate":"Not Available", (ActivityMonitor.getInfo() has :timeToRecovery)?"Recovery Time":"Not Available", (UserProfile.getProfile() has :vo2maxRunning)?"VO2 Max Run":"Not Available", (UserProfile.getProfile() has :vo2maxCycling)?"VO2 Max Cycle":"Not Available", ((Toybox has :Weather) && (Weather has :getSunset and Weather has :getSunrise))?"Next Sun Event":"Not Available", "Battery %/day", (Toybox has :Weather and Toybox.Weather has :getHourlyForecast)?"3h Forecast":"Not Available", "None"];
        mSettingsIconsRessourceName = Rez.JsonData.mIcons12;
    }

    function currentSettingLabel() as String{
        return mSettingsLabels[AppStorage.load(mConfigID)]; //TODO get rid of warning
    }

    function setNextSetting() as String{
        var nextSetting=AppStorage.load(mConfigID)+1;
        if(nextSetting >= mSettingsLabels.size()) {
            nextSetting = 0;
        }
        AppStorage.persist(mConfigID, nextSetting);
        return currentSettingLabel();
    }

    public function getItemID(){
        return mConfigID;
    }
 
    function draw(dc) {
        var icons = Application.loadResource(mSettingsIconsRessourceName) as Array;

		var color = Config.getAccentColor();
        if (color==Graphics.COLOR_WHITE){ color=Graphics.COLOR_LT_GRAY; } //TODO figuring out, why white color is set to gray. And if there better ways to solve the purpose of it
		
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        var iconsFont = Application.loadResource(Rez.Fonts.IconsFont);
        var icon = icons[AppStorage.load(mConfigID)];
        dc.drawText( dc.getWidth()/2, dc.getHeight()/3, iconsFont, icon , Graphics.TEXT_JUSTIFY_CENTER);

        dc.clear();
    }
}

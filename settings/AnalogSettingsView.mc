//
// Copyright 2016-2017 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;
import Toybox.Application;
import Toybox.Application.Storage;


class SettingsMainMenuDelegate extends WatchUi.Menu2InputDelegate {

    public function initialize() {
        Menu2InputDelegate.initialize();
        
    }

    public function onSelect(item) as Void {

        if (item has :getIcon && item.getIcon() != null && item.getIcon() has :setNextSetting){ 
                item.setSubLabel(item.getIcon().setNextSetting());

        } else if (item instanceof WatchUi.ToggleMenuItem  and item.getId() instanceof Number) {
            AppStorage.persist(item.getId() as AppStorage.StorageKey, item.isEnabled());

        } else if( item.getId().equals(:layout) ) {
            WatchUi.pushView(new SettingsLayoutMenu(), self, WatchUi.SLIDE_UP );

        } else if( item.getId().equals(:data_fields) ) {
            WatchUi.pushView(new SettingsDataFieldsMenu(), self, WatchUi.SLIDE_UP );

        } else if( item.getId().equals(:units) ) {
           WatchUi.pushView(new SettingsUnitsMenu(), self, WatchUi.SLIDE_UP );
        }
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }
}

class SettingsMainMenu extends WatchUi.Menu2 {

    private var MENU_LAYOUT_TITLE = "Layout";
    private var MENU_DATAFIELDS_TITLE = "Data Fields";
    private var MENU_UNITS_TITLE = "Base Units";
    private var MENU_THEME_TITLE = "Theme";

    public function initialize() {
        Menu2.initialize({:title=>new SettingsMenuTitle()});

        iconMenuItem(self, "Accent Color", new AccentColorSettings());

        toggleItem(self, MENU_THEME_TITLE, "Light", "Dark", AppStorage.KEY_32_CFG_LIGHT_THEME, Config.getLightTheme());

        menuItem(self, MENU_LAYOUT_TITLE, :layout);

        menuItem(self, MENU_DATAFIELDS_TITLE, :data_fields);
        
        if (Toybox has :Weather or System.getSystemStats() has :batteryInDays){ // 
            menuItem(self, MENU_UNITS_TITLE, :units);
        }
    }

    public static function menuItem(menu as Menu2, title as String, id) as Void{
        menu(menu, new WatchUi.MenuItem(title, null, id, null));
    }

    private static function menu(menu as Menu2, item as WatchUi.MenuItem) as Void{
        menu.addItem(item);
    }

    public static function iconMenuItem(menu as Menu2, lable as String, item as SettingsItem) as Void{
        menu.addItem(new WatchUi.IconMenuItem(lable, item.currentSettingLabel(), item.getItemID(), item as WatchUi.Drawable, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT})); 
    }

    public static function toggleItem(menu as Menu2, title as String, enabledLabel as String, disabledLabel as String, storageKey as AppStorage.StorageKey, currentValue as Boolean) as Void{
        menu.addItem(new WatchUi.ToggleMenuItem(title, {:enabled=>enabledLabel, :disabled=>disabledLabel}, storageKey, currentValue, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
    }
}

class SettingsUnitsMenu extends WatchUi.Menu2 {         

    private var MENU_UNITS_TITLE_SHORT = "Units";

    public function initialize() {
        Menu2.initialize({:title=>MENU_UNITS_TITLE_SHORT});


            if (System.getSystemStats() has :batteryInDays){
                SettingsMainMenu.toggleItem(self, "Battery Estimate", "ON", "OFF", AppStorage.KEY_19_CFG_BATTERY_EST_FLAG, Config.getBatteryEstFlag());
            }

            var today = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG);
            SettingsMainMenu.toggleItem(self, "Date Format", Lang.format("$2$ $1$", [today.month, today.day]), Lang.format("$1$ $2$", [today.month, today.day]), AppStorage.KEY_24_CFG_DATE_FORMAT, Config.getDateFormat());
            SettingsMainMenu.toggleItem(self, "Date Size", "Standard", "Small", AppStorage.KEY_21_CFG_DATE_FONT_SIZE, Config.getDateFontSize());

            if (Toybox has :Weather and Toybox.Weather has :getCurrentConditions and Toybox.Weather.getCurrentConditions()!=null){
                if (Activity.getActivityInfo() has :rawAmbientPressure){
                    SettingsMainMenu.toggleItem(self, "Atm. Pres. Unit", "hPa", "inHg", AppStorage.KEY_20_CFG_PRESSURE_TYPE, Config.getPressureType()); 
                }

                SettingsMainMenu.toggleItem(self, "Temp. Type", "Real Temperature", "Feels Like", AppStorage.KEY_6_CFG_TEMPERATURE_TYPE, Config.getTemperatureType());

                SettingsMainMenu.toggleItem(self, "Temp. Unit", "Always Celsius", "User Settings", AppStorage.KEY_16_CFG_TEMPERATURE_UNIT, Config.getTemperatureUnit());

                SettingsMainMenu.iconMenuItem(self, "Wind Speed Unit", new WindSpeedUnitSettings());
            }
    }

}
class SettingsDataFieldsMenu extends WatchUi.Menu2 {

    private var MENU_DATAFIELDS_TITLE_SHORT = "Data";

    public function initialize() {
        Menu2.initialize({:title=>MENU_DATAFIELDS_TITLE_SHORT});

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

class SettingsLayoutMenu extends WatchUi.Menu2 {

    private var MENU_LAYOUT_TITLE = "Layout";

    public function initialize() {
        Menu2.initialize({:title=>MENU_LAYOUT_TITLE});

		    SettingsMainMenu.toggleItem(self, "Garmin Logo", "ON", "OFF", AppStorage.KEY_3_CFG_GARMINLOGO, Config.getGarminlogo());
            SettingsMainMenu.toggleItem(self, "Bluetooth Logo", "ON", "OFF", AppStorage.KEY_4_CFG_BLUETOOTH_TOGGLE , Config.getBluetoothToggle());
            SettingsMainMenu.toggleItem(self, "Alarm Icon", "ON", "OFF", AppStorage.KEY_8_CFG_ALARM_TOGGLE, Config.getAlarmToggle());
            SettingsMainMenu.toggleItem(self, "Battery Icon", "ON", "OFF", AppStorage.KEY_26_CFG_BATTERY_ICON, Config.getBatteryIcon());
            SettingsMainMenu.toggleItem(self, "Battery Color", "Conditional", "Always Gray", AppStorage.KEY_28_CFG_CONDITIONAL_BATTERY_ICON_COLOR, Config.getConditionalBatteryIconColor());

            if (System.SCREEN_SHAPE_ROUND == System.getDeviceSettings().screenShape) {
                SettingsMainMenu.toggleItem(self, "Hour Labels", "ON", "OFF", AppStorage.KEY_5_CFG_HOUR_LABELS, Config.getHourLabels());
                SettingsMainMenu.toggleItem(self, "Labels Color", "Accent", "Default", AppStorage.KEY_27_CFG_HOUR_LABELS_ACCENT_COLOR, Config.getHourLabelAccentColor());
            }

            SettingsMainMenu.toggleItem(self, "Tickmark Color", "Accent", "Default", AppStorage.KEY_18_CFG_TICKMARK_ACCENT_COLOR, Config.getTickmarkAccentColor());

            if (Toybox has :Weather and Toybox.Weather has :getCurrentConditions){ // has weather, doesn't show these for Fenix 5 Plus series
                    SettingsMainMenu.toggleItem(self, "Weather Condition", "ON", "OFF", AppStorage.KEY_25_CFG_WEATHER_CONDITION, Config.showWeatherCondition());
                    SettingsMainMenu.toggleItem(self, "Condition Name", "ON", "OFF", AppStorage.KEY_7_CFG_WEATHER_CONDITION_NAME, Config.showWeatherConditionName());  
            }

            // allow these extra features only for LCD and AMOLED devices
            if(System.getDeviceSettings().requiresBurnInProtection){
                SettingsMainMenu.toggleItem(self, "AOD Colors", "Accent", "Grayscale", AppStorage.KEY_22_CFG_AOD_USE_ACCENT_COLOR, Config.getAodUseAccentColor());
            }

            if (System.SCREEN_SHAPE_ROUND == System.getDeviceSettings().screenShape) { //check if rounded display
                SettingsMainMenu.toggleItem(self, "Seconds Hand", "On", "Off", AppStorage.KEY_33_CFG_SECONDS_HAND, Config.getSecondsHand());
            }

            SettingsMainMenu.iconMenuItem(self, "Hands Thickness", new HandsThicknessSettings());
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

}

class SettingsMenuTitle extends WatchUi.Drawable {

    function initialize() {
        Drawable.initialize({});
    }

    // Draw the application icon and main menu title
    //TODO reduce/remove magic number usage
    function draw(dc) {
        var title="Config";

        width=dc.getWidth();  

        var appIcon = Application.loadResource(Rez.Drawables.LauncherIcon);        
        var iconWidth = appIcon.getWidth();
        var titleWidth = dc.getTextWidthInPixels(title, Graphics.FONT_SMALL);

        if(titleWidth==117 and dc has :drawScaledBitmap){ // Venu 3s
            iconWidth=55;
        }
    	
        if (width>=390) { // Venu 3 watch allows full width to menu header, as opposed to all other watches which is half width. This condition corrects it.
            width = width*1.25;
        } 
        var iconX = (width - (iconWidth + 2 + titleWidth)) / 3;
        var iconY = (dc.getHeight() - appIcon.getHeight()) / 2;
        var titleX = iconX + iconWidth + 2;
        var titleY = dc.getHeight() / 2;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();               

        var color;
        if (Config.getLightTheme()){
            color = Graphics.COLOR_WHITE;
        } else {
            color = Graphics.COLOR_BLACK;
        }
        dc.setColor(color, color); // removing the background color and all the data points from the background, leaving just the hour hands and hashmarks
        dc.fillRectangle(0, 0, width, dc.getHeight()); //width & height?
        
        if(titleWidth==117){ // Venu 3s
            if(dc has :drawScaledBitmap){
              dc.drawScaledBitmap(iconX, iconY, 55, 55, appIcon); // making icon smaller on this watch, since dc width on top of the screen is quite small constrasting to the big default icon size (70x70)    
            } else {
              titleX = (width - (titleWidth)) / 2; // Vivoactive 5, which doesn't have ScaledBitmap and icon is too big. Removing it and showing only text.
            }
        } else {
            dc.drawBitmap(iconX, iconY, appIcon);
        } 

        dc.setColor(Config.getAccentColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawText(titleX, titleY, Graphics.FONT_SMALL, title, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}

typedef SettingsItem as interface {
    function getItemID();
    function currentSettingLabel() as String;
    function setNextSetting() as String;
};

// This is the custom Icon drawable. It fills the icon space with a color to
// to demonstrate its extents. It changes color each time the next state is
// triggered, which is done when the item is selected in this application.
class AccentColorSettings extends WatchUi.Drawable {

    public function initialize() {
        Drawable.initialize({});
    }

    public function currentSettingLabel() as String {
        var colorLabels;

        if (Config.getLightTheme()){
            colorLabels = Application.loadResource(Rez.JsonData.mColorStringsWhite) as Array;
        } else {
            colorLabels = Application.loadResource(Rez.JsonData.mColorStrings) as Array;
        }
         
        return colorLabels[Config.getAccentColorID()];
    }

    public function setNextSetting() as String {
        var colors;
        if (Config.getLightTheme()){
            colors = Application.loadResource(Rez.JsonData.mColorsWhite) as Array;
        } else {
            colors = Application.loadResource(Rez.JsonData.mColors) as Array;
        }

        var nextColorID = Config.getAccentColorID()+1;
        if(nextColorID >= colors.size()) {
            nextColorID = 0;
        }
		Config.setAccentColor(colors[nextColorID]);
		Config.setAccentColorID(nextColorID);

        return currentSettingLabel();
    }

    public function getItemID(){
        return AppStorage.KEY_1_CFG_ACCENT_COLOR;
    }

    public function getIcon() as WatchUi.Drawable{
        return self;
    }

    public function draw(dc) {
	    var color = Config.getAccentColor();
        dc.setColor(color, color);
        dc.clear();        
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

class HandsThicknessSettings extends WatchUi.Drawable {
    public static enum HandsThicknessLevel {
      STANDARD = 0,
      THICKER = 1,
      THINNER = 2
    }

    private var HAND_THICKNESS_LEVEL_LABELS = ["Standard", "Thicker", "Thinner"];
	
    function initialize() {
        Drawable.initialize({});
    }

    function currentSettingLabel() as String{
        return HAND_THICKNESS_LEVEL_LABELS[Config.getHandsThickness()];
    }    

    function setNextSetting() as String{
        var nextSetting=Config.getHandsThickness()+1;
        if(nextSetting >= HAND_THICKNESS_LEVEL_LABELS.size()) {
            nextSetting = HandsThicknessSettings.STANDARD;
        }
        Config.setHandsThickness(nextSetting);
        return currentSettingLabel();
    }

    public function getItemID() {
        return AppStorage.KEY_13_CFG_HANDS_THICKNESS;
    }

    public function getIcon() as WatchUi.Drawable{
        return self;
    }
}

(:weather) class WindSpeedUnitSettings extends WatchUi.Drawable {

    public static enum WindSpeedUnit {
        KPH_OR_MPH = 0,
        METER_PER_SECONDS = 1,
        KNOTS = 2
    }

    private var WIND_SPEED_LABELS = ["km/h or mph", "m/s", "knots"];
	
    function initialize() {
        Drawable.initialize({});
    }
    
    public function currentSettingLabel() as String{
        return WIND_SPEED_LABELS[Config.getWindSpeedUnit()];
    }    

    public function setNextSetting() as String{
        var nextSetting=Config.getWindSpeedUnit()+1;
        if(nextSetting >= WIND_SPEED_LABELS.size()) {
            nextSetting = WindSpeedUnitSettings.KPH_OR_MPH;
        }
        Config.setWindSpeedUnit(nextSetting);

        return currentSettingLabel();
    }

    public function getItemID() {
        return AppStorage.KEY_15_CFG_WINDSPEED_UNIT;
    }

    public function getIcon() as WatchUi.Drawable{
        return self;
    }
}

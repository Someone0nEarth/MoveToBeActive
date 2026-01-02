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

var count=0;

class AnalogSettingsViewTest extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize(null);

        // Generate a new Menu with a drawable Title
        Menu2.setTitle(new DrawableMenuTitle());

        var drawable1 = new CustomAccent();
        Menu2.addItem(new WatchUi.IconMenuItem("Accent Color", drawable1.getString(), AppStorage.KEY_1_CFG_ACCENT_COLOR, drawable1, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
        Menu2.addItem(new WatchUi.ToggleMenuItem("Theme", {:enabled=>"Light", :disabled=>"Dark"}, AppStorage.KEY_32_CFG_LIGHT_THEME, Config.getLightTheme(), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
        Menu2.addItem(new WatchUi.MenuItem("Layout", null, "design", null));
        Menu2.addItem(new WatchUi.MenuItem("Data Fields", null, "datapoints", null));
        if (Toybox has :Weather or System.getSystemStats() has :batteryInDays){ // 
            Menu2.addItem(new WatchUi.MenuItem("Base Units", null, "units", null));
        }
        //WatchUi.pushView(Menu2, new Menu2TestMenu2Delegate(), WatchUi.SLIDE_UP );	

	}

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return false;
    }  

    function onDone() {
        WatchUi.popView(WatchUi.SLIDE_BLINK);
    }

    function onWrap(key as WatchUi.Key) {
        return true;
    }    

}


class Menu2TestMenu2Delegate extends WatchUi.Menu2InputDelegate { // Sub-menu Design

	public function initialize() {
        Menu2InputDelegate.initialize();
    }

	public function onSelect(item) as Void {

        if (item instanceof WatchUi.IconMenuItem) {
            if (item.getIcon() instanceof CustomAccent){
                item.setSubLabel((item.getIcon() as CustomAccent).nextState(item.getId()));
            } else if (item.getIcon() instanceof CustomDataPoint){
                if (item.getId()==9 or item.getId()==10){
                    item.setSubLabel((item.getIcon() as CustomDataPoint).nextState(item.getId(),1)); //big //TODO get rid of magic number
                } else {
                    item.setSubLabel((item.getIcon() as CustomDataPoint).nextState(item.getId(),2)); //small //TODO get rid of magic number
                }
            } else if (item.getIcon() instanceof HandThicknessSettings){ 
                var cycle=item.getIcon() as HandThicknessSettings;
                cycle.setNextSetting();
                item.setSubLabel(cycle.currentSettingLabel());
            } else if (item.getIcon() instanceof WindSpeedUnitSettings){ 
                var cycle=item.getIcon() as WindSpeedUnitSettings;
                cycle.setNextSetting();
                item.setSubLabel(cycle.currentSettingLabel());
            }
        } else if (item instanceof WatchUi.ToggleMenuItem and item.getId() instanceof Number) {
            Storage.setValue(item.getId() as Number, item.isEnabled());
        }

        WatchUi.requestUpdate(); // really needed?

        if( item.getId().equals("design") ) {
		    
		    var iconMenu = new WatchUi.Menu2({:title=>"Layout"});
		    
		    iconMenu.addItem(new WatchUi.ToggleMenuItem("Garmin Logo", {:enabled=>"ON", :disabled=>"OFF"}, AppStorage.KEY_3_CFG_GARMINLOGO, Config.getGarminlogo(), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
		    iconMenu.addItem(new WatchUi.ToggleMenuItem("Bluetooth Logo", {:enabled=>"ON", :disabled=>"OFF"}, AppStorage.KEY_4_CFG_BLUETOOTH_TOGGLE , Config.getBluetoothToggle(), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
		    iconMenu.addItem(new WatchUi.ToggleMenuItem("Alarm Icon", {:enabled=>"ON", :disabled=>"OFF"}, AppStorage.KEY_8_CFG_ALARM_TOGGLE, Config.getAlarmToggle(), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));    
            iconMenu.addItem(new WatchUi.ToggleMenuItem("Battery Icon", {:enabled=>"ON", :disabled=>"OFF"}, AppStorage.KEY_26_CFG_BATTERY_ICON, Config.getBatteryIcon(), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));    
            iconMenu.addItem(new WatchUi.ToggleMenuItem("Battery Color", {:enabled=>"Conditional", :disabled=>"Always Gray"}, AppStorage.KEY_28_CFG_CONDITIONAL_BATTERY_ICON_COLOR, Config.getConditionalBatteryIconColor() , {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));    
            if (System.SCREEN_SHAPE_ROUND == System.getDeviceSettings().screenShape) {
		        iconMenu.addItem(new WatchUi.ToggleMenuItem("Hour Labels", {:enabled=>"ON", :disabled=>"OFF"}, AppStorage.KEY_5_CFG_HOUR_LABELS, Config.getHourLabels(), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
                iconMenu.addItem(new WatchUi.ToggleMenuItem("Labels Color", {:enabled=>"Accent", :disabled=>"Default"}, AppStorage.KEY_27_CFG_HOUR_LABELS_ACCENT_COLOR, Config.getHourLabelAccentColor(), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));                
            }
            iconMenu.addItem(new WatchUi.ToggleMenuItem("Tickmark Color", {:enabled=>"Accent", :disabled=>"Default"}, AppStorage.KEY_18_CFG_TICKMARK_ACCENT_COLOR, Config.getTickmarkAccentColor(), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            if (Toybox has :Weather and Toybox.Weather has :getCurrentConditions){ // has weather, doesn't show these for Fenix 5 Plus series
                iconMenu.addItem(new WatchUi.ToggleMenuItem("Weather Condition", {:enabled=>"ON", :disabled=>"OFF"}, AppStorage.KEY_25_CFG_WEATHER_CONDITION, Config.showWeatherCondition(), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
                iconMenu.addItem(new WatchUi.ToggleMenuItem("Condition Name", {:enabled=>"ON", :disabled=>"OFF"}, AppStorage.KEY_7_CFG_WEATHER_CONDITION_NAME, Config.showWeatherConditionName(), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            }

            // allow these extra features only for LCD and AMOLED devices
            if(System.getDeviceSettings().requiresBurnInProtection){
                iconMenu.addItem(new WatchUi.ToggleMenuItem("AOD Colors", {:enabled=>"Accent", :disabled=>"Grayscale"}, AppStorage.KEY_22_CFG_AOD_USE_ACCENT_COLOR, Config.getAodUseAccentColor(), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            }
            if (System.SCREEN_SHAPE_ROUND == System.getDeviceSettings().screenShape) { //check if rounded display
                iconMenu.addItem(new WatchUi.ToggleMenuItem("Seconds Hand", {:enabled=>"On", :disabled=>"Off"}, AppStorage.KEY_33_CFG_SECONDS_HAND, Config.getSecondsHand(), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            }
            var drawableT = new HandThicknessSettings();
		    iconMenu.addItem(new WatchUi.IconMenuItem("Hands Thickness", drawableT.currentSettingLabel(), AppStorage.KEY_13_CFG_HANDS_THICKNESS, drawableT, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
		    //WatchUi.pushView(iconMenu, new AnalogSettingsViewTest(), WatchUi.SLIDE_BLINK );
            WatchUi.pushView(iconMenu, new Menu2TestMenu2Delegate(), WatchUi.SLIDE_UP );
        } else if( item.getId().equals("datapoints") ) {
		    var dataMenu = new WatchUi.Menu2({:title=>"Data"});
		    $.count=0;
		    var drawable2 = new CustomDataPoint(1); // Big
		    var drawable3 = new CustomDataPoint(1); // Big
		    //count=0;
		    var drawable4 = new CustomDataPoint(2); // Small
		    var drawable5 = new CustomDataPoint(2); // Small
            var drawable6 = new CustomDataPoint(2); // Small
		    dataMenu.addItem(new WatchUi.IconMenuItem("Left Top", drawable2.nextState(-1,1/*big*/), AppStorage.KEY_9_CFG_LEFT_TOP_DF, drawable2, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
		    dataMenu.addItem(new WatchUi.IconMenuItem("Left Middle", drawable3.nextState(-1,1/*big*/), AppStorage.KEY_10_CFG_LEFT_MIDDLE_DF, drawable3, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
		    dataMenu.addItem(new WatchUi.IconMenuItem("Left Bottom", drawable4.nextState(-1,2/*small*/), AppStorage.KEY_11_CFG_LEFT_BOTTOM_DF, drawable4, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            dataMenu.addItem(new WatchUi.IconMenuItem("Right Top", drawable6.nextState(-1,2/*small*/), AppStorage.KEY_17_CFG_RIGHT_TOP_DF, drawable6, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
		    dataMenu.addItem(new WatchUi.IconMenuItem("Right Bottom", drawable5.nextState(-1,2/*small*/), AppStorage.KEY_12_CFG_RIGHT_BOTTOM_DF, drawable5, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
		   	if (System.SCREEN_SHAPE_ROUND == System.getDeviceSettings().screenShape) { //check if rounded display
                dataMenu.addItem(new WatchUi.ToggleMenuItem("Font Size", {:enabled=>"Bigger", :disabled=>"Standard"}, AppStorage.KEY_14_CFG_FONT_SIZE, Config.getFontSize(), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            }
		    //WatchUi.pushView(dataMenu, new AnalogSettingsViewTest(), WatchUi.SLIDE_BLINK );
            WatchUi.pushView(dataMenu, new Menu2TestMenu2Delegate(), WatchUi.SLIDE_UP );
        } else if( item.getId().equals("units") ) { 
            //var checkWeather=Config.getDateFontSize()[1]; // has :Weather
            var unitsMenu = new WatchUi.Menu2({:title=>"Units"});
            if (System.getSystemStats() has :batteryInDays){
                unitsMenu.addItem(new WatchUi.ToggleMenuItem("Battery Estimate", {:enabled=>"ON", :disabled=>"OFF"}, AppStorage.KEY_19_CFG_BATTERY_EST_FLAG, Config.getBatteryEstFlag(), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            }
            var info = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG);
            unitsMenu.addItem(new WatchUi.ToggleMenuItem("Date Format", {:enabled=>Lang.format("$2$ $1$", [info.month, info.day]), :disabled=>Lang.format("$1$ $2$", [info.month, info.day])}, AppStorage.KEY_24_CFG_DATE_FORMAT, Config.getDateFormat(), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            unitsMenu.addItem(new WatchUi.ToggleMenuItem("Date Size", {:enabled=>"Standard", :disabled=>"Small"}, AppStorage.KEY_21_CFG_DATE_FONT_SIZE, Config.getDateFontSize(), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));    
            if (Toybox has :Weather and Toybox.Weather has :getCurrentConditions and Toybox.Weather.getCurrentConditions()!=null){
                if (Activity.getActivityInfo() has :rawAmbientPressure){
                    unitsMenu.addItem(new WatchUi.ToggleMenuItem("Atm. Pres. Type", {:enabled=>"Mean Sea Level", :disabled=>"Local Pressure"}, AppStorage.KEY_20_CFG_PRESSURE_TYPE, Config.getPressureType(), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
                }
                //if (Toybox.Weather.getCurrentConditions().feelsLikeTemperature!=null and Toybox.Weather.getCurrentConditions().feelsLikeTemperature instanceof Number){
                    unitsMenu.addItem(new WatchUi.ToggleMenuItem("Temp. Type", {:enabled=>"Real Temperature", :disabled=>"Feels Like"}, AppStorage.KEY_6_CFG_TEMPERATURE_TYPE, Config.getTemperatureType(), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
                //}
                unitsMenu.addItem(new WatchUi.ToggleMenuItem("Temp. Unit", {:enabled=>"Always Celsius", :disabled=>"User Settings"}, AppStorage.KEY_16_CFG_TEMPERATURE_UNIT, Config.getTemperatureUnit(), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));		    
                //unitsMenu.addItem(new WatchUi.ToggleMenuItem("Wind Speed Unit", {:enabled=>"km/h or mph", :disabled=>"m/s"}, 15, Config.getWindSpeedUnit(), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
                var drawableW = new WindSpeedUnitSettings();
                unitsMenu.addItem(new WatchUi.IconMenuItem("Wind Speed Unit", drawableW.currentSettingLabel(), AppStorage.KEY_15_CFG_WINDSPEED_UNIT, drawableW, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            }
            //WatchUi.pushView(unitsMenu, new AnalogSettingsViewTest(), WatchUi.SLIDE_BLINK );	
            WatchUi.pushView(unitsMenu, new Menu2TestMenu2Delegate(), WatchUi.SLIDE_UP );	
	    } else {
            WatchUi.requestUpdate();
        }  

	}

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        //return false;
    }  

}


// This is the custom drawable we will use for our main menu title
class DrawableMenuTitle extends WatchUi.Drawable {

    // This constant data stores the color state list.
    //const mColors = [0x55FF00, 0xAAFF00, 0xFFFF00, 0x00AAFF, 0x00FFFF, 0xAA55FF, 0xFFAA00, 0xFF0000, 0xFF55FF, 0xFFFFFF];

    function initialize() {
        Drawable.initialize({});
    }

    // Draw the application icon and main menu title
    function draw(dc) {
        var mIndex, width=dc.getWidth();
        
        if (Config.getAccentIndex() == false or Config.getAccentIndex() == null){ 
        	mIndex = 0;
        } else {
        	mIndex=Config.getAccentIndex();
        }        

        var appIcon = Application.loadResource(Rez.Drawables.LauncherIcon);        
        var bitmapWidth = appIcon.getWidth();
        var labelWidth = dc.getTextWidthInPixels("Config", Graphics.FONT_SMALL);

        if(labelWidth==117 and dc has :drawScaledBitmap){ // Venu 3s
            bitmapWidth=55;
        }
    	
        if (width>=390) { // Venu 3 watch allows full width to menu header, as opposed to all other watches which is half width. This condition corrects it.
            width = width*1.25;
        } 
        var bitmapX = (width - (bitmapWidth + 2 + labelWidth)) / 3; // 2 = spacing between logo and text
        var bitmapY = (dc.getHeight() - appIcon.getHeight()) / 2;
        var labelX = bitmapX + bitmapWidth + 2; // 2 = spacing between logo and text
        var labelY = dc.getHeight() / 2;

        var mColors;
        if (Config.getLightTheme() == null or Config.getLightTheme() == false){
            mColors = Application.loadResource(Rez.JsonData.mColors) as Array;
        } else {
            mColors = Application.loadResource(Rez.JsonData.mColorsWhite) as Array;
        }

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();               

        //dc.clearClip(); //clear instead?
        var Color;
        if (Config.getLightTheme() == null or Config.getLightTheme() == false){ // Dark
            Color = Graphics.COLOR_BLACK;
        } else { // Light
            Color = Graphics.COLOR_WHITE;
        }
        dc.setColor(Color, Color); // removing the background color and all the data points from the background, leaving just the hour hands and hashmarks
        dc.fillRectangle(0, 0, width, dc.getHeight()); //width & height?
        
        if(labelWidth==117 and dc has :drawScaledBitmap){ // Venu 3s
            dc.drawScaledBitmap(bitmapX, bitmapY, 55, 55, appIcon); // making icon smaller on this watch, since dc width on top of the screen is quite small constrasting to the big default icon size (70x70)
        } else if (labelWidth==117){ // Vivoactive 5, which doesn't have ScaledBitmap and icon is too big. Removing it and showing only text.
            labelX = (width - (labelWidth)) / 2;
        } else {
            dc.drawBitmap(bitmapX, bitmapY, appIcon);
        }

        dc.setColor(Config.getAccentColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawText(labelX, labelY, Graphics.FONT_SMALL, "Config", Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}


// This is the custom Icon drawable. It fills the icon space with a color to
// to demonstrate its extents. It changes color each time the next state is
// triggered, which is done when the item is selected in this application.
class CustomAccent extends WatchUi.Drawable {

    // This constant data stores the color state list.
    //const mColors = [0x55FF00, 0xAAFF00, 0xFFFF00, Graphics.COLOR_BLUE, 0x00FFFF, 0xAA55FF, 0xFFAA00/*0xFF5500*/, 0xFF0000, 0xFF55FF, Graphics.COLOR_WHITE];
    //const mColorStrings = ["Bright Green", "Vivomove", "Yellow", "Sky Blue", "Aqua", "Medium Purple", "Orange", "Red", "Pink Flamingo", "White"];
    private var mIndex as Number;

    public function initialize() {
        Drawable.initialize({});
        if (Config.getAccentIndex() == false or Config.getAccentIndex() == null){ 
        	mIndex = 0;
        } else {
        	mIndex=Config.getAccentIndex();
        }
    }

    // Return the color string for the menu to use as it's sublabel
    public function getString() {
        var mColorStrings;
        //if (Config.gettLightTheme() == null or Config.gettLightTheme() == false){
        if (Config.getLightTheme() == true){
            mColorStrings = Application.loadResource(Rez.JsonData.mColorStringsWhite) as Array;
        } else {
            mColorStrings = Application.loadResource(Rez.JsonData.mColorStrings) as Array;
        }
         
        return mColorStrings[mIndex];
    }

    // Advance to the next color state for the drawable
    public function nextState(id) {
        //var mColorStrings = Application.loadResource(Rez.JsonData.mColorStrings);
        
        var mColors;
        if (Config.getLightTheme() == true){
            mColors = Application.loadResource(Rez.JsonData.mColorsWhite) as Array;
        } else {
            mColors = Application.loadResource(Rez.JsonData.mColors) as Array;
        }

        mIndex++;
        if(mIndex >= mColors.size()) {
            mIndex = 0;
        }
		Config.setAccentColor( mColors[mIndex]);
		Config.setAccentIndex( mIndex);

        //return mColorStrings[mIndex];
        return getString();
    }

    // Set the color for the current state and use dc.clear() to fill
    // the drawable area with that color
    public function draw(dc) {
        var mColors;
        if (Config.getLightTheme() == true){
            mColors = Application.loadResource(Rez.JsonData.mColorsWhite) as Array;
        } else {
            mColors = Application.loadResource(Rez.JsonData.mColors) as Array;
        }
	    var color = mColors[mIndex];
        dc.setColor(color, color);
        dc.clear();        
    }
}

// ------

// This is the custom Icon drawable. It fills the icon space with a color to
// to demonstrate its extents. It changes color each time the next state is
// triggered, which is done when the item is selected in this application.
class CustomDataPoint extends WatchUi.Drawable {

    // This constant data stores the color state list.
    //const mIcons = ["0" /*stepsIcon*/, ";" /*elevationIcon*/, "P" /*windIcon*/, "A" /*humidityIcon*/, "S" /*precipitationIcon*/, "6" /*caloriesIcon*/, "1" /*floorsClimbIcon*/, "@" /*pulseOxIcon*/, "3" /*heartRateIcon*/, "5" /*notificationIcon*/, "R" /*solarIcon*/, "" /*none*/];
    //const mIconStrings = ["Steps", ,"Distance", "Elevation", "Wind Speed", "Humidity", "Precipitation", "Calories",  (ActivityMonitor.getInfo() has :floorsClimbed)?"Floors Climbed":"Not Available", (Activity.getActivityInfo() has :currentOxygenSaturation)?"Pulse Ox":"Not available", "Heart Rate", "Notification",(System.getSystemStats() has :solarIntensity and System.getSystemStats().solarIntensity != null) ? "Solar Intensity" : "Not available", "None"];
    var mIndex; // 0=stepsIcon, 1=distanceIcon, 2=elevationIcon, 3=windSpeed, 4=humidityIcon, 5=precipitationIcon, 6=caloriesIcon, 7=floorsClimbIcon, 8=pulseOxIcon, 9=heartRateIcon, 10=notificationIcon, 11=solarIcon, 12=seconds, 13=intensityMin, 14=none
    var type;
	
    function initialize(size) {
        Drawable.initialize({});
        type=size;
        var mArray=[Config.getLeftTopDF(), Config.getLeftMiddleDF(), Config.getLeftBottomDF(), Storage.getValue(12), Config.getRightTopDF()]; // if values are null, then "none"
        mIndex=mArray[$.count];   
        $.count++;
    }
 

    // Advance to the next color state for the drawable, or return the icon string for the menu to use as its label if id=-1
    function nextState(id, size) {
        //var checkWeather = Config.getDateFontSize()[2];
        var mIconStrings;

        if (size==2){ // Data field locations with length limitation = "small"
            mIconStrings = ["Steps", (Toybox has :Weather and Toybox.Weather has :getCurrentConditions)?"Humidity":"Not Available", (Toybox has :Weather and Toybox.Weather has :getCurrentConditions)?"Precipitation":"Not Available", (Activity.getActivityInfo() has :rawAmbientPressure) ? "Atm. Pressure" : "Not available", "Calories Total", "Calories Active", (ActivityMonitor.getInfo() has :floorsClimbed)?"Floors Climbed":"Not Available", (Activity.getActivityInfo() has :currentOxygenSaturation)?"Pulse Ox":"Not available" , "Heart Rate", "Notifications", (System.getSystemStats() has :solarIntensity and System.getSystemStats().solarIntensity != null) ? "Solar Intensity" : "Not available", "Seconds", "Digital Clock", "Intensity Min.", ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getBodyBatteryHistory))?"Body Battery":"Not Available", ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getStressHistory))?"Stress":"Not Available", (ActivityMonitor.getInfo() has :respirationRate)?"Respiration Rate":"Not Available", (ActivityMonitor.getInfo() has :timeToRecovery)?"Recovery Time":"Not Available", (UserProfile.getProfile() has :vo2maxRunning)?"VO2 Max Run":"Not Available", (UserProfile.getProfile() has :vo2maxCycling)?"VO2 Max Cycle":"Not Available", ((Toybox has :Weather) && (Weather has :getSunset and Weather has :getSunrise))?"Next Sun Event":"Not Available", "Battery %/day", (Toybox has :Weather and Toybox.Weather has :getHourlyForecast)?"2h Forecast":"Not Available", "None"];
        } else { // No limitations on data field length
            mIconStrings = ["Steps", "Distance", "Elevation", (Toybox has :Weather and Toybox.Weather has :getCurrentConditions)?"Wind Speed":"Not Available", (Toybox has :Weather and Toybox.Weather has :getCurrentConditions)?"Min/Max Temp.":"Not Available", (Toybox has :Weather and Toybox.Weather has :getCurrentConditions)?"Humidity":"Not Available", (Toybox has :Weather and Toybox.Weather has :getCurrentConditions)?"Precipitation":"Not Available", (Activity.getActivityInfo() has :rawAmbientPressure) ? "Atm. Pressure" : "Not available", "Calories Total", "Calories Active",  (ActivityMonitor.getInfo() has :floorsClimbed)?"Floors Climbed":"Not Available", (Activity.getActivityInfo() has :currentOxygenSaturation)?"Pulse Ox":"Not available", "Heart Rate", "Notifications",(System.getSystemStats() has :solarIntensity and System.getSystemStats().solarIntensity != null) ? "Solar Intensity" : "Not available", "Seconds", "Digital Clock", "Intensity Min.", ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getBodyBatteryHistory))?"Body Battery":"Not Available", ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getStressHistory))?"Stress":"Not Available", (ActivityMonitor.getInfo() has :respirationRate)?"Respiration Rate":"Not Available", (ActivityMonitor.getInfo() has :timeToRecovery)?"Recovery Time":"Not Available", (UserProfile.getProfile() has :vo2maxRunning)?"VO2 Max Run":"Not Available", (UserProfile.getProfile() has :vo2maxCycling)?"VO2 Max Cycle":"Not Available", ((Toybox has :Weather) && (Weather has :getSunset and Weather has :getSunrise))?"Next Sun Event":"Not Available", "Battery %/day", (Toybox has :Weather and Toybox.Weather has :getHourlyForecast)?"3h Forecast":"Not Available", "None"];
        }

        if (id!=-1){ // -1 means to return only the name, while any other value means to skip to next step
            type=size;
            mIndex++;
            if(mIndex >= mIconStrings.size()) {
                mIndex = 0;
            }
            Storage.setValue(id, mIndex); //Storage 9 or 10
        }
        return mIconStrings[mIndex]; // Return the icon string for the menu to use as its label
    }

    // Set the color for the current state and use dc.clear() to fill
    // the drawable area with that color
    function draw(dc) {
        var mIcons;
        if (type==2) {
            mIcons = Application.loadResource(Rez.JsonData.mIcons9) as Array;
        } else {
            mIcons = Application.loadResource(Rez.JsonData.mIcons12) as Array;
        }
        var iColor=0x55FF00;

        if (Config.getAccentColor() != null) {
			iColor = Config.getAccentColor();
            if (iColor==Graphics.COLOR_WHITE){ iColor=Graphics.COLOR_LT_GRAY; }
        }
		
        dc.setColor(iColor, Graphics.COLOR_TRANSPARENT);
		if (mIndex < mIcons.size()-1){
			var iconsFont = Application.loadResource(Rez.Fonts.IconsFont);
			var icon = mIcons[mIndex];
            dc.drawText( dc.getWidth()/2, dc.getHeight()/3, iconsFont, icon , Graphics.TEXT_JUSTIFY_CENTER);
		}
        dc.clear();
    }
}

class HandThicknessSettings extends WatchUi.Drawable {
    public static enum HandsThicknessLevel {
      STANDARD = 0,
      THICKER = 1,
      THINNER = 2
    }

    private static const HAND_THICKNESS_LEVEL_LABELS = ["Standard", "Thicker", "Thinner"];
	
    function initialize() {
        Drawable.initialize({});
    }

    function currentSettingLabel() as String{
        return HAND_THICKNESS_LEVEL_LABELS[Config.getHandsThickness()];
    }    

    function setNextSetting() as Void{
        var nextState=Config.getHandsThickness()+1;
        if(nextState >= HAND_THICKNESS_LEVEL_LABELS.size()) {
            nextState = HandThicknessSettings.STANDARD;
        }
        Config.setHandsThickness(nextState);
    }
}

(:weather) class WindSpeedUnitSettings extends WatchUi.Drawable {
    public static enum WindSpeedUnit {
        KPH_OR_MPH = 0,
        METER_PER_SECONDS = 1,
        KNOTS = 2
    }

    private static const WIND_SPEED_LABELS = ["km/h or mph", "m/s", "knots"];
	
    function initialize() {
        Drawable.initialize({});
    }    
    
    function currentSettingLabel() as String{
        return WIND_SPEED_LABELS[Config.getWindSpeedUnit()];
    }    

    function setNextSetting() as Void{
        var nextState=Config.getWindSpeedUnit()+1;
        if(nextState >= WIND_SPEED_LABELS.size()) {
            nextState = WindSpeedUnitSettings.KPH_OR_MPH;
        }
        Config.setWindSpeedUnit(nextState);
    }
}

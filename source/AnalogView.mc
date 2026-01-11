//
// Copyright 2016-2017 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
// 

import Toybox.Activity;
import Toybox.Weather;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
//import Toybox.Complications;

//var partialUpdatesAllowed = false;
//var fullScreenRefresh;
//var accentColor;
// var inLowPower as Boolean = false;
// //var canBurnIn=false;
// var upTop=true;
// var MtbA = null;


class DrawSettings{
    public var backgroundColor as Number?;
    public var accentColor as Number?;
    public var arborColor as Number?;
    public var borderColor as Number?;
    public var minorTicksColor as Number?;
    public var majorTicksColor as Number?;
    public var verticalCardinalTicksColor as Number?;
    public var horizontalCardinalTicksColor as Number?;
    public var tickIncrement as Number?;

    public var additionalPixelLenghtOfCardinalTicks as Number?;
    public var additionalPixelLenghtOfMajorTicks as Number?;

    public var width as Number?;
    public var height as Number?;

    

}


// This implements an analog watch face
// Original design by Austen Harbour
class AnalogView extends WatchUi.WatchFace {
    //var offscreenBuffer;
    private var mOffscreenBuffer as BufferedBitmap?;  //TODO Review the usage of offscreenBuffer and maybe do a redesign of buffer usages
    //private var _fullScreenRefresh as Boolean;
    //private var _partialUpdatesAllowed as Boolean;

    private var mInLowPower as Boolean = false;
    //var canBurnIn=false;
    private var mUpTop=true; //TODO Figure out the purpose of upTop variable
    private var mDrawer as Drawer;
    private var mCanBurnIn as Boolean = System.getDeviceSettings().requiresBurnInProtection;
    

    // Initialize variables for this view
    function initialize() {
        WatchFace.initialize();
        //_fullScreenRefresh = true;
        //_partialUpdatesAllowed = (WatchUi.WatchFace has :onPartialUpdate);

        Config.load();

        mDrawer= new Drawer(mInLowPower, Config.getFontColor());   
    }

    // Configure the layout of the watchface for this device
(:allColors) public function onLayout(dc as Dc) as Void {
		
        var offscreenBufferOptions = {
                :width=>dc.getWidth(),
                :height=>dc.getHeight(),
                :palette=> [
                    Graphics.COLOR_DK_GRAY,
                    Graphics.COLOR_LT_GRAY,
                    Graphics.COLOR_BLACK,
                    Graphics.COLOR_WHITE
                ]
            };

        if (Graphics has :createBufferedBitmap) {
            // get() used to return resource as Graphics.BufferedBitmap
            mOffscreenBuffer = Graphics.createBufferedBitmap(offscreenBufferOptions).get() as BufferedBitmap;

        } else if (Graphics has :BufferedBitmap) { // If this device supports BufferedBitmap, allocate the buffers we use for drawing
            // Allocate a full screen size buffer with a palette of only 4 colors to draw
            // the background image of the watchface.  This is used to facilitate blanking
            // the second hand during partial updates of the display
            mOffscreenBuffer = new Graphics.BufferedBitmap(offscreenBufferOptions);
        } else {
            mOffscreenBuffer = null;
        }

    }

    // Configure the layout of the watchface for this device
(:lowColors) public function onLayout(dc as Dc) as Void {
		
        var offscreenBufferOptions = {
                :width=>dc.getWidth(),
                :height=>dc.getHeight(),
                :palette=> [
                    Graphics.COLOR_BLACK,
                    Graphics.COLOR_WHITE
                ]
            };

        if (Graphics has :createBufferedBitmap) {
            // get() used to return resource as Graphics.BufferedBitmap
            mOffscreenBuffer = Graphics.createBufferedBitmap(offscreenBufferOptions).get() as BufferedBitmap;

        } else if (Graphics has :BufferedBitmap) { // If this device supports BufferedBitmap, allocate the buffers we use for drawing
            // Allocate a full screen size buffer with a palette of only 4 colors to draw
            // the background image of the watchface.  This is used to facilitate blanking
            // the second hand during partial updates of the display
            mOffscreenBuffer = new Graphics.BufferedBitmap(offscreenBufferOptions);
        } else {
            mOffscreenBuffer = null;
        }

        //MtbA = new MtbA_functions(inLowPower as Boolean);

    }

    // Handle the update event
    public function onUpdate(dc as Dc) as Void {
        mDrawer.setFontColor(Config.getFontColor()); //TODO do this only, when config (light / dark theme) changes
        var bufferDc = null;        
        //var MtbA = new MtbA_functions();
        //var check = Storage.getValue(21);
        
        //var accentColor = config[0];
        

        // We always want to refresh the full screen when we get a regular onUpdate call.
        //_fullScreenRefresh = true;
        if (null != mOffscreenBuffer) {
            // If we have an offscreen buffer that we are using to draw the background,
            // set the draw context of that buffer as our target.
            bufferDc = mOffscreenBuffer.getDc();
            dc.clearClip();
        } else {
            bufferDc = dc;
        }

        var drawSettings = new DrawSettings();

        var width = bufferDc.getWidth();
        var height = bufferDc.getHeight();
        var screenCenterPoint = [width/2, height/2];

        var useAccentColorForTickmarks = Config.getTickmarkAccentColor();
        var arborColor;
        var showSecondHand;
        var borderColor=Graphics.COLOR_BLACK;

        if(mInLowPower and mCanBurnIn) { // aod on
           drawSettings.tickIncrement = 5;
           drawSettings.additionalPixelLenghtOfCardinalTicks = 0;
           drawSettings.additionalPixelLenghtOfMajorTicks = 0;
           
           showSecondHand = false;
           if(Config.getAodUseAccentColor()) {
                drawSettings.accentColor = Config.getAccentColor();
                drawSettings.minorTicksColor = drawSettings.accentColor;
                drawSettings.verticalCardinalTicksColor = drawSettings.accentColor;
                drawSettings.horizontalCardinalTicksColor = drawSettings.accentColor;
                drawSettings.majorTicksColor = drawSettings.accentColor;
                arborColor=Graphics.COLOR_WHITE;
            } else {
                drawSettings.accentColor = Graphics.COLOR_LT_GRAY;
                drawSettings.minorTicksColor = Graphics.COLOR_LT_GRAY;
                drawSettings.verticalCardinalTicksColor = Graphics.COLOR_WHITE;
                drawSettings.horizontalCardinalTicksColor = Graphics.COLOR_LT_GRAY;
                drawSettings.majorTicksColor = Graphics.COLOR_LT_GRAY;
                arborColor=Graphics.COLOR_LT_GRAY;
            } 
            drawAOD(dc, bufferDc, width, useAccentColorForTickmarks, drawSettings);
          
        } else {
            drawSettings.accentColor = Config.getAccentColor();
            drawSettings.tickIncrement = 1;
            drawSettings.verticalCardinalTicksColor = drawSettings.accentColor;

            if(Config.getLightTheme()){
              drawSettings.majorTicksColor = Graphics.COLOR_BLACK;
              drawSettings.minorTicksColor = Graphics.COLOR_BLACK;

            } else {

              if(Config.isAMOLEDDisplay()) {
                drawSettings.majorTicksColor = Graphics.COLOR_DK_GRAY;
                drawSettings.minorTicksColor = Graphics.COLOR_DK_GRAY;

              } else {
                drawSettings.majorTicksColor = Graphics.COLOR_LT_GRAY;
                drawSettings.minorTicksColor = Graphics.COLOR_LT_GRAY;
              }
            }

            if (useAccentColorForTickmarks){
              drawSettings.majorTicksColor = drawSettings.accentColor;
            }

            if(Config.getHourLabels()){
                drawSettings.horizontalCardinalTicksColor = drawSettings.majorTicksColor;
                drawSettings.additionalPixelLenghtOfCardinalTicks = 0;
                drawSettings.additionalPixelLenghtOfMajorTicks = 10;
            } else {
                drawSettings.horizontalCardinalTicksColor = drawSettings.accentColor;
                drawSettings.additionalPixelLenghtOfCardinalTicks = 10;
                drawSettings.additionalPixelLenghtOfMajorTicks = 10;
            }

            if((!mInLowPower && Config.getSecondsHand())){
              showSecondHand = true;
            } else {
              showSecondHand = false;
            }

          if(Config.getLightTheme()){
              arborColor=Graphics.COLOR_LT_GRAY;
          } else {
              arborColor=Graphics.COLOR_WHITE;
          }
          drawNormal(dc, bufferDc, width, height, drawSettings);
        }

        var clockTime = System.getClockTime();
        
		mDrawer.drawHourAndMinuteHands(dc, width, height, screenCenterPoint, Config.getHandsThickness(), drawSettings.accentColor, arborColor, borderColor, clockTime);

       if (mInLowPower and mCanBurnIn)  {
            //TODO really need to figuring out what this checkboard is doing. Dont see any difference in AOD mode with it or without it.
            mDrawer.drawCheckboard(dc, width, height, mUpTop);
        }

        if(showSecondHand){
            mDrawer.drawSecondHand(dc, width, height, screenCenterPoint, Config.getHandsThickness(), drawSettings.accentColor, arborColor, borderColor, clockTime);
        }
    }

    private function drawAOD(dc as Dc, bufferDc as Dc, width as Number, useAccentColorForTickmarks as Boolean, drawSettings as DrawSettings) as Void {
      if (dc has :setAntiAlias) {
        dc.setAntiAlias(false);
        }
            
      mUpTop=!mUpTop;
      //targetDc.clearClip();
      bufferDc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK); // removing the background color and all the data points from the background, leaving just the hour hands and hashmarks
      bufferDc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight()); //width & height

      //TODO Figuring out what the purpose of all of this is...
      if(useAccentColorForTickmarks){ //tickmark color toggle
          drawBackground(dc);
          mDrawer.drawHashMarks(dc, width, drawSettings); //dc
      } else {
          mDrawer.drawHashMarks(bufferDc, width, drawSettings); //dc
          drawBackground(dc);
      }

    }

    private function drawNormal(dc as Dc, bufferDc as Dc, width as Number, height as Number, drawSettings as DrawSettings) as Void {
     // Fill the entire background
            if (Config.getLightTheme()){ // Light Theme
                bufferDc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
            } else { // Dark Theme
                bufferDc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
            }
            bufferDc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight()); //width & height?

            // Output the offscreen buffers to the main display if required.
            drawBackground(dc);

            // Draw the tick marks around the edges of the screen
            if(width>=360){ // No need for anti-alias on hashmarks of AMOLED screens
                mDrawer.drawHashMarks(dc, width, drawSettings); //dc        
            }

            if (dc has :setAntiAlias) {
                dc.setAntiAlias(true);
            }

            // Draw the tick marks around the edges of the screen
            if(width<360){ // With anti-alias for MIP displays
                mDrawer.drawHashMarks(dc, width, drawSettings); //dc         
            }

            // Garmin Logo check
            var showGarminLogo=Config.getGarminlogo();
            var position = Application.loadResource(Rez.JsonData.mPosition) as Array;
            if (showGarminLogo == null or showGarminLogo == true) {
                mDrawer.drawGarminLogo(dc, position[4], position[5], Config.getLightTheme()); 
            }

            // Draw the 3, 6, 9, and 12 hour labels.
            if (System.SCREEN_SHAPE_ROUND == System.getDeviceSettings().screenShape and Config.getHourLabels() != false) {
                mDrawer.drawHourLabels(dc, width, height, drawSettings.accentColor, Config.getHourLabelAccentColor()); 
            }

            if (Config.showWeather()) {
                var weatherConditions= Weather.getCurrentConditions();
                if(weatherConditions != null) {
                    var xIcon, x2Icon, yIcon;
                    var xTemp, yTemp;
                    var xName, yName;
                    
                    if (showGarminLogo) {
                        xIcon=position[18];
                        x2Icon=position[19];
                        yIcon=position[20];

                        xTemp=position[21];
                        yTemp=(System.SCREEN_SHAPE_ROUND==System.getDeviceSettings().screenShape)? (width==208 ? position[23] : position[15]) : position[20]; //TODO make it understandable

                        xName=width/2;
                        yName=position[23];

                        if(width==260){ //TODO Figuring out what the meaning of the magic number "260" is
                          yName = yName+6;
                        }
                    } else {
                        xIcon=position[18];
                        x2Icon=position[19];
                        yIcon=position[22];

                        xTemp=position[21];
                        yTemp=position[7];

                        xName=width/2;
                        yName=position[6];
                    }

                    if (Config.showWeatherCondition()){
                        mDrawer.drawWeatherIcon(dc, xIcon, yIcon, x2Icon, width, weatherConditions.condition, System.getClockTime().hour);
                        mDrawer.drawTemperature(dc, xTemp, yTemp,  Config.getTemperatureType(), width, Config.getTemperatureUnit());
                    }
                    
                    if(Config.showWeatherConditionName()){
                        mDrawer.drawLocation(dc, xName, yName);
                    }
                }
            }
            
            // Draw Battery
            if (Config.getBatteryIcon()!=false){ // Show Battery Icon
                mDrawer.drawBatteryIcon(dc, width*0.69, height / 2.11, width*0.82, height / 2.06+(width==218 ? 1 : 0), width, drawSettings.accentColor, Config.getConditionalBatteryIconColor());
                mDrawer.drawBatteryText(dc, width*0.76, height / 2.14 - 1, width, Config.getBatteryEstFlag());
            }

            //Data Points
            var FontAdj=0;
            if (Config.getFontSize()){ // fontSize height adjustment
                if (width==260 and dc.getFontHeight(Graphics.FONT_TINY)==29) { //Fenix 6
                    FontAdj=6;
                } else if (width==260 and dc.getFontHeight(Graphics.FONT_TINY)==27) { // Vivoactive 4
                    FontAdj=5; 
                } else if (width==280){
                    FontAdj=7;
                } else if (width==416) { // Venu 2 and 2 Plus
                    FontAdj=5;
                } else if (width==360 or width==390) { //Venu and 2s
                    FontAdj=4;
                } else if (width>=454) {
                    FontAdj=6;
                } else if (width==218) {
                    if (dc.getFontHeight(Graphics.FONT_TINY)==23){
                        FontAdj=2;
                    } else {
                        FontAdj=3;
                    }
                } else if (width==240) { 
                    if (dc.getFontHeight(Graphics.FONT_TINY)==26 and dc.getFontHeight(Graphics.FONT_XTINY)!=26) { // Fenix 6s
                        FontAdj=4;
                    }
                } else { // Fenix 5 Plus
                    FontAdj=2;
                }
            }

            // (dc, xIcon, yIcon, xText, yText, accentColor, width, Xoffset, dataPoint)            
            var dataPoint = Config.getRightBottomDF(); //right bottom
            mDrawer.drawPoints(dc, position[8], position[14], position[10], position[15]-FontAdj, drawSettings.accentColor, width, dataPoint, 4);
            //MtbA.drawRightPoints(dc, position[8], position[14], position[10], position[15], accentColor, width, 0, dataPoint);

            dataPoint = Config.getRightTopDF(); //right top
            mDrawer.drawPoints(dc, position[8], position[9], position[10], position[11]-FontAdj, drawSettings.accentColor, width, dataPoint, 4); 

            //(dc, xIcon, yIcon, xText, yText, accentColor, width, Xoffset)
            dataPoint = Config.getLeftTopDF(); // left top
            mDrawer.drawPoints(dc, position[12], position[9], position[13], position[11]-FontAdj, drawSettings.accentColor, width, dataPoint, 1);

            dataPoint = Config.getLeftMiddleDF(); // left middle
            mDrawer.drawPoints(dc, position[12], position[16], position[13], position[17]-FontAdj, drawSettings.accentColor, width, dataPoint, 2);	
            //MtbA.drawLeftMiddle(dc, position[12], position[16], position[13], position[17], accentColor, width, dataPoint);	

            dataPoint = Config.getLeftBottomDF(); // left bottom
            mDrawer.drawPoints(dc, position[12], position[14], position[13], position[15]-FontAdj, drawSettings.accentColor, width, dataPoint, 3);

            var iconSize = 0;

            if (width==360){
                iconSize = 12;
            } else if (width==280){
                iconSize = 13;
            } else if (width==260){
                iconSize = 14;
            } else if (width==240){
                iconSize = 12;
            } else if (width==218){
                iconSize = 15;
            } else if (width>360){
                iconSize = 20;
            }

            // Bluetooth, Alarm and Dnd Icons
            var alarm = Config.getAlarmToggle(), blue = Config.getBluetoothToggle();
            if (System.getDeviceSettings() has :doNotDisturb and System.getDeviceSettings().doNotDisturb) { // Dnd exists and is turned on
                if ((alarm == true and blue == true) or (alarm == null and blue == null)){ // all 3 icons
                    // Draw the Do Not Disturb Icon in the middle
                    mDrawer.drawDndIcon(dc, position[0], position[1], width);
                    // Draw alarm icon on the right
                    mDrawer.drawAlarmIcon(dc, position[3], position[1], drawSettings.accentColor, width);
                    //Draw bluetooth icon on the left
                    mDrawer.drawBluetoothIcon(dc, position[2], position[1]);
                } else if(alarm == false and (blue == true)) { // alarm icon is hidden
                    // Draw the Do Not Disturb Icon on the right
                    mDrawer.drawDndIcon(dc, (position[0]+position[3])/2, position[1], width);
                    //Draw bluetooth icon on the left
                    mDrawer.drawBluetoothIcon(dc, (position[2]+position[0])/2, position[1]);
                } else if(alarm == true and blue == false){ // bluetooth icon is hidden
                    // Draw the Do Not Disturb Icon on the left
                    mDrawer.drawDndIcon(dc, (position[3]+position[0])/2, position[1], width);
                    // Draw alarm icon on the right
                    mDrawer.drawAlarmIcon(dc, (position[0]+position[2])/2, position[1], drawSettings.accentColor, width);                    
                } else{ // only Dnd
                    // Draw the Do Not Disturb Icon in the middle
                    mDrawer.drawDndIcon(dc, position[0], position[1], width);
                }
            } else { // Dnd does not exist or is turned off
                if ((alarm == true or alarm == null) and (blue == true or blue == null)){ // all 2 icons
                    // Draw alarm icon on the right
                    //MtbA.drawAlarmIcon(dc, (position[3]+(position[3]+position[0])/2)/2, position[1], accentColor, width);
                    mDrawer.drawAlarmIcon(dc, ((position[3]+position[0])/2)+iconSize, position[1], drawSettings.accentColor, width);
                    //Draw bluetooth icon on the left
                    mDrawer.drawBluetoothIcon(dc, (position[2]+position[0])/2, position[1]);
                } else if(alarm == false and (blue == true)){ // alarm icon is hidden
                    mDrawer.drawBluetoothIcon(dc, (width/2)-1, position[1]);
                } else if(alarm == true){
                    mDrawer.drawAlarmIcon(dc, width/2, position[1], drawSettings.accentColor, width);
                }
            }

            //Draw the date string
            if (showGarminLogo == null or showGarminLogo == true) { // Garmin Logo check
                mDrawer.drawDateString( dc, width / 2, position[6], Config.getDateFormat(), Config.getDateFontSize()); 
            } else { // No Garmin Logo
                mDrawer.drawDateString( dc, width / 2, position[5] + (width<=240 ? 5 : 0 ) + (width==218 ? 3 : 0 ), Config.getDateFormat(), Config.getDateFontSize()); // offsets needed because of size of Garmin Logo compared to Date Font
            }

    }


  // Handle the partial update event
    public function onPartialUpdate(dc as Dc) as Void {
        // If we're not doing a full screen refresh we need to re-draw the background
        // before drawing the updated second hand position. Note this will only re-draw
        // the background in the area specified by the previously computed clipping region.
    //    if (!_fullScreenRefresh) {
    //        drawBackground(dc);
    //    }

        //call the seconds hand here
    }


    //! Draw the watch face background
    //! onUpdate uses this method to transfer newly rendered Buffered Bitmaps
    //! to the main display.
    //! onPartialUpdate uses this to blank the second hand from the previous
    //! second before outputting the new one.
    //! @param dc Device context
    private function drawBackground(dc as Dc) as Void {
        // If we have an offscreen buffer that has been written to
        // draw it to the screen.
        if (mOffscreenBuffer != null) {
            dc.drawBitmap(0, 0, mOffscreenBuffer);
            //dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
            //dc.clear();
        }

    }
    
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    //! This method is called when the device re-enters sleep mode.
    //! Set the isAwake flag to let onUpdate know it should stop rendering the second hand.
    public function onEnterSleep() as Void {
        //_isAwake = false;
        mInLowPower=true;            
        mDrawer.enterSleep(mInLowPower);
        WatchUi.requestUpdate();
    }

    //! This method is called when the device exits sleep mode.
    //! Set the isAwake flag to let onUpdate know it should render the second hand.
    public function onExitSleep() as Void {
        //_isAwake = true;
        mInLowPower=false;
        mDrawer.exitSleep(mInLowPower);
        //WatchUi.requestUpdate();
    }

    //! Turn off partial updates
    /* public function turnPartialUpdatesOff() as Void {
        _partialUpdatesAllowed = false;
    }    
    */
}

class AnalogDelegate extends WatchUi.WatchFaceDelegate {

    //private var _view as AnalogView;

    //function initialize(view as AnalogView) {
    function initialize() {
        WatchFaceDelegate.initialize();
//        _view = view;
    }

    // The onPowerBudgetExceeded callback is called by the system if the
    // onPartialUpdate method exceeds the allowed power budget. If this occurs,
    // the system will stop invoking onPartialUpdate each second, so we set the
    // partialUpdatesAllowed flag here to let the rendering methods know they
    // should not be rendering a second hand.
    function onPowerBudgetExceeded(powerInfo) {
        //System.println( "Average execution time: " + powerInfo.executionTimeAverage );
        //System.println( "Allowed execution time: " + powerInfo.executionTimeLimit );
        //partialUpdatesAllowed = false;
    }
}



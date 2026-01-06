//
// Copyright 2016-2017 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.WatchUi;
import Toybox.Lang;

typedef SettingsItem as interface {
  function getItemID();
  function currentSettingLabel() as String;
  function setNextSetting() as String;
};

class SettingsMainMenu extends WatchUi.Menu2 {
  public function initialize() {
    Menu2.initialize({ :title => new SettingsMenuTitle() });

    iconMenuItem(self, "Accent Color", new AccentColorSettings());

    toggleItem(self, "Theme", "Light", "Dark", AppStorage.KEY_32_CFG_LIGHT_THEME, Config.getLightTheme());

    menuItem(self, "Layout", :layout);

    menuItem(self, "Data Fields", :data_fields);

    if (Toybox has :Weather or (System.getSystemStats() has :batteryInDays)) {
      menuItem(self, "Base Units", :units);
    }
  }

  public static function menuItem(menu as Menu2, title as String, id) as Void {
    menu(menu, new WatchUi.MenuItem(title, null, id, null));
  }

  private static function menu(menu as Menu2, item as WatchUi.MenuItem) as Void {
    menu.addItem(item);
  }

  // prettier-ignore
  public static function iconMenuItem(menu as Menu2, lable as String, item as SettingsItem) as Void{
        // prettier-ignore
        menu.addItem(new WatchUi.IconMenuItem(lable, item.currentSettingLabel(), item.getItemID(), item as WatchUi.Drawable, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT})); 
    }

  // prettier-ignore
  public static function toggleItem(menu as Menu2, title as String, enabledLabel as String, disabledLabel as String, storageKey as AppStorage.StorageKey, currentValue as Boolean) as Void{
        // prettier-ignore
        menu.addItem(new WatchUi.ToggleMenuItem(title, {:enabled=>enabledLabel, :disabled=>disabledLabel}, storageKey, currentValue, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
    }
}

class SettingsMainMenuDelegate extends WatchUi.Menu2InputDelegate {
  public function initialize() {
    Menu2InputDelegate.initialize();
  }

  public function onSelect(item) as Void {
    if (item has :getIcon && item.getIcon() != null && item.getIcon() has :setNextSetting) {
      item.setSubLabel(item.getIcon().setNextSetting());
    } else if (item instanceof WatchUi.ToggleMenuItem and item.getId() instanceof Number) {
      AppStorage.persist(item.getId() as AppStorage.StorageKey, item.isEnabled());
    } else if (item.getId().equals(:layout)) {
      WatchUi.pushView(new SettingsLayoutMenu(), self, WatchUi.SLIDE_UP);
    } else if (item.getId().equals(:data_fields)) {
      WatchUi.pushView(new SettingsDataFieldsMenu(), self, WatchUi.SLIDE_UP);
    } else if (item.getId().equals(:units)) {
      WatchUi.pushView(new SettingsUnitsMenu(), self, WatchUi.SLIDE_UP);
    }
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
    var title = "Config";

    width = dc.getWidth();

    var appIcon = Application.loadResource(Rez.Drawables.LauncherIcon);
    var iconWidth = appIcon.getWidth();
    var titleWidth = dc.getTextWidthInPixels(title, Graphics.FONT_SMALL);

    if (titleWidth == 117 and (dc has :drawScaledBitmap)) {
      // Venu 3s
      iconWidth = 55;
    }

    if (width >= 390) {
      // Venu 3 watch allows full width to menu header, as opposed to all other watches which is half width. This condition corrects it.
      width = width * 1.25;
    }
    var iconX = (width - (iconWidth + 2 + titleWidth)) / 3;
    var iconY = (dc.getHeight() - appIcon.getHeight()) / 2;
    var titleX = iconX + iconWidth + 2;
    var titleY = dc.getHeight() / 2;

    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
    dc.clear();

    var color;
    if (Config.getLightTheme()) {
      color = Graphics.COLOR_WHITE;
    } else {
      color = Graphics.COLOR_BLACK;
    }
    dc.setColor(color, color); // removing the background color and all the data points from the background, leaving just the hour hands and hashmarks
    dc.fillRectangle(0, 0, width, dc.getHeight()); //width & height?

    if (titleWidth == 117) {
      // Venu 3s
      if (dc has :drawScaledBitmap) {
        dc.drawScaledBitmap(iconX, iconY, 55, 55, appIcon); // making icon smaller on this watch, since dc width on top of the screen is quite small constrasting to the big default icon size (70x70)
      } else {
        titleX = (width - titleWidth) / 2; // Vivoactive 5, which doesn't have ScaledBitmap and icon is too big. Removing it and showing only text.
      }
    } else {
      dc.drawBitmap(iconX, iconY, appIcon);
    }

    dc.setColor(Config.getAccentColor(), Graphics.COLOR_TRANSPARENT);
    // prettier-ignore
    dc.drawText(titleX, titleY, Graphics.FONT_SMALL, title, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
  }
}

// This is the custom Icon drawable. It fills the icon space with a color to
// to demonstrate its extents. It changes color each time the next state is
// triggered, which is done when the item is selected in this application.
class AccentColorSettings extends WatchUi.Drawable {
  public function initialize() {
    Drawable.initialize({});
  }

  public function currentSettingLabel() as String {
    var colorLabels;

    if (Config.getLightTheme()) {
      colorLabels = Application.loadResource(Rez.JsonData.mColorStringsWhite) as Array;
    } else {
      colorLabels = Application.loadResource(Rez.JsonData.mColorStrings) as Array;
    }

    return colorLabels[Config.getAccentColorID()];
  }

  public function setNextSetting() as String {
    var colors;
    if (Config.getLightTheme()) {
      colors = Application.loadResource(Rez.JsonData.mColorsWhite) as Array;
    } else {
      colors = Application.loadResource(Rez.JsonData.mColors) as Array;
    }

    var nextColorID = Config.getAccentColorID() + 1;
    if (nextColorID >= colors.size()) {
      nextColorID = 0;
    }
    Config.setAccentColor(colors[nextColorID]);
    Config.setAccentColorID(nextColorID);

    return currentSettingLabel();
  }

  public function getItemID() {
    return AppStorage.KEY_1_CFG_ACCENT_COLOR;
  }

  public function getIcon() as WatchUi.Drawable {
    return self;
  }

  public function draw(dc) {
    var color = Config.getAccentColor();
    dc.setColor(color, color);
    dc.clear();
  }
}

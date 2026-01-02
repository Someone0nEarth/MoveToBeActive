import Toybox.Lang;

class Status {

    public static function getMaxPercentageWhenCharging() as Lang.Numeric {
        return AppStorage.load(AppStorage.KEY_30_STAT_MAX_PERCENTAGE_WHEN_CHARGING);
    }

    public static function setMaxPercentageWhenCharging(battery as Lang.Numeric) as Void{
        AppStorage.persist(AppStorage.KEY_30_STAT_MAX_PERCENTAGE_WHEN_CHARGING, battery);
    }

    public static function setLastTimeCharging(time) as Void{
        AppStorage.persist(AppStorage.KEY_29_STAT_LAST_TIME_CAHRGING, time);
    }

    public static function getLastTimeCharging() as Array {
        return AppStorage.load(AppStorage.KEY_29_STAT_LAST_TIME_CAHRGING);
    }

    public static function setChargeText(text as String) as Void{
        AppStorage.persist(AppStorage.KEY_31_STAT_CHARGE_TEXT, text);
    }

    public static function resetChargeText() as Void{
        AppStorage.delete(AppStorage.KEY_31_STAT_CHARGE_TEXT);
    }

    public static function getChargeText() as String {
        return AppStorage.load(AppStorage.KEY_31_STAT_CHARGE_TEXT);
    }
}

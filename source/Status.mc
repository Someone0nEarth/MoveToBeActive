import Toybox.Lang;

class Status {

    public static function getMaxPercentageWhenCharging() as Lang.Numeric {
        return AppStorage.load(AppStorage.KEY_30_STAT_MAX_PERCENTAGE_WHEN_CHARGING);
    }

    public static function setMaxPercentageWhenCharging(battery as Lang.Numeric){
        return AppStorage.persist(AppStorage.KEY_30_STAT_MAX_PERCENTAGE_WHEN_CHARGING, battery);
    }
}

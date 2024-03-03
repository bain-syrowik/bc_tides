import Toybox.Application.Properties;

using Toybox.WatchUi;

class MainMenuDelegate extends WatchUi.Menu2InputDelegate {
    public enum {
        MENU_SETTINGS_UNITS_ID,
        MENU_SETTINGS_DISP_TYPE_ID,
        MENU_SETTINGS_DISP_MODE_ID,
        MENU_SETTINGS_ZONE_ID,
        MENU_GET_DATA,
        MENU_SET_STATION,
        MENU_SETTINGS_GPS_ID,
        MENU_SETTINGS_ENABLE_BACKGROUND_DL
    }
    private var _parent;
    function initialize(parent) {
        _parent = parent;
        Menu2InputDelegate.initialize();
    }

    function stationMenu() {
        var menu = new WatchUi.Menu2({:title=>Rez.Strings.selectStationMenuTitle});

        menu.addItem(
            new WatchUi.MenuItem(
                Rez.Strings.selectStationMenuRecent,
                "", // Sub-Label
                StationMenuDelegate.MENU_STATION_RECENT, // identifier
                {} // options
            )
        );
        menu.addItem(
            new WatchUi.MenuItem(
                Rez.Strings.selectStationMenuNearest,
                "", // Sub-Label
                StationMenuDelegate.MENU_STATION_NEAREST, // identifier
                {} // options
            )
        );
        menu.addItem(
            new WatchUi.MenuItem(
                Rez.Strings.selectStationMenuAlphabetical,
                "", // Sub-Label
                StationMenuDelegate.MENU_STATION_ALPHABETICAL, // identifier
                {} // options
            )
        );
        menu.addItem(
            new WatchUi.MenuItem(
                Rez.Strings.selectStationMenuSearch,
                "", // Sub-Label
                StationMenuDelegate.MENU_STATION_SEARCH, // identifier
                {} // options
            )
        );

        var delegate = new StationMenuDelegate();
        WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);

        return true;
    }

    function onSelect(item) {
        // FIXME: Find a good way to clean this up.
        if (item.getId() == MENU_SETTINGS_UNITS_ID) {
            var subLabel = item.getSubLabel();
            if (subLabel.equals(WatchUi.loadResource(Rez.Strings.unitsSettingSystem))) {
                item.setSubLabel(Rez.Strings.unitsSettingMetric);
                Properties.setValue("unitsProp", PropUtil.UNITS_PROP_METRIC);
            } else if (subLabel.equals(WatchUi.loadResource(Rez.Strings.unitsSettingMetric))) {
                item.setSubLabel(Rez.Strings.unitsSettingImperial);
                Properties.setValue("unitsProp", PropUtil.UNITS_PROP_IMPERIAL);
            } else if (subLabel.equals(WatchUi.loadResource(Rez.Strings.unitsSettingImperial))) {
                item.setSubLabel(Rez.Strings.unitsSettingSystem);
                Properties.setValue("unitsProp", PropUtil.UNITS_PROP_SYSTEM);
            }
        } else if (item.getId() == MENU_SETTINGS_DISP_TYPE_ID) {
            var subLabel = item.getSubLabel();
            if (subLabel.equals(WatchUi.loadResource(Rez.Strings.labelSettingValHeight))) {
                item.setSubLabel(Rez.Strings.labelSettingValTime);
                Properties.setValue("dataLabelProp", PropUtil.DATA_LABEL_PROP_TIME);
            } else if (subLabel.equals(WatchUi.loadResource(Rez.Strings.labelSettingValTime))) {
                item.setSubLabel(Rez.Strings.labelSettingValNone);
                Properties.setValue("dataLabelProp", PropUtil.DATA_LABEL_PROP_NONE);
            } else if (subLabel.equals(WatchUi.loadResource(Rez.Strings.labelSettingValNone))) {
                item.setSubLabel(Rez.Strings.labelSettingValHeight);
                Properties.setValue("dataLabelProp", PropUtil.DATA_LABEL_PROP_HEIGHT);
            }
        } else if (item.getId() == MENU_SETTINGS_DISP_MODE_ID) {
            var subLabel = item.getSubLabel();
            if (subLabel.equals(WatchUi.loadResource(Rez.Strings.displaySettingValGraph))) {
                item.setSubLabel(Rez.Strings.displaySettingValTable);
                Properties.setValue("displayProp", PropUtil.DISPLAY_PROP_TABLE);
            } else if (subLabel.equals(WatchUi.loadResource(Rez.Strings.displaySettingValTable))) {
                item.setSubLabel(Rez.Strings.displaySettingValGraph);
                Properties.setValue("displayProp", PropUtil.DISPLAY_PROP_GRAPH);
            }
        } else if (item.getId() == MENU_SETTINGS_ZONE_ID) {
            var subLabel = item.getSubLabel();
            if (subLabel.equals(WatchUi.loadResource(Rez.Strings.zoneSettingValNorth))) {
                item.setSubLabel(Rez.Strings.zoneSettingValSouth);
                Properties.setValue("zoneProp", PropUtil.ZONE_PROP_SOUTH);
            } else if (subLabel.equals(WatchUi.loadResource(Rez.Strings.zoneSettingValSouth))) {
                item.setSubLabel(Rez.Strings.zoneSettingValNorth);
                Properties.setValue("zoneProp", PropUtil.ZONE_PROP_NORTH);
            }
        } else if (item.getId() == MENU_SETTINGS_GPS_ID) {
            _parent.getLocation();
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        } else if (item.getId() == MENU_SETTINGS_ENABLE_BACKGROUND_DL) {
            var subLabel = item.getSubLabel();
            if (subLabel.equals(WatchUi.loadResource(Rez.Strings.yes))) {
                item.setSubLabel(Rez.Strings.no);
                Properties.setValue("backgroundDownloadProp", false);
            } else if (subLabel.equals(WatchUi.loadResource(Rez.Strings.no))) {
                item.setSubLabel(Rez.Strings.yes);
                Properties.setValue("backgroundDownloadProp", true);
            }
            // TODO: some action here to control whether or not we download background data?
            // Can actually just check before we enable the timer.  Here, if we set it to "no", we can disable any existing timer?
            // If we set it to "yes", should start the timer...
        } else if (item.getId() == MENU_GET_DATA) {
            WebRequests.getStationInfo();
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            if (StorageUtil.getStationCode() == null) {
                Notification.showNotification(WatchUi.loadResource(Rez.Strings.noStationSelectedMessage), 2000);
            }
        } else if (item.getId() == MENU_SET_STATION) {
            stationMenu();
        }
    }
}

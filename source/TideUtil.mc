import Toybox.Lang;
import Toybox.System;
import Toybox.Application.Properties;


(:glance)
class TideUtil {
    static const FEET_PER_METER = 3.28084;

    static var current_station_name = getStationName();

    static var currentPosition = null;

    // static variables for getHeightAtT
    static var last_i = null;
    static var t1 = null, t2 = null;
    static var h1 = 0.0f, h2 = 0.0f;
    static var A, B_n = Toybox.Math.PI, B_d, C, D;


    static function tideData(app) as Array<Array> {
        return app._hilo as Array<Array>;
    }

    static function getNextEvent(t as Number, app) as Array {
        var last_h = 0;
        for (var i = 0; i < app._hilo.size(); i++) {
            var time = tideData(app)[i][0];
            var height = tideData(app)[i][1];
            if (time > t) {
                var event_type = "H";
                if (last_h > height) {
                    event_type = "L";
                }
                return [time, height, event_type];
            }
            last_h = height;
        }
        return [null, null, null];
    }

    static function getHeightAtT(t as Number, d as Number, p, app) as Array {
        // Compute h(t) = A * cos(B * (t - C)) + D
        // For: A = (h1 - h2) / 2
        //      B = PI / (t2 - t1)
        //      C = t1
        //      D = (h2 + h1) / 2

        if (t1 == null) { t1 = t; }
        if (t2 == null) { t2 = t; }
        //var t1 = t, t2 = t;
        //var h1 = 0.0f, h2 = 0.0f;
        if (last_i == null || t2 < t) {
            var start_i = 0;
            if (last_i != null) {
                start_i = last_i;
            }
            for (var i = start_i; i < tideData(app).size(); i++) {
                if (tideData(app)[i][0] < t) {
                    t1 = tideData(app)[i][0];
                    h1 = tideData(app)[i][1];
                } else {
                    t2 = tideData(app)[i][0];
                    h2 = tideData(app)[i][1];
                    break;
                }
            }
            A = (h1 - h2) / 2.0f;
            B_d = t2 - t1;
            C = t1;
            D = (h2 + h1) / 2.0f;
        }
        var h = A * Toybox.Math.cos(B_n * (t - C) / B_d) + D;
        //if (p) { System.println("h1 = " + h1.toString() + "; h2 = " + h2.toString() + "; t1 = " + formatDateStringShort(t1) + "; t2 = " + formatDateStringShort(t2)); }
        //if (p) { System.println("h(t) = " + A.toString() + " * cos(" + B_n.toString() + " * (t - " + formatDateStringShort(C) + ") / " + B_d.toString() + ") + " + D.toString()); }
        //if (t.subtract(t1).greaterThan(d)) {
        if (t - t1 < d) {
            return [h, (h1 > h2), h1, t1];
        } else if (t2 - t < d) {
            return [h, (h1 < h2), h2, t2];
        }
        return [h, null, null, null];
    }
}
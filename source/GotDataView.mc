import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Timer;
import Toybox.WatchUi;

// Behaviour Delegate that pops the view on any input
class GotDataViewDelegate extends WatchUi.BehaviorDelegate {
    private var mView;
    
    function initialize(view as GotDataView) {
        mView = view;
        BehaviorDelegate.initialize();
    }
    
    // Helper function - all events produce same behavior
    private function processEvent(event) as Boolean {
        mView.disableTimer();
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }
    
    function onKey(event) { return processEvent(event); }
    function onTap(event) { return processEvent(event); }
    function onFlick(event) { return processEvent(event); }
    function onSwipe(event) { return processEvent(event); }
}

class GotDataView extends WatchUi.View {
    private var mTimer;

    function disableTimer() as Void {
        mTimer.stop();
    }

    function timerCallback() as Void {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

    function initialize() {
        View.initialize();
        mTimer = new Timer.Timer();
        mTimer.start(method(:timerCallback), 2000, false);  // Auto-dismiss after 2 seconds
    }

    public function onLayout( dc as Dc ) as Void {
        setLayout(Rez.Layouts.GotDataPrompt(dc));
    }

    public function onUpdate( dc as Dc) as Void {
        View.onUpdate(dc);
    }
}
import Toybox.Lang;
import Toybox.WatchUi;

class CricketUmpireCounterDelegate extends WatchUi.BehaviorDelegate {

	function initialize() {
		BehaviorDelegate.initialize();
	}

	function onMenu() as Boolean {
		WatchUi.pushView(new Rez.Menus.MainMenu(), new CricketUmpireCounterMenuDelegate(), WatchUi.SLIDE_UP);
		return true;
	}

}
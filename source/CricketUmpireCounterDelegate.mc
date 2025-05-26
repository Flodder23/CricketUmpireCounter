import Toybox.Lang;
import Toybox.WatchUi;

class CricketUmpireCounterDelegate extends WatchUi.BehaviorDelegate {
	private var _view_parent as CricketUmpireCounterView;

	private const incrementKeys as Array<Number> = [
		KEY_ZIN,
		KEY_ENTER,
		KEY_UP,
		KEY_START,
//		KEY_SELECT,
	];

	private const decrementKeys as Array<Number> = [
		KEY_ZOUT,
		KEY_DOWN,
		KEY_LAP,
	];

	function initialize(view as CricketUmpireCounterView) {
		BehaviorDelegate.initialize();

		_view_parent = view;
	}

	function onKey(keyEvent as KeyEvent) as Boolean {
		if (incrementKeys.indexOf(keyEvent.getKey()) != -1) {
			_view_parent.increment_count();
		} else if (decrementKeys.indexOf(keyEvent.getKey()) != -1) {
			_view_parent.decrement_count();
		} else {
			return false;
		}

		return true;
	}

	function onSwipe(swipeEvent as SwipeEvent) as Boolean {
		if (swipeEvent.getDirection() == SWIPE_UP) {
			_view_parent.increment_count();
		} else if (swipeEvent.getDirection() == SWIPE_DOWN) {
			_view_parent.decrement_count();
		} else {
			return false;
		}

		return true;
	}
}

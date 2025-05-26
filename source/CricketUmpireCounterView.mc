import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class CricketUmpireCounterView extends WatchUi.View {
	private var _label_count as Text?;

	private var _count as Number = 0;

	private var _min as Number = 0;
	private var _max as Number = 5;

	function initialize() {
		View.initialize();
	}

	// Load your resources here
	function onLayout(dc as Dc) as Void {
		setLayout($.Rez.Layouts.MainLayout(dc));

		_label_count = View.findDrawableById("label_count") as Text?;
		if (_label_count == null) {
			System.println(("couldn't find `label_count`"));
		}
	}

	// Called when this View is brought to the foreground. Restore
	// the state of this View and prepare it to be shown. This includes
	// loading resources into memory.
	function onShow() as Void {
	}

	// Update the view
	function onUpdate(dc as Dc) as Void {
		if (_label_count != null) {
			_label_count.setText(_count.toString());
		}

		// Call the parent onUpdate function to redraw the layout
		View.onUpdate(dc);
	}

	// Called when this View is removed from the screen. Save the
	// state of this View here. This includes freeing resources from
	// memory.
	function onHide() as Void {
	}

	function get_count() as Number{
		return _count;
	}

	function set_count(count) as Void {
		_count = count;

		if (_count >= _max) { // if we've gone over, reset
			_count = _min;
		} else if (_count < _min) {
			_count = _min; // if we've (somehow) gone below, reset
		}

		WatchUi.requestUpdate();
	}

	function increment_count() as Void {
		set_count(_count + 1);
	}

	function decrement_count() as Void {
		set_count(_count - 1);
	}

	function reset_count() as Void {
		set_count(_min);
	}
	
	function get_min() as Number {
		return _min;
	}

	function set_min(min as Number) as Void {
		_min = min;

		if (_count < _min) {
			set_count(_min);
		}
	}

	function get_max() as Number {
		return _max;
	}

	function set_max(max as Number) as Void {
		_max = max;

		if (_count >= _max) {
			set_count(_max);
		}
	}
}

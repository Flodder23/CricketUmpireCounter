import Toybox.Attention;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class CricketUmpireCounterView extends WatchUi.View {
	private var _label_count as Text?;

	private var _count as Number = 0;

	private var _min as Number = 0;
	private var _max as Number = 5;

	static const _vibrate_pulse as Attention.VibeProfile = new Attention.VibeProfile(100, 100 );
	static const _vibrate_short as Attention.VibeProfile = new Attention.VibeProfile(100, 250 );
	static const _vibrate_med   as Attention.VibeProfile = new Attention.VibeProfile(100, 500 );
	static const _vibrate_long  as Attention.VibeProfile = new Attention.VibeProfile(100, 1000);
	static const _vibrate_gap   as Attention.VibeProfile = new Attention.VibeProfile(0  , 250 );

	static const _vibrate_def  as Array<Attention.VibeProfile> = [ _vibrate_pulse ];
	static const _vibrate_over as Array<Attention.VibeProfile> = [ _vibrate_long  ];
	static const _vibrate_one  as Array<Attention.VibeProfile> = [ _vibrate_med   ];
	static const _vibrate_two  as Array<Attention.VibeProfile> = [
		_vibrate_short,
		_vibrate_gap  ,
		_vibrate_short
	];

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
			Attention.vibrate(_vibrate_over);
			_count = _min;
		} else if (_count == _max - 1) {
			Attention.vibrate(_vibrate_one);
		} else if (_count == _max - 2) {
			Attention.vibrate(_vibrate_two);
		} else if (_count >= _min) {
			Attention.vibrate(_vibrate_def);
		} else {
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

import Toybox.Application.Storage;
import Toybox.Attention;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class CricketUmpireCounterView extends WatchUi.View {
	private var _label_count as Text?;

	private var _min as Number = 0;
	private var _max as Number = 5;

	private var _count as Number = _min;

	private static const _vibeProfile_pulse as Attention.VibeProfile = new Attention.VibeProfile(100, 100 );
	private static const _vibeProfile_short as Attention.VibeProfile = new Attention.VibeProfile(100, 250 );
	private static const _vibeProfile_med   as Attention.VibeProfile = new Attention.VibeProfile(100, 500 );
	private static const _vibeProfile_long  as Attention.VibeProfile = new Attention.VibeProfile(100, 1000);
	private static const _vibeProfile_gap   as Attention.VibeProfile = new Attention.VibeProfile(0  , 250 );

	private static const _vibePattern_def  as Array<Attention.VibeProfile> = [ _vibeProfile_pulse ];
	private static const _vibePattern_over as Array<Attention.VibeProfile> = [ _vibeProfile_long  ];
	private static const _vibePattern_one  as Array<Attention.VibeProfile> = [ _vibeProfile_med   ];
	private static const _vibePattern_two  as Array<Attention.VibeProfile> = [
		_vibeProfile_short,
		_vibeProfile_gap  ,
		_vibeProfile_short
	];

	function initialize() {
		View.initialize();
	}

	// Load your resources here
	function onLayout(dc as Dc) as Void {
		setLayout(Rez.Layouts.MainLayout(dc));

		_label_count = View.findDrawableById("label_count") as Text?;
		if (_label_count == null) {
			System.println(("couldn't find 'label_count'"));
		}
	}

	function _storage_getValue(key as String, default_value as Toybox.Application.PropertyValueType) as Toybox.Application.PropertyValueType {
		var val;
		if (Toybox.Application has :Storage) {
			val = Storage.getValue(key);
		} else {
			val = Application.getApp().getProperty(key);
		}

		if (val == null) {
			System.println("couldn't load '" + key + "' from storage, setting to default value " + default_value.toString());
			return default_value;
		} else {
			return val;
		}
	}

	function _storage_setValue(key as String, value as Toybox.Application.PropertyValueType) as Void {
		if (Toybox.Application has :Storage) {
			Storage.setValue(key, value);
		} else {
			Application.getApp().setProperty(key, value);
		}
	}

	// Called when this View is brought to the foreground. Restore
	// the state of this View and prepare it to be shown. This includes
	// loading resources into memory.
	function onShow() as Void {
		_count = _storage_getValue("count", _count);
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
		_storage_setValue("count", _count);
	}

	function get_count() as Number{
		return _count;
	}

	function set_count(count) as Void {
		_count = count;

		if (_count > _max) { // if we've gone over, reset
			if (Attention has :vibrate) { Attention.vibrate(_vibePattern_over); }
			_count = _min;
		} else if (_count == _max) {
			if (Attention has :vibrate) { Attention.vibrate(_vibePattern_one); }
		} else if (_count == _max - 1) {
			if (Attention has :vibrate) { Attention.vibrate(_vibePattern_two); }
		} else if (_count >= _min) {
			if (Attention has :vibrate) { Attention.vibrate(_vibePattern_def); }
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

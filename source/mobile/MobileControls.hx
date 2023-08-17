package mobile;

import mobile.flixel.FlxVirtualPadExtra;
import haxe.ds.Map;
import mobile.flixel.FlxHitbox;
import mobile.flixel.FlxVirtualPad;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil;
import shaders.RGBPalette;
import shaders.RGBPalette.RGBShaderReference;

class MobileControls extends FlxSpriteGroup
{
	public var htiboxMap:Map<String, Modes>;
	public static var instance:MobileControls;
	public var virtualPad:FlxVirtualPad;
	public var virtualPadExtra:FlxVirtualPadExtra;
	public var hitbox:FlxHitbox;
	var padMap:Map<String, FlxExtraActions>;
	public static var globalRgbShaders:Array<RGBPalette> = [];
	public var rgbShader:RGBShaderReference;

	public function new()
	{
		instance = this;
		super();
		switch (MobileControls.getMode())
		{
			case 0: // RIGHT_FULL
				initControler(0);
			case 1: // LEFT_FULL
				initControler(1);
			case 2: // CUSTOM
				initControler(2);
			case 3: // BOTH_FULL
				initControler(3);
			case 4: // HITBOX
				initControler(4);
			case 5: // KEYBOARD
		}
	}

	private function initControler(virtualPadMode:Int = 0):Void
	{
		padMap = new Map<String, FlxExtraActions>();
		padMap.set("NONE", NONE);
		padMap.set("ONE", SINGLE);
		padMap.set("TWO", DOUBLE);
		switch (virtualPadMode)
		{
			case 0:
				virtualPad = new FlxVirtualPad(RIGHT_FULL, NONE);
				add(virtualPad);
				virtualPadExtra = MobileControls.getExtraCustomMode(new FlxVirtualPadExtra(padMap.get(ClientPrefs.data.extraButtons)));
				add(virtualPadExtra);
				for (i in 0...virtualPad.length)
					rgbShader = new RGBShaderReference(virtualPad, initDynamicColors(i));
			case 1:
				virtualPad = new FlxVirtualPad(LEFT_FULL, NONE);
				add(virtualPad);
				virtualPadExtra = MobileControls.getExtraCustomMode(new FlxVirtualPadExtra(padMap.get(ClientPrefs.data.extraButtons)));
				add(virtualPadExtra);
				for (i in 0...virtualPad.length)
					rgbShader = new RGBShaderReference(virtualPad, initDynamicColors(i));
			case 2:
				virtualPad = MobileControls.getCustomMode(new FlxVirtualPad(RIGHT_FULL, NONE));
				add(virtualPad);
				virtualPadExtra = MobileControls.getExtraCustomMode(new FlxVirtualPadExtra(padMap.get(ClientPrefs.data.extraButtons)));
				add(virtualPadExtra);
				for (i in 0...virtualPad.length)
					rgbShader = new RGBShaderReference(virtualPad, initDynamicColors(i));
			case 3:
				virtualPad = new FlxVirtualPad(BOTH_FULL, NONE);
				add(virtualPad);
				virtualPadExtra = MobileControls.getExtraCustomMode(new FlxVirtualPadExtra(padMap.get(ClientPrefs.data.extraButtons)));
				add(virtualPadExtra);
				for (i in 0...virtualPad.length)
					rgbShader = new RGBShaderReference(virtualPad, initDynamicColors(i));
			case 4:
			htiboxMap = new Map<String, Modes>();
			htiboxMap.set("NONE", DEFAULT);
			htiboxMap.set("ONE", SINGLE);
			htiboxMap.set("TWO", DOUBLE);

			hitbox = new FlxHitbox(htiboxMap.get(ClientPrefs.data.extraButtons));

				add(hitbox);
				for (i in 0...hitbox.length){
					if (i != 4 ||  i != 5) // no colors for extra hitboxes
					rgbShader = new RGBShaderReference(hitbox, initDynamicColors(i));
				}
		}
	}

	override public function destroy():Void
	{
		super.destroy();

		if (virtualPad != null)
		{
			virtualPad = FlxDestroyUtil.destroy(virtualPad);
			virtualPad = null;
		}

		if (hitbox != null)
		{
			hitbox = FlxDestroyUtil.destroy(hitbox);
			hitbox = null;
		}
	}

	public static function setOpacity(opacity:Float = 0.6):Void
	{
		FlxG.save.data.mobileControlsOpacity = opacity;
		FlxG.save.flush();
	}

	public static function getOpacity():Float
	{
		if (FlxG.save.data.mobileControlsOpacity == null)
		{
			FlxG.save.data.mobileControlsOpacity = 0.6;
			FlxG.save.flush();
		}

		return FlxG.save.data.mobileControlsOpacity;
	}

	public static function setMode(mode:Int = 0):Void
	{
		FlxG.save.data.mobileControlsMode = mode;
		FlxG.save.flush();
	}

	public static function getMode():Int
	{
		if (FlxG.save.data.mobileControlsMode == null)
		{
			FlxG.save.data.mobileControlsMode = 0;
			FlxG.save.flush();
		}

		return FlxG.save.data.mobileControlsMode;
	}

	public static function setCustomMode(virtualPad:FlxVirtualPad):Void
	{
		if (FlxG.save.data.buttons == null)
		{
			FlxG.save.data.buttons = new Array();
			for (buttons in virtualPad)
				FlxG.save.data.buttons.push(FlxPoint.get(buttons.x, buttons.y));
		}
		else
		{
			var tempCount:Int = 0;
			for (buttons in virtualPad)
			{
				FlxG.save.data.buttons[tempCount] = FlxPoint.get(buttons.x, buttons.y);
				tempCount++;
			}
		}

		FlxG.save.flush();
	}

	public static function getCustomMode(virtualPad:FlxVirtualPad):FlxVirtualPad
	{
		var tempCount:Int = 0;

		if (FlxG.save.data.buttons == null)
			return virtualPad;

		for (buttons in virtualPad)
		{
			buttons.x = FlxG.save.data.buttons[tempCount].x;
			buttons.y = FlxG.save.data.buttons[tempCount].y;
			tempCount++;
		}

		return virtualPad;
	}
	public static function setExtraCustomMode(virtualPad:FlxVirtualPadExtra):Void
		{
			if (FlxG.save.data.buttonsExtra == null)
			{
				FlxG.save.data.buttonsExtra = new Array();
				for (buttons in virtualPad)
					FlxG.save.data.buttonsExtra.push(FlxPoint.get(buttons.x, buttons.y));
			}
			else
			{
				var tempCount:Int = 0;
				for (buttons in virtualPad)
				{
					FlxG.save.data.buttonsExtra[tempCount] = FlxPoint.get(buttons.x, buttons.y);
					tempCount++;
				}
			}
	
			FlxG.save.flush();
		}
	
		public static function getExtraCustomMode(virtualPad:FlxVirtualPadExtra):FlxVirtualPadExtra
		{
			var tempCount:Int = 0;
	
			if (FlxG.save.data.buttonsExtra == null)
				return virtualPad;
			for (buttons in virtualPad)
				FlxG.save.data.buttonsExtra.push(FlxPoint.get(buttons.x, buttons.y));

			for (buttons in virtualPad)
			{
				buttons.x = FlxG.save.data.buttonsExtra[tempCount].x;
				buttons.y = FlxG.save.data.buttonsExtra[tempCount].y;
				tempCount++;
			}
	
			return virtualPad;
		}
		public static function initDynamicColors(button:Int)			{
				if(backend.ClientPrefs.data.dynamicColors && globalRgbShaders == null)
				{
					var newRGB:RGBPalette = new RGBPalette();
						globalRgbShaders[button] = newRGB;
						var arr:Array<FlxColor> = ClientPrefs.data.arrowRGB[button];
						if (button > -1 && button <= arr.length)
							{
								newRGB.r = arr[0];
								newRGB.g = arr[1];
								newRGB.b = arr[2];
							}
				}
				return globalRgbShaders[button];
			}
}

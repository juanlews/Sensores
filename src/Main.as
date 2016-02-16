package
{
	import flash.desktop.NativeApplication;
	import flash.display.Loader;
	import flash.events.AccelerometerEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.GeolocationEvent;
	import flash.events.MediaEvent;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.media.CameraRoll;
	import flash.media.CameraUI;
	import flash.media.MediaPromise;
	import flash.sensors.Accelerometer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.sensors.Geolocation;
	import flash.events.MediaEvent;
	
	/**
	 * ...
	 * @author
	 */
	public class Main extends Sprite
	{
		private var _roll:CameraRoll;
		private var _geo:Geolocation;
		private var _texto:TextField;
		private var _acc:Accelerometer;
		private var _quadrado:Sprite;
		private var _camera:CameraUI
		
		public function Main()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			
			this._texto = new TextField();
			this._texto.width = stage.stageWidth;
			this._texto.height = stage.stageHeight;
			this._texto.multiline = true;
			this._texto.wordWrap = true;
			this.addChild(_texto);
			
			this._quadrado = new Sprite();
			this._quadrado.graphics.beginFill(0);
			this._quadrado.graphics.drawRect(0, 0, 200, 200);
			this._quadrado.graphics.endFill();
			this._quadrado.x = (stage.stageWidth - this._quadrado.height) / 2;
			this._quadrado.y = (stage.stageHeight - this._quadrado.width) / 2;
			
			stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE, swipe);
			stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, zoom);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, down);
			stage.addEventListener(MouseEvent.MOUSE_UP, up);
			this.addChild(_quadrado);
			
			_camera = new CameraUI;
			/*			
			_camera.addEventListener(MediaEvent.COMPLETE, completa);
			_camera.addEventListener(ErrorEvent.ERROR, cameraErro);
			_camera.addEventListener(Event.CANCEL, cameraCancel);
			
			_camera.launch("image");*/
			
			_roll = new CameraRoll;
			
			_roll.addEventListener(MediaEvent.SELECT, completa);
			_roll.addEventListener(ErrorEvent.ERROR, cameraErro);
			_roll.addEventListener(Event.CANCEL, cameraCancel);
			
			if (Accelerometer.isSupported)
			{
				this._texto.defaultTextFormat = new TextFormat('sans', 20 + stage.stageHeight / 50, 0);
				this._texto.text = "Acelerometro Localizado";
				
				this._acc.addEventListener(AccelerometerEvent.UPDATE, accAtualizado);
			}
			else
			{
				this._texto.defaultTextFormat = new TextFormat('sans', 20 + stage.stageHeight / 50, 0XFF000000);
				this._texto.appendText("\n" + "Sem Suporte ao acelerometro");
			}
			
			if (Geolocation.isSupported)
			{
				
				this._texto.defaultTextFormat = new TextFormat('sans', 20, 0);
				this._texto.appendText("\n" + "GPS Localizado");
				this._geo = new Geolocation();
				this._geo.addEventListener(GeolocationEvent.UPDATE, gpsatualizado);
				
			}
			else
			{
				
				this._texto.defaultTextFormat = new TextFormat('sans', 20 + stage.stageHeight / 50, 0XFF000000);
				this._texto.appendText("\n" + "GPS Não Loacalizado");
			}
		}
		
		private function completa(evento:MediaEvent):void
		{
			var promise:MediaPromise = evento.data;
			var _loader:Loader = new Loader;
				
			trace("completa")
			addChild(_loader);
		
			_loader.loadFilePromise(promise);
			
		}
		
		private function cameraErro(evento:ErrorEvent):void
		{
			trace("erro");
		}
		
		private function cameraCancel(evento:Event):void
		{
			trace("cancelado");
		}
		
		private function down(evento:MouseEvent):void
		{
			_quadrado.startDrag();
		
		}
		
		private function up(evento:MouseEvent):void
		{
			_quadrado.stopDrag();
		
		}
		
		private function swipe(evento:TransformGestureEvent):void
		{
			_quadrado.graphics.clear();
			this._quadrado.graphics.beginFill(int(Math.round(Math.random() * 0XFFFFFF)));
			this._quadrado.graphics.drawRect(0, 0, 200, 200);
			this._quadrado.graphics.endFill();
		
		}
		
		private function zoom(evento:TransformGestureEvent):void
		{
			_quadrado.scaleX *= evento.scaleX;
			_quadrado.scaleY *= evento.scaleY;
		
		}
		
		private function gpsatualizado(evento:GeolocationEvent):void
		{
			_texto.appendText("\n" + evento.longitude + "\n" + evento.altitude);
		
		}
		
		private function accAtualizado(evento:AccelerometerEvent):void
		{
			this._texto.appendText('X: ' + evento.accelerationX + "\n" + "Y: " + evento.accelerationY + "\n" + "Z: " + evento.accelerationZ);
		
		}
		
		private function deactivate(e:Event):void
		{
			// make sure the app behaves well (or exits) when in background
			//NativeApplication.nativeApplication.exit();
		}
	
	}

}
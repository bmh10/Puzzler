package com.techlabs.puzzle {

	import com.bit101.components.ProgressBar;
	import com.bit101.components.PushButton;
	import com.bit101.components.Text;
	import com.techlabs.puzzle.events.PuzzleEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;

	public class ControlPanel extends Sprite {

		private var _shuffleButton:PushButton;
		private var _randomPuzzle:PushButton;
		private var _uploadImage:PushButton;
		private var _textBox:Text;
		private var _timerBar:ProgressBar;
		
		private var _preview:Bitmap;
		private var index:int = -1;
		private const MAX_INDEX:int = 4;
		
		private var gameTimer:Timer;
		private const TIMER_DELAY:int = 1000;

		public function ControlPanel() {
			
			// Buttons
			_shuffleButton = new PushButton(this, 20, 20, "Shuffle", shuffleBoardHandler);
			_randomPuzzle = new PushButton(this, 20, 45, "Random Puzzle", changeImageHandler);
			_uploadImage = new PushButton(this, 20, 70, "Upload Image", uploadImageHandler);
			_textBox = new Text(this, 130, 70, "Image URL");
			_textBox.height = 20;
			_textBox.width = 200;
			_textBox.visible = false;
			
			_timerBar = new ProgressBar(this, 150, 25);
			_timerBar.width = 500;
			_timerBar.maximum = 100;
			_timerBar.value = 20;
			
			gameTimer = new Timer(TIMER_DELAY, _timerBar.maximum);
			gameTimer.addEventListener(TimerEvent.TIMER, onGameTimerTick);
			gameTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onGameTimerComplete);
			gameTimer.start();
		}
		
		// Sets the small preview image
		// It is there only give the user a hint about how
		// the result should look like
		public function setPreview(image:Bitmap):void {
			
			// This is the scale we need to get 100x100px image
			// -> 100px = Originalwidth / scaleFactor;
			// -> scaleFactor = 100px / Originalwidth;
			var scale:Number = 100/image.width;
			
			// Transform matrix for scaling
			var m:Matrix = new Matrix();
			m.scale(scale, scale);
		
			var bmd:BitmapData = new BitmapData(image.width*scale, image.width*scale);
			bmd.draw(image, m);
			_preview = new Bitmap(bmd, PixelSnapping.AUTO, true);
			
			addChild(_preview);

			_preview.x = 20;
			_preview.y = 105;
		}
		
		private function shuffleBoardHandler(e:Event):void {
			dispatchEvent(new PuzzleEvent(PuzzleEvent.SHUFFLE));
		}

		private function uploadImageHandler(e:Event):void {
			_textBox.visible = !_textBox.visible;
			dispatchEvent(new PuzzleEvent(PuzzleEvent.CHANGE_IMAGE, null, _textBox.text));
		}
		
		private function changeImageHandler(e:Event):void {
			index++;
			if (index == MAX_INDEX)
				index = 0;
			
			switch (index) {
				case 0:
					dispatchEvent(new PuzzleEvent(PuzzleEvent.CHANGE_IMAGE, null, "sports_car.jpg"));
					break;
				case 1:
					dispatchEvent(new PuzzleEvent(PuzzleEvent.CHANGE_IMAGE, null, "newYork.jpg"));
					break;
				case 2:
					dispatchEvent(new PuzzleEvent(PuzzleEvent.CHANGE_IMAGE, null, "Flower.png"));
					break;
				case 3:
					dispatchEvent(new PuzzleEvent(PuzzleEvent.CHANGE_IMAGE, null, "hamster.jpg"));
					break;
			}
		}
			
		private function onGameTimerTick(e:TimerEvent) : void {
			_timerBar.value++;
		}
			
		private function onGameTimerComplete(e:TimerEvent) : void {
		
		}
		
	}
}

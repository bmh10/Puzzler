package com.techlabs.puzzle {

	import com.bit101.components.Label;
	import com.bit101.components.ProgressBar;
	import com.bit101.components.PushButton;
	import com.bit101.components.Text;
	import com.techlabs.puzzle.events.PuzzleEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.utils.Timer;

	public class ControlPanel extends Sprite {

		private var _shuffleButton:PushButton;
		private var _randomPuzzle:PushButton;
		private var _uploadImage:PushButton;
		private var _mainMenuImage:PushButton;
		private var _textBox:Text;
		private var _timerBar:ProgressBar;
		private var _label:Label;
		
		private var _preview:Bitmap;
		private var index:int = -1;
		private const MAX_INDEX:int = 4;
		
		private var gameTimer:Timer;
		private const TIMER_DELAY:int = 1000;
		private const TIMER_MAX:int = 10;
		
		private var game:SlidingPuzzle;
		private var timed:Boolean;

		public function ControlPanel(game:SlidingPuzzle, timed:Boolean) {
			this.game = game;
			this.timed = timed;
			
			// Buttons
			_shuffleButton = new PushButton(this, 20, 20, "Shuffle", shuffleBoardHandler);
			_randomPuzzle = new PushButton(this, 20, 45, "Random Puzzle", changeImageHandler);
			_uploadImage = new PushButton(this, 20, 70, "Upload Image", uploadImageHandler);
			_mainMenuImage = new PushButton(this, 20, 105, "Main Menu", mainMenuHandler);
			_textBox = new Text(this, 130, 70, "Image URL");
			_textBox.height = 20;
			_textBox.width = 200;
			_textBox.visible = false;
			
			if (timed) {
				_timerBar = new ProgressBar(this, 150, 20);
				_timerBar.width = 500;
				_timerBar.maximum = TIMER_MAX;
				_timerBar.value = 0;
				
				_label = new Label(this, 325, 30, "Press 'shuffle' to start timer...");
				
				gameTimer = new Timer(TIMER_DELAY, _timerBar.maximum);
				gameTimer.addEventListener(TimerEvent.TIMER, onGameTimerTick);
				gameTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onGameTimerComplete);
			}
		}
		
		public function setVisible(b:Boolean) : void {
			_shuffleButton.visible = b;
			_randomPuzzle.visible = b;
			_uploadImage.visible = b;
			_mainMenuImage.visible = b;
			_textBox.visible = b;
			_preview.visible = b;
			removeChild(_preview);
			if (timed) {
				_timerBar.visible = b;
				_label.visible = b;	
			}
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
			
			// Remove last preview image (so we are not just drawing over old image)
			if (_preview != null)
				removeChild(_preview);
			_preview = new Bitmap(bmd, PixelSnapping.AUTO, true);
			
			addChild(_preview);

			_preview.x = 20;
			_preview.y = 140;
		}
		
		private function shuffleBoardHandler(e:Event):void {
			dispatchEvent(new PuzzleEvent(PuzzleEvent.SHUFFLE));
			restartTimer();
			game.playButtonSound();
		}

		private function uploadImageHandler(e:Event):void {
			resetTimer();
			_textBox.visible = !_textBox.visible;
			dispatchEvent(new PuzzleEvent(PuzzleEvent.CHANGE_IMAGE, null, _textBox.text));
			game.playButtonSound();
		}
		
		private function changeImageHandler(e:Event):void {
			resetTimer();
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
			game.playButtonSound();
		}
		
		private function mainMenuHandler(e:Event):void {
			resetTimer();
			game.loadMenuSystem();
			game.playButtonSound();
		}
		
		private function resetTimer() : void {
			if (timed) {
				gameTimer.reset();
				_timerBar.value = 0;
			}
		}
		
		private function restartTimer() : void {
			if (timed) {
				gameTimer.reset();
				_timerBar.value = 0;
				gameTimer.start();
			}
		}
			
		private function onGameTimerTick(e:TimerEvent) : void {
			_timerBar.value++;
		}
			
		private function onGameTimerComplete(e:TimerEvent) : void {
			dispatchEvent(new PuzzleEvent(PuzzleEvent.CHANGE_IMAGE, null, "game_over.png"));
		}
		
	}
}

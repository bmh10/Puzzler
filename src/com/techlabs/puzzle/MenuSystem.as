package com.techlabs.puzzle {
	
	import away3d.arcane;
	
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Slider;
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
	
	public class MenuSystem extends Sprite {
		
		private var game:SlidingPuzzle;
		
		//0=main, 1=options, 2=info, 3=gameType
		private var menuState:int = 0;
		
		private var _playButton:PushButton;
		private var _optionsButton:PushButton;
		private var _infoButton:PushButton;
		
		private var _soundButton:PushButton;
		private var _difficultyLabel:Label;
		private var _difficultySlider:Slider;
		private var _paddingLabel:Label;
		private var _paddingSlider:Slider;
		private var _backButton:PushButton;
		private var _infoLabel:Label;
		
		private var _trainingButton:PushButton;
		private var _timedButton:PushButton;
		
		
		public function MenuSystem(g:SlidingPuzzle) {
			this.game = g;
			var x:int = 350;
			var y:int = 50;
			var s:int = 25;
			
			_playButton = new PushButton(this, x, y, "Play", playHandler);
			_optionsButton = new PushButton(this, x, y+=s, "Options", optionsHandler);
			_infoButton = new PushButton(this, x, y+=s, "Info", infoHandler);
			
			y=50;
			_soundButton = new PushButton(this, x, y, "Sound", soundHandler);
			_difficultyLabel = new Label(this, x-70, y+s-5, "Difficulty");
			_difficultySlider = new Slider("horizontal", this, x, y+=s, difficultyHandler);
			_difficultySlider.minimum = 0;
			_difficultySlider.maximum = 100;

			_paddingLabel = new Label(this, x-70, y+s-5, "Padding");
			_paddingSlider = new Slider("horizontal", this, x, y+=s, paddingHandler);
			_paddingSlider.minimum = 3;
			_paddingSlider.maximum = 20;
			_backButton = new PushButton(this, x, y+=s, "Back", backHandler);
			
			y=50;
			_trainingButton = new PushButton(this, x, y, "Training", trainingHandler);
			_timedButton = new PushButton(this, x, y+=s, "Timed", timedHandler);
			
			y=50+s;
			_infoLabel = new Label(this, x, y, "A 3D sliding puzzle game\n adapted by Ben Homer");
			
			setInitialSliderValues();
			updateComponents();
		}
		
		private function playHandler(e:Event):void {
			menuState = 3;
			updateComponents();
			game.playButtonSound();
		}
		
		private function optionsHandler(e:Event):void {
			menuState = 1;
			updateComponents();
			game.playButtonSound();
		}
		
		private function infoHandler(e:Event) : void {
			menuState = 2;
			updateComponents();
			game.playButtonSound();
		}
		
		private function soundHandler(e:Event) : void {
			game.switchSound();
			game.playButtonSound();
		}
		
		private function setInitialSliderValues() : void {
			var diff:int = SlidingPuzzle.subdivisions;
			if (diff == 4)
				_difficultySlider.value = 25;
			else if (diff == 5)
				_difficultySlider.value = 50;
			else if (diff == 10)
				_difficultySlider.value = 75;
			
			_paddingSlider.value = SlidingPuzzle.padding;
		}
		
		private function difficultyHandler(e:Event) : void {
			var n:int = Math.round(_difficultySlider.value);
			var diff:int = 10;
			if (n < 33)
				diff = 4;
			else if (n < 66)
				diff = 5;
				
			game.newDifficulty(diff);
		}
		
		private function paddingHandler(e:Event) : void {
			var n:int = Math.round(_paddingSlider.value);
			game.newPadding(n);
		}
		
		private function backHandler(e:Event) : void {
			menuState = 0;
			updateComponents();
			game.playButtonSound();
		}
		
		private function trainingHandler(e:Event) : void {
			game.loadGame(false);
			game.playButtonSound();
		}
		
		private function timedHandler(e:Event) : void {
			game.loadGame(true);
			game.playButtonSound();
		}
		
		public function setVisible(b:Boolean) : void {
			_playButton.visible = b;
			_optionsButton.visible = b;
			_infoButton.visible = b;
			_soundButton.visible = b;
			_difficultyLabel.visible = b;
			_difficultySlider.visible = b;
			_paddingLabel.visible = b;
			_paddingSlider.visible = b;
			_backButton.visible = b;
			_trainingButton.visible = b;
			_timedButton.visible = b;
			_infoLabel.visible = b;
		}
		
		private function updateComponents() : void {
			setVisible(false);
			
			switch (menuState) {
				case 0:
					_playButton.visible = true;
					_optionsButton.visible = true;
					_infoButton.visible = true;
					break;
				
				case 1:
					_soundButton.visible = true;
				    _difficultyLabel.visible = true;
					_difficultySlider.visible = true;
					_paddingLabel.visible = true;
					_paddingSlider.visible = true;
					_backButton.visible = true;
					break;
					
				case 2:
					_infoLabel.visible = true;
					_backButton.visible = true;
					break;
				
				case 3:
					_trainingButton.visible = true;
					_timedButton.visible = true;
					break;
			}
		}
		
	}
}

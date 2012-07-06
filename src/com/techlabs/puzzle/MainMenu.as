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
	
	public class MainMenu extends Sprite {
		
		private var _playButton:PushButton;
		private var _optionsButton:PushButton;
		private var _infoButton:PushButton;
		
		private var _preview:Bitmap;
		
		
		public function MainMenu() {
			
			// Buttons
			_playButton = new PushButton(this, 20, 20, "Play", playHandler);
			_optionsButton = new PushButton(this, 20, 45, "Options", optionsHandler);
			_infoButton = new PushButton(this, 20, 70, "Info", infoHandler);
		}
		
		private function playHandler(e:Event):void {
		}
		
		private function optionsHandler(e:Event):void {
		}
		
		private function infoHandler(e:Event) : void {
		}
		
	}
}

package com.techlabs.puzzle {

	import away3d.events.MouseEvent3D;
	import away3d.materials.BitmapMaterial;
	import away3d.primitives.Plane;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Circ;
	import com.techlabs.puzzle.events.PuzzleEvent;
	
	import flash.display.Bitmap;

	/**
	 * ...
	 * @author Timo Virtanen
	 */
	public class PuzzlePiece extends Plane {
		
		public static const LEFT:int = 1;
		public static const RIGHT:int = 2;
		public static const DOWN:int = 3;
		public static const UP:int = 4;
		
		private var _ease:Function = Circ.easeInOut;

		private var _padding:int;
		
		public var image:Bitmap;

		public function PuzzlePiece(image:Bitmap, init:Object = null) {
			init.material = new BitmapMaterial(image.bitmapData, {smoothing:true})
			super(init);
			
			this.image = image;
			
			_padding = SlidingPuzzle.padding;
			addOnMouseDown(mouseDownHandler);
		}
		
		// This function moves the tile to the given direction.
		// It takes an optional parameter "tween". If set to false this puzzle piece
		// will be immediately moved to the destination (no tween)
		public function move(direction:int, tween:Boolean = true):void {
			switch(direction) {
				// LEFT
				case LEFT:
					if (tween) {
						TweenLite.to(this, .4, {x:x - width - _padding, ease:_ease, onComplete:tweenComplete});
						dispatchEvent(new PuzzleEvent(PuzzleEvent.MOVE));
					} else {
						x = x - width - _padding
					}

					break;
				// RIGHT	
				case RIGHT:
					if (tween) {
						TweenLite.to(this, .4, {x:x + width + _padding, ease:_ease, onComplete:tweenComplete});
						dispatchEvent(new PuzzleEvent(PuzzleEvent.MOVE));
					} else {
						x = x + width + _padding;
					}

					break;
				// UP
				case UP:
					if (tween) {
						TweenLite.to(this, .4, {z:z + height + _padding, ease:_ease, onComplete:tweenComplete});
						dispatchEvent(new PuzzleEvent(PuzzleEvent.MOVE));
					} else {
						z = z + height + _padding;
					}

					break;
				// DOWN
				case DOWN:
					if (tween) {
						TweenLite.to(this, .4, {z:z - height - _padding, ease:_ease, onComplete:tweenComplete});
						dispatchEvent(new PuzzleEvent(PuzzleEvent.MOVE));
					} else {
						z = z - height - _padding;
					}

					break;
			}
		}
		
		private function tweenComplete():void {
			dispatchEvent(new PuzzleEvent(PuzzleEvent.READY));
		}
		
		private function mouseDownHandler(e:MouseEvent3D):void {
			dispatchEvent(new PuzzleEvent(PuzzleEvent.CLICK, this));
		}

	}

}

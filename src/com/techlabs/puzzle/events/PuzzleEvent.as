package com.techlabs.puzzle.events {

	import com.techlabs.puzzle.PuzzlePiece;
	
	import flash.events.Event;

	/**
	 * ...
	 * @author Timo Virtanen
	 */
	public class PuzzleEvent extends Event {

		public static const MOVE:String 		= "PuzzleEvent:MOVE";
		public static const CLICK:String 		= "PuzzleEvent:CLICK";
		public static const READY:String 		= "PuzzleEvent:READY";
		public static const SHUFFLE:String 		= "PuzzleEvent:SUFFLE";
		public static const CHANGE_IMAGE:String = "PuzzleEvent:CHANGE_IMAGE";

		private var _piece:PuzzlePiece;
		private var _imageURL:String;

		public function PuzzleEvent(type:String, piece:PuzzlePiece = null, imageURL:String = null) {
			super(type);
			_piece = piece;
			_imageURL = imageURL;
		}

		public override function clone():Event {
			return new PuzzleEvent(type, piece, imageURL);
		}

		public override function toString():String {
			return formatToString("NavigationEvent", "piece", "imageURL");
		}

		public function get piece():PuzzlePiece {
			return _piece;
		}
		
		public function get imageURL():String {
			return _imageURL;
		}

	}

}

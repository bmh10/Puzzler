package {

	import away3d.cameras.HoverCamera3D;
	import away3d.containers.View3D;
	
	import com.techlabs.puzzle.ControlPanel;
	import com.techlabs.puzzle.PuzzleBoard;
	import com.techlabs.puzzle.events.PuzzleEvent;
	import com.techlabs.puzzle.helpers.ImageSlicer;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Timo Virtanen
	 */
	[SWF(width=800, height = 600, backgroundColor = "#333333", framerate = "25")]
	public class SlidingPuzzle extends Sprite {
		
		// Defines how the puzzle will be divided
		public static var subdivisions:int = 4;
		
		// Padding between the pieces
		public static var padding:int = 3;
		
		// The size of the puzzle board
		public static var size:int = 500;

		private var _image:Bitmap;

		private var _loader:Loader;
		private var _request:URLRequest;
		
		private var _slicer:ImageSlicer;
		private var _puzzleImages:Array;

		private var _gameBoard:PuzzleBoard;

		private var _view:View3D;
		private var _camera:HoverCamera3D;

		private var _controlPanel:ControlPanel;

		public function SlidingPuzzle() {
			_slicer = new ImageSlicer();

			_gameBoard = new PuzzleBoard();
			_puzzleImages = new Array();

			_controlPanel = new ControlPanel();
			_controlPanel.addEventListener(PuzzleEvent.CHANGE_IMAGE, imageChangeHandler);
			_controlPanel.addEventListener(PuzzleEvent.SHUFFLE, suffleHandler);
			addChild(_controlPanel);

			initStage();
			init3D();

			initPuzzle("http://taylorlifescience.pbworks.com/f/1266511756/hamster%201.jpg");
		}

		private function initStage():void {
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.MEDIUM;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}

		private function init3D():void {
			_camera = new HoverCamera3D();
			_camera.minTiltAngle = 15;
			_camera.maxTiltAngle = 65;

			_view = new View3D({width:800, height:600, x:400, y:300, camera:_camera});
			addChild(_view);

			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		private function initPuzzle(imageURL:String):void {
			loadPuzzleImage(imageURL);
		}
		
		// Loads the image
		private function loadPuzzleImage(imageURL:String):void {
			_loader = new Loader();
			_request = new URLRequest(imageURL);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoadComplete);
			_loader.load(_request);
		}
		
		// This will execute when load completes
		private function imageLoadComplete(e:Event):void {
			_image = _loader.content as Bitmap;
			
			// sliceImage() returns a two dimensional array containing the sliced bitmaps
			_puzzleImages = _slicer.sliceImage(_image);
			
			// creates the puzzle board
			_gameBoard.createPuzzle(_puzzleImages);
			_view.scene.addChild(_gameBoard);
			
			// sets the preview image in the control panel
			_controlPanel.setPreview(_image);
		}

		private function imageChangeHandler(e:PuzzleEvent):void {
			initPuzzle(e.imageURL);
		}
		
		private function suffleHandler(e:PuzzleEvent):void {
			_gameBoard.shuffle();
		}
		
		// EnterFrameHandler is responsible for
		// 1. camera controls
		// 2. rendering the 3D view
		private function enterFrameHandler(e:Event):void {
			_camera.panAngle = (stage.stageWidth * .5 - stage.mouseX) * .1 - 180;
			_camera.tiltAngle = (stage.stageHeight * .5 - stage.mouseY) * .5;
			_camera.hover();
			
			_view.render();
		}

	}

}

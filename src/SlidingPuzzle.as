package {

	import away3d.cameras.HoverCamera3D;
	import away3d.containers.View3D;
	
	import com.techlabs.puzzle.ControlPanel;
	import com.techlabs.puzzle.MenuSystem;
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
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	import flashx.textLayout.formats.BackgroundColor;
	
	/**
	 * ...
	 * @author Timo Virtanen
	 */
	[SWF(width=800, height = 600, backgroundColor = "#333333", framerate = "25")]
	public class SlidingPuzzle extends Sprite {
		
		// Defines how the puzzle will be divided
		// NB must be a multiple of 'size' (otherwise moving pieces will break)
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
		
		private var _menuSystem:MenuSystem;
		
		//private var _backingTrack:Sound;
		private var _buttonSound:Sound;
		private var soundOn:Boolean = true;
		
		public function SlidingPuzzle() {
			init();
			loadMenuSystem();
		}
		
		private function init() : void {
			//_backingTrack = new Sound(new URLRequest("back1.mp3"));
			_buttonSound = new Sound(new URLRequest("buttonPress.mp3"));
			_slicer = new ImageSlicer();
			_gameBoard = new PuzzleBoard();
			_puzzleImages = new Array();
			
			initStage();
			init3D();
			//_backingTrack.play(0, 100);
		}
		
		public function newDifficulty(diff:int) : void {
			subdivisions = diff;
			_view.scene.removeChild(_gameBoard);
			initPuzzle("puzzler_logo.png");
		}
		
		public function newPadding(pad:int) : void {
			padding = pad;
			_view.scene.removeChild(_gameBoard);
			initPuzzle("puzzler_logo.png");
		}
		
		public function loadMenuSystem() : void {
			if (_controlPanel != null)
				_controlPanel.setVisible(false);
			_controlPanel = null;
			
			_menuSystem = new MenuSystem(this);
			_menuSystem.addEventListener(PuzzleEvent.CHANGE_IMAGE, imageChangeHandler);
			addChild(_menuSystem);
			
			initPuzzle("puzzler_logo.png");
		}		
		
		public function loadGame(timed:Boolean) : void {
			_menuSystem.setVisible(false);
			_menuSystem = null;
			
			_controlPanel = new ControlPanel(this, timed);
			_controlPanel.addEventListener(PuzzleEvent.CHANGE_IMAGE, imageChangeHandler);
			_controlPanel.addEventListener(PuzzleEvent.SHUFFLE, suffleHandler);
			addChild(_controlPanel);
			
			initPuzzle("Flower.png");
		}

		private function initStage():void {
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.MEDIUM;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}

		private function init3D(xpos:int=400, ypos:int=300):void {
			_camera = new HoverCamera3D();
			_camera.minTiltAngle = 15;
			_camera.maxTiltAngle = 65;

			_view = new View3D({width:800, height:600, x:xpos, y:ypos, camera:_camera});
			addChild(_view);

			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		private function initPuzzle(imageURL:String):void {
			loadPuzzleImage(imageURL);
		}
		
		public function playButtonSound() : void {
			if (soundOn)
				_buttonSound.play();
		}
		
		public function switchSound() : void {
			soundOn = !soundOn;
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
			if (_controlPanel != null)
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

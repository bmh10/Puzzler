package com.techlabs.puzzle.helpers {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class ImageSlicer {

		public function ImageSlicer() {
		}
		
		// Slices the given image into pieces and returns a
		// two dimensional array containing the slices
		public function sliceImage(image:Bitmap):Array {
			// total width and height
			var imgW:Number = image.width;
			var imgH:Number = image.height;
			
			// Width and height of an individual piece
			var pieceW:Number = imgW / SlidingPuzzle.subdivisions;
			var pieceH:Number = imgH / SlidingPuzzle.subdivisions;

			var imageArray:Array = new Array();

			var rect:Rectangle;
			var temp:Bitmap;
			var tempdata:BitmapData;
			
			for(var y:int = 0; y < SlidingPuzzle.subdivisions; y++) {
				imageArray[y] = new Array();
				for(var x:int = 0; x < SlidingPuzzle.subdivisions; x++) {
					tempdata = new BitmapData(pieceW, pieceH, true, 0x00000000);
					rect = new Rectangle(x * pieceW, y * pieceH, pieceW, pieceH);
					tempdata.copyPixels(image.bitmapData, rect, new Point(0, 0));
					temp = new Bitmap(tempdata);

					imageArray[y][x] = temp;
				}
			}

			return imageArray;
		}

	}

}

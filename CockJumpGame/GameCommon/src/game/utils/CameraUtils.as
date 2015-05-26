package game.utils
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import citrus.view.ACitrusCamera;
	
	import game.core.Device;
	import game.core.SceneConstants;

	public class CameraUtils
	{
		public static function setupCamera(camera:ACitrusCamera, focus:Object, leftBound:int = -900, topBound:int = -900, center:Point = null):void
		{
			var width:int = Device.SCREEN_WIDTH;
			var height:int = Device.SCREEN_HEIGHT;
			var sceneHeight:int = SceneConstants.SCENE_HEIGHT;
			center = center == null ? new Point(0.25, 0.6):center;
			camera.setUp(focus, null, center);
			camera.bounds = new Rectangle(leftBound, topBound, int.MAX_VALUE, sceneHeight - topBound);
			camera.allowRotation = true;
			camera.allowZoom = true;
			camera.easing.setTo(1, 1);
			camera.rotationEasing = 1;
			camera.zoomEasing = 1;	
			camera.zoomFit(width, height, true);
			camera.reset();
		}
	}
}
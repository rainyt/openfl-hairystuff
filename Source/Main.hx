package;

import openfl.events.Event;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite {
	public var sprite:FibreBrick = new FibreBrick(100, 100);

	public function new() {
		super();

		// var quad:Sprite = new Sprite();
		// this.addChild(quad);
		// quad.graphics.beginFill(0xff0000);
		// quad.graphics.drawRect(0, 0, 100, 100);

		// this.addEventListener(Event.ENTER_FRAME, function(e) {
		// 	quad.x++;
		// });

		this.stage.frameRate = 60;
		this.stage.color = 0x0;

		// Sprite渲染对象，用于渲染毛发
		this.addChild(sprite);
		sprite.x = 300;
		sprite.y = 400;

		var fps = new FPS(10, 10, 0xff0000);
		this.addChild(fps);
	}
}

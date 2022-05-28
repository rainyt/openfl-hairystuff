package;

import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite {
	public var sprite:FibreBrick = new FibreBrick(100, 100);

	public function new() {
		super();

		this.stage.color = 0x0;

		// Sprite渲染对象，用于渲染毛发
		this.addChild(sprite);
		sprite.x = 300;
		sprite.y = 400;

		var fps = new FPS(10, 10, 0xff0000);
		this.addChild(fps);
	}
}

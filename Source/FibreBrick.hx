import openfl.Vector;
import haxe.Timer;
import openfl.events.Event;
import hxnoise.Perlin;
import openfl.display.Sprite;

class FibreBrick extends Sprite {
	var brick = new Array<Array<Fibre>>();

	var step:Float = 0;
	var noiseStep = 0.01;
	var noiseOffset = 0.03;

	var width_amount:Int = 0;
	var height_amount:Int = 0;

	var xStep:Float = 0;
	var yStep:Float = 0;
	var xOffset:Float = 0;
	var yOffset:Float = 0;

	var perlinNoise:Perlin = new Perlin();

	var currentShader = new FibreShader();

	public function new(width_amount:Int, height_amount:Int) {
		super();
		this.width_amount = width_amount;
		this.height_amount = height_amount;
		for (x in 0...width_amount) {
			var temp_arr = new Array<Fibre>();
			for (y in 0...height_amount) {
				var fibre = new Fibre(x * 2.8, y * 2.8);
				temp_arr.push(fibre);
			}
			brick.push(temp_arr);
		}

		// 绘制
		this.graphics.clear();
		this.graphics.beginShaderFill(currentShader);

		var vertices:Vector<Float> = new Vector();
		var triangles:Vector<Int> = new Vector();
		var i = 0;
		for (array in brick) {
			for (fibre in array) {
				// this.graphics.lineStyle(fibre.thickness, fibre.color, fibre.alpha);
				// this.graphics.moveTo(fibre.start_x, fibre.start_y);
				// this.graphics.lineTo(fibre.end_x, fibre.end_y);
				vertices.push(0);
				vertices.push(0);
				vertices.push(2);
				vertices.push(0);
				vertices.push(2);
				vertices.push(50);
				vertices.push(0);
				vertices.push(50);
				triangles.push(0 + 4 * i);
				triangles.push(1 + 4 * i);
				triangles.push(2 + 4 * i);
				triangles.push(2 + 4 * i);
				triangles.push(3 + 4 * i);
				triangles.push(0 + 4 * i);

				for (i2 in 0...6) {
					currentShader.a_pos.value[i * 12 + i2 * 2 + 0] = fibre.start_x;
					currentShader.a_pos.value[i * 12 + i2 * 2 + 1] = fibre.start_y;
				}
				// uv.push(0);
				// uv.push(0);
				// uv.push(1);
				// uv.push(0);
				// uv.push(1);
				// uv.push(1);
				// uv.push(0);
				// uv.push(1);
				i++;
			}
		}

		this.graphics.drawTriangles(vertices, triangles);

		this.addEventListener(Event.ENTER_FRAME, onFrameEvent);

		// this.shader = currentShader;
	}

	private var delta:Float = 0;

	private function onFrameEvent(e:Event):Void {
		var now = Timer.stamp();
		update(now - delta);
		delta = now;
		var index = 0;
		for (array in brick) {
			for (fibre in array) {
				for (i in 0...6) {
					currentShader.a_noiseFactor.value[index * 6 + i] = fibre.alpha;
					// for (i2 in 0...2) {
					// 	currentShader.a_radians.value[index * 12 + i] = fibre.start_x;
					// 	currentShader.a_radians.value[index * 12 + i] = fibre.start_y;
					// }
				}
				index++;
			}
		}
		currentShader.u_stageSize.value[0] = stage.stageWidth;
		currentShader.u_stageSize.value[1] = stage.stageHeight;
		@:privateAccess for (index => value in this.graphics.__usedShaderBuffers) {
			value.update(value.shader);
			// ShaderBuffer.update(value, cast value.shader, updateAttr);
		}
		trace(currentShader.u_stageSize.value);
		this.invalidate();
	}

	function update(delta:Float) {
		step += noiseStep;

		xStep += noiseStep;
		yStep += noiseStep;

		xOffset = xStep;
		for (x in 0...width_amount) {
			yOffset = yStep;
			for (y in 0...height_amount) {
				var factor = noise(xOffset, yOffset);
				brick[x][y].update(factor);
				yOffset += noiseOffset;
			}
			xOffset += noiseOffset;
		}
	}

	function noise(x:Float, ?y:Float = 0, ?z:Float = 0) {
		return perlinNoise.OctavePerlin(x, y, z, 4, 0.55, 0.45);
	}
}

class Fibre {
	static inline var LENGTH:Float = 50;

	public var start_x:Float;
	public var start_y:Float;
	public var end_x:Float;
	public var end_y:Float;

	var radians:Float;

	public var radius:Float;

	public var color:UInt;
	public var thickness:Float;
	public var alpha:Float;

	public function new(startX:Float, startY:Float, color:UInt = 0xffffff) {
		start_x = startX;
		start_y = startY;

		end_x = start_x + LENGTH;
		end_y = start_y + LENGTH;

		thickness = 2;
		this.color = color;
	}

	public function update(noiseFactor:Float) {
		alpha = noiseFactor;
		// radians = noiseFactor * (2 * Math.PI);
		// radius = LENGTH * noiseFactor;
		// // var c = Color.fromRGBFloat(noiseFactor, noiseFactor, noiseFactor);
		// var c = StringTools.hex(Std.int(noiseFactor * 255));
		// color = Std.parseInt("0x" + c + c + c);
		// end_x = start_x + (radius * Math.sin(radians));
		// end_y = start_y + (radius * Math.cos(radians));
		// points = [start_x, start_y, end_x, end_y];
	}
}

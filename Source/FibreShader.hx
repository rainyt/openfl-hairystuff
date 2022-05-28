import glsl.Sampler2D;
import glsl.GLSL.texture2D;
import glsl.OpenFLGraphicsShader;
import VectorMath;

class FibreShader extends OpenFLGraphicsShader {
	// @:attribute public var noiseFactor:Float;
	@:attribute public var pos:Vec2;

	@:uniform public var time:Float;

	@:uniform public var bitmap2:Sampler2D;

	/**
	 * 舞台尺寸以及全局透明度
	 */
	@:uniform public var stageSize:Vec2;

	@:varying public var vNoiseFactor:Float;

	/**
	 * 平移
	 * @param x 
	 * @param y 
	 */
	@:vertexglsl public function translation(x:Float, y:Float):Mat4 {
		return mat4(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, x, y, 0, 0);
	}

	/**
	 * 比例缩放
	 * @param scaleX 
	 * @param scaleY 
	 */
	@:vertexglsl public function scale(xScale:Float, yScale:Float):Mat4 {
		return mat4(xScale, 0.0, 0.0, 0.0, 0.0, yScale, 0.0, 0.0, 0.0, 0.0, 1, 0.0, 0.0, 0.0, 0.0, 1.0);
	}

	/**
	 * 旋转实现
	 * @return Mat4
	 */
	@:vertexglsl public function rotaion(radians:Float, axis:Vec3, ts:Vec3):Mat4 {
		var tx:Float = ts.x;
		var ty:Float = ts.y;
		var tz:Float = ts.z;

		var radian:Float = radians;
		var c:Float = cos(radian);
		var s:Float = sin(radian);
		var x:Float = axis.x;
		var y:Float = axis.y;
		var z:Float = axis.z;
		var x2:Float = x * x;
		var y2:Float = y * y;
		var z2:Float = z * z;
		var ls:Float = x2 + y2 + z2;
		if (ls != 0) {
			var l:Float = sqrt(ls);
			x /= l;
			y /= l;
			z /= l;
			x2 /= ls;
			y2 /= ls;
			z2 /= ls;
		}
		var ccos:Float = 1 - c;
		var d:Mat4 = gl_openfl_Matrix;
		d[0].x = x2 + (y2 + z2) * c;
		d[0].y = x * y * ccos + z * s;
		d[0].z = x * z * ccos - y * s;
		d[1].x = x * y * ccos - z * s;
		d[1].y = y2 + (x2 + z2) * c;
		d[1].z = y * z * ccos + x * s;
		d[2].x = x * z * ccos + y * s;
		d[2].y = y * z * ccos - x * s;
		d[2].z = z2 + (x2 + y2) * c;
		d[3].x = (tx * (y2 + z2) - x * (ty * y + tz * z)) * ccos + (ty * z - tz * y) * s;
		d[3].y = (ty * (x2 + z2) - y * (tx * x + tz * z)) * ccos + (tz * x - tx * z) * s;
		d[3].z = (tz * (x2 + y2) - z * (tx * x + ty * y)) * ccos + (tx * y - ty * x) * s;
		return d;
	}

	public function new() {
		super();
		a_pos.value = [];
		// a_noiseFactor.value = [];
		u_stageSize.value = [];
		u_time.value = [0];
	}

	override function vertex() {
		super.vertex();
		// var t:Mat4 = translation(1, 1);
		// var noice:Vec4 = texture2D(bitmap2, fract(pos / 2.8 / 100. + time));
		var noice:Vec4 = texture2D(bitmap2, fract(pos / 2.8 / 500. + time));
		var noiseFactor:Float = noice.x;
		// noice = texture2D(bitmap2, fract(pos / 2.8 / 00. + time * noiseFactor));
		noiseFactor = noice.x;
		var radians:Float = noiseFactor * (2 * 3.14);
		var d:Mat4 = rotaion(radians, vec3(0, 0, 1), vec3(0, 0, 0));
		var mat:Mat4 = gl_openfl_Matrix;

		// UV位移
		var uv:Vec2 = 2. / stageSize.xy;
		var t:Mat4 = translation(uv.x * pos.x, uv.y * pos.y);
		vNoiseFactor = noiseFactor;

		// 缩放
		var s:Mat4 = scale(1, noiseFactor);
		// this.gl_Position = mat * d * t * gl_openfl_Position;
		this.gl_Position = (mat + t) * d * s * gl_openfl_Position;
	}

	override function fragment() {
		this.gl_FragColor = vec4(vNoiseFactor, vNoiseFactor, vNoiseFactor, 1) * vNoiseFactor;
		// this.gl_FragColor = vec4(1, 0, 0, 1);
	}
}

package shaders;

import openfl.display.BitmapData;
import flixel.FlxBasic;
import flixel.system.FlxAssets.FlxShader;

/**
 * Implements the overlay blend mode as a Flixel shader.
 * 
 * @see https://en.wikipedia.org/wiki/Blend_modes#Overlay
 * @author EliteMasterEric
 */

class CleftShader extends FlxBasic
{
    public var shader(default, null):FabsShaderGLSL = new FabsShaderGLSL();
}
class FabsShaderGLSL extends FlxShader
{
	@:glFragmentSource('
		#pragma header

        // Takes an image as the input.
        uniform sampler2D bitmapOverlay;

		void main()
		{
			vec4 base = texture2D(bitmap, openfl_TextureCoordv);
			gl_FragColor = vec4(base.r * 1., base.g * 1.25, base.b * 0.9, 1.0);
		}')

        public function new()
            {
                super();
            }
}
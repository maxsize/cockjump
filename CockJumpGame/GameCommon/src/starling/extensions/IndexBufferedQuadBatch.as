package starling.extensions
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.textures.Texture;
	import starling.utils.VertexData;
	
	/**
	 * ...
	 * @author Max
	 */
	public class IndexBufferedQuadBatch extends QuadBatch 
	{
		private var renderJobs:Vector.<RenderJob>;
		private var mIndexStartFrom:int = 0;
		private var lastQuadNum:int = 0;
		private var lastQuad:Quad;
		private var lastTexture:Texture;
		private var jobIndex:int = 0;
	
		/*private var pool:Vector.<RenderJob> = new Vector.<RenderJob>();
		
		private function acquire():RenderJob
		{
			if (pool.length < 1)
			{
				return new RenderJob();
			}
			else
			{
				return pool.pop();
			}
		}
		
		private function recycle(jobs:Vector.<RenderJob>):void
		{
			while (jobs.length)
			{
				pool.push(jobs.pop());
			}
		}*/
		
		override public function isStateChange(tinted:Boolean, parentAlpha:Number, texture:Texture, smoothing:String, blendMode:String, numQuads:int = 1):Boolean 
		{
			return false;
		}
		
		override public function addQuad(quad:Quad, parentAlpha:Number = 1.0, texture:Texture = null, smoothing:String = null, modelViewMatrix:Matrix = null, blendMode:String = null):void 
		{
			var tintWas:Boolean = mTinted;
			super.addQuad(quad, parentAlpha, texture, smoothing, modelViewMatrix, blendMode);
			mTinted = tintWas;
			if (super.isStateChange(quad.tinted, parentAlpha, texture, smoothing, blendMode, 1))
			{
				record(quad.tinted, texture);
			}
			else
			{
				this.lastQuad = quad;
				this.lastTexture = texture;
			}
		}
		
		override public function addQuadBatch(quadBatch:QuadBatch, parentAlpha:Number = 1.0, modelViewMatrix:Matrix = null, blendMode:String = null):void 
		{
			var tintWas:Boolean = mTinted;
			super.addQuadBatch(quadBatch, parentAlpha, modelViewMatrix, blendMode);
			mTinted = tintWas;
			if (super.isStateChange(quadBatch.tinted, parentAlpha, quadBatch.texture, quadBatch.smoothing, blendMode))
			{
				record(quadBatch.tinted, quadBatch.texture);
			}
		}
		
		override public function reset():void 
		{
			super.reset();
			mIndexStartFrom = 0;
			lastQuadNum = 0;
			lastQuad = null;
			lastTexture = null;
			if (renderJobs)
			{
				renderJobs.length = 0;
			}
			//jobIndex = 0;
		}
		
		override public function renderCustom(mvpMatrix:Matrix3D, parentAlpha:Number = 1.0, blendMode:String = null):void 
		{
			//trace(parentAlpha);
			if (mNumQuads == 0)
				return;
			if (lastQuad)
			{
				record(lastQuad.tinted, lastTexture);
			}
			syncBuffers();
			
			if (renderJobs == null)
			{
				super.renderCustom(mvpMatrix, parentAlpha, blendMode);
				return;
			}

			const jobLen:int = renderJobs.length;
			//const jobLen:int = jobIndex + 1;
            var context:Context3D = Starling.context;
			var indexLen:int;
			var job:RenderJob;

			var pma:Boolean = mVertexData.premultipliedAlpha;
			sRenderAlpha[0] = sRenderAlpha[1] = sRenderAlpha[2] = pma ? parentAlpha : 1.0;
			sRenderAlpha[3] = parentAlpha;
			//MatrixUtil.convertTo3D(mvpMatrix, sRenderMatrix);

			RenderSupport.setBlendFactors(pma, blendMode ? blendMode : this.blendMode);
			
			context.setVertexBufferAt(0, mVertexBuffer, VertexData.POSITION_OFFSET, Context3DVertexBufferFormat.FLOAT_2);
			//context.setBlendFactors(blendFactors[0], blendFactors[1]);
            context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, sRenderAlpha, 1);
            context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 1, mvpMatrix, true);

			for (var i:int = 0; i < jobLen; i++)
			{
				job = renderJobs[i];

				if (job.texture)
				{
					context.setTextureAt(0, job.texture);
					context.setVertexBufferAt(2, mVertexBuffer, VertexData.TEXCOORD_OFFSET, 
                                          Context3DVertexBufferFormat.FLOAT_2);
				}
				if (job.tinted)
				{
					context.setVertexBufferAt(1, mVertexBuffer, VertexData.COLOR_OFFSET, Context3DVertexBufferFormat.FLOAT_4);
				}
				context.setProgram(job.program);
				context.drawTriangles(mIndexBuffer, job.firstIndex, job.numQuads * 2);

				if (job.texture)
				{
					context.setVertexBufferAt(2, null);
					context.setTextureAt(0, null);
				}
				if (job.tinted)
				{
					context.setVertexBufferAt(1, null);
				}
			}
			/*if (mInvalid)
			{
				mInvalid = false;
			}
			DRAW_COUNT += jobLen;
			TOTAL_QUADS += mNumQuads;*/
		}
		
		private function record(tinted:Boolean, texture:Texture):void 
		{
			if (mNumQuads == 0 || mNumQuads == lastQuadNum)
				return;
			if (renderJobs == null)
			{
				renderJobs = new Vector.<RenderJob>();
			}
			//tinted = true;
			var currentNumQuad:int = mNumQuads - lastQuadNum;
			var endIndex:int = mIndexStartFrom + currentNumQuad * 6;
			
			var job:RenderJob = new RenderJob();
			/*var job:RenderJob;
			if (jobIndex == renderJobs.length)
			{
				job = new RenderJob();
				renderJobs.push(job);
			}
			else
			{
				job = renderJobs[jobIndex];
			}*/
			jobIndex++;
			
			job.tinted = tinted;
			mTexture = texture;
			job.program = getProgram(tinted);
			job.texture = texture ? texture.base : null;
			job.firstIndex = mIndexStartFrom;
			job.numQuads = currentNumQuad;
			renderJobs.push(job);
			
			mIndexStartFrom = endIndex;
			lastQuadNum = mNumQuads;
		}
	}
	
}

import flash.display3D.Program3D;
import flash.display3D.textures.TextureBase;

class RenderJob
{
	public var tinted:Boolean;
	public var program:Program3D;
	public var texture:TextureBase;
	public var firstIndex:int;
	public var numQuads:int;
}
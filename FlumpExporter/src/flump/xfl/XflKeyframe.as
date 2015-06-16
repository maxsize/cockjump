//
// Flump - Copyright 2013 Flump Authors

package flump.xfl {
	
	import flash.geom.Matrix;
	
	import aspire.util.MatrixUtil;
	import aspire.util.XmlUtil;
	
	import flump.mold.KeyframeMold;
	
	public class XflKeyframe
	{
		use namespace xflns;
		
		public static function parse (lib :XflLibrary, baseLocation :String, xml :XML,
									  flipbook :Boolean) :KeyframeMold {
			
			const kf :KeyframeMold = new KeyframeMold();
			kf.index = XmlUtil.getIntAttr(xml, "index");
			const location :String = baseLocation + ":" + (kf.index + 1);
			kf.duration = XmlUtil.getIntAttr(xml, "duration", 1);
			kf.label = XmlUtil.getStringAttr(xml, "name", null);
			kf.ease = XmlUtil.getNumberAttr(xml, "acceleration", 0) / 100;
			
			const tweenType :String = XmlUtil.getStringAttr(xml, "tweenType", null);
			kf.tweened = (tweenType != null);
			if (tweenType != null && tweenType != "motion") {
				lib.addError(location, ParseError.WARN, "Unrecognized tweenType '" + tweenType + "'");
			}
			
			if (flipbook) {
				if (xml.elements.elements().length() == 0) {
					lib.addError(location, ParseError.CRIT, "Empty frames are not allowed in flipbooks");
				}
				return kf;
			}
			
			var symbolXml :XML;
			for each (var frameEl :XML in xml.elements.elements()) {
				if (frameEl.name().localName == "DOMSymbolInstance" || frameEl.name().localName == "DOMComponentInstance")
				{
					if (symbolXml != null)
					{
						lib.addError(location, ParseError.CRIT, "There can be only one symbol instance at " +
							"a time in a keyframe.");
					} else symbolXml = frameEl;
				}
				else
				{
					lib.addError(location, ParseError.CRIT, "Non-symbols may not be in movie layers");
				}
			}
			
			if (symbolXml == null) return kf; // Purely labelled frame
			
			if (XmlUtil.getBooleanAttr(xml, "motionTweenOrientToPath", false)) {
				lib.addError(location, ParseError.WARN, "Motion paths are not supported");
			}
			
			if (XmlUtil.getBooleanAttr(xml, "hasCustomEase", false)) {
				lib.addError(location, ParseError.WARN, "Custom easing is not supported");
			}
			
			// Fill this in with the library name for now. XflLibrary.finishLoading will swap in the
			// symbol or implicit symbol the library item corresponds to.
			kf.ref = XmlUtil.getStringAttr(symbolXml, "libraryItemName");
			kf.visible = XmlUtil.getBooleanAttr(symbolXml, "isVisible", true);
			
			var matrix :Matrix = new Matrix();
			
			// Read the matrix transform
			if (symbolXml.matrix != null) {
				const matrixXml :XML = symbolXml.matrix.Matrix[0];
				function m (name :String, def :Number) :Number {
					return matrixXml == null ? def : XmlUtil.getNumberAttr(matrixXml, name, def);
				}
				matrix = new Matrix(m("a", 1), m("b", 0), m("c", 0), m("d", 1), m("tx", 0), m("ty", 0));
				
				kf.scaleX = MatrixUtil.scaleX(matrix);
				kf.scaleY = MatrixUtil.scaleY(matrix);
				kf.skewX = MatrixUtil.skewX(matrix);
				kf.skewY = MatrixUtil.skewY(matrix);
			}
			
			// Read the pivot point
			if (symbolXml.transformationPoint != null) {
				var pivotXml :XML = symbolXml.transformationPoint.Point[0];
				if (pivotXml != null) {
					kf.pivotX = XmlUtil.getNumberAttr(pivotXml, "x", 0);
					kf.pivotY = XmlUtil.getNumberAttr(pivotXml, "y", 0);
					
					// Translate to the pivot point
					const orig :Matrix = matrix.clone();
					matrix.identity();
					matrix.translate(kf.pivotX, kf.pivotY);
					matrix.concat(orig);
				}
			}
			
			// Now that the matrix and pivot point have been read, apply translation
			kf.x = matrix.tx;
			kf.y = matrix.ty;
			
			// Read the alpha
			if (symbolXml.color != null) {
				const colorXml :XML = symbolXml.color.Color[0];
				if (colorXml != null) {
					kf.alpha = XmlUtil.getNumberAttr(colorXml, "alphaMultiplier", 1);
				}
			}
			
			//read component data
			if (symbolXml.parametersAsXML != null && String(symbolXml.parametersAsXML) != "")
			{
				var cdata:String = String(symbolXml.parametersAsXML);
				cdata = cdata.replace("<![CDATA[", "");
				cdata = cdata.replace("]]>", "");
				var inspectors:XMLList = XMLList(cdata)..Inspectable;
				kf.customData = getInspectors(inspectors);
			}
			return kf;
		}
		
		private static function getInspectors(inspectors:XMLList):Object
		{
			var value:Object = {};
			for each(var xml:XML in inspectors)
			{
				var type:String = XmlUtil.getStringAttr(xml, "type");
				value[XmlUtil.getStringAttr(xml, "name")] = XmlUtil["get" + getFunctionName(type) + "Attr"](xml, "defaultValue");
			}
			return value;
		}
		
		private static function getFunctionName(type:String):String
		{
			switch (type)
			{
				case "Number":
				case "Int":
				case "Boolean":
				case "String":
					return type;
				default:
					return "String";
			}
		}
	}
}








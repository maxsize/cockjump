//
// Flump - Copyright 2013 Flump Authors

package flump.xfl {

import flash.geom.Rectangle;

import adobe.utils.XMLUI;

import aspire.util.Set;
import aspire.util.Sets;
import aspire.util.XmlUtil;

import flump.mold.KeyframeMold;
import flump.mold.LayerMold;
import flump.mold.MovieMold;

public class XflMovie
{
    use namespace xflns;

    /** Returns true if the given movie symbol is marked for "Export for ActionScript" */
    public static function isExported (xml :XML) :Boolean {
        return XmlUtil.hasAttr(xml, "linkageClassName");
    }

    /** Returns the library name of the given movie */
    public static function getName (xml :XML) :String {
        return XmlUtil.getStringAttr(xml, "name");
    }

    /** Return a Set of all the symbols this movie references. */
    public static function getSymbolNames (mold :MovieMold) :Set {
        var names :Set = Sets.newSetOf(String);
        for each (var layer :LayerMold in mold.layers) {
            if (!layer.flipbook) {
                for each (var kf :KeyframeMold in layer.keyframes) {
                    if (kf.ref != null) names.add(kf.ref);
                }
            }
        }
        return names;
    }

    public static function parse (lib :XflLibrary, xml :XML) :MovieMold {
		
		/*<DOMSymbolItem name="Grid9Blue" scaleGridLeft="12.1" scaleGridRight="36.4" scaleGridTop="12.1" scaleGridBottom="36.4">
		<timeline>
		<DOMTimeline name="Grid9Blue">
		<layers>
		<DOMLayer name="Layer 1" color="#4FFF4F" current="true" isSelected="true">
		<frames>
		<DOMFrame index="0" keyMode="9728">
		<elements>
		<DOMSymbolInstance libraryItemName="BlueBrick" centerPoint3DX="24.25" centerPoint3DY="24.25">
		<transformationPoint>
		<Point/>
		</transformationPoint>
		</DOMSymbolInstance>
		</elements>
		</DOMFrame>
		</frames>
		</DOMLayer>
		</layers>
		</DOMTimeline>
		</timeline>
		</DOMSymbolItem>*/
		
        const movie :MovieMold = new MovieMold();
        const name :String = getName(xml);
        const symbol :String = XmlUtil.getStringAttr(xml, "linkageClassName", null);
        movie.id = lib.createId(movie, name, symbol);
        const location :String = lib.location + ":" + movie.id;
		
		if (XmlUtil.hasAttr(xml, "scaleGridLeft"))
		{
			var scaleGrid:Rectangle = new Rectangle();
			scaleGrid.x = XmlUtil.getNumberAttr(xml, "scaleGridLeft");
			scaleGrid.width = XmlUtil.getNumberAttr(xml, "scaleGridRight") - scaleGrid.x;
			scaleGrid.y = XmlUtil.getNumberAttr(xml, "scaleGridTop");
			scaleGrid.height = XmlUtil.getNumberAttr(xml, "scaleGridBottom") - scaleGrid.y;
			
			/*scaleGrid.x = int(scaleGrid.x);
			scaleGrid.y = int(scaleGrid.y);*/
			movie.scale9Grid = scaleGrid;
		}

        const layerEls :XMLList = xml.timeline.DOMTimeline[0].layers.DOMLayer;
        if (XmlUtil.getStringAttr(layerEls[0], "name") == "flipbook") {
            movie.layers.push(XflLayer.parse(lib, location, layerEls[0], true));
            if (symbol == null) {
                lib.addError(location, ParseError.CRIT, "Flipbook movie '" + movie.id + "' not exported");
            }
            for each (var kf :KeyframeMold in movie.layers[0].keyframes) {
                kf.ref = movie.id + "_flipbook_" + kf.index;
            }
        } else {
            for each (var layerEl :XML in layerEls) {
                var layerType :String = XmlUtil.getStringAttr(layerEl, "layerType", "");
                if ((layerType != "guide") && (layerType != "folder")) {
                    movie.layers.unshift(XflLayer.parse(lib, location, layerEl, false));
                }
            }
        }
        movie.fillLabels();

        if (movie.layers.length == 0) {
            lib.addError(location, ParseError.CRIT, "Movies must have at least one layer");
        }

        return movie;
    }
}
}

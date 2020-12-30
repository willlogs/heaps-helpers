package level;

import haxe.Int64;
import haxe.Json;
import hxd.fs.FileEntry;
import hxd.res.Resource;

class Map extends Resource {
    public var mapData : {
        layers: Array<{
            name: String,
            data: Array<UInt>,
            objects: Array<{
                x: Float,
                y: Float,
                height: Float,
                width: Float
            }>
        }>,
        height: Int, width: Int,
        tileheight: Int, tilewidth: Int
    };

    public function new(entry:FileEntry) {
        super(entry);
        mapData = Json.parse(entry.getText());
    }
}
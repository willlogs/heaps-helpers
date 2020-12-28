package level;

import haxe.Json;
import hxd.fs.FileEntry;
import hxd.res.Resource;

class Map extends Resource {
    public var mapData : { layers: Array<{ data: Array<Int> }>, height: Int, width: Int };

    public function new(entry:FileEntry) {
        super(entry);
        mapData = Json.parse(entry.getText());
    }
}
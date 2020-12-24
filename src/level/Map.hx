package level;

import haxe.Json;
import hxd.fs.FileEntry;
import hxd.res.Resource;

class Map extends Resource {
    private var data : { layers: Array<{ data: Array<Int> }> };

    public function new(entry:FileEntry) {
        super(entry);
        data = Json.parse(entry.getText());
    }
}
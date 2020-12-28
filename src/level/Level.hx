package level;

import ecs.Updatable;
import h2d.Object;
import h2d.Layers;
import h2d.Bitmap;
import h2d.Tile;
import hxd.fs.FileEntry;
import h2d.Scene;

class Level extends Updatable {
    public var levelMap : Map;
    public var scene : Scene;
    public var tileset : Array<Tile>;

    private var tw : Int;
    private var th : Int;

    private var HORIZONTALFLIPFLAG(default, never) : Int = 0x80000000;
    private var VERTICALFLIPFLAG(default, never) : Int = 0x40000000;
    private var ANTIDIAGONALFLIPFLAG(default, never) : Int = 0x20000000;

    public function new(mapEntry: FileEntry, tileset: Tile, tw: Int, th: Int) {
        this.levelMap = new Map(mapEntry);

        this.tw = tw;
        this.th = th;

        this.tileset = [
            for(y in 0...Std.int(tileset.height/th))
                for(x in 0...Std.int(tileset.width/tw))
                    tileset.sub(x * tw, y * th, tw, th)
        ];
    }

    public function preRender() {
        this.scene = new Scene();

        var layerNumber : Int = 0;

        for(layer in levelMap.mapData.layers){

            var tileIndex : Int = 0;
            for(tile in layer.data){
                if(tile == 0){
                    tileIndex++;
                    continue;
                }

                var horizontalFlip : Bool = tile & HORIZONTALFLIPFLAG != 0;
                if(horizontalFlip)
                    tile ^= HORIZONTALFLIPFLAG;

                var verticalFlip : Bool = tile & VERTICALFLIPFLAG != 0;
                if(verticalFlip)
                    tile ^= VERTICALFLIPFLAG;

                var antiDiagonalFlip : Bool = tile & ANTIDIAGONALFLIPFLAG != 0;
                if(antiDiagonalFlip)
                    tile ^= ANTIDIAGONALFLIPFLAG;

                var bmp : Bitmap = new Bitmap(tileset[tile - 1]);
                bmp.tile.dx = -bmp.tile.width/2;

                if(horizontalFlip){
                    bmp.scaleX = -1;
                }

                bmp.setPosition(Std.int(tileIndex % levelMap.mapData.width) * tw, Std.int(tileIndex / levelMap.mapData.height) * th);
                scene.addChild(bmp);
                
                tileIndex++;
            }
            layerNumber++;
        }

        this.scene.setScale(7);
    }

    public override function update(dt:Float) {
        return;
    }
}
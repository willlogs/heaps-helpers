package level;

import format.mp3.Data.Layer;
import haxe.Int64;
import ecs.BoxCollider;
import utils.Vector2;
import ecs.Collider;
import ecs.Component;
import ecs.GameObject;
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
    public var collidersGO : GameObject;

    private var tw : Int;
    private var th : Int;
    private var scale : Int = 5;

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
        this.collidersGO = new GameObject(this.scene, 0, 0, "mapColliders");

        var layerIndex : Int = 0;
        for (layer in this.levelMap.mapData.layers){
            if(layer.name == "colliders"){
                for(obj in layer.objects){
                    var colliderGO = new GameObject(this.scene, obj.x, obj.y, "colliderGO");
                    var center : Vector2 = new Vector2(obj.width / 2, obj.height / 2);
                    new BoxCollider(colliderGO, center, obj.width, obj.height, true);
                }
            }
            else{
                for (i in 0...layer.data.length){
                    var tile : Int = layer.data[i];
                    var horizontalFlip : Bool = HORIZONTALFLIPFLAG & tile != 0;
                    var verticalFlip : Bool = VERTICALFLIPFLAG & tile != 0;
                    var antiDiagonalFlip : Bool = ANTIDIAGONALFLIPFLAG & tile != 0;

                    if(horizontalFlip)
                        tile ^= HORIZONTALFLIPFLAG;
                    if(verticalFlip)
                        tile ^= VERTICALFLIPFLAG;
                    if(antiDiagonalFlip)
                        tile ^= ANTIDIAGONALFLIPFLAG;

                    if(layer.data[i] == 0){
                        continue;
                    }

                    var bmp : Bitmap = new Bitmap(tileset[tile - 1]);
                                        
                    bmp.tile.dx = -bmp.tile.width / 2;
                    bmp.tile.dy = -bmp.tile.height / 2;

                    bmp.scaleX *= horizontalFlip ? -1 : 1;
                    bmp.scaleY *= verticalFlip ? -1 : 1;

                    bmp.setPosition(
                        Std.int(i % this.levelMap.mapData.width) * levelMap.mapData.tilewidth + bmp.tile.width / 2,
                        Std.int(i / this.levelMap.mapData.width) * levelMap.mapData.tileheight + bmp.tile.height / 2
                    );
                    this.scene.addChild(bmp);
                }
                layerIndex++;
            }
        }

        this.scene.setScale(scale);
    }

    public function setCam(x: Float, y: Float) {
        this.scene.x = -x * scale + this.scene.width / 2;
        this.scene.y = -y * scale + this.scene.height / 2;
    }

    public override function update(dt:Float) {
        return;
    }
}
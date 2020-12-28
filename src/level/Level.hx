package level;

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

        

        this.scene.setScale(2);
    }

    public override function update(dt:Float) {
        return;
    }
}
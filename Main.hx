import eventbeacon.Beacon;
import h2d.Tile;
import hxd.Window;
import h2d.Anim;
import utils.*;
import h2d.Font;
import ecs.*;

class Main extends hxd.App {
    var go : GameObject;
    var go1 : GameObject;

    var enemyanim : Anim;
    var bulletanim : Anim;
    var myanim : Anim;

    var t1:Tile;
    var t2:Tile;
    var t3:Tile;

    var time:Float = 0;
    var tick:Float = 5;
    var reduce:Float = 0.1;

    public var paused : Bool = false;
    public var bullet : GameObject;

    public static var UpdateList = new List<GameObject>();

    static function main() {
        new Main();
    }

    override function init() {
        hxd.Res.initEmbed();
        Window.getInstance().addEventTarget(OnEvent);

        var font : Font = hxd.res.DefaultFont.get();
        var tf = new h2d.Text(font);
        tf.text = "Hello World";
        s2d.addChild(tf);
    }

    override function update(dt:Float) {
        for(gameObject in UpdateList){
            gameObject.update(dt);
        }
        ColliderSystem.CheckCollide();
    }
    
    public function OnEvent(event : hxd.Event){
        switch(event.kind) {
            case EMove: MouseMoveEvent(event);
            case EPush: MouseClickEvent(event);
            case _:
        }
    }
    public function MouseMoveEvent(event : hxd.Event){
        //event.relX, event.relY
    }
    
    public function MouseClickEvent(event : hxd.Event){
        
    }
}
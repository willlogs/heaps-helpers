import hxd.Res;
import hxd.Window;
import utils.*;
import h2d.Font;
import ecs.*;
import level.*;

class Main extends hxd.App {
    public var paused : Bool = false;
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
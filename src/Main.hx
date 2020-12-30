import hxd.Res;
import hxd.Window;
import utils.*;
import h2d.Font;
import ecs.*;
import level.*;

class Main extends hxd.App {
    public static var UpdateList = new List<Updatable>();
    public static var Paused : Bool = false;

    public static var DebugMode : Bool = true;
    public static var customGraphics : h2d.Graphics;

    static function main() {
        new Main();
    }

    override function init() {
        hxd.Res.initEmbed();
        Window.getInstance().addEventTarget(OnEvent);

        var font : Font = hxd.res.DefaultFont.get();
        var tf = new h2d.Text(font);
        tf.text = "Hello World";

        var mainLevel : Level = new Level(Res.map1.entry, Res.cavestileset.toTile(), 8, 8);
        mainLevel.preRender();
        s2d = mainLevel.scene;

        s2d.addChild(tf);

        if(DebugMode){            
            customGraphics = new h2d.Graphics(s2d);
        }

        var testGO : GameObject = new GameObject(s2d, 20, 10);
        new RigidBody(testGO, true);
        new BoxCollider(testGO, new Vector2(0, 0), 10, 10);
    }

    override function update(dt:Float) {
        if(DebugMode){            
            customGraphics.clear();
        }

        if(!Paused){
            // do physics checks first
            ColliderSystem.CheckCollide();

            // pre update
            for(updatable in UpdateList){
                updatable.preUpdate(dt);
            }

            // update
            for(updatable in UpdateList){
                updatable.update(dt);
            }

            // after update
            for(updatable in UpdateList){
                updatable.afterUpdate(dt);
            }
        }
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
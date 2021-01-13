import h3d.Vector;
import haxe.macro.Expr.Catch;
import h2d.Text;
import hxd.Key;
import haxe.Timer;
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

    public static var timeScale : Float = 1;
    public static var fixedDeltaTime : Float = 0.005;
    public static var fixedTimer : FixedTimer;

    public static var rb_ : RigidBody;
    public static var tf : Text;
    public static var mainLevel : Level;

    static function main() {
        new Main();
    }

    override function init() {
        hxd.Res.initEmbed();
        Window.getInstance().addEventTarget(OnEvent);
        fixedTimer = new FixedTimer(Std.int(fixedDeltaTime * 1000));
        fixedTimer.hooks.add(this.fixedUpdate);

        if(DebugMode){            
            customGraphics = new h2d.Graphics(s2d);
        }

        var font : Font = hxd.res.DefaultFont.get();
        tf = new h2d.Text(font);
        tf.text = "Hello World";
        s2d.addChild(tf);
    }

    override function update(dt:Float) {
        if(DebugMode){
            customGraphics.clear();
        }

        if(!Paused){
            // do physics checks first
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

    public function fixedUpdate() {
        if(!Paused){
            ColliderSystem.CheckCollide();

            for(updatable in UpdateList){
                updatable.fixedUpdate();
            }
        }

        if(Key.isReleased(Key.F)){
            Paused = !Paused;
        }
    }
    
    public function OnEvent(event : hxd.Event){
        switch(event.kind) {
            case EMove: MouseMoveEvent(event);
            case EPush: MouseClickEvent(event);
            case EKeyDown: KeyDownEvent(event);
            case _:
        }
    }

    public function MouseMoveEvent(event : hxd.Event){
        //event.relX, event.relY
    }
    
    public function MouseClickEvent(event : hxd.Event){
        
    }

    public function KeyDownEvent(event) {
        
    }
}
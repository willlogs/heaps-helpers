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

        var font : Font = hxd.res.DefaultFont.get();
        tf = new h2d.Text(font);

        mainLevel = new Level(Res.map1.entry, Res.cavestileset.toTile(), 8, 8);
        mainLevel.preRender();
        s2d = mainLevel.scene;

        s2d.addChild(tf);

        if(DebugMode){            
            customGraphics = new h2d.Graphics(s2d);
        }

        var testGO : GameObject = new GameObject(s2d, 20, 190);
        rb_ = new RigidBody(testGO, true, false, 0.05);
        new BoxCollider(testGO, new Vector2(0, 0), 5, 5);
        new Sprite(testGO, Res.sprite_sheet.toTile());
        new Animation(testGO, Res.sprite_sheet.toTile(), 16, 16, 5, new Vector2(0, -6));
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

            mainLevel.setCam(rb_.attachee.obj.x, rb_.attachee.obj.y);
        }

        try{
            tf.color = new Vector(1, 1, 1);
            tf.text = rb_.colliderNormals.first().n.x + " " + rb_.colliderNormals.first().n.y;
            tf.x = rb_.attachee.obj.x;
            tf.y = rb_.attachee.obj.y;
        } catch(e) {
            tf.color = new Vector(0, 1, 0);
            tf.text = Std.int(rb_.attachee.obj.x) + " " + Std.int(rb_.attachee.obj.y);
            tf.x = rb_.attachee.obj.x;
            tf.y = rb_.attachee.obj.y;
        }
    }

    public function fixedUpdate() {
        if(!Paused){
            ColliderSystem.CheckCollide();

            for(updatable in UpdateList){
                updatable.fixedUpdate();
            }
        }

        if(Key.isDown(Key.D)){
            rb_.velocity = new Vector2(100, rb_.velocity.y);
        }

        if(Key.isDown(Key.A)){
            rb_.velocity = new Vector2(-100, rb_.velocity.y);
        }

        if(Key.isReleased(Key.SPACE)){
            rb_.velocity = new Vector2(rb_.velocity.x, -300);
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
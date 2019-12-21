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

    override function init() {
        hxd.Res.initEmbed();

        var font : Font = hxd.res.DefaultFont.get();
        var tf = new h2d.Text(font);
        tf.text = "Click to shoot\nTo Restart press f5";
        s2d.addChild(tf);

        // Set up how 3 sprites look like
        t1 = h2d.Tile.fromColor(0xFF0000, 40, 40);
        t2 = h2d.Tile.fromColor(0x00FF00, 5, 5);
        t3 = h2d.Tile.fromColor(0x0000FF, 40, 40);

        t1.dx = -20; t1.dy = -20;
        t2.dx = -2.5; t2.dy = -2.5;
        t3.dx = -20; t3.dy = -20;
        
        // Add event listener
        Window.getInstance().addEventTarget(OnEvent);

        AddPlayer();
        AddEnemy();
        // c.colliderEvents.on('enter', function(c) {
        //     trace("enter event");
        // });

        // go1 = new GameObject(s2d, 0, 600);
        // new Sprite(go1, myanim);
        // new CircleCollider(go1, new Vector2(0,0), 100);
    }

    override function update(dt:Float) {
        time += dt;
        if(time >= tick){
            time = 0;
            // tick
            AddEnemy();
        }
        if(paused) dt = 0;
        for(gameObject in UpdateList){
            gameObject.update(dt);
        }
        ColliderSystem.CheckCollide();
    }
    static function main() {
        new Main();
    }

    public function AddEnemy(){
        go1 = new GameObject(s2d, Math.random() * s2d.width, s2d.height - 20, "Enemy", 1);
        new Sprite(go1, t1);
        new RigidBody(go1, false);
        new CircleCollider(go1, new Vector2(0,0), 40);
        new EnemyComponent(go1, go.obj);
    }
    public function AddPlayer(){
        go = new GameObject(s2d, s2d.width * 0.5, s2d.height * 0.5);
        new Sprite(go, t3);
        new RigidBody(go, true);
        var c:CircleCollider = new CircleCollider(go, new Vector2(0,0), 40);
    }
    public function OnEvent(event : hxd.Event){
        switch(event.kind) {
            case EMove: MouseMoveEvent(event);
            case EPush: MouseClickEvent(event);
            case _:
        }
    }
    public function MouseMoveEvent(event : hxd.Event){
        var diffv:Vector2 = new Vector2(event.relX - go.obj.x, event.relY - go.obj.y);
        var atan = Math.atan2(diffv.y, diffv.x);
        go.obj.rotation = atan;
    }
    public function MouseClickEvent(event : hxd.Event){
        var diffv:Vector2 = new Vector2(event.relX - go.obj.x, event.relY - go.obj.y);
        diffv = diffv.Normalized();
        diffv.x *= -500;
        diffv.y *= -500;
        cast(go.GetComponent("RigidBody"), RigidBody).velocity = new Vector2(diffv.x, diffv.y);

        diffv.x *= -1;
        diffv.y *= -1;

        bullet = new GameObject(s2d, go.obj.x, go.obj.y, "Bullet");
        new Sprite(bullet, t2);
        var rb:RigidBody = new RigidBody(bullet, false);
        var c:CircleCollider = new CircleCollider(bullet, new Vector2(0,0), 5);
        c.isTrigger = true;
        c.colliderEvents.funcList.add(function(c:Collider) {
            if(c.attachee.name == "Enemy"){
                tick -= reduce;
                if(tick < 0.5) tick = 0.5;
                cast(c.attachee.GetComponent("Sprite"), Sprite).kill();
            }
        });
        rb.velocity = new Vector2(diffv.x, diffv.y);
    }
}
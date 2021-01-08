package ecs;

import utils.ColliderSystem;
import utils.Vector2;

import eventbeacon.Beacon;

class Collider extends Component{
    public var center:Vector2;
    public var collidedWith = new List<{collider: Collider, normal: Vector2}>();
    public var pushOutSpeed : Float = 200;
    public var rb : RigidBody;
    public var hasRb : Bool = false;
    public var isTrigger : Bool;
    public var isStatic : Bool = false;
    public var colliderEvents : ColliderEvent = new ColliderEvent();

    public function new(attachee:GameObject, center:Vector2, staticity:Bool = false){
        super(attachee);
        this.center = center;
        this.isStatic = staticity;
        utils.ColliderSystem.collidersInScene.add(this);
        var component = attachee.GetComponent("RigidBody");
        
        if(component != null){
            rb = cast(component, RigidBody);
            hasRb = true;
        }
    }

    public function GetTop():Float{
        return 0;
    }

    public function GetBottom():Float{
        return 0;
    }

    public function GetLeft():Float{
        return 0;
    }

    public function GetRight():Float{
        return 0;
    }

    public function GetCenter():Vector2{
        return new Vector2(center.x + attachee.obj.x, center.y + attachee.obj.y);
    }

    public function AddCollided(c:Collider, normal:Vector2){
        if(collidedWith.filter( function (cc) return cc.collider == c).length == 0){
            // enter
            collidedWith.add({collider: c, normal: normal});
            colliderEvents.call(c);
        }else{
            // stay
        }
    }

    public function RemoveCollided(c:Collider){
        // exit
        collidedWith = collidedWith.filter(function (cc) return cc.collider != c);
    }

    public override function preUpdate(dt:Float) {
        if(!isTrigger) {
            for(c in collidedWith){
                if(!c.collider.isTrigger)
                    ApplyPushBack(c.normal);
            }
        }
    }

    private function ApplyPushBack(pv:Vector2) {
        if(hasRb){
            rb.colliderNormals.add(pv);
        }
    }
}
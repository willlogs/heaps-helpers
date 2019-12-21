package ecs;

import utils.ColliderSystem;
import utils.Vector2;

import eventbeacon.Beacon;

class Collider extends Component{
    public var center:Vector2;
    public var collidedWith = new List<Collider>();
    public var pushOutSpeed : Float = 20;
    public var rb : RigidBody;
    public var isTrigger : Bool;
    public var colliderEvents : ColliderEvent = new ColliderEvent();

    public function new(attachee:GameObject, center:Vector2){
        super(attachee);
        this.center = center;
        utils.ColliderSystem.collidersInScene.add(this);
        rb = cast(attachee.GetComponent("RigidBody"), RigidBody);
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

    public function AddCollided(c:Collider){
        if(collidedWith.filter( function (cc) return cc == c).length == 0){
            //enter
            collidedWith.add(c);
            colliderEvents.call(c);
        }else{
            //stay
        }
    }

    public function RemoveCollided(c:Collider){
        //exit
        collidedWith.remove(c);
    }

    public override function update(dt:Float) {
        if(!isTrigger) {
            for(c in collidedWith){
                if(!c.isTrigger)
                    ApplyPushBack(ColliderSystem.PushBackVector(this, c));
            }
        }
    }

    private function ApplyPushBack(pv:Vector2) {
        rb.velocity = new Vector2(-pv.x * pushOutSpeed, -pv.y * pushOutSpeed);
    }
}
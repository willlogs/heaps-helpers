package ecs;

import utils.Vector2;

class EnemyComponent extends Component{
    var target:h2d.Object;
    var rb:RigidBody;

    public var killed:Bool = false;

    var moveSpeed = 100;

    public function new(attachee:GameObject, t:h2d.Object) {
        super(attachee);
        target = t;
        rb = cast(attachee.GetComponent("RigidBody"), RigidBody);
    }

    public override function update(dt:Float) {
        if(!killed){
            var diffv:Vector2 = new Vector2(target.x - attachee.obj.x, target.y - attachee.obj.y);
            diffv = diffv.Normalized();
            diffv.x *= moveSpeed;
            diffv.y *= moveSpeed;
            rb.velocity = diffv;
        }
    }
}
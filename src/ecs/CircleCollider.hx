package ecs;

import utils.Vector2;

class CircleCollider extends Collider{
    public var radius:Float;

    public function new(attachee:GameObject, center:Vector2, rad:Float){
        super(attachee, center);
        type = "CircleCollider";
        this.radius = rad;
    }

    public override function GetTop():Float{
        return 0;
    }

    public override function GetBottom():Float{
        return 0;
    }

    public override function GetLeft():Float{
        return 0;
    }

    public override function GetRight():Float{
        return 0;
    }
}
package utils;

import ecs.*;

class ColliderSystem{
    public static var collidersInScene = new List<Collider>();

    public static function CheckCollide(){
        for(c1 in collidersInScene){
            for(c2 in collidersInScene){
                if(c1 != c2){
                    if(DoCollide(c1, c2)){
                        c1.AddCollided(c2);
                        c2.AddCollided(c1);
                    }
                    else{
                        c1.RemoveCollided(c2);
                        c2.RemoveCollided(c1);
                    }
                }
            }
        }
    }

    public static function DoCollide(c1:Collider, c2:Collider):Bool{
        if(Std.is(c1, CircleCollider)){
            var cc1:CircleCollider = cast(c1, CircleCollider);
            if(Std.is(c2, CircleCollider)){
                var cc2:CircleCollider = cast(c2, CircleCollider);
                return DoCollideC(cc1, cc2);
            }
        }

        if(Std.is(c1, BoxCollider)){
            var cc1:BoxCollider = cast(c1, BoxCollider);
            if(Std.is(c2, BoxCollider)){
                var cc2:BoxCollider = cast(c2, BoxCollider);
                return DoCollideBox(cc1, cc2);
            }
        }

        return false;
    }

    public static function DoCollideC(c1:CircleCollider, c2:CircleCollider):Bool{
        return Distance(c1.GetCenter(), c2.GetCenter()) <= c1.radius * 0.5 + c2.radius * 0.5;
    }

    public static function DoCollideBox(c1: BoxCollider, c2: BoxCollider):Bool {
        var xCollide : Bool = false;
        var yCollide : Bool = false;

        yCollide = DoIntersect(c1.GetTop(), c2.GetTop(), c1.GetBottom(), c2.GetBottom());
        xCollide = DoIntersect(c1.GetRight(), c2.GetRight(), c1.GetLeft(), c2.GetLeft());

        return xCollide && yCollide;
    }

    public static function Distance(v1:Vector2, v2:Vector2){
        var x:Float = Math.abs(v1.x - v2.x);
        var y:Float = Math.abs(v1.y - v2.y);
        
        x *= x;
        y *= y;

        return Math.sqrt(x + y);
    }

    public static function PushBackVector(c1:Collider, c2:Collider):Vector2{
        var c2c:Vector2 = c2.GetCenter();
        var c1c:Vector2 = c1.GetCenter();

        c2c.x -= c1c.x;
        c2c.y -= c1c.y;

        return c2c.Normalized();
    }

    private static function DoIntersect(upper1:Float, upper2:Float, lower1:Float, lower2:Float):Bool{
        return (upper1 >= upper2 && lower1 <= upper2) || (upper2 >= upper1 && lower2 <= upper1);
    }
}
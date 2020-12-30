package utils;

import haxe.ds.Vector;
import ecs.*;

class ColliderSystem{
    public static var collidersInScene = new List<Collider>();

    private static var c1Normal : Vector2;
    private static var c2Normal : Vector2;

    public static function CheckCollide(){
        for(c1 in collidersInScene){
            if(!c1.hasRb){
                continue;
            }

            for(c2 in collidersInScene){
                if(c1 != c2){
                    if(DoCollide(c1, c2)){
                        c1.AddCollided(c2, c2Normal);
                        c2.AddCollided(c1, c1Normal);
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
        var center1 = c1.GetCenter();
        var center2 = c2.GetCenter();
        if(Distance(center1, center2) <= c1.radius * 0.5 + c2.radius * 0.5){
            c1Normal = new Vector2(center1.x - center2.x, center1.y - center2.y).Normalized();
            c2Normal = new Vector2(center2.x - center1.x, center2.y - center1.y).Normalized();
            return true;
        }
        else{
            return false;
        }
    }

    public static function DoCollideBox(c1: BoxCollider, c2: BoxCollider):Bool {
        var xCollide : Bool = false;
        var yCollide : Bool = false;

        // each box has 4 edges, you have to check against them and use their normals -> BoxCollider.edges
        yCollide = DoIntersect(c1.GetTop(), c2.GetTop(), c1.GetBottom(), c2.GetBottom());
        xCollide = DoIntersect(c1.GetRight(), c2.GetRight(), c1.GetLeft(), c2.GetLeft());

        var center1 = c1.GetCenter();
        var center2 = c2.GetCenter();

        if(xCollide && yCollide){
            
            return true;
        }
        else{
            return false;
        }
    }

    public static function Distance(v1:Vector2, v2:Vector2){
        var x:Float = Math.abs(v1.x - v2.x);
        var y:Float = Math.abs(v1.y - v2.y);
        
        x *= x;
        y *= y;

        return Math.sqrt(x + y);
    }

    private static function DoIntersect(upper1:Float, upper2:Float, lower1:Float, lower2:Float):Bool{
        return (upper1 >= upper2 && lower1 <= upper2) || (upper2 >= upper1 && lower2 <= upper1);
    }
}
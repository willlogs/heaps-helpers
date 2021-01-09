package utils;

import haxe.ds.Vector;
import ecs.*;

class ColliderSystem{
    public static var collidersInScene = new List<Collider>();

    private static var c1Normal : Vector2;
    private static var c2Normal : Vector2;
    private static var err : Float;

    public static function CheckCollide(){
        for(c1 in collidersInScene){
            if(!c1.hasRb){
                continue;
            }

            for(c2 in collidersInScene){
                if(c1 != c2){
                    if(DoCollide(c1, c2)){
                        c1.AddCollided(c2, c2Normal, err);
                        c2.AddCollided(c1, c1Normal, err);
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
        if(c1.isStatic && c2.isStatic){
            return false;
        }

        if(Std.is(c1, CircleCollider)){
            var cc1:CircleCollider = cast(c1, CircleCollider);
            if(Std.is(c2, CircleCollider)){
                var cc2:CircleCollider = cast(c2, CircleCollider);
                return DoCollide_Circle(cc1, cc2);
            }
        }

        if(Std.is(c1, BoxCollider)){
            var cc1:BoxCollider = cast(c1, BoxCollider);
            if(Std.is(c2, BoxCollider)){
                var cc2:BoxCollider = cast(c2, BoxCollider);
                return DoCollide_Box(cc1, cc2);
            }
        }

        return false;
    }

    public static function DoCollide_Circle(c1:CircleCollider, c2:CircleCollider):Bool{
        var center1 = c1.GetCenter();
        var center2 = c2.GetCenter();
        if(Distance(center1, center2) <= c1.radius * 0.5 + c2.radius * 0.5){
            c1Normal = new Vector2(center1.x - center2.x, center1.y - center2.y).Normalized();
            c2Normal = new Vector2(center2.x - center1.x, center2.y - center1.y).Normalized();
            err = Math.abs(center1.x - center2.x) + Math.abs(center1.y - center2.y);
            return true;
        }
        else{
            return false;
        }
    }

    public static function DoCollide_Box(c1: BoxCollider, c2: BoxCollider):Bool {
        var result1:{err: Float, min: Int, intersection: Bool};
        var result2:{err: Float, min: Int, intersection: Bool};

        var result3:{err: Float, min: Int, intersection: Bool};
        var result4:{err: Float, min: Int, intersection: Bool};

        var xResult:{err: Float, min: Int, intersection: Bool};
        var yResult:{err: Float, min: Int, intersection: Bool};

        var u1 = c1.GetBottom();
        var l1 = c1.GetTop();

        var u2 = c2.GetBottom();
        var l2 = c2.GetTop();

        var xFirst:Bool = false;
        var yFirst:Bool = false;

        result1 = CheckBoxIntersection(u1, l1, u2, l2);
        if(result1.intersection){
            yResult = result1;
            yFirst = true;
        }else{
            result2 = CheckBoxIntersection(u2, l2, u1, l1);
            if(result2.intersection){
                yResult = result2;
            }
            else{
                return false;
            }

            yFirst = false;
        }

        u1 = c1.GetRight();
        l1 = c1.GetLeft();

        u2 = c2.GetRight();
        l2 = c2.GetLeft();

        result3 = CheckBoxIntersection(u1, l1, u2, l2);
        if(result3.intersection){
            xResult = result3;
            xFirst = true;
        }
        else {
            result4 = CheckBoxIntersection(u2, l2, u1, l1);
            if(result4.intersection){
                xResult = result4;
            }
            else{
                return false;
            }
            xFirst = false;
        }

        var choice = xResult.err < yResult.err;
        
        if(choice){
            if(!xFirst){
                var tmp = c1;
                c1 = c2;
                c2 = tmp;
            }

            if(xResult.min > 0){
                // upper = right => push right
                c1.AddCollided(c2, new Vector2(1, 0), xResult.err);
                c2.AddCollided(c1, new Vector2(-1, 0), xResult.err);
            }else{
                // lower = left => push left
                c1.AddCollided(c2, new Vector2(-1, 0), xResult.err);
                c2.AddCollided(c1, new Vector2(1, 0), xResult.err);
            }
        }
        else{
            if(!yFirst){
                var tmp = c1;
                c1 = c2;
                c2 = tmp;
            }

            if(yResult.min > 0){
                // upper = down => push down
                c1.AddCollided(c2, new Vector2(0, 1), yResult.err);
                c2.AddCollided(c1, new Vector2(0, -1), yResult.err);
            }
            else{
                // lower = up => push up
                c1.AddCollided(c2, new Vector2(0, -1), yResult.err);
                c2.AddCollided(c1, new Vector2(0, 1), yResult.err);
            }
        }

        return true;
    }

    // min = 1 means u1_upper was chosen in min as err and -1 means l1_lower
    // err is amount of intersection in collider we always fix the minimum err with pushing things out of each other xD
    public static function CheckBoxIntersection(upper:Float, lower: Float, u1: Float, l1: Float):{err: Float, min: Int, intersection: Bool} {
        var u1_upper = u1 - upper;
        var u1_lower = u1 - lower;

        var l1_upper = l1 - upper;
        var l1_lower = l1 - lower;

        // are the signs same?
        // if not, it means intersection
        var s_u = (u1_upper > 0) != (u1_lower > 0);
        var s_l = (l1_upper > 0) != (l1_lower > 0);
        
        if(s_u || s_l){
            var error : Float = 0;
            var choice : Int = 0;
            if(u1_upper < l1_lower){
                error = Math.abs(u1_upper);
                choice = 1;
            }
            else{
                error = Math.abs(l1_lower);
                choice = -1;
            }
            return{ err: error,  min: choice, intersection: true};
        }
        else{
            return { err: 0, min: 0, intersection: false };
        }
    }

    public static function Distance(v1:Vector2, v2:Vector2){
        var x:Float = Math.abs(v1.x - v2.x);
        var y:Float = Math.abs(v1.y - v2.y);
        
        x *= x;
        y *= y;

        return Math.sqrt(x + y);
    }
}
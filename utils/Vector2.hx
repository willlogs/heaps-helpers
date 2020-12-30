package utils;

class Vector2{
    public var x:Float;
    public var y:Float;

    public function new(x:Float = 0, y:Float = 0){
        this.x = x;
        this.y = y;
    }

    public function Normalized():Vector2{
        var abs = Magnitude();
        return new Vector2(x/abs, y/abs);
    }

    public function NeutralizeBy(v:Vector2){
        var normalV = v.Normalized();
        var m = multiply(normalV, Dot(normalV));
        x -= m.x;
        y -= m.y;
    }

    public function Dot(v:Vector2):Float {
        return x * v.x + y * v.y;
    }

    public function Magnitude():Float{
        return Math.sqrt(x*x + y*y);
    }

    public function Multiply(m:Float) {
        x *= m;
        y *= m;
    }

    public static function sum(a:Vector2, b:Vector2):Vector2 {
        return new Vector2(a.x + b.x, a.y + b.y);
    }

    public static function sub(a:Vector2, b:Vector2):Vector2 {
        return new Vector2(a.x - b.x, a.y - b.y);
    }

    public static function multiply(a:Vector2, b:Float):Vector2 {
        return new Vector2(a.x * b, a.y * b);
    }

    public static function rotateBy(a:Vector2, b:Float):Vector2 {
        var sin:Float = Math.sin(b);
        var cos:Float = Math.cos(b);
        
        return new Vector2(
            a.x * cos - a.y * sin,
            a.x * sin + a.y * sin
        );
    }
}